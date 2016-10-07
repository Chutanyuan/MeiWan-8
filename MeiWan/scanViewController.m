//
//  scanViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "scanViewController.h"
#import "CorlorTransform.h"
@interface scanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI_init];
    
    
}

- (void)UI_init
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * view = [[UIView alloc]init];
    view.center = self.view.center;
    view.bounds = CGRectMake(0, 0, 250, 250);
    [self.view addSubview:view];
    
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, view.frame.origin.y)];
    top.backgroundColor = [UIColor blackColor];
    top.alpha = 0.5;
    [self.view addSubview:top];
    
    UIView * left = [[UIView alloc]initWithFrame:CGRectMake(0, top.frame.size.height, view.frame.origin.x, view.frame.size.height)];
    left.backgroundColor = [UIColor blackColor];
    left.alpha = 0.5;
    [self.view addSubview:left];
    
    UIView * right = [[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x+view.frame.size.width, top.frame.size.height, left.frame.size.width, left.frame.size.height)];
    right.backgroundColor = [UIColor blackColor];
    right.alpha = 0.5;
    [self.view addSubview:right];
    
    UIView * bottom = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y, dtScreenWidth, dtScreenHeight-view.frame.size.height-view.frame.origin.y)];
    bottom.backgroundColor = [UIColor blackColor];
    bottom.alpha = 0.5;
    [self.view addSubview:bottom];
    
    UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2, view.frame.size.width, 1)];
    lineImage.backgroundColor = [CorlorTransform colorWithHexString:@"#458B00"];
    [view addSubview:lineImage];
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        lineImage.frame = CGRectMake(0, view.frame.size.width, view.frame.size.width, 1);
        
        
        if (lineImage.frame.origin.y == view.frame.size.width) {
            lineImage.frame = CGRectMake(0, 0, view.frame.size.width, 1);
        }
        if (lineImage.frame.origin.y == 0) {
            lineImage.frame = CGRectMake(0, view.frame.size.width, view.frame.size.width, 1);

        }
        
    } completion:nil];


    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:CGRectMake((124)/dtScreenHeight,((dtScreenWidth-220)/2)/dtScreenWidth,220/dtScreenHeight,220/dtScreenWidth)];
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];

}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        [session stopRunning];
        
        
        
        [self showMessageAlert:metadataObject.stringValue];
    }
}
/**提示框*/
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
