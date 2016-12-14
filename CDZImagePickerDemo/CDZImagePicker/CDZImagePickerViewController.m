//
//  CDZImagePickerView.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/23.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "CDZImagePickerViewController.h"

#import "CDZImagePickerActionsItem.h"
#import "CDZImagePickerActionsDataSource.h"

#import "CDZImagePIckerPhotosCell.h"
#import "CDZImagePickerPhotosDataSource.h"

@interface CDZImagePickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,PHPhotoLibraryChangeObserver>

@property (nonatomic ,copy) CDZImageResultBlock block;

@property (nonatomic ,strong) UIImage *resultImage;
@property (nonatomic ,strong) PHFetchResult *imageAssetsResult;

@property (nonatomic ,strong) UICollectionView *photosView;
@property (nonatomic ,strong) UITableView *actionView;
@property (nonatomic ,strong) UIView *backgroundView;

@property (nonatomic ,strong) CDZImagePickerActionsDataSource *actionsDataSource;
@property (nonatomic ,strong) CDZImagePickerPhotosDataSource *photosDataSource;
@property (nonatomic ,strong) UICollectionViewFlowLayout *photosFlowLayout;
@end


@implementation CDZImagePickerViewController

#pragma mark - about init
- (void)viewDidLoad{
    [super viewDidLoad];
    [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.actionView];
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self.view addSubview:self.photosView];
    }

}


- (void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary]unregisterChangeObserver:self];
    NSLog(@"ImagePicker已销毁");
}


- (void)openPickerInController:(UIViewController *)controller withImageBlock:(CDZImageResultBlock)imageBlock{
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;//iOS8上默认presentviewcontroller不透明，需设置style
    self.block = imageBlock;
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){
        [self showPermissionAlertInController:controller];
    }
    else {
        [controller presentViewController:self animated:YES completion:nil];
    }
}

#pragma mark - event response
- (void)dissPicker:(UIGestureRecognizer *)gesture{
    [self closeAction];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
        NSLog(@"照片保存成功");
    }else{
        NSLog(@"照片保存失败");
    }
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
        case CDZImagePickerCloseAction:
            [self closeAction];
            break;
    }
}

- (void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:NO completion:nil];
        NSLog(@"打开相机");
    }
}

- (void)openLibrary{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:NO completion:nil];
    NSLog(@"打开图库");
    
}

- (void)closeAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.block(nil);
    NSLog(@"关闭");
}


- (void)openRecentImage{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
    [[PHImageManager defaultManager]requestImageForAsset:self.photosDataSource.itemArray[0] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.block(self.resultImage);
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"打开最新图片");
    }];
    }
}


#pragma mark - private methods

- (void)showPermissionAlertInController:(UIViewController *)controller{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"需要你的图库的权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [controller presentViewController:self animated:YES completion:nil];
    }];
    UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"用户同意授权相册");
                }else {
                    NSLog(@"用户拒绝授权相册");
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [controller presentViewController:self animated:YES completion:nil];
                });
            }];

        });
    }];
    [alert addAction:cancelAction];
    [alert addAction:requestAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (NSMutableArray *)getImageAssets{
    self.imageAssetsResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSMutableArray *assets = [NSMutableArray new];
    for (PHAsset *asset in self.imageAssetsResult){
        [assets insertObject:asset atIndex:0];
    }
    return assets;
}

- (void)photoLibraryDidChange:(PHChange *)changeInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *changes = [changeInfo changeDetailsForFetchResult:self.imageAssetsResult];
        if (changes) {
            self.photosDataSource.itemArray = [self getImageAssets];
            [self.photosView reloadData];
        }
    });
}


#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    self.block(image);
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"从相机或图库获取图片");
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return actionsViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDZImagePickerActionsItem *item = self.actionsDataSource.itemArray[indexPath.row];
    [self doActionsWithType:item.actionType];
}

#pragma mark - collectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.photosDataSource.itemArray[indexPath.row];
    CGFloat height = photosViewHeight - 2 * photosViewInset;
    CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
    CGFloat width = height * aspectRatio;
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(photosViewInset, photosViewInset, photosViewInset, photosViewInset);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return photosViewInset;
}

#pragma mark - collectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[PHImageManager defaultManager]requestImageForAsset:self.photosDataSource.itemArray[indexPath.row] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.block(result);
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"已选择图片");
    }];
}

#pragma views setter&getter
- (UICollectionView *)photosView{
    if (!_photosView){
        CGFloat actionsViewHeight = actionsViewCellHeight * self.actionArray.count;
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - actionsViewHeight - photosViewHeight , SCREEN_WIDTH, photosViewHeight) collectionViewLayout:self.photosFlowLayout];
        _photosView.delegate = self;
        _photosView.dataSource = self.photosDataSource;
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        [_photosView registerClass:[CDZImagePickerPhotosCell class] forCellWithReuseIdentifier:NSStringFromClass([CDZImagePickerPhotosCell class])];
    }
    return _photosView;
}


- (UITableView *)actionView{
    if (!_actionView) {
        CGFloat actionsViewHeight = actionsViewCellHeight * self.actionArray.count;
        _actionView = [[UITableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - actionsViewHeight ,SCREEN_WIDTH, actionsViewHeight) style:UITableViewStylePlain];
        _actionView.scrollEnabled = NO; //不需要滑动
        _actionView.separatorStyle = UITableViewCellSeparatorStyleNone; //分割线去除
        _actionView.delegate = self;
        _actionView.dataSource = self.actionsDataSource;
    }
    return _actionView;
}

- (UIView *)backgroundView{
    if (!_backgroundView){
        CGFloat actionsViewHeight = actionsViewCellHeight * self.actionArray.count;
        _backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - photosViewHeight - actionsViewHeight)];
        _backgroundView.opaque = YES;
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissPicker:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

#pragma mark - property setter&getter

- (UICollectionViewFlowLayout *)photosFlowLayout{
    if (!_photosFlowLayout) {
        _photosFlowLayout = [UICollectionViewFlowLayout new];
        _photosFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //水平滚动
    }
    return _photosFlowLayout;
}


- (CDZImagePickerActionsDataSource *)actionsDataSource{
    if (!_actionsDataSource) {
        _actionsDataSource = [[CDZImagePickerActionsDataSource alloc]init];
        _actionsDataSource.itemArray = self.actionArray;
    }
    return _actionsDataSource;
}

- (CDZImagePickerPhotosDataSource *)photosDataSource{
    if (!_photosDataSource){
        _photosDataSource = [[CDZImagePickerPhotosDataSource alloc]init];
        _photosDataSource.itemArray = [self getImageAssets];
    }
    return _photosDataSource;
}

- (NSMutableArray *)actionArray{
    if (!_actionArray){
        _actionArray = [NSMutableArray arrayWithObjects:
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"图库" withActionType:CDZImagePickerLibraryAction withImage:nil],
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"相机" withActionType:CDZImagePickerCameraAction withImage:nil],
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"取消" withActionType:CDZImagePickerCloseAction withImage:nil],
                        nil];
    }
    return _actionArray;
}



@end
