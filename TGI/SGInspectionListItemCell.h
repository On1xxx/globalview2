//
//  SGInspectionListItemCell.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGInspectionListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateUtcLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTzLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspectionIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspectionStatusLabel;

@end
