//
//  CDZImagePIckerPhotosCell.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerPhotosCell.h"
#import <Photos/PHImageManager.h>

@interface CDZImagePickerPhotosCell()

@property (nonatomic ,strong) UIImageView *photoImageView;

@end

@implementation CDZImagePickerPhotosCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.photoImageView.frame = self.contentView.bounds;
}

- (void)setCellFromItem:(PHAsset *)asset{
    CGRect imageViewFrame = self.photoImageView.frame;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:imageViewFrame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoImageView.image = result;
            });
        }];
   });
}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}

@end
