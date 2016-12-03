//
//  CDZImagePickerPhotosDataSource.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerPhotosDataSource.h"
#import "CDZImagePIckerPhotosCell.h"
@class PHAsset;

@implementation CDZImagePickerPhotosDataSource

#pragma mark - collectionViewDataSourceRequried

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *item = self.itemArray[indexPath.row];
    CDZImagePickerPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CDZImagePickerPhotosCell class]) forIndexPath:indexPath];
    [cell setCellFromItem:item];
    return cell;
}

@end
