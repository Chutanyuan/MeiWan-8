//
//  CompressImage.m
//  MeiWan
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CompressImage.h"


@implementation CompressImage

+ (UIImage*)compressImage:(UIImage*)image{
    NSData *data = UIImagePNGRepresentation(image);
    float length = data.length/1024/1024.0;
    //NSLog(@"%f",length);
    UIImage *comprssImage = nil;
    if (length > 10 ) {
        comprssImage = [self scaleImage:image toScale:0.15];
    }else if(length>8){
        comprssImage = [self scaleImage:image toScale:0.2];
    }else if(length> 6){
        comprssImage = [self scaleImage:image toScale:0.3];
    }else if(length > 4){
        comprssImage = [self scaleImage:image toScale:0.4];
    }else if(length > 3){
        comprssImage = [self scaleImage:image toScale:0.5];
    }else if(length > 2){
        comprssImage = [self scaleImage:image toScale:0.6];
    }else if(length > 1){
        comprssImage = [self scaleImage:image toScale:0.7];
    }else if(length > 0.3){
        comprssImage = [self scaleImage:image toScale:0.8];
    }else{
        comprssImage = [self scaleImage:image toScale:1];
    }
    return comprssImage;
}

+ (UIImage *)scaleImage:(UIImage*)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
