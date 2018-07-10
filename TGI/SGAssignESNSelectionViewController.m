//
//  SGAssignESNSelectionViewController.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGAssignESNSelectionViewController.h"
#import "SGDictListItem.h"

@implementation SGAssignESNSelectionViewController {
    NSString *_selectedItemValue;
}

- (void)viewDidLoad {
    if (self.target == 1) {
        _selectedItemValue = self.obj.groupValue;
    } else if (self.target == 2) {
        _selectedItemValue = self.obj.subGroupValue;
    } else if (self.target == 3) {
        _selectedItemValue = self.obj.typeValue;
    } else if (self.target == 4) {
        _selectedItemValue = self.obj.accountValue;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGDictListItem *item = self.items[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    cell.textLabel.text = item.itemDescription;
    
    if ([_selectedItemValue isEqualToString:item.itemCode]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SGDictListItem *item = self.items[indexPath.row];
    if (self.target == 1) {
        self.obj.groupValue = item.itemCode;
        self.obj.groupLabel = item.itemDescription;
    } else if (self.target == 2) {
        self.obj.subGroupValue = item.itemCode;
        self.obj.subGroupLabel = item.itemDescription;
    } else if (self.target == 3) {
        self.obj.typeValue = item.itemCode;
        self.obj.typeLabel = item.itemDescription;
    } else if (self.target == 4) {
        self.obj.accountValue = item.itemCode;
        self.obj.accountLabel = item.itemDescription;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
