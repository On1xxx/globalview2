//
//  SGKeyValuePair.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPair : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *value;

+ (SGPair *)pairWithKey:(NSString *)key value:(NSString *)value;

@end
