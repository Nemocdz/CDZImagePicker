//
//  ViewController.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/23.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import "ViewController.h"
#import "CDZImagePickerViewController.h"

@interface ViewController ()
- (IBAction)openPicker:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)openPicker:(UIButton *)sender {
    [CDZImagePickerViewController openPickerInView:self.view inController:self withImageBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];

}
@end
