//
//  SGAssignESNViewController.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGAssignESNViewController.h"
#import "SGAssignESNSelectionViewController.h"
#import "SGAssignESNCommentsViewController.h"
#import "SGAssignESN.h"
#import "SGLoadingView.h"
#import "SGPortlet.h"
#import "SGAssignESNParser.h"
#import "SGDictListParser.h"

@implementation SGAssignESNViewController {
    SGAssignESN *_obj;
    SGLoadingView *_loadingView;

    NSMutableArray *_tags;
    BOOL _error;
    NSArray *_groups;
    NSArray *_subGroups;
    NSArray *_types;
    NSArray *_accounts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _obj = [[SGAssignESN alloc] init];
    
    _loadingView = [SGLoadingView loadingView:self.view];
    
    _tags = [[NSMutableArray alloc] initWithArray:@[@"group", @"subgroup", @"type", @"account"]];
    _error = false;
    [self getItems:@"group" item:@"Group"];
    [self getItems:@"subgroup" item:@"Sub Group"];
    [self getItems:@"type" item:@"Type"];
    [self getItems:@"account" item:@"Account"];
}

- (void)getItems:(NSString *)tag item:(NSString *)item {
    SGDictListParser *parser = [[SGDictListParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"TGILIST"
                                                        tag:tag
                                                     parser:parser
                                                   delegate:self];
    [portlet setDisplayError:false];
    [portlet addParameter:@"opp" value:@"list"];
    [portlet addParameter:@"section" value:@"Asset"];
    [portlet addParameter:@"item" value:item];
    [portlet invoke];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshData];
    [super viewWillAppear:animated];
}

- (void)refreshData {
    self.assetGroupTextField.text = _obj.groupLabel;
    self.subGroupTextField.text = _obj.subGroupLabel;
    self.typeTextField.text = _obj.typeLabel;
    self.assetAccountTextField.text = _obj.accountLabel;
    self.commentsTextField.text = _obj.comments;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseGroup"]) {
        SGAssignESNSelectionViewController *controller = segue.destinationViewController;
        controller.title = @"Asset Group";
        controller.items = _groups;
        controller.obj = _obj;
        controller.target = 1;
    } else if ([segue.identifier isEqualToString:@"chooseSubGroup"]) {
        SGAssignESNSelectionViewController *controller = segue.destinationViewController;
        controller.title = @"Sub Group";
        controller.items = _subGroups;
        controller.obj = _obj;
        controller.target = 2;
    } else if ([segue.identifier isEqualToString:@"chooseType"]) {
        SGAssignESNSelectionViewController *controller = segue.destinationViewController;
        controller.title = @"Type";
        controller.items = _types;
        controller.obj = _obj;
        controller.target = 3;
    } else if ([segue.identifier isEqualToString:@"chooseAccount"]) {
        SGAssignESNSelectionViewController *controller = segue.destinationViewController;
        controller.title = @"Asset Account";
        controller.items = _accounts;
        controller.obj = _obj;
        controller.target = 4;
    } else if ([segue.identifier isEqualToString:@"comments"]) {
        SGAssignESNCommentsViewController *controller = segue.destinationViewController;
        controller.obj = _obj;
    }
}

- (IBAction)assign:(id)sender {
    if (self.assetNumberTextField.text.length == 0) {
        [self showError:@"Asset Number must be filled in"];
        return;
    }
    if (self.esnTextField.text.length == 0) {
        [self showError:@"ESN must be filled in"];
        return;
    }
    
    SGLoadingView *loadingView = [SGLoadingView loadingView:self.view];
    
    SGAssignESNParser *parser = [[SGAssignESNParser alloc] init];
    SGPortlet *portlet = [[SGPortlet alloc] initWithPortlet:@"ASSIGNESN"
                                                     parser:parser
                                                  onSuccess:^() {
                                                      if (parser.result != NULL) {
                                                          [self showResult:parser.result];
                                                      }
                                                  }
                                                    onError:^() {
                                                        [loadingView dismiss];
                                                    }];
    [portlet addParameter:@"asset" value:self.assetNumberTextField.text];
    [portlet addParameter:@"esn" value:self.esnTextField.text];
    [portlet addParameter:@"asset_group" value:_obj.groupValue];
    [portlet addParameter:@"sub_group" value:_obj.subGroupValue];
    [portlet addParameter:@"type" value:_obj.typeValue];
    [portlet addParameter:@"account" value:_obj.accountValue];
    [portlet addParameter:@"vin" value:self.vinTextField.text];
    [portlet addParameter:@"plate_number" value:self.plateNumberTextField.text];
    [portlet addParameter:@"comments" value:_obj.comments];
    [portlet invoke];
}

- (void)showResult:(NSString *)result {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result"
                                                    message:result
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSuccess:(NSString *)tag result:(id)result {
    NSLog(@"success: %@", tag);
    [self onResult:tag items:result];
}

- (void)onError:(NSString *)tag {
    NSLog(@"error: %@", tag);
    _error = true;
    [self onResult:tag items:nil];
}

- (void)onResult:(NSString *)tag items:(NSArray *)items {
    BOOL enabled = items != nil;
    @synchronized(_tags) {
        SGDictListItem *firstItem = [items firstObject];
        if ([tag isEqualToString:@"group"]) {
            self.assetGroupCell.userInteractionEnabled = enabled;
            _groups = items;
            _obj.groupValue = firstItem.itemCode;
            _obj.groupLabel = firstItem.itemDescription;
        } else if ([tag isEqualToString:@"subgroup"]) {
            self.subGroupCell.userInteractionEnabled = enabled;
            _subGroups = items;
            _obj.subGroupValue = firstItem.itemCode;
            _obj.subGroupLabel = firstItem.itemDescription;
        } else if ([tag isEqualToString:@"type"]) {
            self.typeCell.userInteractionEnabled = enabled;
            _types = items;
            _obj.typeValue = firstItem.itemCode;
            _obj.typeLabel = firstItem.itemDescription;
        } else if ([tag isEqualToString:@"account"]) {
            self.assetAccountCell.userInteractionEnabled = enabled;
            _accounts = items;
            _obj.accountValue = firstItem.itemCode;
            _obj.accountLabel = firstItem.itemDescription;
            if (!enabled) {
                self.assetAccountCell.hidden = YES;
            }
        }
        [_tags removeObject:tag];
        // all tags have been fetched
        if ([_tags count] == 0) {
            [self refreshData];
            [_loadingView dismiss];
        }
    }
}

@end
