//
//  SGFindAssetParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGFindAssetParser.h"

@implementation SGFindAssetParser
{
    NSMutableDictionary *asset;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"TRKASSETSIMPLEDETAIL"]) {
        asset = [[NSMutableDictionary alloc] init];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters
{
     if ([elementName isEqualToString:@"TRKASSETSIMPLEDETAIL"]) {
        NSString *loc = [NSString stringWithFormat:@"%@, %@, %@",
                         [asset valueForKey:@"Last_City"],
                         [asset valueForKey:@"Last_Province_or_State"],
                         [asset valueForKey:@"Last_Country"]];
        [asset setValue:loc forKey:@"Last_Location"];
        NSLog(@"asset: %@", asset);
    } else {
        NSLog(@"element: %@ value: %@", elementName, characters);
        [asset setValue:characters forKey:elementName];
    }
}

- (NSDictionary *)asset
{
    return asset;
}

@end
