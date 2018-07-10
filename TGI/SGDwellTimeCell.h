//
//  SGDwellTimeCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDwellTime.h"

@interface SGDwellTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assetIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *landmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@property (weak, nonatomic) SGDwellTime *dwellTime;

@end
