//
//  SGAssignESNCommentsViewController.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAssignESN.h"

@interface SGAssignESNCommentsViewController : UIViewController

@property (weak, nonatomic) SGAssignESN *obj;

@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;

- (IBAction)save:(id)sender;

@end
