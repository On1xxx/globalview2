//
//  SGInspection.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SGInspectionCategory.h"
#import "SGInspectionQuestion.h"
#import "SGInspectionPhoto.h"

@interface SGInspection : NSObject

@property (readonly, nonatomic) NSString *uuid;

@property (strong, nonatomic) NSString *registredOwner;
@property (strong, nonatomic) NSString *safteyNo;
@property (strong, nonatomic) NSString *claimNo;
@property (strong, nonatomic) NSString *inspector;
@property (strong, nonatomic) NSString *odometerValue;
@property (strong, nonatomic) NSString *odometerUnit;
@property (strong, nonatomic) NSString *plateNo;
@property (strong, nonatomic) NSString *inspectionType;

@property (strong, nonatomic) NSString *group;
@property (strong, nonatomic) NSString *subGroup;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *vin;
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *year;

@property (strong, nonatomic) NSString *notes;

@property (strong, nonatomic) NSString *dateUtc;
@property (strong, nonatomic) NSString *dateTz;

- (void)addCategory:(SGInspectionCategory *)category;
- (NSUInteger)getCategoryCount;
- (SGInspectionCategory *)getCategoryAtIndex:(NSUInteger)index;

- (void)setLocalDate:(NSDate *)localDate;

- (NSArray *)attachments;
- (void)addAttachment:(SGInspectionPhoto *)p;

@end
