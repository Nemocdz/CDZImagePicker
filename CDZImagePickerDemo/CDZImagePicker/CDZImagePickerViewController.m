//
//  CDZImagePickerView.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/23.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//



#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CDZImagePickerViewController.h"

#import "CDZImagePickerActionsItem.h"
#import "CDZImagePickerActionsCell.h"
#import "CDZImagePickerActionsDataSource.h"
#import "CDZImagePickerActionsSection.h"

static const float tableViewCellHeight = 54.0;

@interface CDZImagePickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic ,copy) CDZImageResultBlock block;
@property (nonatomic ,strong) UIViewController *sourceVC;
//@property (nonatomic ,strong) NSArray *actionArray;
@property (nonatomic ,strong) UITableView *actionView;
@property (nonatomic ,strong) UIView *backgroundView;
@property (nonatomic ,strong) CDZImagePickerActionsDataSource *actionsDataSource;
@property (nonatomic ,strong) CDZImagePickerActionsSection *actionsSection;

@end


@implementation CDZImagePickerViewController

#pragma mark - about init
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.actionView];
}

+ (void)openPickerInView:(UIView *)view inController:(UIViewController *)controller withImageBlock:(CDZImageResultBlock)imageBlock{
    CDZImagePickerViewController *picker = [[CDZImagePickerViewController alloc]init];
    picker.view.backgroundColor = [UIColor clearColor];
    picker.block = imageBlock;
    [controller presentViewController:picker animated:NO completion:nil];
}

- (void)dealloc{
    NSLog(@"dealloc");
}

#pragma mark - event response
- (void)dissPicker:(UIGestureRecognizer *)gesture{
    [self closeThisView];
}

- (void)didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
        NSLog(@"照片保存成功");
    }else
        NSLog(@"照片保存失败");
}


#pragma mark - actions
- (void)doActionsWithType:(CDZImagePickerActionType)type{
    switch (type) {
        case  CDZImagePickerCameraAction:
            [self openCamera];
            break;
        case   CDZImagePickerRecentAction:
            [self openRecentImage];
            break;
        case CDZImagePickerLibraryAction:
            [self openLibrary];
            break;
        case CDZImagePickerCancelAction:
            [self closeThisView];
            break;
    }
    
}

- (void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:NO completion:nil];
    }
}

- (void)openLibrary{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:NO completion:nil];
    
}

- (void)closeThisView{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)openRecentImage{
    
}





#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingWithError:contextInfo:), NULL);
    }
    self.block(image);
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"获取照片");
}





#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDZImagePickerActionsSection *sectionObject = self.actionsDataSource.sections[indexPath.row];
    CDZImagePickerActionsItem *item = sectionObject.items[indexPath.row];
    [self doActionsWithType:item.actionType];
}


#pragma setter&getter
- (UIView *)backgroundView{
    if (!_backgroundView){
        _backgroundView =[[UIView alloc]initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = BACKGROUND_BLACK_COLOR;
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissPicker:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (UITableView *)actionView{
    if (!_actionView) {
        CGFloat actionsViewHeight = tableViewCellHeight * self.actionsSection.items.count;
        _actionView = [[UITableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - actionsViewHeight ,SCREEN_WIDTH, actionsViewHeight) style:UITableViewStylePlain];
        _actionView.backgroundColor = [UIColor redColor];
        _actionView.scrollEnabled = NO;
        _actionView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _actionView.delegate = self;
        _actionView.dataSource = self.actionsDataSource;
    }
    return _actionView;
}


- (CDZImagePickerActionsDataSource *)actionsDataSource{
    if (!_actionsDataSource) {
        _actionsDataSource = [[CDZImagePickerActionsDataSource alloc]init];
        _actionsDataSource.sections = [NSMutableArray arrayWithObject:self.actionsSection];
    }
    return _actionsDataSource;
}

- (CDZImagePickerActionsSection *)actionsSection{
    if (!_actionsSection) {
        _actionsSection = [[CDZImagePickerActionsSection alloc]init];
        _actionsSection.items =[NSMutableArray arrayWithObjects:[[CDZImagePickerActionsItem alloc]initWithTitle:@"图库" withActionType:CDZImagePickerLibraryAction withImage:nil],
                              [[CDZImagePickerActionsItem alloc]initWithTitle:@"拍照" withActionType:CDZImagePickerCameraAction withImage:nil],
                              [[CDZImagePickerActionsItem alloc]initWithTitle:@"最新" withActionType:CDZImagePickerRecentAction withImage:nil],
                              nil];
    }
    return _actionsSection;
}

@end
