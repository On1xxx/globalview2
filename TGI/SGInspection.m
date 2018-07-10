//
//  SGInspection.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspection.h"

@implementation SGInspection {
    NSMutableArray *_categories;
    NSMutableArray *_attachments;
    NSDateFormatter *_formatterTz;
    NSDateFormatter *_formatterUtc;
}

- (id)init {
    self = [super init];
    if (self) {
        _uuid = [[NSUUID UUID] UUIDString];
        _categories = [[NSMutableArray alloc] init];
        _attachments = [[NSMutableArray alloc] init];
        _formatterTz = [[NSDateFormatter alloc] init];
        _formatterTz.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _formatterUtc = [[NSDateFormatter alloc] init];
        _formatterUtc.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _formatterUtc.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    return self;
}

- (void)addCategory:(SGInspectionCategory *)category {
    [_categories addObject:category];
}

- (NSUInteger)getCategoryCount {
    return _categories.count;
}

- (SGInspectionCategory *)getCategoryAtIndex:(NSUInteger)index {
    return _categories[index];
}

- (void)setLocalDate:(NSDate *)localDate {
    self.dateUtc = [_formatterUtc stringFromDate:localDate];
    self.dateTz = [_formatterTz stringFromDate:localDate];
}

- (NSArray *)attachments {
    return _attachments;
}

- (void)addAttachment:(SGInspectionPhoto *)p {
    [_attachments addObject:p];
}

@end
