//
//  SGSortOptionCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSortOrder.h"

@interface SGSortOptionCell : UITableViewCell

@property (weak, nonatomic) NSString *option;
@property (nonatomic) SGSortOrder order;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ascImage;
@property (weak, nonatomic) IBOutlet UIImageView *descImage;

@end
