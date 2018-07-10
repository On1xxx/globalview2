//
//  SGYardCheckViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGYardCheckViewController.h"
#import "SGYardCheckAsset.h"
#import "SGYardCheckAssetParser.h"
#import "SGPortlet.h"
#import "SGYardCheckAssetCell.h"
#import "SGFindAssetParser.h"
#import "SGFindAssetShortInfoViewController.h"
#import "SGLoadingView.h"
#import "SGSortOrder.h"

@implementation SGYardCheckViewController
{
    NSArray *array;
    NSString *sortOption;
    SGSortOrder sortOrder;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        sortOption = @"";
        sortOrder = SORT_ORDER_NONE;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    self.sortButton.enabled = NO;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Yard Check: %@", self.yardCheck.landmark];
    
    SGYardCheckAssetParser *parser = [[SGYardCheckAssetParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKYARDCHECKL"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      NSLog(@"result = %@", parser.array);
                                                      if (parser.array != NULL) {
                                                          [loadingView removeFromSuperview];
                                                          array = parser.array;
                                                          [self.tableView reloadData];
                                                          self.sortButton.enabled = YES;
                                                      }
                                                  }];
    [portlet addParameter:@"id" value:self.yardCheck.landmark];
    [portlet invoke];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGYardCheckAsset *asset = [array objectAtIndex:indexPath.row];
    SGYardCheckAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YardCheckAssetCell"];
    [cell setAsset:asset];
    return cell;
}

- (void)didSelectOption:(NSString *)option
{
    if ([sortOption isEqualToString:option]) {
        if (sortOrder == SORT_ORDER_ASC) {
            sortOrder = SORT_ORDER_DESC;
        } else {
            sortOrder = SORT_ORDER_ASC;
        }
    } else {
        sortOrder = SORT_ORDER_ASC;
    }
    sortOption = option;
    
    NSString *sortKey = nil;
    if ([@"Asset" isEqualToString:option]) {
        sortKey = @"assetId";
    } else if ([@"Days" isEqualToString:option]) {
        sortKey = @"daysNotMoved";
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey
                                                                 ascending:(sortOrder == SORT_ORDER_ASC)
                                                                  selector:@selector(localizedStandardCompare:)];
    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGYardCheckAsset *asset = [array objectAtIndex:indexPath.row];
    
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGFindAssetParser *parser = [[SGFindAssetParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKASSETSIMPLEDETAIL"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      if (parser.asset != NULL) {
                                                          [loadingView removeFromSuperview];
                                                          [self performSegueWithIdentifier:@"YardCheckAssetSegue" sender:parser.asset];
                                                      }
                                                  }];
    [portlet addParameter:@"asset_id" value:asset.assetId];
    [portlet invoke];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.sortButton) {
        SGSortOptionsViewController *viewController = segue.destinationViewController;
        viewController.options = @[ @"Asset", @"Days" ];
        viewController.currentOption = sortOption;
        viewController.currentOrder = sortOrder;
        viewController.delegate = self;
    } else {
        SGFindAssetShortInfoViewController *viewController = segue.destinationViewController;
        viewController.asset = sender;
    }
}

@end
