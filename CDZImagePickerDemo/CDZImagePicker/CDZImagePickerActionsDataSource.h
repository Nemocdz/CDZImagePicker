//
//  CDZImagePickerActionsDataSource.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/24.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CDZImagePickerActionsItem;


@interface CDZImagePickerActionsDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sections;

@end
