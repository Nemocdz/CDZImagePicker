//
//  CDZImagePickerActionsCell.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerActionsCell.h"
#import "CDZImagePickerActionsItem.h"

@implementation CDZImagePickerActionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellFromItem:(CDZImagePickerActionsItem *)item{
    self.textLabel.text = item.actionTitle;
    self.textLabel.textColor = [UIColor colorWithRed:0.29 green:0.30 blue:0.30 alpha:1.00];
    self.textLabel.font = [UIFont systemFontOfSize:18.0f];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.selectionStyle = UITableViewCellSelectionStyleNone;//点击不变色
}

@end
