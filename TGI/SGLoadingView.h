//
//  SGLoadingView.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <SAMLoadingView/SAMLoadingView.h>

@interface SGLoadingView : SAMLoadingView

+ (SGLoadingView *)loadingView:(UIView *)view;

- (void)dismiss;

@end
