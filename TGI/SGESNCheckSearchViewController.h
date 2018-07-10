//
//  SGESNCheckSearchViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGESNCheckSearchViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *esnTextField;

- (IBAction)search:(id)sender;

@end
