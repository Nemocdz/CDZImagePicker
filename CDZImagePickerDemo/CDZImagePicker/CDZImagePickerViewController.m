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
#import <Photos/Photos.h>
#import "CDZImagePickerViewController.h"

#import "CDZImagePickerActionsItem.h"
#import "CDZImagePickerActionsCell.h"
#import "CDZImagePickerActionsDataSource.h"

#import "CDZImagePIckerPhotosCell.h"
#import "CDZImagePickerPhotosDataSource.h"

@interface CDZImagePickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate>

@property (nonatomic ,copy) CDZImageResultBlock block;

@property (nonatomic ,strong) NSMutableArray *actionArray;
@property (nonatomic ,strong) NSMutableArray *photosArray;

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
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.actionView];
    [self.view addSubview:self.photosView];
}

+ (void)openPickerInView:(UIView *)view inController:(UIViewController *)controller withImageBlock:(CDZImageResultBlock)imageBlock{
    CDZImagePickerViewController *picker = [[CDZImagePickerViewController alloc]init];
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;//iOS8上默认presentviewcontroller不透明，需设置style
    picker.block = imageBlock;
    [controller presentViewController:picker animated:NO completion:nil];
}

- (void)dealloc{
    NSLog(@"ImagePicker已销毁");
}

#pragma mark - event response
- (void)dissPicker:(UIGestureRecognizer *)gesture{
    [self closeSelfController];
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
        case CDZImagePickerCloseAction:
            [self closeSelfController];
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

- (void)closeSelfController{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"ImagePicker关闭");
}

- (void)openRecentImage{
    [[PHImageManager defaultManager]requestImageForAsset:self.photosArray[0] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.block(result);
    }];
    NSLog(@"打开最新图片");
    [self closeSelfController];
   
}


#pragma mark - private methods

- (void)getAllPhotoWithBlock:(CDZImageAssetBlock)block{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary){
            PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            for (PHAsset *asset in assets){
                block(asset);
            }
        }
    }
}


#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingWithError:contextInfo:), NULL);
    }
    self.block(image);
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self closeSelfController];
    NSLog(@"从相机或图库获取图片");
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return actionsViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDZImagePickerActionsItem *item = self.actionArray[indexPath.row];
    [self doActionsWithType:item.actionType];
}

#pragma mark - collectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *photo = self.photosArray[indexPath.row];
    CGFloat height = photosViewHeight - 2 * photosViewInset;
    CGFloat aspectRatio = (CGFloat)photo.pixelWidth / (CGFloat)photo.pixelHeight;
    CGFloat width = height * aspectRatio;
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(photosViewInset, 0.0f, photosViewInset, 0.0f);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return photosViewInset;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[PHImageManager defaultManager]requestImageForAsset:self.photosArray[indexPath.row] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.block(result);
    }];
    NSLog(@"已选择图片");
    [self closeSelfController];
}

#pragma views setter&getter
- (UICollectionView *)photosView{
    if (!_photosView){
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - actionsViewCellHeight * self.actionArray.count - photosViewHeight , SCREEN_WIDTH, photosViewHeight) collectionViewLayout:self.photosFlowLayout];
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
        _actionView.scrollEnabled = NO;
        _actionView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _actionView.delegate = self;
        _actionView.dataSource = self.actionsDataSource;
    }
    return _actionView;
}

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

#pragma mark - property setter&getter

- (UICollectionViewFlowLayout *)photosFlowLayout{
    if (!_photosFlowLayout) {
        _photosFlowLayout = [UICollectionViewFlowLayout new];
        _photosFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
        _photosDataSource.itemArray = self.photosArray;
    }
    return _photosDataSource;
}

- (NSMutableArray *)actionArray{
    if (!_actionArray){
        _actionArray = [NSMutableArray arrayWithObjects:
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"图库" withActionType:CDZImagePickerLibraryAction withImage:nil],
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"拍照" withActionType:CDZImagePickerCameraAction withImage:nil],
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"最新" withActionType:CDZImagePickerRecentAction withImage:nil],
                        [[CDZImagePickerActionsItem alloc]initWithTitle:@"取消" withActionType:CDZImagePickerCloseAction withImage:nil],
                        nil];
    }
    return _actionArray;
}

- (NSMutableArray *)photosArray{
    if (!_photosArray){
        _photosArray = [NSMutableArray new];
        [self getAllPhotoWithBlock:^(PHAsset *asset) {
            [_photosArray insertObject:asset atIndex:0];
        }];
        NSLog(@"已加载%d张图片",(int)_photosArray.count);
    }
    return _photosArray;
}

@end