//
//  SGInspectionQuestionViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionQuestionViewController.h"
#import "NSString+SGUtils.h"

@implementation SGInspectionQuestionViewController {
    CGFloat _height;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
}

- (SGInspectionCategory *)currentCategory {
    return [_inspection getCategoryAtIndex:_categoryIndex];
}

- (SGInspectionQuestion *)currentQuestion {
    return [[self currentCategory] getQuestionAtIndex:_questionIndex];
}

- (BOOL)isNextCategory {
    return _categoryIndex + 1 < [_inspection getCategoryCount];
}

- (BOOL)isPrevCategory {
    return _categoryIndex > 0;
}

- (BOOL)isNextQuestion {
    return _questionIndex + 1 < [[self currentCategory] getQuestionCount];
}

- (BOOL)isPrevQuestion {
    return _questionIndex > 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)onStatusChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self currentQuestion].status = SGInspectionQuestionStatusPass;
    } else if (sender.selectedSegmentIndex == 1) {
        [self currentQuestion].status = SGInspectionQuestionStatusSkip;
    } else if (sender.selectedSegmentIndex == 2) {
        [self currentQuestion].status = SGInspectionQuestionStatusFail;
    }
    [self.view endEditing:YES];
}

- (IBAction)onRepairedChanged:(UISwitch *)sender {
    [self currentQuestion].repaired = sender.isOn;
    [self.view endEditing:YES];
}

- (IBAction)readingEditingDidEnd:(UITextField *)sender {
    [self currentQuestion].value = sender.text;
    [self.view endEditing:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self currentQuestion].note = textView.text;
    [self.view endEditing:YES];
}

- (IBAction)prevQuestion:(id)sender {
    [self.view endEditing:YES];
    NSLog(@"Prev question");
    
    if (![self validateQuestion:[self currentQuestion]]) {
        NSLog(@"Invalid");
        return;
    }
    
    if ([self isPrevQuestion]) {
        _questionIndex -= 1;
    } else {
        if ([self isPrevCategory]) {
            _categoryIndex -= 1;
            _questionIndex = [[self currentCategory] getQuestionCount] - 1;
        }
    }
    [self refresh];
}

- (IBAction)nextQuestion:(id)sender {
    [self.view endEditing:YES];
    NSLog(@"Next question");
    
    if (![self validateQuestion:[self currentQuestion]]) {
        NSLog(@"Invalid");
        return;
    }
    
    if ([self isNextQuestion]) {
        _questionIndex += 1;
    } else {
        if ([self isNextCategory]) {
            _categoryIndex += 1;
            _questionIndex = 0;
        }
    }
    [self refresh];
}

- (void)refresh {
    SGInspectionCategory *c = [self currentCategory];
    SGInspectionQuestion *q = [self currentQuestion];
    
    NSLog(@"Title: (%@/%@), type: %@", c.title, q.title, q.type);
    
    [self.tableView beginUpdates];
    
    self.categoryLabel.text = c.title;
    self.questionLabel.text = q.title;
    if (q.status == SGInspectionQuestionStatusPass) {
        self.statusSegmentedControl.selectedSegmentIndex = 0;
    } else if (q.status == SGInspectionQuestionStatusSkip) {
        self.statusSegmentedControl.selectedSegmentIndex = 1;
    } else if (q.status == SGInspectionQuestionStatusFail) {
        self.statusSegmentedControl.selectedSegmentIndex = 2;
    }
    self.statusSegmentedControl.enabled = !_readOnly;
    self.repairedSwitch.on = q.repaired;
    self.repairedSwitch.enabled = !_readOnly;
    if ([@"range" isEqualToString:q.type] || [@"decimal" isEqualToString:q.type] || [@"integer" isEqualToString:q.type]) {
        self.readingTextField.text = q.value;
        self.readingTextField.enabled = !_readOnly;
        self.readingTableViewCell.hidden = NO;
    } else {
        self.readingTableViewCell.hidden = YES;
    }
    
    if ([@"range" isEqualToString:q.type]) {
        self.rangeLabel.text = [NSString stringWithFormat:@"(%.5f - %.5f)", [q.rangeLow doubleValue], [q.rangeHigh doubleValue]];
        self.rangeTableViewCell.hidden = NO;
    } else {
        self.rangeTableViewCell.hidden = YES;
    }

    if ([q.info isEmpty]) {
        self.infoTableViewCell.hidden = YES;
    } else {
        self.infoLabel.text = q.info;
        self.infoTableViewCell.hidden = NO;
    }

    self.noteTextView.text = q.note;
    self.noteTextView.editable = !_readOnly;
    
    [self.tableView endUpdates];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self logRect:@"Keyboard end frame" rect:keyboardEndFrame];
    
    CGRect newFrame = self.view.frame;
    
    [self logRect:@"Text view frame" rect:newFrame];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    [self logRect:@"Keyboard frame" rect:keyboardFrame];
    
    //    keyboardFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    self.view.frame = newFrame;
    
    CGRect toolbarFrame = self.navigationController.toolbar.frame;
    
    [self logRect:@"Toolbar frame" rect:toolbarFrame];
    
    toolbarFrame.origin.y = toolbarFrame.origin.y - (keyboardFrame.size.height * (up ? 1 : -1));
    self.navigationController.toolbar.frame = toolbarFrame;
    
    [UIView commitAnimations];
}

- (void)logRect:(NSString *)name rect:(CGRect)rect {
    NSLog(@"%@", name);
    NSLog(@"origin.x: %f, origin.y: %f", rect.origin.x, rect.origin.y);
    NSLog(@"size.w: %f, size.h: %f", rect.size.width, rect.size.height);
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return self.readingTableViewCell.hidden ? 0 : 75;
    } else if (indexPath.row == 3) {
        return self.rangeTableViewCell.hidden ? 0 : 25;
    } else if (indexPath.row == 4) {
        return self.infoTableViewCell.hidden ? 0 : 25;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
                                                                 
- (void)done:(id)sender {
    [self.view endEditing:YES];
    SGInspectionQuestion *q = [self currentQuestion];
    if ([self validateQuestion:q]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)validateQuestion:(SGInspectionQuestion *)q {
    NSMutableString *msg = [[NSMutableString alloc] init];

    BOOL valid = [self validateNote:q msg:msg] && [self validateRange:q msg:msg];

    if (!valid) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[msg trim]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }

    return valid;
}

- (BOOL)validateNote:(SGInspectionQuestion *)q msg:(NSMutableString *)msg {
    BOOL mandatoryNote = NO;
    
    if (q.status == SGInspectionQuestionStatusFail || q.repaired) {
        mandatoryNote = YES;
    }
    
    if (mandatoryNote && [q.note isEmpty]) {
        [msg appendString:@"\nNote is mandatory"];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)validateRange:(SGInspectionQuestion *)q msg:(NSMutableString *)msg {
    if (![@"range" isEqualToString:q.type] || [q.value isEmpty]) {
        return YES;
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *v = [f numberFromString:q.value];
    
    BOOL outOfRange = ([v doubleValue] < [q.rangeLow doubleValue]) || ([v doubleValue] > [q.rangeHigh doubleValue]);
    
    if (outOfRange && (q.status == SGInspectionQuestionStatusPass && !q.repaired)) {
        [msg appendString:@"\nValue is out of range"];
        return NO;
    } else {
        return YES;
    }
}

@end
