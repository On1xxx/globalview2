//
//  SGSortOptionsViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGSortOptionsViewController.h"
#import "SGSortOptionCell.h"

@implementation SGSortOptionsViewController

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option = [self.options objectAtIndex:indexPath.row];
    
    SGSortOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortOptionCell"];
    cell.option = option;
    if ([self.currentOption isEqualToString:option]) {
        cell.order =  self.currentOrder;
    } else {
        cell.order = SORT_ORDER_NONE;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option = [self.options objectAtIndex:indexPath.row];
    
    NSLog(@"Dismissing modal view");
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Invoking delegate");
    [self.delegate didSelectOption:option];
}

@end
