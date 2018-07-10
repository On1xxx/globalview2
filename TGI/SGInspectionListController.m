//
//  SGInspectionListTableViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionListController.h"
#import "SGInspectionListParser.h"
#import "SGInspectionListItem.h"
#import "SGInspectionListItemCell.h"
#import "SGPortlet.h"
#import "SGLoadingView.h"
#import "SGInspectionListTabBarController.h"
#import "SGInspectionTabBarController.h"

@implementation SGInspectionListController {
    NSArray *_items;
    NSString *_range;
    SGPortlet *_portlet;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self->_range = @"Today";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = _range;
    

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addItem)];
    
    UIBarButtonItem *rangeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Calendar.png"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(changeRange)];
    
    self.tabBarController.navigationItem.rightBarButtonItems = @[addItem, rangeItem];
    
    [self reload:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items ? (int)_items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGInspectionListItem *item = _items[(uint)indexPath.row];
    
    SGInspectionListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITEM"
                                                                     forIndexPath:indexPath];
    cell.assetLabel.text = [NSString stringWithFormat:@"%@ - %@, %@, %@", item.assetId, item.group, item.subGroup, item.type];
    cell.dateUtcLabel.text = [NSString stringWithFormat:@"%@ (UTC)", item.dateUtc];
    cell.dateTzLabel.text = [NSString stringWithFormat:@"%@ (%@)", item.dateTz, item.tz];
    cell.inspectionIdLabel.text = item.inspectionId;
    cell.inspectionStatusLabel.text = item.status;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SGInspectionListItem *item = _items[indexPath.row];
    [self performSegueWithIdentifier:@"VIEW_INSPECTION" sender:item];
}

- (void)addItem {
    SGInspectionListTabBarController *controller = (SGInspectionListTabBarController *)self.tabBarController;
    [controller newInspection];
}

- (void)changeRange {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a range:"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Today", @"Yesterday", @"This week", @"Last week", @"This month", @"Last month", @"This year", @"Last year", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *range = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self reload:range];
}

- (void)reload:(NSString *)range {
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    NSString *effectiveRange = range ? range : _range;
    
    NSLog(@"Reloading, range: %@, effective: %@", range, effectiveRange);
    
    SGInspectionListParser *parser = [[SGInspectionListParser alloc] init];
    _portlet = [[SGPortlet alloc] initWithPortlet:@"INSPECTION_LIST"
                                           parser:parser
                                        onSuccess:^() {
                                            self->_items = parser.items;
                                            self->_range = effectiveRange;
                                            self.title = effectiveRange;
                                            [self.tableView reloadData];
                                            [loadingView removeFromSuperview];
                                        }
                                          onError:^() {
                                              [loadingView removeFromSuperview];
                                          }];
    [_portlet addParameter:@"range" value:effectiveRange];
    [_portlet invoke];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"VIEW_INSPECTION" isEqualToString:segue.identifier]) {
        SGInspectionListItem *item = sender;
        SGInspectionTabBarController *controller = segue.destinationViewController;
        controller.assetId = item.assetId;
        controller.inspectionId = item.inspectionId;
    }
}

@end
