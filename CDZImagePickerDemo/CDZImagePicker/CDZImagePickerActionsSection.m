//
//  CDZImagePickerSection.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "CDZImagePickerActionsSection.h"

@implementation CDZImagePickerActionsSection

- (instancetype)initWithItemArray:(NSMutableArray *)items {
    self = [self init];
    if (self) {
        [self.items addObjectsFromArray:items];
    }
    return self;
}


@end
