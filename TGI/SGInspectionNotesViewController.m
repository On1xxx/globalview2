//
//  SGInspectionNotesViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionNotesViewController.h"

@implementation SGInspectionNotesViewController {
    SGInspection *_inspection;
    BOOL _readOnly;
}

- (void)setInspection:(SGInspection *)inspection readOnly:(BOOL)readOnly {
    _inspection = inspection;
    _readOnly = readOnly;
}

- (void)viewDidLoad {
    self.textView.text = _inspection.notes;
    self.textView.editable = !_readOnly;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _inspection.notes = textView.text;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    
    CGRect newFrame = self.textView.frame;
    
    [self logRect:@"Text view frame" rect:newFrame];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    [self logRect:@"Keyboard frame" rect:keyboardFrame];
    
//    keyboardFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    self.textView.frame = newFrame;
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    
    [self logRect:@"Tab bar frame" rect:tabBarFrame];
    
    tabBarFrame.origin.y = tabBarFrame.origin.y - (keyboardFrame.size.height * (up ? 1 : -1));
    self.tabBarController.tabBar.frame = tabBarFrame;
    
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
@end
