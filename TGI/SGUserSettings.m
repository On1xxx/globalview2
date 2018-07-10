//
//  SGUserSettings.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGUserSettings.h"

NSString * const CompanyPrefKey = @"TGICompanyPrefKey";
NSString * const UsernamePrefKey = @"TGIUsernamePrefKey";
NSString * const PasswordPrefKey = @"TGIPasswordPrefKey";
NSString * const RegisteredOwnerPrefKey = @"TGIRegisteredOwnerPrefKey";
NSString * const InspectorPrefKey = @"TGIInspectorPrefKey";
NSString * const FontSizePrefKey = @"TGIFontSizePrefKey";
NSString * const AcceptanceDatePrefKey = @"TGIAcceptanceDatePrefKey";
NSString * const ServerPrefKey = @"TGIServerPrefKey";
NSString * const InspectionSchemaPrefKey = @"TGIInspectionSchemaPrefKey";

@implementation SGUserSettings

+ (void)setCompany:(NSString *)company
{
    [[NSUserDefaults standardUserDefaults] setObject:company forKey:CompanyPrefKey];
}

+ (NSString *)company
{
    NSString *c = [[NSUserDefaults standardUserDefaults] stringForKey:CompanyPrefKey];
    return c.length == 0 ? @"Global View" : c;
}

+ (void)setUsername:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:UsernamePrefKey];
}

+ (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:UsernamePrefKey];
}

+ (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:PasswordPrefKey];  
}

+ (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PasswordPrefKey];
}

+ (void)setRegisteredOwner:(NSString *)registeredOwner
{
    [[NSUserDefaults standardUserDefaults] setObject:registeredOwner forKey:RegisteredOwnerPrefKey];
}

+ (NSString *)registeredOwner
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:RegisteredOwnerPrefKey];
}

+ (void)setInspector:(NSString *)inspector
{
    [[NSUserDefaults standardUserDefaults] setObject:inspector forKey:InspectorPrefKey];
}

+ (NSString *)inspector
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:InspectorPrefKey];
}

+ (void)setFontSize:(NSInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:FontSizePrefKey];
}

+ (NSInteger)fontSize
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:FontSizePrefKey];
    if (!obj) {
        return 1;
    } else {
        return [[NSUserDefaults standardUserDefaults] integerForKey:FontSizePrefKey];
    }
}

+ (void)setAcceptanceDate:(NSDate *)date
{
    NSTimeInterval t = [date timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:t forKey:AcceptanceDatePrefKey];
}

+ (NSDate *)acceptanceDate
{
    NSTimeInterval t = [[NSUserDefaults standardUserDefaults] doubleForKey:AcceptanceDatePrefKey];
    if (t) {
        return [NSDate dateWithTimeIntervalSince1970:t];
    } else {
        return nil;
    }
}

+ (void)setServerURL:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:ServerPrefKey];
}

+ (NSString *)serverURL
{
    NSString *s = [[NSUserDefaults standardUserDefaults] stringForKey:ServerPrefKey];
    return s.length == 0 ? @"https://tw1.tgi-connect.com/webservices/ws.cgi" : s;
}

+ (void)setInspectionSchema:(NSString *)xml
{
    [[NSUserDefaults standardUserDefaults] setObject:xml forKey:InspectionSchemaPrefKey];
}

+ (NSString *)inspectionSchema
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:InspectionSchemaPrefKey];
}

@end
