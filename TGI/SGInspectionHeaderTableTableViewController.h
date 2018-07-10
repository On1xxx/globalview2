//
//  SGInspectionHeaderTableTableViewController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGInspectionViewControllerDelegate.h"
#import "SGLovViewController.h"
#import "SGInspection.h"

@interface SGInspectionHeaderTableTableViewController : UITableViewController <SGInspectionViewControllerDelegate, SGLovDelegate, UITextFieldDelegate>

@property (weak, nonatomic) SGInspection* inspection;

@property (weak, nonatomic) IBOutlet UITextField *registredOwnerTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *safteyNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *claimNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *inspectionTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *inspectorTextField;
@property (weak, nonatomic) IBOutlet UITextField *odometerValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *odometerUnitTextField;
@property (weak, nonatomic) IBOutlet UITextField *plateNoTextField;

@property (weak, nonatomic) IBOutlet UITextField *groupTextField;
@property (weak, nonatomic) IBOutlet UITextField *subGroupTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *vinTextField;
@property (weak, nonatomic) IBOutlet UITextField *makeTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)dateChanged:(id)sender;

@end
