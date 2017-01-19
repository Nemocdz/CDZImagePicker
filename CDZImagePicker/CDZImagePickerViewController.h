//
//  CDZImagePickerView.h
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/23.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDZImagePickerConstant.h"

@interface CDZImagePickerViewController : UIViewController

@property (nonatomic ,strong) NSMutableArray *actionArray;

- (void)openPickerInController:(UIViewController *)controller withImageBlock:(CDZImageResultBlock)imageBlock;

@end
