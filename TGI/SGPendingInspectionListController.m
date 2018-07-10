//
//  SGPendingInspectionListController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGPendingInspectionListController.h"

#import <dispatch/dispatch.h>
#import "SGLoadingView.h"
#import "SGPendingInspection.h"
#import "SGPendingInspectionTableViewCell.h"
#import "SGInspectionUtil.h"
#import "SGInspectionListTabBarController.h"
#import "SGInspectionSavedParser.h"
#import "SGPortlet.h"

@implementation SGPendingInspectionListController {
    dispatch_queue_t _pendingQueue;
    dispatch_queue_t _uploadQueue;
    SGLoadingView *_loadingView;
    NSArray *_inspections;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _pendingQueue = dispatch_queue_create("com.sophia.tgi.inspections.pending", NULL);
        _uploadQueue = dispatch_queue_create("com.sophia.tgi.inspections.upload", NULL);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addItem)];

    UIBarButtonItem *uploadItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Upload.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(uploadAll)];

    self.tabBarController.navigationItem.rightBarButtonItems = @[addItem, uploadItem];
    
    [self findPendingInspections];
}

- (void)findPendingInspections {
    _loadingView = [SGLoadingView loadingView:self.view];
    
    dispatch_async(_pendingQueue, ^{
        NSArray *inspections = [SGInspectionUtil findPendingInspections];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInspections:inspections];
            [self.tableView reloadData];
            [_loadingView dismiss];
        });
    });
}

- (void)addItem {
    SGInspectionListTabBarController *controller = (SGInspectionListTabBarController *)self.tabBarController;
    [controller newInspection];
}

- (void)uploadAll {
    _loadingView = [SGLoadingView loadingView:self.view];
    
    dispatch_group_t group = dispatch_group_create();

    NSMutableArray *inspections = [[NSMutableArray alloc] initWithArray:_inspections];
    for (SGPendingInspection *inspection in _inspections) {
        dispatch_group_async(group, _uploadQueue, ^{
            NSLog(@"Uploading inspection, asset: %@, datetz: %@, path: %@", inspection.assetId, inspection.dateTz, inspection.directoryPath);
            if ([self upload:inspection]) {
                [SGInspectionUtil deletePendingInspection:inspection.directoryPath];
                [inspections removeObject:inspection];
                NSLog(@"Uploaded inspection, path: %@", inspection.directoryPath);
            }
        });
    }
    
    dispatch_group_notify(group, _uploadQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInspections:inspections];
            [self.tableView reloadData];
            [_loadingView dismiss];
        });
    });
}

- (BOOL)upload:(SGPendingInspection *)inspection {
    NSString *xml = [SGInspectionUtil findPendingInspectionXml:inspection.directoryPath];
    
    __block BOOL uploaded;
    
    SGInspectionSavedParser *parser = [[SGInspectionSavedParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_ADD"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      uploaded = YES;
                                                  }
                                                    onError:^() {
                                                        uploaded = NO;
                                                    }];
    [portlet addParameter:@"asset_id" value:inspection.assetId];
    [portlet addParameter:@"data" value:[NSString stringWithFormat:@"<![CDATA[%@]]>", xml]];
    [portlet invokeSynchronously];
    
    return uploaded;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inspections ? _inspections.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGPendingInspection *inspection = [_inspections objectAtIndex:indexPath.row];
    
    SGPendingInspectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"
                                                                             forIndexPath:indexPath];
    cell.assetIdLabel.text = inspection.assetId;
    cell.dateUtcLabel.text = [NSString stringWithFormat:@"%@ (UTC)", inspection.dateUtc];
    cell.dateTzLabel.text = inspection.dateTz;
    return cell;
}

- (void)setInspections:(NSArray *)inspections {
    if (inspections.count > 0) {
        self.tabBarItem.title = [NSString stringWithFormat:@"Pending (%d)", inspections.count];
    } else {
        self.tabBarItem.title = @"Pending";
    }
    _inspections = inspections;
}

@end
