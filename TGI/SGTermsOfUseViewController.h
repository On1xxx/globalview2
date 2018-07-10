//
//  SGTermsOfUseViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGTermsOfUseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;

- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;

@end
