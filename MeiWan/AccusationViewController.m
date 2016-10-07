//
//  AccusationViewController.m
//  MeiWan
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AccusationViewController.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "RandNumber.h"
#import "Meiwan-Swift.h"
#import "LoginViewController.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "CompressImage.h"
@interface AccusationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITextView *accusationText;
@property (strong, nonatomic) IBOutlet UILabel *placeHold;
@property (strong, nonatomic) IBOutlet UIImageView *imageview1;
@property (strong, nonatomic) IBOutlet UIImageView *imageview2;
@property (strong, nonatomic) IBOutlet UIImageView *imageview3;
@property (strong, nonatomic) NSMutableArray *statePhotos;
@property (nonatomic,assign) int imageCount;
@end

@implementation AccusationViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.statePhotos = [NSMutableArray array];
    self.imageCount = 0;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHold.text = @"投诉内容...";
    }else{
        self.placeHold.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (IBAction)addImageBtn:(UITapGestureRecognizer*)sender {
    UIImageView * imgV = (UIImageView*)sender.view;
    if (imgV.image) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
        [alert show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    if (buttonIndex == 1) {

        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            ipc.allowsEditing = YES;
            ipc.showsCameraControls  = YES;
            
            [self presentViewController:ipc animated:YES completion:nil];
        }else{
           
        }
    }
    if (buttonIndex == 2) {
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:ipc animated:YES completion:nil];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *scaleImage = [CompressImage compressImage:originImage];
        if (scaleImage == nil) {
            [ShowMessage showMessage:@"不支持该类型图片"];
        }else{
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
            MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            
            //常用的设置
            //小矩形的背景色
            HUD.color = [UIColor grayColor];//这儿表示无背景
            //显示的文字
            HUD.labelText = @"正在上传";
            //是否有庶罩
            HUD.dimBackground = NO;
            if (UIImagePNGRepresentation(scaleImage) == nil) {
                //将图片转换为JPG格式的二进制数据
                data = UIImageJPEGRepresentation(scaleImage, 1);
            } else {
                //将图片转换为PNG格式的二进制数据
                data = UIImagePNGRepresentation(scaleImage);
            }
            NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:data];
            NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
            NSString * signature = signaturePolicyDic[@"signature"];
            NSString * policy = signaturePolicyDic[@"policy"];
            NSString * bucket = signaturePolicyDic[@"bucket"];
            UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
            [manager uploadWithFile:data policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
            } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
                if (completed) {
                    //[ShowMessage showMessage:@"头像上传成功"];
                    NSString *url = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                    UIImage *image = [UIImage imageWithData:data];
                    [HUD hide:YES afterDelay:0];
                    if (self.imageCount == 0) {
                        self.imageview1.image = image;
                        self.imageCount = 1;
                        if (!self.imageview2.image) {
                            self.imageview2.image = [UIImage imageNamed:@"peiwan_add2"];
                        }
                    }else if (self.imageCount == 1){
                        self.imageview2.image = image;
                        self.imageCount = 2;
                        if (!self.imageview3.image) {
                            self.imageview3.image = [UIImage imageNamed:@"peiwan_add2"];
                        }

                    }else{
                        self.imageview3.image = image;
                    }
                    [self.statePhotos addObject:url];
                }else {
                    [HUD hide:YES afterDelay:0];
                    [ShowMessage showMessage:@"上传失败"];
                }
                
            }];
        }
        //将二进制数据生成UIImage
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
    //#warning 您需要加上自己的bucket和secret
    NSString * bucket = [setting getImgBuketName];
    NSString * secret = [setting getSecret];
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *time = [NSString stringWithFormat:@"%lld",recordTime];
    NSString *strNumber = [RandNumber getRandNumberString];
    NSString *headUrl = [NSString stringWithFormat:@"%@_%@.jpeg",time,strNumber];
    [mutableDic setObject:headUrl forKey:@"path"];//设置保存路径
    /**
     *  这个 mutableDic 可以塞入其他可选参数
     */
    NSString * signature = @"";
    NSArray * keys = [mutableDic allKeys];
    keys= [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutableDic[key];
        signature = [NSString stringWithFormat:@"%@%@%@",signature,key,value];
    }
    signature = [signature stringByAppendingString:secret];
    
    return @{@"signature":[signature MD5],
             @"policy":[self dictionaryToJSONStringBase64Encoding:mutableDic],
             @"bucket":bucket};
}
- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}

- (IBAction)accusation:(UIBarButtonItem *)sender {
    NSString *title = @"";
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    NSString *photos = [writer stringWithObject:self.statePhotos];
    if (self.accusationText.text.length == 0) {
        [ShowMessage showMessage:@"请发布内容"];
    }else{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector sendComplain:session orderId:[self.orderDic objectForKey:@"id"] title:title content:self.accusationText.text photos:photos receiver:^(NSData *data, NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {

                    [self showMessageAlert:@"投诉成功，我们的客服正在处理您的退款请求"];
                }else if (status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                 }else if (status == 2){
                    [ShowMessage showMessage:@"已经提交过投诉了"];
                }else{
                    
                }
                
            }
        }];
    }
    
}

- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){

        [self.navigationController popViewControllerAnimated:YES];

    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
