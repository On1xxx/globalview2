//
//  SGAssetUtilizationByGroupOrAssetListViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetUtilizationByGroupOrAssetListViewController.h"
#import "SGLoadingView.h"
#import "SGPortlet.h"
#import "SGAssetUtilizationByGroupOrAssetParser.h"
#import "SGAssetUtilizationCell.h"
#import "SGAssetUtilizationExpCell.h"
#import "SGFindAssetParser.h"
#import "SGFindAssetShortInfoViewController.h"
#import "SGSortOrder.h"

@implementation SGAssetUtilizationByGroupOrAssetListViewController
{
    NSArray *array;
    NSDateFormatter *dateFormatter;
    NSIndexPath *path;
    NSString *currentSortOption;
    SGSortOrder currentSortOrder;
}
@synthesize sortButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        currentSortOption = @"";
        currentSortOrder = SORT_ORDER_NONE;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    self.sortButton.enabled = NO;
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGAssetUtilizationByGroupOrAssetParser *parser = [[SGAssetUtilizationByGroupOrAssetParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKUTILIZATIONGP"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      if (parser.array != NULL) {
                                                          NSLog(@"Received %d results", parser.array.count);
                                                          array = parser.array;
                                                          [self.tableView reloadData];
                                                          self.sortButton.enabled = YES;
                                                          [loadingView removeFromSuperview];
                                                      }
                                                  }
                                                    onError:^() {
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }];
    [portlet addParameter:@"s_date" value:self.fromDate ? [dateFormatter stringFromDate:self.fromDate] : @""];
    [portlet addParameter:@"e_date" value:self.toDate ? [dateFormatter stringFromDate:self.toDate] : @""];
    [portlet addParameter:@"range" value:self.range];
    [portlet addParameter:@"dis" value:self.type];
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
    SGAssetUtilizationData *data = [array objectAtIndex:indexPath.row];
    
    if (path && path.row == indexPath.row) {
        SGAssetUtilizationExpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetUtilExpCell"];
        cell.delegate = self;
        cell.data = data;
        return cell;
    } else {
        SGAssetUtilizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetUtilCell"];
        cell.delegate = self;
        cell.data = [array objectAtIndex:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (path && path.row == indexPath.row) {
        return 178; // 149
    } else {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    [paths addObject:indexPath];
    
    if (path) {
        if (path.row != indexPath.row) {
            [paths addObject:path];
            path = indexPath;
        } else {
            path = nil;
        }
    } else {
        path = indexPath;
    }

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)showAssetInfo:(NSString *)asset
{
    NSLog(@"Show asset %@ info", asset);
    if (![asset isEqualToString:@""]) {
        SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
        
        SGFindAssetParser *parser = [[SGFindAssetParser alloc] init];
        SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TRKASSETSIMPLEDETAIL"
                                                         parser:parser
                                                      onSuccess:^() {
                                                          if (parser.asset != NULL) {
                                                              [loadingView removeFromSuperview];
                                                              [self performSegueWithIdentifier:@"ShowAssetInfo" sender:parser.asset];
                                                          }
                                                      }];
        [portlet addParameter:@"asset_id" value:asset];
        [portlet invoke];
    }
}

- (void)didSelectOption:(NSString *)option
{
    NSLog(@"Old: %@ (%d), new: %@", currentSortOption, currentSortOrder, option);
    if ([currentSortOption isEqualToString:option]) {
        if (currentSortOrder == SORT_ORDER_ASC) {
            currentSortOrder = SORT_ORDER_DESC;
        } else {
            currentSortOrder = SORT_ORDER_ASC;
        }
    } else {
        currentSortOrder = SORT_ORDER_ASC;
    }
    currentSortOption = option;

    NSSortDescriptor *descriptor;
    if ([currentSortOption isEqualToString:@"Avg"]) {
        descriptor = [NSSortDescriptor sortDescriptorWithKey:@"avgValue"
                                                   ascending:(currentSortOrder == SORT_ORDER_ASC)];
    } else {
        NSString *key;
        if ([currentSortOption isEqualToString:@"Asset"]) {
            key = @"asset";
        } else if ([currentSortOption isEqualToString:@"Group"]) {
            key = @"group";
        } else if ([currentSortOption isEqualToString:@"Sub group"]) {
            key = @"subGroup";
        } else if ([currentSortOption isEqualToString:@"Type"]) {
            key = @"type";
        }
        descriptor  = [NSSortDescriptor sortDescriptorWithKey:key
                                                    ascending:(currentSortOrder == SORT_ORDER_ASC)
                                                     selector:@selector(localizedStandardCompare:)];
    }
    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.sortButton) {
        SGSortOptionsViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        NSMutableArray *options = [NSMutableArray arrayWithObjects: @"Group", @"Sub group", @"Type", @"Avg", nil];
        if ([self.type isEqualToString:@"Asset"]) {
            [options insertObject:@"Asset" atIndex:0];
        }
        viewController.options = options;
        viewController.currentOption = currentSortOption;
        viewController.currentOrder = currentSortOrder;
    } else {
        SGFindAssetShortInfoViewController *viewController = segue.destinationViewController;
        viewController.asset = sender;
    }
}

@end
