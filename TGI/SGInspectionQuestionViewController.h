//
//  SGInspectionQuestionViewController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGInspection.h"
#import "SGInspectionCategory.h"
#import "SGInspectionQuestion.h"

@interface SGInspectionQuestionViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate, UINavigationBarDelegate>

@property (weak, nonatomic) SGInspection *inspection;
@property (nonatomic) NSInteger categoryIndex;
@property (nonatomic) NSInteger questionIndex;
@property (nonatomic) BOOL readOnly;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *repairedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UITextField *readingTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;

- (IBAction)onStatusChanged:(UISegmentedControl *)sender;
- (IBAction)onRepairedChanged:(UISwitch *)sender;
- (IBAction)readingEditingDidEnd:(id)sender;

- (IBAction)prevQuestion:(id)sender;
- (IBAction)nextQuestion:(id)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *readingTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *rangeTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *infoTableViewCell;

@end
