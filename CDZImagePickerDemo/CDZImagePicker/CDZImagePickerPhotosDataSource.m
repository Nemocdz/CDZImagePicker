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

#pragma mark - collectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(100, 100);
    CDZImagePIckerPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CDZImagePIckerPhotosCell class]) forIndexPath:indexPath];
    [[PHImageManager defaultManager]requestImageForAsset:self.itemArray[indexPath.row] targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [cell setCellFromImage:result];
    }];
    return cell;
}

@end
