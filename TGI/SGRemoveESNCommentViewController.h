//
//  SGRemoveESNCommentViewController.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGRemoveESN.h"

@interface SGRemoveESNCommentViewController : UIViewController

@property (weak, nonatomic) SGRemoveESN *obj;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

- (IBAction)save:(id)sender;

@end
