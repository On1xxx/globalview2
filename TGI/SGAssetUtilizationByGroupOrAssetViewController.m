//
//  SGAssetUtilizationByGroupOrAssetViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetUtilizationByGroupOrAssetViewController.h"
#import "SGAssetUtilizationByGroupOrAssetListViewController.h"

@implementation SGAssetUtilizationByGroupOrAssetViewController
{
    NSDateFormatter *dateFormatter;
    NSArray *rangeChoices;
    NSArray *typeChoices;
    UITextField *lastTextField;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        rangeChoices = @[
            @"",
            @"Today",
            @"Yesterday",
            @"This week",
            @"Last week",
            @"This month",
            @"Last month",
            @"This year",
            @"Last year",
        ];
        
        typeChoices = @[ @"Group", @"Asset" ];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)viewDidLoad
{
    NSDate *now = [NSDate date];
    
    self.dateFromDatePicker.date = now;
    self.dateFromTextField.inputView = self.dateFromDatePicker;
    self.dateFromTextField.inputAccessoryView = self.toolbar;
    self.dateFromTextField.text = [dateFormatter stringFromDate:now];
    self.dateFromTextField.delegate = self;
    
    self.dateToDatePicker.date = now;
    self.dateToTextField.inputView = self.dateToDatePicker;
    self.dateToTextField.inputAccessoryView = self.toolbar;
    self.dateToTextField.text = [dateFormatter stringFromDate:now];
    self.dateToTextField.delegate = self;
    
    self.rangePicker.dataSource = self;
    self.rangePicker.delegate = self;
    self.rangeTextField.inputView = self.rangePicker;
    self.rangeTextField.inputAccessoryView = self.toolbar;
//    self.rangeTextField.text = [rangeChoices objectAtIndex:0];
    self.rangeTextField.delegate = self;
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    self.typeTextField.inputView = self.typePicker;
    self.typeTextField.inputAccessoryView = self.toolbar;
    self.typeTextField.text = [typeChoices objectAtIndex:0];
    self.typeTextField.delegate = self;
}

- (IBAction)dateFromValueChanged:(id)sender
{
    self.dateFromTextField.text = [dateFormatter stringFromDate:self.dateFromDatePicker.date];
}

- (IBAction)dateToValueChanged:(id)sender
{
    self.dateToTextField.text = [dateFormatter stringFromDate:self.dateToDatePicker.date];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.rangePicker) {
        return rangeChoices.count;
    } else {
        return typeChoices.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.rangePicker) {
        return [rangeChoices objectAtIndex:row];
    } else {
        return [typeChoices objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    if (pickerView == self.rangePicker) {
        self.rangeTextField.text = title;
        
        if ([title isEqualToString:@""]) {
            self.dateFromTextField.enabled = YES;
            self.dateFromTextField.text = [dateFormatter stringFromDate:self.dateFromDatePicker.date];
            self.dateToTextField.enabled = YES;
            self.dateToTextField.text = [dateFormatter stringFromDate:self.dateToDatePicker.date];
        } else {
            self.dateFromTextField.enabled = NO;
            self.dateFromTextField.text = @"--";
            self.dateToTextField.enabled = NO;
            self.dateToTextField.text = @"--";
        }
    } else {
        self.typeTextField.text = title;
    }    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    lastTextField = textField;
    
    if (textField == self.rangeTextField) {
        if ([self.rangeTextField.text isEqualToString:@""]) {
            self.rangeTextField.text = [rangeChoices objectAtIndex:0];
        }
    }
}

- (IBAction)closePicker:(id)sender
{
    [lastTextField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SGAssetUtilizationByGroupOrAssetListViewController *viewController = segue.destinationViewController;
    
    if ([self.dateFromTextField.text isEqualToString:@"--"]) {
        viewController.fromDate = nil;
    } else {
        viewController.fromDate = self.dateFromDatePicker.date;
    }
    
    if ([self.dateToTextField.text isEqualToString:@"--"]) {
        viewController.toDate = nil;
    } else {
        viewController.toDate = self.dateToDatePicker.date;
    }
    
    viewController.range = self.rangeTextField.text;
    viewController.type = self.typeTextField.text;
}

@end
