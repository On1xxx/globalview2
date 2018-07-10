//
//  SGFindAssetSearchViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFindAssetSearchViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *assetIdField;

- (IBAction)searchAsset:(id)sender;

@end
