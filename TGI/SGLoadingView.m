//
//  SGLoadingView.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGLoadingView.h"

@implementation SGLoadingView

+ (SGLoadingView *)loadingView:(UIView *)view
{
    SGLoadingView *loadingView = [[SGLoadingView alloc] initWithFrame:view.bounds];
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:loadingView];
    return loadingView;
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
