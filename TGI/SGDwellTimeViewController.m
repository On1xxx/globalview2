//
//  SGDwellTimeViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeViewController.h"
#import "SGDwellTimeParser.h"
#import "SGPortlet.h"
#import "SGDwellTimeCell.h"
#import "SGDwellTime.h"
#import "SGLoadingView.h"
#import "SGDwellTimeAssetShortInfoViewController.h"
#import "SGDwellTimeTabBarController.h"
#import "SGSegmentedControl.h"
#import "SGSortOptionsViewController.h"
#import "SGSortOrder.h"

@implementation SGDwellTimeViewController
{
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

- (void)setArray:(NSArray *)array
{
    _array = array;
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGDwellTime *dwellTime = [self.array objectAtIndex:indexPath.row];
    
    SGDwellTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DwellTimeCell"];
    [cell setDwellTime:dwellTime];
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
    } else if ([@"Landmark" isEqualToString:option]) {
        sortKey = @"landmark";
    } else if ([@"Days" isEqualToString:option]) {
        sortKey = @"days";
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey
                                                                 ascending:(sortOrder == SORT_ORDER_ASC)
                                                                  selector:@selector(localizedStandardCompare:)];
    self.array = [self.array sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.tableView reloadData];
}

- (void)willSort
{
    [self performSegueWithIdentifier:@"SortOptionsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SortOptionsSegue"]) {
        SGSortOptionsViewController *viewController = segue.destinationViewController;
        viewController.options = @[@"Asset", @"Landmark", @"Days"];
        viewController.currentOption = sortOption;
        viewController.currentOrder = sortOrder;
        viewController.delegate = self;
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SGDwellTime *dwellTime = [self.array objectAtIndex:indexPath.row];
        
        SGDwellTimeAssetShortInfoViewController *viewController = segue.destinationViewController;
        viewController.title = self.title;
        viewController.dwellTime = dwellTime;
    }
}

@end
