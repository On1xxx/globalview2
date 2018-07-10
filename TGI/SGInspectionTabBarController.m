//
//  SGInspectionTabBarController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionTabBarController.h"
#import "SGLoadingView.h"
#import "SGInspectionParser.h"
#import "SGPortlet.h"
#import "SGInspectionViewControllerDelegate.h"
#import "SGInspectionSavedParser.h"
#import "SGInspectionSerializer.h"
#import "SGReachability.h"
#import "SGInspectionUtil.h"
#import "SGInspectionPhotoController.h"
#import "SGInspectionViewParser.h"
#import <dispatch/dispatch.h>

@implementation SGInspectionTabBarController {
    SGInspection *_inspection;
    SGLoadingView *_loadingView;
    dispatch_queue_t _uploadQueue;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _uploadQueue = dispatch_queue_create("com.sophia.tgi.inspections.upload", NULL);
    }
    return self;
}

- (void)setAssetId:(NSString *)assetId {
    _assetId = assetId;
    self.title = assetId;

    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(setAssetId:)]) {
            [controller setAssetId:_assetId];
        }
    }
}

- (void)setInspectionId:(NSString *)inspectionId {
    _inspectionId = inspectionId;

    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(setInspectionId:)]) {
            [controller setInspectionId:inspectionId];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadingView = [SGLoadingView loadingView:self.view];
    
    if (_inspectionId.length == 0) {
        [self getInspectionSchema];
    } else {
        [self getInspection];
    }
}

- (void)setupButtons {
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                target:self
                                                                                action:@selector(takePhoto)];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveInspection)];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.navigationItem.rightBarButtonItems = @[saveItem, cameraItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[saveItem];
    }
}

- (void)getInspectionSchema {
    SGInspectionParser *parser = [[SGInspectionParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_SCHEMA"
                                                     parser:parser
                                                  onSuccess:^{
                                                      NSLog(@"Inspection schema success");
                                                      [self setInspection:parser.inspection readOnly:NO];
                                                      [self setupButtons];
                                                      [_loadingView dismiss];
                                                  }];
    [portlet addParameter:@"asset_id" value:_assetId];
    [portlet invoke];
}

- (void)getInspection {
    SGInspectionViewParser *parser = [[SGInspectionViewParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_VIEW"
                                                     parser:parser
                                                  onSuccess:^{
                                                      NSLog(@"Inspection view success");
                                                      [self setInspection:parser.inspection readOnly:YES];
                                                      [_loadingView dismiss];
                                                  }];
    [portlet addParameter:@"asset_id" value:_assetId];
    [portlet addParameter:@"inspection_id" value:_inspectionId];
    [portlet invoke];
}

- (void)setInspection:(SGInspection *)inspection readOnly:(BOOL)readOnly {
    _inspection = inspection;
    for (id controller in self.viewControllers) {
        [controller setInspection:inspection readOnly:readOnly];
    }
}

- (void)takePhoto {
    NSLog(@"Taking photo...");
    [self performSegueWithIdentifier:@"PHOTO" sender:self];
}

- (void)saveInspection {
    NSLog(@"Saving inspection...");
    [self.view endEditing:YES];
    NSLog(@"Registred owner: %@", _inspection.registredOwner);
    NSLog(@"Saftey: %@", _inspection.safteyNo);
    NSLog(@"Claim: %@", _inspection.claimNo);
    NSLog(@"Type: %@", _inspection.type);
    NSLog(@"Inspector: %@", _inspection.inspector);
    NSLog(@"Odometer: %@, %@", _inspection.odometerValue, _inspection.odometerUnit);
    NSLog(@"Plate: %@", _inspection.plateNo);

    SGInspectionSerializer *serializer = [[SGInspectionSerializer alloc] initWithAssetId:_assetId
                                                                              inspection:_inspection];
    
    _loadingView = [SGLoadingView loadingView:self.view];
    
    NSString *directoryPath = [SGInspectionUtil saveInspectionInDocumentsFolderForAssetId:_assetId
                                                                               inspection:_inspection
                                                                               serializer:serializer];
    
    if ([SGReachability isReachable]) {
        [self uploadInspection:serializer directoryPath:directoryPath];
    } else {
        [self showInspectionSaved];
    }
}

- (void)showInspectionAdded:(NSString *)inspectionId {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Added inspection"
                                                        message:[NSString stringWithFormat:@"Inspection id: %@", inspectionId]
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (void)showInspectionSaved {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved inspection"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self dismiss];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
    [_loadingView dismiss];
}

- (void)uploadInspection:(SGInspectionSerializer *)serializer directoryPath:(NSString *)directoryPath {
    dispatch_async(_uploadQueue, ^{
        SGInspectionSavedParser *parser = [[SGInspectionSavedParser alloc] init];
        SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_ADD"
                                                         parser:parser];
        [portlet addParameter:@"asset_id" value:_assetId];
        [portlet addParameter:@"data" value:[NSString stringWithFormat:@"<![CDATA[%@]]>", serializer.xml]];
        BOOL success = [portlet invokeSynchronously];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [SGInspectionUtil deletePendingInspection:directoryPath];
                [self showInspectionAdded:parser.inspectionId];
            } else {
                [_loadingView dismiss];
            }
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SGInspectionPhotoController *controller = segue.destinationViewController;
    controller.uuid = _inspection.uuid;
    controller.photosDelegate = self;
}

- (void)photoAdded {
//    SGInspectionPhotosTableViewController *controller = self.viewControllers[2];
//    [controller refresh];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self.view endEditing:YES];
}

@end
