//
//  SGAssetFullInfoCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGPair.h"

@interface SGAssetFullInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldValue;

- (void)setLabel:(NSString *)labelText value:(NSString *)valueText color:(UIColor *)textColor;

@end
