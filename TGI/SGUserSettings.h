//
//  SGUserSettings.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGUserSettings : NSObject

+ (void)setCompany:(NSString *)company;
+ (NSString *)company;

+ (void)setUsername:(NSString *)username;
+ (NSString *)username;

+ (void)setPassword:(NSString *)password;
+ (NSString *)password;

+ (void)setRegisteredOwner:(NSString *)registeredOwner;
+ (NSString *)registeredOwner;

+ (void)setInspector:(NSString *)inspector;
+ (NSString *)inspector;

+ (void)setFontSize:(NSInteger)size;
+ (NSInteger)fontSize;

+ (void)setAcceptanceDate:(NSDate *)date;
+ (NSDate *)acceptanceDate;

+ (void)setServerURL:(NSString *)url;
+ (NSString *)serverURL;

+ (void)setInspectionSchema:(NSString *)xml;
+ (NSString *)inspectionSchema;

@end
