//
//  SGDwellTimeAssetInfoViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeAssetInfoViewController.h"
#import "SGDwellTimeAssetCell.h"
#import "SGColor.h"

@implementation SGDwellTimeAssetInfoViewController
{
    NSMutableArray *array;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)addField:(NSString *)key value:(NSString *)value
{
    [array addObject:[SGPair pairWithKey:key value:value]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGDwellTimeAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DwellTimeAssetCell"];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"Asset ID";
        cell.valueLabel.text = self.dwellTime.assetId;
        cell.valueLabel.textColor = [SGColor orange];
    } else {
        SGPair *row = [array objectAtIndex:indexPath.row];
        cell.titleLabel.text = row.key;
        cell.valueLabel.text = row.value;
        cell.valueLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

@end
