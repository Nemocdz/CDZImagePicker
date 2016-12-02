//
//  CDZImagePIckerPhotosCell.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerPhotosCell.h"

@implementation CDZImagePickerPhotosCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.photoImageView.frame = self.contentView.bounds;
}


@end
