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

- (void)layoutSubviews{
    [super layoutSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;//点击不变色
    self.imageView.frame = CGRectMake(20, 15, 22, 22);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.textColor = [UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1.00];
    if (self.imageView.image){
        self.textLabel.frame = CGRectMake(60, 2, 200, 48);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    else{
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}


- (void)setItem:(CDZImagePickerActionsItem *)item{
    self.textLabel.text = item.actionTitle;
    self.imageView.image = item.actionImage;
}


@end
