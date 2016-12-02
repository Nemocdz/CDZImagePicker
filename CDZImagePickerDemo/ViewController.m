//
//  ViewController.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/23.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "ViewController.h"
#import "CDZImagePickerConstant.h"
#import "CDZImagePickerViewController.h"
#import "CDZImagePickerActionsItem.h"

@interface ViewController ()
- (IBAction)openPicker:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIView *backgroundView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)openPicker:(UIButton *)sender {
   [self.view addSubview:self.backgroundView];
    CDZImagePickerViewController *imagePickerController = [[CDZImagePickerViewController alloc]init];
    imagePickerController.actionArray = [NSMutableArray arrayWithObjects:
                      [[CDZImagePickerActionsItem alloc]initWithTitle:@"打开设备上的图片" withActionType:CDZImagePickerLibraryAction withImage:[UIImage imageNamed:@"phone-icon.png"]],
                      [[CDZImagePickerActionsItem alloc]initWithTitle:@"相机" withActionType:CDZImagePickerCameraAction withImage:[UIImage imageNamed:@"camera-icon.png"]],
                      [[CDZImagePickerActionsItem alloc]initWithTitle:@"打开最新图片" withActionType:CDZImagePickerRecentAction withImage:[UIImage imageNamed:@"clock-icon.png"]],
                      nil];
    [imagePickerController openPickerInController:self withImageBlock:^(UIImage *image) {
        if (image) { //检查是否有照片
           self.imageView.image = image;
        }
        [self.backgroundView removeFromSuperview];
    }];

}

- (UIView *)backgroundView{
    if (!_backgroundView) {
         _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
         _backgroundView.backgroundColor = BACKGROUND_BLACK_COLOR;
    }
    return _backgroundView;
}
@end
