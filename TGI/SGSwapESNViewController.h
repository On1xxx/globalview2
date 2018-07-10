//
//  SGSwapESNViewController.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGSwapESNViewController : UITableViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *assetIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *esnNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

- (IBAction)save:(id)sender;

@end
