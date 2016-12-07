# CDZImagePicker

This is a ImagePickerController with  buttons of action and collection of photos.

And the button can add beautiful icon like Snapseed used.

## Demo Preview

![ImagePickerDemo2](http://ww3.sinaimg.cn/large/006y8mN6gw1fai80p1okwg30ku1124oj.gif)

## Installation
### Manual

Add "CDZImagePicker" files to your project

### CocoaPods

Coming soon

## Usage

- Use default style

```objective-c 
#import "CDZImagePickerViewController.h"
```

```objective-c
 CDZImagePickerViewController *imagePickerController = [[CDZImagePickerViewController alloc]init];
[imagePickerController openPickerInController:self withImageBlock:^(UIImage *image) {
        if (image) { //if image has changed
           self.imageView.image = image;//your code
        }
        [self.backgroundView removeFromSuperview];//your code
    }];
```

- Use in iOS10

  Open "Info.plist" file in your project and add

```xml
 <key>NSCameraUsageDescription</key>    
 <string>cameraDesciption</string>

<key>NSPhotoLibraryUsageDescription</key>    
<string>cameraDesciption</string>
```

- Change style of action button

```objective-c
#import "CDZImagePickerActionsItem.h"
```

   And init the actionArray with CDZImagePickerActionItem with title, action, image and order you want.

```objective-c
imagePickerController.actionArray = [NSMutableArray arrayWithObjects:  		[[CDZImagePickerActionsItem alloc]initWithTitle:@"打开设备上的图片" withActionType:CDZImagePickerLibraryAction withImage:[UIImage imageNamed:@"phone-icon.png"]],
[[CDZImagePickerActionsItem alloc]initWithTitle:@"相机" withActionType:CDZImagePickerCameraAction withImage:[UIImage imageNamed:@"camera-icon.png"]]
 [[CDZImagePickerActionsItem alloc]initWithTitle:@"打开最新图片" withActionType:CDZImagePickerRecentAction withImage:[UIImage imageNamed:@"clock-icon.png"]],  nil];
```

## Articles
[iOS中写一个仿Snapseed的ImagePickerController（照片选择器 )]（http://www.jianshu.com/p/e8e23e9cc67d）

## Requirements
iOS 8.0 Above

## TODO

- Memory optimize
- Add Permisson Check
- CollectionView Realtime Refresh

## Contact
- Open a issue
- QQ：757765420
- Email：nemocdz@gmail.com
- Weibo：[@Nemocdz](http://weibo.com/nemocdz)

## License
CDZImagePicker is available under the MIT license. See the LICENSE file for more info.

