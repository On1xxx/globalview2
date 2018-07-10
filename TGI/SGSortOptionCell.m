//
//  SGSortOptionCell.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGSortOptionCell.h"

@implementation SGSortOptionCell

- (void)setOption:(NSString *)option
{
    _option = option;
    
    self.titleLabel.text = option;
    self.ascImage.hidden = YES;
}

- (void)setOrder:(SGSortOrder)order
{
    _order = order;
    
    switch (order) {
        case SORT_ORDER_ASC:
            self.ascImage.hidden = NO;
            self.descImage.hidden = YES;
            break;
        case SORT_ORDER_DESC:
            self.ascImage.hidden = YES;
            self.descImage.hidden = NO;
            break;
        default:
            self.ascImage.hidden = YES;
            self.descImage.hidden = YES;
            break;
    }
}

@end
