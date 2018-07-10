//
//  SGInspectionNotesViewController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGInspectionViewControllerDelegate.h"

@interface SGInspectionNotesViewController : UIViewController <SGInspectionViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
