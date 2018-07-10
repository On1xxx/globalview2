//
//  SGSwapESNCommentViewController.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSwapESN.h"

@interface SGSwapESNCommentViewController : UIViewController

@property (weak, nonatomic) SGSwapESN *obj;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

- (IBAction)save:(id)sender;

@end
