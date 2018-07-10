//
//  SGOptionsFontSizeViewControllerViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGOptionsFontSizeViewController.h"

@implementation SGOptionsFontSizeViewController

@synthesize optionsController;
@synthesize fontSize;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FontSizeCell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Small";
            break;
        case 1:
            cell.textLabel.text = @"Medium";
            break;
        case 2:
            cell.textLabel.text = @"Large";
            break;
    }
    if (indexPath.row == fontSize) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [optionsController setFontSize:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
