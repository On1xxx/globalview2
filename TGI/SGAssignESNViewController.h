//
//  SGAssignESNViewController.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPortletDelegate.h"

@interface SGAssignESNViewController : UITableViewController <UIAlertViewDelegate, SGPortletDelegate>

@property (weak, nonatomic) IBOutlet UITextField *assetNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *esnTextField;

@property (weak, nonatomic) IBOutlet UITextField *assetGroupTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *assetGroupCell;

@property (weak, nonatomic) IBOutlet UITextField *subGroupTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *subGroupCell;

@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;

@property (weak, nonatomic) IBOutlet UITextField *assetAccountTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *assetAccountCell;

@property (weak, nonatomic) IBOutlet UITextField *vinTextField;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;

- (IBAction)assign:(id)sender;

@end
