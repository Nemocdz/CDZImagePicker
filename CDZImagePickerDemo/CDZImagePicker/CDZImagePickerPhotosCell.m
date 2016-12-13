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
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.photoImageView.image = result;
    }];
}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}

@end
