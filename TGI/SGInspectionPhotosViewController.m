//
//  SGInspectionPhotosViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionPhotosViewController.h"
#import "SGLoadingView.h"
#import "SGInspection.h"
#import "SGInspectionUtil.h"
#import "SGInspectionPhotoViewCell.h"
#import "SGInspectionPhoto.h"
#import "SGInspectionAttachmentParser.h"
#import "SGPortlet.h"

@implementation SGInspectionPhotosViewController {
    dispatch_queue_t _queue;
    SGInspection *_inspection;
    NSString *_assetId;
    NSString *_inspectionId;
    BOOL _readOnly;
    SGLoadingView *_loadingView;
    NSArray *_items;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _queue = dispatch_queue_create("com.sophia.tgi.inspections.photos.refresh", NULL);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items ? _items.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SGInspectionPhoto *photo = _items[indexPath.row];
    
    SGInspectionPhotoViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PHOTO_CELL" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithContentsOfFile:photo.filepath];
    return cell;
}

- (void)setInspection:(SGInspection *)inspection readOnly:(BOOL)readOnly {
    _inspection = inspection;
    _readOnly = readOnly;
}

- (void)setAssetId:(NSString *)assetId {
    _assetId = assetId;
}

- (void)setInspectionId:(NSString *)inspectionId {
    _inspectionId = inspectionId;
}

- (void)refresh {
    if (_readOnly) {
        [self fetchInspectionPhotos];
    } else {
        [self findPendingPhotos];
    }
}

- (void)findPendingPhotos {
    _loadingView = [SGLoadingView loadingView:self.view];
    dispatch_async(_queue, ^{
        NSArray *items = [SGInspectionUtil findInspectionPhotos:_inspection.uuid];
        NSLog(@"Found, count: %lu", (unsigned long)items.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            _items = items;
            [self.collectionView reloadData];
            [_loadingView dismiss];
        });
    });
}

- (void)fetchInspectionPhotos {
    if (_items.count > 0) {
        return;
    }
    _loadingView = [SGLoadingView loadingView:self.view];
    dispatch_async(_queue, ^{
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (SGInspectionPhoto *p in _inspection.attachments) {
            NSString *filePath = [self fetchInspectionPhoto:p];
            if (filePath != nil) {
                p.filepath = filePath;
                [items addObject:p];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _items = items;
            [self.collectionView reloadData];
            [_loadingView dismiss];
        });
    });
}

- (NSString *)fetchInspectionPhoto:(SGInspectionPhoto *)p {
    NSLog(@"Fetching attachment, id: %@", p.docId);
    SGInspectionAttachmentParser *parser = [[SGInspectionAttachmentParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_VIEW"
                                                     parser:parser];
    [portlet addParameter:@"asset_id" value:_assetId];
    [portlet addParameter:@"inspection_id" value:_inspectionId];
    [portlet addParameter:@"doc_id" value:p.docId];
    if ([portlet invokeSynchronously]) {
        NSLog(@"Fetched attachment, id: %@", p.docId);
        NSData *data = [SGInspectionUtil dataWithBase64EncodedString:parser.data];
        NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], p.filename];
        NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
        NSLog(@"Saving attachment, id: %@, url: %@", p.docId, fileURL);
        NSError *error;
        BOOL saved = [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
        NSLog(@"Saved document, id: %@, saved: %hhd, error: %@", p.docId, saved, error);
        return fileURL.path;
    } else {
        return nil;
    }
}

@end
