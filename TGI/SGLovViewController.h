//
//  SGLovViewController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGLovDelegate <NSObject>

- (void)valueChanged:(NSString *)newValue tag:(NSString *)tag;

@end

@interface SGLovViewController : UITableViewController

@property (strong, nonatomic) NSArray *values;
@property (weak, nonatomic) NSString *currentValue;

@property (strong, nonatomic) NSString *tag;
@property (weak, nonatomic) id <SGLovDelegate> delegate;

@end

