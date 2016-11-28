//
//  CDZImagePIckerPhotosCell.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePIckerPhotosCell.h"


@implementation CDZImagePIckerPhotosCell

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}

- (void)setCellFromImage:(UIImage *)image{
    self.photoImageView.image = image;
    [self.contentView addSubview:self.photoImageView];
}





@end
