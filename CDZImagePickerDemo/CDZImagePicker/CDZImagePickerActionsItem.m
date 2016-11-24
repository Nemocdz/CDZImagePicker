//
//  CDZImagePickerActionsItem.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerActionsItem.h"

@implementation CDZImagePickerActionsItem

- (instancetype)initWithTitle:(NSString *)titele withActionType:(CDZImagePickerActionType)type withImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _actionTitle = titele;
        _actionType = type;
        _actionImage = image;
    }
    return self;
}

@end
