//
//  SGInspectionSerializer.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionSerializer.h"

#import <GDataXMLNode.h>
#import "SGInspectionUtil.h"
#import "SGInspectionPhoto.h"

@implementation SGInspectionSerializer {
    NSString *_assetId;
    SGInspection *_inspection;
    NSString *_xml;
}

- (instancetype)initWithAssetId:(NSString *)assetId inspection:(SGInspection *)inspection {
    self = [super init];
    if (self) {
        self->_assetId = assetId;
        self->_inspection = inspection;
    }
    return self;
}

- (NSString *)xml {
    if (!_xml) {
        _xml = [self serialize];
    }
    return _xml;
}

- (NSString *)serialize {
    GDataXMLElement *categoriesElement = [GDataXMLElement elementWithName:@"Categories"];
    
    for (uint i = 0; i < [_inspection getCategoryCount]; i++) {
        SGInspectionCategory *category = [_inspection getCategoryAtIndex:i];
        for (uint j = 0; j < [category getQuestionCount]; j++) {
            SGInspectionQuestion *question = [category getQuestionAtIndex:j];
            
            GDataXMLElement *typeElement = [GDataXMLElement elementWithName:@"Item_Control_Type"
                                                                stringValue:question.type];
            
            NSString *valueTag;
            if ([@"simple" isEqualToString:question.type]) {
                valueTag = @"Item_Value_String";
            } else if ([@"datestamp" isEqualToString:question.type]) {
                valueTag = @"Item_Value_Datestamp";
            } else if ([@"range" isEqualToString:question.type] || [@"decimal" isEqualToString:question.type]) {
                valueTag = @"Item_Value_Decimal";
            } else if ([@"integer" isEqualToString:question.type]) {
                valueTag = @"Item_Value_Integer";
            }
            
            GDataXMLElement *valueElement = [GDataXMLElement elementWithName:valueTag
                                                                 stringValue:question.value];
            
            NSString *status;
            if (question.status == SGInspectionQuestionStatusPass) {
                status = @"pass";
            } else if (question.status == SGInspectionQuestionStatusSkip) {
                status = @"skip";
            } else if (question.status == SGInspectionQuestionStatusFail) {
                status = @"fail";
            }
            
            GDataXMLElement *statusElement = [GDataXMLElement elementWithName:@"Item_Status"
                                                                  stringValue:status];
            
            NSString *repaired;
            if (question.repaired) {
                repaired = @"Yes";
            } else {
                repaired = @"";
            }
            
            GDataXMLElement *repairedElement = [GDataXMLElement elementWithName:@"Item_Repaired"
                                                                    stringValue:repaired];
            
            GDataXMLElement *noteElement = [GDataXMLElement elementWithName:@"Item_Note"
                                                                stringValue:question.note];
            
            GDataXMLElement *itemElement = [GDataXMLElement elementWithName:@"Item"
                                                                stringValue:question.title];
            
            GDataXMLElement *element = [GDataXMLElement elementWithName:category.tag];
            [element addAttribute:itemElement];
            [element addChild:typeElement];
            [element addChild:valueElement];
            [element addChild:statusElement];
            [element addChild:repairedElement];
            [element addChild:noteElement];
            [categoriesElement addChild:element];
        }
    }
    
    GDataXMLElement *odometerUnitElement = [GDataXMLElement elementWithName:@"Odometer_Uom"
                                                                stringValue:_inspection.odometerUnit];
    GDataXMLElement *registeredOwnerElement = [GDataXMLElement elementWithName:@"Registered_Owner"
                                                                   stringValue:_inspection.registredOwner];
    GDataXMLElement *odometerElement = [GDataXMLElement elementWithName:@"Odometer"
                                                            stringValue:_inspection.odometerValue];
    GDataXMLElement *inspectionDateElement = [GDataXMLElement elementWithName:@"Inspection_Date"
                                                                  stringValue:_inspection.dateUtc];
    GDataXMLElement *safteyNoElement = [GDataXMLElement elementWithName:@"Saftey_No"
                                                            stringValue:_inspection.safteyNo];
    GDataXMLElement *assetIdElement = [GDataXMLElement elementWithName:@"Asset_Id"
                                                           stringValue:_assetId];
    GDataXMLElement *inspectionTypeElement = [GDataXMLElement elementWithName:@"Inspection_Type"
                                                                  stringValue:_inspection.type];
    GDataXMLElement *inspectorElement = [GDataXMLElement elementWithName:@"Inspector"
                                                             stringValue:_inspection.inspector];
    GDataXMLElement *plateNoElement = [GDataXMLElement elementWithName:@"Plate"
                                                           stringValue:_inspection.plateNo];
    GDataXMLElement *claimNoElement = [GDataXMLElement elementWithName:@"Claim_No"
                                                           stringValue:_inspection.claimNo];
    GDataXMLElement *notesElement = [GDataXMLElement elementWithName:@"Notes"
                                                          stringValue:_inspection.notes];
    GDataXMLElement *documentsElement = [GDataXMLElement elementWithName:@"Documents"];
    
    NSArray *photos = [SGInspectionUtil findInspectionPhotos:_inspection.uuid];
    for (SGInspectionPhoto *photo in photos) {
        NSString *base64 = [SGInspectionUtil base64EncodedString:photo];
        
        GDataXMLElement *filenameElement = [GDataXMLElement elementWithName:@"FileName"
                                                                stringValue:photo.filename];
        GDataXMLElement *encodingElement = [GDataXMLElement elementWithName:@"Encoding"
                                                                stringValue:@"Base64"];
        GDataXMLElement *dataElement = [GDataXMLElement elementWithName:@"Data"];
        [dataElement addChild:[GDataXMLElement textWithStringValue:base64]];
        
        GDataXMLElement *attachmentElement = [GDataXMLElement elementWithName:@"Attach"];
        [attachmentElement addChild:filenameElement];
        [attachmentElement addChild:encodingElement];
        [attachmentElement addChild:dataElement];

        [documentsElement addChild:attachmentElement];
    }
    
    GDataXMLElement *headerElement = [GDataXMLElement elementWithName:@"Header"];
    [headerElement addChild:odometerUnitElement];
    [headerElement addChild:registeredOwnerElement];
    [headerElement addChild:odometerElement];
    [headerElement addChild:inspectionDateElement];
    [headerElement addChild:safteyNoElement];
    [headerElement addChild:assetIdElement];
    [headerElement addChild:inspectionTypeElement];
    [headerElement addChild:inspectorElement];
    [headerElement addChild:plateNoElement];
    [headerElement addChild:claimNoElement];
    [headerElement addChild:notesElement];
    [headerElement addChild:documentsElement];
    
    GDataXMLElement *inspectionElement = [GDataXMLElement elementWithName:@"Inspection"];
    [inspectionElement addChild:headerElement];
    [inspectionElement addChild:categoriesElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:inspectionElement];
    NSString *xml = document.rootElement.XMLString;
    NSLog(@"xml: %@", xml);
    return xml;
}

@end
