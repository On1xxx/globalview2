//
//  SGInspectionQuestion.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SGInspectionQuestionStatus) {
    SGInspectionQuestionStatusPass,
    SGInspectionQuestionStatusFail,
    SGInspectionQuestionStatusSkip
};

//NSString const *SGInspectionQuestionTypeSimple = @"simple";
//NSString const *SGInspectionQuestionTypeRange = @"range";
//NSString const *SGInspectionQuestionTypeDecimal = @"decimal";
//NSString const *SGInspectionQuestionTypeInteger = @"integer";
//NSString const *SGInspectionQuestionTypeText = @"text";
//NSString const *SGInspectionQuestionTypeTimestamp = @"datestamp";

@interface SGInspectionQuestion : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *info;
@property (nonatomic) NSString *note;
@property (nonatomic) NSNumber *rangeHigh;
@property (nonatomic) NSNumber *rangeLow;
@property (nonatomic) BOOL repaired;
@property (nonatomic) SGInspectionQuestionStatus status;
@property (nonatomic) NSString *value;

- (instancetype)initWithTitle:(NSString *)aTitle;

@end
