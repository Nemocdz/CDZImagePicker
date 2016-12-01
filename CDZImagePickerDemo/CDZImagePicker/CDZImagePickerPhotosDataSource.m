//
//  CDZImagePickerPhotosDataSource.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerPhotosDataSource.h"
#import "CDZImagePIckerPhotosCell.h"
#import <Photos/Photos.h>

@implementation CDZImagePickerPhotosDataSource

#pragma mark - collectionViewDataSourceRequried

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CDZImagePickerPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CDZImagePickerPhotosCell class]) forIndexPath:indexPath];
    CGRect cellFrame = cell.frame;
    [[PHImageManager defaultManager]requestImageForAsset:self.itemArray[indexPath.row] targetSize:cellFrame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       cell.photoImageView.image = result;
    }];
    return cell;
}

@end
