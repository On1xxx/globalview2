//
//  SGPendingInspectionTableViewCell.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGPendingInspectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assetIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateUtcLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTzLabel;

@end
