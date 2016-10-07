//
//  AliHelper.m
//  MeiWan
//
//  Created by mac on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AliHelper.h"


#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliOrder.h"
#import "RandNumber.h"
#import "setting.h"

@implementation AliHelper
+(void)aliPay:(NSInteger)orderId price:(double)price callback:(Callback)callback{
    NSString *partner = @"2088021015812842";
    NSString *seller = @"2695019756@qq.com";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALGqFh0UyIXXmmcxB+RRQFeboGEu+NXfIQFcjYya5u9J3HWluoNsxrNMMHQmUbhxDZq0z89jkqcr/soCoNMUNHpheFvjMKsOxzvtA15yhRalcwUL8+kojflQ4PWIdNZ4wri1wpmQ7KoFni7LM3XpmSdK1NNU+2Iu+XPHOjWpeEUDAgMBAAECgYBAhl+FrFivk4B2Xe5Z09CkgNcctKyXMHSSRAT8vf2FhrPU3p4AwW7hC5jFdm1TqWuhdm3LCoTmxinBQHccckgkV2UEWAYpQ/8BMfv3SCGfmiN+oNtML9Vjw7FopPuUdFS2iyqtToy3CrVcjEl3Q3jyH/6gJpG1ErBOZv38Sfqk4QJBANzFsVDY6J6vhzG5NNowFPw160fcH8Z4h84ahkV4IWWpzfdRxtrh8Bxi/IGV8K6bMh+tLQW9RDI99vkGefiTovkCQQDOA3w0ZlR5FMoJxSXJXe+zvuN4DZRNyDlVogNhfK5dO4S4MIAut5zmMaHTJ7ttdD/5F1fIQ5AvDYSZlR7KpyrbAkAJZE+axN+AgK8bqmlZLtp1sEWGFRM0+kOsvOwhYG7rSEH+13fCMAJq8rsTODG4+9kyB8f2ioqwKHqtNV1S+dThAkBRsuQgy6wYUHxHH536m3wh5kPDKm9z4UGLijKZCJ8FbkMV4HYVEM/yIiCw4oLbx0xPdkhjrReS8WNynMaXS3AdAkB7veDHqOJRX4JldTRmt0sRGGyHQuQUNNFk/Pr0j/XYPE52J+4u+IK/5QBkgf9zl48JZxB86ETEEGodOUNn7c5O";

    AliOrder *order = [[AliOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    NSString *no=[NSString stringWithFormat:@"%ld-%@",(long)orderId,[RandNumber getRandNumberString:12]];//订单ID（由商家自行制定）
    order.tradeNO =no;
    order.productName = @"美玩"; //商品标题
    order.productDescription = @"美玩"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    if (isTest) {
        order.notifyURL =  @"http://120.26.107.177:8081/peiwan-server/notify_url.jsp"; //回调URL
    }else{
        order.notifyURL =  @"http://121.43.157.12:8081/peiwan-server/notify_url.jsp"; //回调URL
    }
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"meiwan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            callback(resultDic);
        }];
        
    }

}
+(void)aliRecharge:(NSInteger)rechargeId price:(double)price callback:(Callback)callback{
    NSString *partner = @"2088021015812842";
    NSString *seller = @"2695019756@qq.com";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALGqFh0UyIXXmmcxB+RRQFeboGEu+NXfIQFcjYya5u9J3HWluoNsxrNMMHQmUbhxDZq0z89jkqcr/soCoNMUNHpheFvjMKsOxzvtA15yhRalcwUL8+kojflQ4PWIdNZ4wri1wpmQ7KoFni7LM3XpmSdK1NNU+2Iu+XPHOjWpeEUDAgMBAAECgYBAhl+FrFivk4B2Xe5Z09CkgNcctKyXMHSSRAT8vf2FhrPU3p4AwW7hC5jFdm1TqWuhdm3LCoTmxinBQHccckgkV2UEWAYpQ/8BMfv3SCGfmiN+oNtML9Vjw7FopPuUdFS2iyqtToy3CrVcjEl3Q3jyH/6gJpG1ErBOZv38Sfqk4QJBANzFsVDY6J6vhzG5NNowFPw160fcH8Z4h84ahkV4IWWpzfdRxtrh8Bxi/IGV8K6bMh+tLQW9RDI99vkGefiTovkCQQDOA3w0ZlR5FMoJxSXJXe+zvuN4DZRNyDlVogNhfK5dO4S4MIAut5zmMaHTJ7ttdD/5F1fIQ5AvDYSZlR7KpyrbAkAJZE+axN+AgK8bqmlZLtp1sEWGFRM0+kOsvOwhYG7rSEH+13fCMAJq8rsTODG4+9kyB8f2ioqwKHqtNV1S+dThAkBRsuQgy6wYUHxHH536m3wh5kPDKm9z4UGLijKZCJ8FbkMV4HYVEM/yIiCw4oLbx0xPdkhjrReS8WNynMaXS3AdAkB7veDHqOJRX4JldTRmt0sRGGyHQuQUNNFk/Pr0j/XYPE52J+4u+IK/5QBkgf9zl48JZxB86ETEEGodOUNn7c5O";
    
    AliOrder *order = [[AliOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    NSString *no=[NSString stringWithFormat:@"%ld-%@",(long)rechargeId,[RandNumber getRandNumberString:12]];//订单ID（由商家自行制定）
    order.tradeNO =no;
    order.productName = @"美玩充值"; //商品标题
    order.productDescription = @"美玩充值"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    if (isTest) {
        order.notifyURL =  @"http://120.26.107.177:8081/peiwan-server/notify_url2.jsp"; //回调URL
    }else{
        order.notifyURL =  @"http://121.43.157.12:8081/peiwan-server/notify_url2.jsp"; //回调URL
    }
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"meiwan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            callback(resultDic);
        }];
        
    }
    
}

@end
