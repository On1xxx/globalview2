//
//  SGAssignESNCommentsViewController.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGAssignESNCommentsViewController.h"

@implementation SGAssignESNCommentsViewController

- (void)viewWillAppear:(BOOL)animated {
    self.commentsTextView.text = self.obj.comments;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.commentsTextView becomeFirstResponder];
}

- (IBAction)save:(id)sender {
    self.obj.comments = self.commentsTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
