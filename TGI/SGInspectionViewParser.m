//
//  SGInspectionViewParser.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionViewParser.h"
#import "SGInspection.h"
#import "SGInspectionCategory.h"
#import "SGInspectionQuestion.h"
#import "SGInspectionPhoto.h"

NSInteger const MODE_PARSING_INSPECTION = 1;
NSInteger const MODE_PARSING_CATEGORIES = 2;
NSInteger const MODE_PARSING_QUESTIONS = 3;
NSInteger const MODE_PARSING_QUESTION = 4;
NSInteger const MODE_PARSING_ATTACHMENT = 5;

@implementation SGInspectionViewParser {
    SGInspection *_inspection;
    int _mode;
    NSString *_categoryElementName;
    int _categoryIndex;
    SGInspectionCategory *_category;
    SGInspectionQuestion *_question;
    SGInspectionPhoto *_photo;
}

- (SGInspection *)inspection {
    return _inspection;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes {
    if ([@"Inspection" isEqualToString:elementName]) {
        _inspection = [[SGInspection alloc] init];
    } else if ([@"InspectionCategories" isEqualToString:elementName]) {
        _mode = MODE_PARSING_CATEGORIES;
    } else if ([@"Categories" isEqualToString:elementName]) {
        _mode = MODE_PARSING_QUESTIONS;
        _categoryIndex = -1;
    } else if ([@"Attach" isEqualToString:elementName]) {
        _mode = MODE_PARSING_ATTACHMENT;
        _photo = [[SGInspectionPhoto alloc] init];
    } else {
        if (_mode == MODE_PARSING_QUESTIONS) {
            _mode = MODE_PARSING_QUESTION;
            if (![elementName isEqualToString:_categoryElementName]) {
                _categoryIndex += 1;
            }
            _categoryElementName = elementName;
            _category = [_inspection getCategoryAtIndex:_categoryIndex];
            _question = [[SGInspectionQuestion alloc] init];
            [_category addQuestion:_question];
        }
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if (_mode == MODE_PARSING_CATEGORIES) {
        if ([@"InspectionCategories" isEqualToString:elementName]) {
            _mode = MODE_PARSING_INSPECTION;
        } else if ([@"Category" isEqualToString:elementName]) {
            SGInspectionCategory *c = [[SGInspectionCategory alloc] initWithTitle:characters];
            [_inspection addCategory:c];
        }
    } else if (_mode == MODE_PARSING_QUESTIONS) {
        if ([@"Categories" isEqualToString:elementName]) {
            _mode = MODE_PARSING_INSPECTION;
        }
    } else if (_mode == MODE_PARSING_QUESTION) {
        if ([_categoryElementName isEqualToString:elementName]) {
            _mode = MODE_PARSING_QUESTIONS;
        } else if ([@"Item" isEqualToString:elementName]) {
            _question.title = characters;
        } else if ([@"Item_Control_Type" isEqualToString:elementName]) {
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
    } else if (_mode == MODE_PARSING_ATTACHMENT) {
        if ([@"Doc_Id" isEqualToString:elementName]) {
            _photo.docId = characters;
        } else if ([@"FileName" isEqualToString:elementName]) {
            _photo.filename = characters;
        } else if ([@"Attach" isEqualToString:elementName]) {
            [_inspection addAttachment:_photo];
            _mode = MODE_PARSING_INSPECTION;
        }
    } else {
        [self headerElementDidEnd:elementName characters:characters];
    }
}

- (void)headerElementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if ([@"Odometer_Uom" isEqualToString:elementName]) {
        _inspection.odometerUnit = characters;
    } else if ([@"Registered_Owner" isEqualToString:elementName]) {
        _inspection.registredOwner = characters;
    } else if ([@"Odometer" isEqualToString:elementName]) {
        _inspection.odometerValue = characters;
    } else if ([@"Saftey_No" isEqualToString:elementName]) {
        _inspection.safteyNo = characters;
    } else if ([@"Notes" isEqualToString:elementName]) {
        _inspection.notes = characters;
    } else if ([@"Inspection_Type" isEqualToString:elementName]) {
        _inspection.inspectionType = characters;
    } else if ([@"Inspector" isEqualToString:elementName]) {
        _inspection.inspector = characters;
    } else if ([@"Plate" isEqualToString:elementName]) {
        _inspection.plateNo = characters;
    } else if ([@"Claim_No" isEqualToString:elementName]) {
        _inspection.claimNo = characters;
    } else if ([elementName hasPrefix:@"Inspection_Date_"]) {
        NSArray *parts = [elementName componentsSeparatedByString:@"_"];
        NSString *tz = parts[parts.count - 1];
        if ([@"UTC" isEqualToString:tz]) {
            _inspection.dateUtc = characters;
        } else {
            _inspection.dateTz = characters;
        }
    }
}


@end
