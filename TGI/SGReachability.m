//
//  SGReachability.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGReachability.h"

#import <Reachability.h>
#import "SGUserSettings.h"

@implementation SGReachability

+ (BOOL)isReachable {
    NSURL *url = [NSURL URLWithString:[SGUserSettings serverURL]];
    Reachability *reach = [Reachability reachabilityWithHostname:url.host];
    return [reach isReachable];
}

@end
