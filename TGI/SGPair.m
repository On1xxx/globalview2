//
//  SGKeyValuePair.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGPair.h"

@implementation SGPair

@synthesize key, value;

+ (SGPair *)pairWithKey:(NSString *)key value:(NSString *)value
{
    SGPair *pair = [[SGPair alloc] init];
    pair.key = key;
    pair.value = value;
    return pair;
}

@end
