//
//  MoveActionViewController.m
//  MeiWan
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoveActionViewController.h"
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
@interface MoveActionViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextView *mytextView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *placehode;
@property (nonatomic,strong) NSMutableArray *statePhotos;
@property (nonatomic,assign) int imagecount;

@end

@implementation MoveActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.statePhotos = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.imagecount = 0;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placehode.text = @"说点什么吧...";
    }else{
        self.placehode.text = @"";
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
- (IBAction)addBtn:(UITapGestureRecognizer*)sender {
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
       // NSLog(@"1");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            ipc.allowsEditing = YES;
            ipc.showsCameraControls  = YES;
            
            [self presentViewController:ipc animated:YES completion:nil];
        }else{
           // NSLog(@"硬件不支持");
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
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        if (originImage) {
            [ShowMessage showMessage:@"图片存在"];
        }
        UIImage *scaleImage = [CompressImage compressImage:originImage];
        if (scaleImage == nil) {
            [ShowMessage showMessage:@"不支持该类型图片"];
        }else{
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
            //NSLog(@"%ld",data.length);
            [manager uploadWithFile:data policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                //NSLog(@"%f",percent);
            } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
                if (completed) {
                    [ShowMessage showMessage:@"上传成功"];
                    NSString *url;
                    if (isTest){
                        url = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                    }else{
                        url = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                    }
                    UIImage *image = [UIImage imageWithData:data];
                    [HUD hide:YES afterDelay:0];
                    if (self.imagecount == 0) {
                        self.image1.image = image;
                        self.imagecount = 1;
                        if (!self.image2.image) {
                            self.image2.image = [UIImage imageNamed:@"peiwan_add2"];
                        }

                    }else if (self.imagecount == 1){
                        self.image2.image = image;
                        self.imagecount = 2;
                        if (!self.image3.image) {
                            self.image3.image = [UIImage imageNamed:@"peiwan_add2"];
                        }
                    }else{
                        self.image3.image = image;
                    }
                    [self.statePhotos addObject:url];
                    // NSLog(@"%d",self.statePhotos.count);
                    //NSLog(@"%@",result);
                }else {
                    [ShowMessage showMessage:@"上传失败"];
                    [HUD hide:YES afterDelay:0];
                    //NSLog(@"%@",error);
                }
                
            }];
            //将二进制数据生成UIImage
            //将图片传递给截取界面进行截取并设置回调方法（协议）
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
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
    //NSLog(@"%lld",recordTime);
    NSString *strNumber = [RandNumber getRandNumberString];
    //NSLog(@"%@,%d",strNumber,strNumber.length);
    NSString *headUrl = [NSString stringWithFormat:@"%@_%@.jpeg",time,strNumber];
    [mutableDic setObject:headUrl forKey:@"path"];//设置保存路径
    /**
     *  这个 mutableDic 可以塞入其他可选参数 见：     */
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

- (IBAction)send:(UIBarButtonItem *)sender {
    //NSLog(@"%d",self.statePhotos.count);
    if (self.mytextView.text.length != 0 || self.statePhotos.count != 0) {
        for (int i = (int)self.statePhotos.count; i<3; i++) {
            [self.statePhotos addObject:[NSNull null]];
        }
        SBJsonWriter *writer = [[SBJsonWriter alloc]init];
        NSString *json = [writer stringWithObject:self.statePhotos];
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector insertState:session content:self.mytextView.text statePhotos:json receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    // NSLog(@"%@",json);
                    [self.delegate back];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if(status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                }
            }
        }];

    }else{
        [ShowMessage showMessage:@"请添加内容"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
