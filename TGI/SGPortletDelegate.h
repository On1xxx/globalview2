//
//  SGPortletDelegate.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

@protocol SGPortletDelegate <NSObject>

@optional

- (void)onSuccess:(NSString *)tag result:(id)result;
- (void)onError:(NSString *)tag;

@end
