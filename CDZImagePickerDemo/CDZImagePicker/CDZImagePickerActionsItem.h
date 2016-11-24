//
//  CDZImagePickerActionsItem.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CDZImagePickerConstant.h"

@interface CDZImagePickerActionsItem : NSObject

@property(nonatomic, retain) NSString *actionTitle;
@property(nonatomic, retain) UIImage *actionImage;
@property(nonatomic, assign) CDZImagePickerActionType actionType;

- (instancetype)initWithTitle:(NSString *)titele withActionType:(CDZImagePickerActionType)type withImage:(UIImage *)image;

@end
