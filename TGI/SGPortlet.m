//
//  SGPortlet.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGPortlet.h"
#import "SGParser.h"
#import "SGParserDelegate.h"
#import "SGUserSettings.h"
#import "SGReachability.h"
#import <UIAlertView+Blocks.h>

@implementation SGPortlet {
    NSString *portlet;
    id <SGParserDelegate> parserDelegate;
    void (^onSuccess)();
    void (^onError)();
    BOOL _displayError;
    int _errorCode;
    
    NSMutableDictionary *parameters;
    
    NSURLConnection *connection;
    NSMutableData *xmlData;
}

- (id)initWithPortlet:(NSString *)aPortlet
                  tag:(NSString *)aTag
               parser:(id <SGParserDelegate>)aParserDelegate
             delegate:(id <SGPortletDelegate>)aDelegate {
    return [self initWithPortlet:aPortlet
                          parser:aParserDelegate
                       onSuccess:^{
                              id result = [aParserDelegate result];
                              [aDelegate onSuccess:aTag result:result];
                       } onError:^{
                              [aDelegate onError:aTag];
                          }];
}

- (id)initWithPortlet:(NSString *)aPortlet
               parser:(id <SGParserDelegate>)aParserDelegate
{
    return [self initWithPortlet:aPortlet parser:aParserDelegate onSuccess:nil onError:nil];
}

- (id)initWithPortlet:(NSString *)aPortlet
               parser:(id <SGParserDelegate>)aParserDelegate
            onSuccess:(void (^)())successBlock
{
    return [self initWithPortlet:aPortlet parser:aParserDelegate onSuccess:successBlock onError:^() {
        // no-op
    }];
}

- (id)initWithPortlet:(NSString *)aPortlet
               parser:(id <SGParserDelegate>)aParserDelegate
            onSuccess:(void (^)())successBlock
              onError:(void (^)())errorBlock
{
    self = [super init];
    if (self) {
        portlet = aPortlet;
        parserDelegate = aParserDelegate;
        onSuccess = successBlock;
        onError = errorBlock;
        _displayError = true;
        _errorCode = -1;
        parameters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addParameter:(NSString *)name value:(NSString *)value
{
    [parameters setValue:value forKey:name];
}

- (NSURLRequest *)createRequest {
    NSURL *url = [NSURL URLWithString:[SGUserSettings serverURL]];
    NSMutableString *xmlBody = [NSMutableString stringWithFormat:
                                @"<?xml version=\"1.0\" standalone=\"yes\"?>"
                                "<TGI>"
                                "<aaa>"
                                "<comp>%@</comp>"
                                "<portlet>%@</portlet>"
                                "<uid>%@</uid>"
                                "<pwd>%@</pwd>"
                                "</aaa>",
                                [SGUserSettings company],
                                portlet,
                                [SGUserSettings username],
                                [SGUserSettings password]];
    if (parameters.count > 0) {
        [xmlBody appendFormat:@"<%@>", portlet];
        for (NSString *key in parameters) {
            NSString *value = [[parameters valueForKey:key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [xmlBody appendFormat:@"<%@>%@</%@>", key, value, key];
        }
        [xmlBody appendFormat:@"</%@>", portlet];
    }
    [xmlBody appendString:@"</TGI>"];

    NSLog(@"URL: %@", url);
    NSLog(@"XML: %@", xmlBody);
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[xmlBody dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}

- (void)invoke
{
    if (![SGReachability isReachable]) {
        [SGPortlet showError:@"The device appears to be offline" dismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (onError) {
                onError();
            }
        }];
        return;
    }
    
    xmlData = [[NSMutableData alloc] init];
    
    NSURLRequest *req = [self createRequest];
    
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

- (BOOL)invokeSynchronously
{
    NSURLRequest *req = [self createRequest];
    NSURLResponse *resp;
    NSError *error;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    xmlData = [[NSMutableData alloc] initWithData:data];
    [self cleanXml];
    BOOL success = [self finish];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    return success;
}

- (void)invokeWithXml:(NSString *)xml 
{
    xmlData = [[NSMutableData alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response respondsToSelector:@selector(statusCode)]) {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        NSLog(@"Status: %d", statusCode);
        if (statusCode == 500) {
            _errorCode = statusCode;
        } else {
            _errorCode = -1;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self cleanXml];
    [self finish];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)cleanXml {
    if (_errorCode > 0) {
        NSLog(@"Skip cleaning, error: %d", _errorCode);
        return;
    }
    
    NSString *xml = [[NSString alloc] initWithData:xmlData
                                          encoding:NSUTF8StringEncoding];
    
    NSLog(@"xml = %@", xml);
    
    // remove js block in yard check response
    NSRange range = [xml rangeOfString:@"<?xml"];
    if (range.location != NSNotFound) {
        xml = [xml substringFromIndex:range.location];
    }
    // escape serial# in yard check for landmark
    xml = [xml stringByReplacingOccurrencesOfString:@"Serial#" withString:@"Serial_Number"];
    xml = [xml stringByReplacingOccurrencesOfString:@"#_of_Assets_in_Group" withString:@"Number_of_Assets_in_Group"];
    xml = [xml stringByReplacingOccurrencesOfString:@"#_of_Days" withString:@"Number_of_Days"];
    xml = [xml stringByReplacingOccurrencesOfString:@"#_of_Moves" withString:@"Number_of_Moves"];
    xml = [xml stringByReplacingOccurrencesOfString:@"(UTC)>" withString:@"_UTC>"];
    
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    xmlData = [NSMutableData dataWithData:data];
}

- (BOOL)finish {
    if (_errorCode > 0) {
        NSLog(@"Request error: %d", _errorCode);
        if (_displayError) {
            NSString *errorMessage;
            if (_errorCode == 500) {
                errorMessage = @"Internal Server Error";
            } else {
                errorMessage = [NSString stringWithFormat:@"Error: %d", _errorCode];
            }
            [SGPortlet showError:errorMessage dismissBlock:nil];
        }
        if (onError) {
            onError();
        }
        return NO;
    }
    
    NSLog(@"Parsing data");
    if ([parserDelegate respondsToSelector:@selector(willParseXML:)]) {
        NSString *xml = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
        [parserDelegate willParseXML:xml];
    }
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    SGParser *p = [SGParser parserWithDelegate:parserDelegate];
    parser.delegate = p;
    if ([parser parse]) {
        NSLog(@"Parsing success");
        if (onSuccess) {
            onSuccess();
        }
        return YES;
    } else {
        NSLog(@"Parsing error: %@", [p errorMessage]);
        if (_displayError) {
            if (![@"No records found!" isEqualToString:[p errorMessage]]) {
                [SGPortlet showError:[p errorMessage] dismissBlock:nil];
            }
        }
        if (onError) {
            onError();
        }
        return NO;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed with error: %@", error);
    [SGPortlet showError:[error localizedDescription] dismissBlock:nil];
}

- (void)setDisplayError:(BOOL)displayError {
    _displayError = displayError;
}

+ (void)showError:(NSString *)errorMessage dismissBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))dismissBlock
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    if (dismissBlock) {
        alert.didDismissBlock = dismissBlock;
    }
    [alert show];
}

@end
