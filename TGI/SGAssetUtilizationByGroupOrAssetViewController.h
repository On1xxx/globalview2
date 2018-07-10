//
//  SGAssetUtilizationByGroupOrAssetViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGAssetUtilizationByGroupOrAssetViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dateFromTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateToTextField;
@property (weak, nonatomic) IBOutlet UITextField *rangeTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (strong, nonatomic) IBOutlet UIDatePicker *dateFromDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateToDatePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *rangePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)closePicker:(id)sender;

@end
