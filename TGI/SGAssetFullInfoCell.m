//
//  SGAssetFullInfoCell.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetFullInfoCell.h"

@implementation SGAssetFullInfoCell

@synthesize fieldLabel, fieldValue;

- (void)setLabel:(NSString *)labelText value:(NSString *)valueText color:(UIColor *)textColor
{
    fieldLabel.text = labelText;
    fieldValue.text = valueText;
    fieldValue.textColor = textColor;
}

@end
