//
//  SGInspectionHeaderTableTableViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionHeaderTableTableViewController.h"
#import "SGUserSettings.h"

@implementation SGInspectionHeaderTableTableViewController {
    BOOL _readOnly;
    NSInteger _datePickerCellHeight;
    BOOL _hidden;
}

- (void)setInspection:(SGInspection *)inspection readOnly:(BOOL)readOnly {
    _inspection = inspection;
    _readOnly = readOnly;
    
    if (self.inspection.registredOwner.length == 0) {
        self.inspection.registredOwner = [SGUserSettings registeredOwner];
    }

    if (self.inspection.inspector.length == 0) {
        self.inspection.inspector = [SGUserSettings inspector];
    }

    self.registredOwnerTextField.text = self.inspection.registredOwner;
    self.registredOwnerTextField.enabled = !readOnly;
    self.registredOwnerTextField.clearButtonMode = readOnly ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    self.safteyNoTextField.text = self.inspection.safteyNo;
    self.safteyNoTextField.enabled = !readOnly;
    self.safteyNoTextField.clearButtonMode = readOnly ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    self.claimNoTextField.text = self.inspection.claimNo;
    self.claimNoTextField.enabled = !readOnly;
    self.claimNoTextField.clearButtonMode = readOnly ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    self.inspectorTextField.text = self.inspection.inspector;
    self.inspectorTextField.enabled = !readOnly;
    self.inspectorTextField.clearButtonMode = readOnly ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    self.odometerValueTextField.text = self.inspection.odometerValue;
    self.odometerValueTextField.enabled = !readOnly;
    self.odometerValueTextField.clearButtonMode = readOnly ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    self.odometerUnitTextField.text = self.inspection.odometerUnit;
    self.plateNoTextField.text = self.inspection.plateNo;
    self.plateNoTextField.enabled = !readOnly;
    self.plateNoTextField.clearButtonMode = readOnly ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    
    if (inspection.dateTz.length == 0) {
        self.datePicker.date = [NSDate date];
        [self.inspection setLocalDate:self.datePicker.date];
    }
    self.dateTextField.text = self.inspection.dateTz;
    
    self.groupTextField.text = self.inspection.group;
    self.subGroupTextField.text = self.inspection.subGroup;
    self.typeTextField.text = self.inspection.type;
    self.vinTextField.text = self.inspection.vin;
    self.makeTextField.text = self.inspection.make;
    self.modelTextField.text = self.inspection.model;
    self.yearTextField.text = self.inspection.year;
    
    if (inspection.inspectionType.length == 0) {
        [self setInspectionType:[[self inspectionTypes] firstObject]];
    } else {
        [self setInspectionType:inspection.inspectionType];
    }

    if (inspection.odometerUnit.length == 0) {
        [self setOdometerUnit:[[self odometerUnits] firstObject]];
    } else {
        [self setOdometerUnit:inspection.odometerUnit];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.registredOwnerTextField.delegate = self;
    self.safteyNoTextField.delegate = self;
    self.claimNoTextField.delegate = self;
    self.inspectorTextField.delegate = self;
    self.odometerValueTextField.delegate = self;
    self.plateNoTextField.delegate = self;
        
    _datePickerCellHeight = CGRectGetHeight(self.datePickerCell.frame);
    _hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.registredOwnerTextField == textField) {
        self.inspection.registredOwner = textField.text;
    } else if (self.safteyNoTextField == textField) {
        self.inspection.safteyNo = textField.text;
    } else if (self.claimNoTextField == textField) {
        self.inspection.claimNo = textField.text;
    } else if (self.inspectorTextField == textField) {
        self.inspection.inspector = textField.text;
    } else if (self.odometerValueTextField == textField) {
        self.inspection.odometerValue = textField.text;
    } else if (self.plateNoTextField == textField) {
        self.inspection.plateNo = textField.text;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"INSPECTION_TYPE" isEqualToString:sender]) {
        SGLovViewController *controller = segue.destinationViewController;
        controller.title = @"Choose inspection type";
        controller.values = [self inspectionTypes];
        controller.currentValue = self.inspectionTypeTextField.text;
        controller.tag = sender;
        controller.delegate = self;
    } else if ([@"ODOMETER_UNIT" isEqualToString:sender]) {
        SGLovViewController *controller = segue.destinationViewController;
        controller.title = @"Choose odometer unit"; 
        controller.values = [self odometerUnits];
        controller.currentValue = self.odometerUnitTextField.text;
        controller.tag = sender;
        controller.delegate = self;
    }
}

- (void)valueChanged:(NSString *)newValue tag:(NSString *)tag {
    if ([@"INSPECTION_TYPE" isEqualToString:tag]) {
        [self setInspectionType:newValue];
    } else if ([@"ODOMETER_UNIT" isEqualToString:tag]) {
        [self setOdometerUnit:newValue];
    }
}

static NSArray *_inspectionTypes;

- (NSArray *)inspectionTypes {
    if (!_inspectionTypes) {
        _inspectionTypes = @[@"Incident inspection", @"Maintenance", @"CVOR inspection"];
    }
    return _inspectionTypes;
}

- (void)setInspectionType:(NSString *)inspectionType {
    self.inspectionTypeTextField.text = inspectionType;
    self.inspection.inspectionType = inspectionType;
}

static NSArray *_odometerUnits;

- (NSArray *)odometerUnits {
    if (!_odometerUnits) {
        _odometerUnits = @[@"KM", @"Miles"];
    }
    return _odometerUnits;
}

- (void)setOdometerUnit:(NSString *)newUnit {
    self.odometerUnitTextField.text = newUnit;
    self.inspection.odometerUnit = newUnit;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"DATE"]) {
        [tableView beginUpdates];
        
        _hidden = _readOnly || !_hidden;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView endUpdates];
    } else if ([cell.reuseIdentifier isEqualToString:@"INSPECTION_TYPE"]) {
        if (!_readOnly) {
            [self performSegueWithIdentifier:@"LOV" sender:@"INSPECTION_TYPE"];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if ([cell.reuseIdentifier isEqualToString:@"ODOMETER_UNIT"]) {
        if (!_readOnly) {
            [self performSegueWithIdentifier:@"LOV" sender:@"ODOMETER_UNIT"];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        self.datePicker.hidden = _hidden;
        return _hidden ? 0 : _datePickerCellHeight;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (IBAction)dateChanged:(id)sender {
    [self.inspection setLocalDate:self.datePicker.date];
    self.dateTextField.text = self.inspection.dateTz;
}

@end
