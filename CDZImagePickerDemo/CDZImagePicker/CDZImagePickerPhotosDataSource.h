//
//  CDZImagePickerPhotosDataSource.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/25.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CDZImagePickerPhotosDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;


@end
