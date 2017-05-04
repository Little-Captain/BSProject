//
//  BSPictureViewController.m
//  BSProject
//
//  Created by Liu-Mac on 14/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCPictureViewController.h"
#import "LCTopicItem.h"
#import "LCCircularProgressView.h"
#import <Photos/Photos.h>

#import <UIImageView+YYWebImage.h>
#import <SVProgressHUD.h>

#define BSAlbumTitle @"百思不得姐"

@interface LCPictureViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet LCCircularProgressView *progressView;

/** imageV */
@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation LCPictureViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpImageView];
    
}
- (IBAction)savePicture {
    
    if (!self.imageV.image) {
        [SVProgressHUD showErrorWithStatus:@"图片还没有下载完!"];
        return;
    }
    // 将图片写入相册!!!
    // 方法一
//    UIImageWriteToSavedPhotosAlbum(self.imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // 方法二
    // 使用Photos框架
    // 常用类
    /*
     PHAsset: A representation of an image, video or Live Photo in the Photos library.
     PHAssetCollection: A representation of a Photos asset grouping, such as a moment, user-created album, or smart album.
     PHFetchResult: An ordered list of assets or collections returned from a Photos fetch method.
     PHAssetChangeRequest: A request to create, delete, change metadata for, or edit the content of a Photos asset, for use in a photo library change block.
     PHAssetCollectionChangeRequest: A request to create, delete, or modify a Photos asset collection, for use in a photo library change block.
     PHObjectPlaceholder: A read-only proxy representing a Photos asset or collection object yet to be created by a change request.
     */
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageV.image];
        // Request editing the album.
        PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHAssetCollectionChangeRequest *albumChangeRequest = nil;
        if (fetchResult.count) {
            for (PHAssetCollection *collection in fetchResult) {
                if ([collection.localizedTitle isEqualToString:BSAlbumTitle]) {
                    albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                    break;
                }
            }
        } else {
            albumChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:BSAlbumTitle];
        }
        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[ assetPlaceholder ]];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败!"];
        }
    }];
    
}

- (void)setUpImageView {
    [self.progressView setProgress:self.topicItem.picProgress animated:NO];
    UIImageView *imageV = [NSClassFromString(@"YYAnimatedImageView") new];
    self.imageV = imageV;
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [imageV addGestureRecognizer:tap];
    [imageV yy_setImageWithURL:[NSURL URLWithString:self.topicItem.bigImage] placeholder:nil options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        self.topicItem.picProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:self.topicItem.picProgress animated:NO];
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.progressView.hidden = YES;
    }];
    
    CGFloat picW = self.topicItem.width.doubleValue;
    CGFloat picH = self.topicItem.height.doubleValue;
    // picW    * picH
    // calPicW * calPicH
    CGFloat calPicW = ScreenW;
    CGFloat calPicH = picH * calPicW / picW;
    
    imageV.fWidth = calPicW;
    imageV.fHeight = calPicH;
    
    if (calPicH < ScreenH) {
        imageV.cY = ScreenH * 0.5;
    } else {
        imageV.fX = 0;
        imageV.fY = 0;
    }
    
//    BSLog(@"%@", NSStringFromCGRect(imageV.frame));
    self.scrollV.contentSize = imageV.fSize;
    [self.scrollV addSubview:imageV];
}

- (IBAction)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 屏幕方向支持
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

@end
