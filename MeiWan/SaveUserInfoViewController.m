//
//  SaveUserInfoViewController.m
//  MeiWan
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SaveUserInfoViewController.h"
#import "CorlorTransform.h"
#import "ShowMessage.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "setting.h"
#import "RandNumber.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import <MAMapKit/MAMapKit.h>


@interface SaveUserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (nonatomic,strong) UIAlertView *alert1;
@property (nonatomic,strong) UIAlertView *alert3;
@property (nonatomic,strong) UIDatePicker *picker;
@property (nonatomic,strong) UIView *vi;
@property (nonatomic,assign) BOOL isloadPicture;
@property (nonatomic,strong) MAMapView *mapview;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *sublocality;
@end

@implementation SaveUserInfoViewController

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation){
         CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                //这时的placemarks数组里面只有一个元素
                CLPlacemark * placemark = [placemarks firstObject];
                if (!self.city) {
                    self.city = [placemark.addressDictionary objectForKey:@"City"];
                }
                if (!self.sublocality) {
                    self.sublocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
                }
            }
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapview = [[MAMapView alloc]init];
    self.mapview.delegate = self;
    self.mapview.showsUserLocation = YES;

    self.headImage.layer.cornerRadius = 35;
    self.headImage.layer.masksToBounds = YES;
    //self.vi.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    // Do any additional setup after loading the view.
}
- (IBAction)hideKeyboard:(UITextField *)sender {
    [self.nickName resignFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)choicePhoto:(UITapGestureRecognizer *)sender {
    self.alert3 = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [self.alert3 show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.alert3) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
        ipc.delegate = self;
        if (buttonIndex == 1) {
            //NSLog(@"1");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
                ipc.allowsEditing = YES;
                ipc.showsCameraControls  = YES;
                [self presentViewController:ipc animated:YES completion:nil];
            }else{
                NSLog(@"硬件不支持");
            }
        }
        if (buttonIndex == 2) {
            [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            ipc.allowsEditing = YES;
            [self presentViewController:ipc animated:YES completion:nil];
        }
        

    }
    if (alertView == self.alert1) {
        if (buttonIndex == 0) {
            self.sex.text = @"男";
            self.myregistInfo.gender = 0;
        }else{
            self.sex.text = @"女";
            self.myregistInfo.gender = 1;
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        //将二进制数据生成UIImage
        UIImage *image = [CompressImage compressImage:originImage];
        if (image == nil) {
            [ShowMessage showMessage:@"不支持该类型图片"];
        }else{
            [self passImage:image];
        }        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)passImage:(UIImage *)image{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    
    //常用的设置
    //小矩形的背景色
    HUD.color = [UIColor grayColor];//这儿表示无背景
    //显示的文字
    HUD.labelText = @"正在上传";
    //是否有庶罩
    HUD.dimBackground = NO;
    NSData *data = UIImagePNGRepresentation(image);
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
            [HUD hide:YES afterDelay:0];
            self.headImage.image = image;
            [ShowMessage showMessage:@"头像上传成功"];
            self.isloadPicture = YES;
            if (isTest){
                self.myregistInfo.headUrl = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }else{
                self.myregistInfo.headUrl = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }

            //NSLog(@"%@",result);
        }else {
            [HUD hide:YES afterDelay:0];
            self.isloadPicture = YES;
            [ShowMessage showMessage:@"头像上传失败"];
            //NSLog(@"%@",error);
        }
        
    }];

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
     *  这个 mutableDic 可以塞入其他可选参数 见：http://docs.upyun.com/api/form_api/#Policy%e5%86%85%e5%ae%b9%e8%af%a6%e8%a7%a3
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)choiceSex:(UITapGestureRecognizer *)sender {
    self.alert1 = [[UIAlertView alloc]initWithTitle:@"请选择性别" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    [self.alert1 show];
}

- (IBAction)choiceBirthday:(UITapGestureRecognizer *)sender {
    self.vi = [[UIView alloc]initWithFrame:CGRectMake(20, (self.view.bounds.size.height-256)/2, self.view.bounds.size.width-40, 257)];
    self.vi.backgroundColor = [UIColor grayColor];
    
    self.picker = [[UIDatePicker alloc]init];
    self.picker.frame = CGRectMake(0, 0, self.vi.bounds.size.width, 216);
    self.picker.datePickerMode = UIDatePickerModeDate;
    self.picker.backgroundColor = [UIColor whiteColor];
    [self.vi  addSubview:self.picker];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 217, self.vi.bounds.size.width/2-0.5, 40)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    [self.vi addSubview:btn];
    
    UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(self.vi.bounds.size.width/2+0.5,217, self.vi.bounds.size.width/2-0.5, 40)];
    [btn1 setTitle:@"确定" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor whiteColor];
    [self.vi addSubview:btn1];
    
    self.view.alpha = 0.5;
    self.view.userInteractionEnabled = NO;
    [[ShowMessage mainWindow] addSubview:self.vi];
    
    
}
-(void)cancel:(UIButton*)sender{
    self.view.alpha = 1;
    self.view.userInteractionEnabled = YES;
    [self.vi removeFromSuperview];
    
}
-(void)sure:(UIButton*)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    self.birthday.text = [formatter stringFromDate:self.picker.date];
    NSRange r ;
    r.location = 0;
    r.length =4;
    NSString *year = [self.birthday.text substringWithRange:r];
    self.myregistInfo.year = [year intValue];
    //NSLog(@"%d",self.myregistInfo.year);

    NSRange r1 ;
    r1.location = 5;
    r1.length =2;
    NSString *month = [self.birthday.text substringWithRange:r1];
    self.myregistInfo.month = [month intValue];
    //NSLog(@"%d",self.myregistInfo.month);
    
    NSRange r2 ;
    r2.location = 8;
    r2.length =2;
    NSString *day = [self.birthday.text substringWithRange:r2];
    self.myregistInfo.day = [day intValue];
    //NSLog(@"%d",self.myregistInfo.day);
    
    self.view.alpha = 1;
    self.view.userInteractionEnabled = YES;
    [self.vi removeFromSuperview];
}
- (IBAction)Done:(UIButton *)sender {

    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    self.mapview = nil;
 
    if (self.nickName.text.length > 0 && self.sex.text.length == 1 && self.birthday.text.length == 11 && self.isloadPicture) {
        self.myregistInfo.nickname = self.nickName.text;
        [UserConnector register:self.myregistInfo.username password:self.myregistInfo.password verifyCode:self.myregistInfo.verifyCode nickname:self.myregistInfo.nickname gender:[[NSNumber alloc] initWithInt:self.myregistInfo.gender] year:[[NSNumber alloc] initWithInt:self.myregistInfo.year] month:[[NSNumber alloc] initWithInt:self.myregistInfo.month] day:[[NSNumber alloc] initWithInt:self.myregistInfo.day] headUrl:self.myregistInfo.headUrl city:self.city     district:self.sublocality deviceType:@2 receiver:^(NSData *data,NSError *error){
            
            HUD.labelText = @"注册中";
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
                [HUD hide:YES afterDelay:0];
            }
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
            NSDictionary *userDict = [json objectForKey:@"entity"];
            NSNumber *status=[json objectForKey:@"status"];
            if (status.intValue==1) {
                [self showMessage:@"验证码错误"];
            }else if(status.intValue==2){
                [self showMessage:@"用户已经存在"];
            }else{
                NSString *session = [json objectForKey:@"extra"];
                //NSLog(@"%@",session);
                [PersistenceManager setLoginUser:userDict];
                [PersistenceManager setLoginSession:session];
                
                [[EMClient sharedClient] setApnsNickname:self.nickName.text];
                
                [HUD hide:YES afterDelay:0];
                [self performSegueWithIdentifier:@"players" sender:nil];
            }
        }];

    }else{
        
        [self showMessage:@"请填写完整信息"];
        HUD.hidden = YES; 
    }
}
- (void)showMessage:(NSString *)string
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
