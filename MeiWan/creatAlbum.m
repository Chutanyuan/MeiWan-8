//
//  creatAlbum.m
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "creatAlbum.h"
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>
#import "ShowMessage.h"

@implementation creatAlbum


#pragma mark - 创建相册
+ (void)createAlbumSaveImage:(UIImage *)saveImage
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
            NSLog(@"%@",group);
        }
        
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:@"美玩"])
                {
                    haveHDRGroup = YES;
                }
            }
            
            if (!haveHDRGroup)
            {
                [assetsLibrary addAssetsGroupAlbumWithName:@"美玩" resultBlock:^(ALAssetsGroup *group) {
                    
                    [groups addObject:group];
                    
                } failureBlock:nil];
                haveHDRGroup = YES;
            }
        }
        
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    
    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(saveImage) customAlbumName:@"美玩" completionBlock:^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowMessage showMessage:@"保存成功"];
        });
        
    }failureBlock:^(NSError *error){
        //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
            if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                
                [alert show];
            }
        });
    }];
}

+ (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}


@end
