//
//  SGDwellTimeTabBarController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGDwellTimeTabBarController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic) NSArray *array;

- (void)dwellTime;
- (void)detentionTime;

@end
