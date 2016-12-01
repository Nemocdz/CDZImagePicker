//
//  CDZImagePickerConstant.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define BACKGROUND_BLACK_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

static const float actionsViewCellHeight = 54.0f;
static const float photosViewHeight = 165.0f;
static const float photosViewInset = 5.0f;


typedef NS_ENUM(NSInteger, CDZImagePickerActionType) {
    CDZImagePickerCameraAction,
    CDZImagePickerLibraryAction,
    CDZImagePickerRecentAction,
    CDZImagePickerCloseAction
};

typedef void (^CDZImageResultBlock)(UIImage *image);
typedef void (^CDZImageAssetBlock) (PHAsset *asset);


@interface CDZImagePickerConstant : NSObject

@end
