//
//  SGInspectionParser.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionParser.h"
#import "SGInspection.h"

NSInteger const MODE_PRE_PARSING_CATEGORY = -2;
NSInteger const MODE_PARSING_CATEGORY = -1;
NSInteger const MODE_PARSING_END = -3;

@implementation SGInspectionParser {
    SGInspectionCategory *_category;
    SGInspectionQuestion *_question;
    NSInteger _categoryIndex;
    NSInteger _mode;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes {
    NSLog(@"Start: %@", elementName);
    
    if ([@"InspectionCategories" isEqualToString:elementName]) {
        _inspection = [[SGInspection alloc] init];
    } else if ([@"Categories" isEqualToString:elementName]) {
        _mode = MODE_PRE_PARSING_CATEGORY;
        _categoryIndex = -1;
        NSLog(@"Categories: %d", [_inspection getCategoryCount]);
    } else {
        if (_mode == MODE_PRE_PARSING_CATEGORY) {
            if (![elementName isEqualToString:_category.tag]) {
                _categoryIndex += 1;
            }
            NSString *title = [attributes objectForKey:@"Item"];
            _question = [[SGInspectionQuestion alloc] initWithTitle:title];
            _category = [_inspection getCategoryAtIndex:_categoryIndex];
            _category.tag = elementName;
            [_category addQuestion:_question];
            _mode = MODE_PARSING_CATEGORY;
        }
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    NSLog(@"End: %@, Text: %@", elementName, characters);
    
    if ([@"Category" isEqualToString:elementName]) {
        _category = [[SGInspectionCategory alloc] initWithTitle:characters];
        [_inspection addCategory:_category];
    } else if ([_category.tag isEqualToString:elementName]) {
        _mode = MODE_PRE_PARSING_CATEGORY;
    } else if ([@"Categories" isEqualToString:elementName]) {
        _mode = MODE_PARSING_END;
    } else if (_mode == MODE_PARSING_CATEGORY) {
        if ([@"Item_Control_Type" isEqualToString:elementName]) {
            _question.type = characters;
        } else if ([@"Item_Info" isEqualToString:elementName]) {
            _question.info = characters;
        } else if ([@"Item_Note" isEqualToString:elementName]) {
            _question.note = characters;
        } else if ([@"Item_Repaired" isEqualToString:elementName]) {
            _question.repaired = [@"Yes" isEqualToString:characters];
        } else if ([@"Item_Status" isEqualToString:elementName]) {
            if ([@"skip" isEqualToString:[characters lowercaseString]]) {
                _question.status = SGInspectionQuestionStatusSkip;
            } else if ([@"fail" isEqualToString:[characters lowercaseString]]) {
                _question.status = SGInspectionQuestionStatusFail;
            } else {
                _question.status = SGInspectionQuestionStatusPass;
            }
        } else if ([@"Item_Range_High" isEqualToString:elementName]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            _question.rangeHigh = [f numberFromString:characters];
        } else if ([@"Item_Range_Low" isEqualToString:elementName]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            _question.rangeLow = [f numberFromString:characters];
        } else if ([@"Item_Value_String" isEqualToString:elementName]) {
            _question.value = characters;
        } else if ([@"Item_Value_Decimal" isEqualToString:elementName]) {
            _question.value = characters;
        } else if ([@"Item_Value_Integer" isEqualToString:elementName]) {
            _question.value = characters;
        } else if ([@"Item_Value_Datestamp" isEqualToString:elementName]) {
            _question.value = characters;
        } else if ([@"Item_Value_String" isEqualToString:elementName]) {
            _question.value = characters;
        }
    }
}

@end
