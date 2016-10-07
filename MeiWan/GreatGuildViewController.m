//
//  GreatGuildViewController.m
//  MeiWan
//
//  Created by Fox on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GreatGuildViewController.h"
#import "guildCenterViewController.h"

#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "Meiwan-Swift.h"
#import "setting.h"
#import "CompressImage.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "UMUUploaderManager.h"
#import "RandNumber.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"

@interface GreatGuildViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UIImageView *guildHeadImage;

@property (nonatomic, strong)UserInfo *userInfo;

@property (nonatomic, strong)UITextField *guildNameTextFild;

@property (nonatomic, strong)UIButton *upDataButton;

@property (nonatomic, strong)NSString *guildName;

@property (nonatomic, strong) NSDictionary *userInfoDic;


@end

@implementation GreatGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userInfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];
    
    self.guildHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake((dtScreenWidth-70)/2, dtNavBarDefaultHeight+40, 70, 70)];
    [self.guildHeadImage.layer setBorderWidth:0.5];
    [self.guildHeadImage.layer setBorderColor:[UIColor blackColor].CGColor];
    self.guildHeadImage.layer.cornerRadius = 35;
    self.guildHeadImage.clipsToBounds = YES;
    NSURL *url = [NSURL URLWithString:self.userInfo.headUrl];
    [self.guildHeadImage setImageWithURL:url];
    [self.view addSubview:self.guildHeadImage];
    
    self.guildHeadImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* guildHeadImageSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleGuildHeadImageTap:)];
    guildHeadImageSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.guildHeadImage addGestureRecognizer:guildHeadImageSingleRecognizer];
    
    self.guildNameTextFild = [[UITextField alloc] initWithFrame:CGRectMake((dtScreenWidth-200)/2, self.guildHeadImage.frame.origin.y+self.guildHeadImage.frame.size.height+20, 200, 35)];
    self.guildNameTextFild.borderStyle = UITextBorderStyleRoundedRect;
    self.guildNameTextFild.textAlignment = NSTextAlignmentLeft;
    self.guildNameTextFild.font = [UIFont systemFontOfSize:13.0f];
    self.guildNameTextFild.placeholder = @"创建公会的昵称";
    [self.guildNameTextFild setValue:[UIFont boldSystemFontOfSize:11.0f] forKeyPath:@"_placeholderLabel.font"];
    [self.guildNameTextFild setValue:[UIColor colorWithWhite:0.5 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    self.guildNameTextFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    NSMutableParagraphStyle *signStyle = [self.guildNameTextFild.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    signStyle.minimumLineHeight = self.guildNameTextFild.font.lineHeight - (self.guildNameTextFild.font.lineHeight - [UIFont systemFontOfSize:11.0f].lineHeight) / 2.0;
    //[UIFont systemFontOfSize:13.0f]是设置的placeholder的字体
    self.guildNameTextFild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.guildNameTextFild.placeholder
                                                                     attributes:@{NSParagraphStyleAttributeName : signStyle}];
    self.guildNameTextFild.textAlignment = NSTextAlignmentCenter;
    [self.guildNameTextFild addTarget:self action:@selector(guildNameTextFild:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.guildNameTextFild];
    
    self.upDataButton = [[UIButton alloc] initWithFrame:CGRectMake((dtScreenWidth-150)/2, self.guildNameTextFild.frame.origin.y+self.guildNameTextFild.frame.size.height+40, 150, 35)];
    [self.upDataButton setTitle:@"提交资料" forState:UIControlStateNormal];
    self.upDataButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.upDataButton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
    self.upDataButton.layer.masksToBounds = YES;
    self.upDataButton.layer.cornerRadius = 6.0f;
    [self.upDataButton addTarget:self action:@selector(upDataButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upDataButton];
    
    // Do any additional setup after loading the view.
}

- (void)SingleGuildHeadImageTap:(UITapGestureRecognizer*)recognizer{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [alert show];
}

- (void)upDataButton:(UIButton *)sender{
    
    if (self.guildName == nil) {
        [ShowMessage showMessage:@"公会名不能为空"];
    }else{
        NSData *data = UIImagePNGRepresentation(self.guildHeadImage.image);
        NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:data];
        NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
        
        NSString * signature = signaturePolicyDic[@"signature"];
        NSString * policy = signaturePolicyDic[@"policy"];
        NSString * bucket = signaturePolicyDic[@"bucket"];
        
        UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
        [manager uploadWithFile:data policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
            //NSLog(@"%f",percent);
        } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
            if (completed) {
                //[ShowMessage showMessage:@"头像上传成功"];
                NSString *headUrl;
                if (isTest){
                    headUrl = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                }else{
                    headUrl = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                }
                NSString *session = [PersistenceManager getLoginSession];
                [UserConnector  createUnion:session name:self.guildName headUrl:headUrl receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if (error) {
                        [ShowMessage showMessage:@"服务器连接失败,提交失败"];
                    }else{
                        SBJsonParser*parser=[[SBJsonParser alloc]init];
                        NSMutableDictionary *json=[parser objectWithData:data];
                        int status = [json[@"status"] intValue];
                        if (status == 0) {
                            [ShowMessage showMessage:@"资料提交成功"];
                            [self performSelector:@selector(pushViewController) withObject:nil afterDelay:0.5];

                        }else if (status == 1){
                            [ShowMessage showMessage:@"没有登录"];
                        }else{
                            [ShowMessage showMessage:@"信息错误"];
                        }
                        
                        
                    }
                }];
            }else{
                [ShowMessage showMessage:@"提交失败,请重新提交"];
            }
        }];

    }
    
}
- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo        {
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

        

- (void)guildNameTextFild:(UITextField *)textField
{
    if (textField.text.length > 8) {
        textField.text = [textField.text substringToIndex:8];
        [self showMessageAlert:@"字符不能大于8个字符"];
    }
    self.guildName = textField.text;
    NSLog(@"%@",textField.text);
    NSLog(@"%lu",textField.text.length);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    //    ipc.navigationBar.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];//系统导航栏透明未解决
    [[ipc navigationBar] setTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    if (buttonIndex == 1) {
        //NSLog(@"1");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            ipc.allowsEditing = YES;
            ipc.showsCameraControls  = YES;
            [self presentViewController:ipc animated:YES completion:nil];
            
        }else{
            //NSLog(@"硬件不支持");
        }
    }
    if (buttonIndex == 2) {
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        ipc.allowsEditing = YES;
        [self presentViewController:ipc animated:YES completion:nil];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [CompressImage compressImage:originImage];
        if (scaleImage == nil) {
            [ShowMessage showMessage:@"不支持该类型图片"];
        }else{
            [self passImage:scaleImage];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)passImage:(UIImage *)image{
    self.guildHeadImage.image = image;
}

- (void)pushViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate popViewLoadView];
}
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
