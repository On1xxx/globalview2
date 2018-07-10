//
//  SGRemoveESNCommentViewController.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGRemoveESNCommentViewController.h"

@implementation SGRemoveESNCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    self.commentTextView.text = self.obj.comment;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.commentTextView becomeFirstResponder];
}

- (IBAction)save:(id)sender {
    self.obj.comment = self.commentTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
