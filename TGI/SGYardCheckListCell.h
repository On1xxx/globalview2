//
//  SGYardCheckListCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGYardCheck.h"

@interface SGYardCheckListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *landmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

- (void)setYardCheck:(SGYardCheck *)yardCheck;

@end
