//
//  CDZImagePickerView.m
//  CDZImagePickerDemo
//
//  Created by Nemocdz on 2016/11/23.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//
#import "UIView+CDZExtension.h"

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

static const float tableViewCellHeight = 54.0;

@interface CDZImagePickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate>
@property (nonatomic ,copy) CDZImageResultBlock block;

@property (nonatomic ,strong) NSMutableArray *actionArray;
@property (nonatomic ,strong) NSMutableArray *photosArray;

@property (nonatomic ,strong) UITableView *actionView;
@property (nonatomic ,strong) UIView *backgroundView;
@property (nonatomic ,strong) CDZImagePickerActionsDataSource *actionsDataSource;
@property (nonatomic ,strong) CDZImagePickerPhotosDataSource *photosDataSource;
@property (nonatomic ,strong) UICollectionView *photosView;

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
   // CDZImagePickerActionsSection *sectionObject = self.actionsDataSource.sections[indexPath.row];
    CDZImagePickerActionsItem *item = self.actionArray[indexPath.row];
    [self doActionsWithType:item.actionType];
}

#pragma mark - collectionViewDelegate


#pragma setter&getter
- (UICollectionView *)photosView{
    if (!_photosView){
        CGFloat photosViewHeight = 130;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(130, 130);
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.actionView.height - photosViewHeight , SCREEN_WIDTH, photosViewHeight) collectionViewLayout:layout];
        _photosView.delegate = self;
        _photosView.dataSource = self.photosDataSource;
        _photosView.backgroundColor = [UIColor whiteColor];
        [_photosView registerClass:[CDZImagePIckerPhotosCell class] forCellWithReuseIdentifier:NSStringFromClass([CDZImagePIckerPhotosCell class])];
    }
    return _photosView;
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

- (UITableView *)actionView{
    if (!_actionView) {
        CGFloat actionsViewHeight = tableViewCellHeight * self.actionArray.count;
        _actionView = [[UITableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - actionsViewHeight ,SCREEN_WIDTH, actionsViewHeight) style:UITableViewStylePlain];
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

    }
    return _photosArray;
}


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


@end
