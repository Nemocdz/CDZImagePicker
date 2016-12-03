//
//  CDZImagePIckerPhotosCell.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

@interface CDZImagePickerPhotosCell : UICollectionViewCell

- (void)setCellFromItem:(PHAsset *)asset;

@end
