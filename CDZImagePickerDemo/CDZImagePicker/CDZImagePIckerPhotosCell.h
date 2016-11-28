//
//  CDZImagePIckerPhotosCell.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDZImagePickerPhotosItems;

@interface CDZImagePIckerPhotosCell : UICollectionViewCell

@property(nonatomic ,strong) UIImageView *photoImageView;

- (void)setCellFromImage:(UIImage *)image;

@end
