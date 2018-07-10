//
//  SGAssignESNSelection.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAssignESN : NSObject

@property (strong, nonatomic) NSString *groupValue;
@property (strong, nonatomic) NSString *groupLabel;
@property (strong, nonatomic) NSString *subGroupValue;
@property (strong, nonatomic) NSString *subGroupLabel;
@property (strong, nonatomic) NSString *typeValue;
@property (strong, nonatomic) NSString *typeLabel;

@property (strong, nonatomic) NSString *accountValue;
@property (strong, nonatomic) NSString *accountLabel;

@property (strong, nonatomic) NSString *comments;

@end
