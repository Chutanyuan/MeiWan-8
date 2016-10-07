//
//  AskForPlayWithViewController.m
//  MeiWan
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AskForPlayWithViewController.h"
#import "UMUUploaderManager.h"
#import "MD5.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "setting.h"
#import "RandNumber.h"
#import "meiwan-Swift.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "CorlorTransform.h"
@interface AskForPlayWithViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView * timelabelView;
    NSArray * labelArray;
}
@property (strong, nonatomic) IBOutlet UITextField *nameOfGame;
@property (strong, nonatomic) IBOutlet UITextField *nicknameInGame;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UIImageView *personPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *gamePhoto;
@property (strong, nonatomic) IBOutlet UILabel *agreement;
@property (strong, nonatomic) IBOutlet UILabel *protolc;
@property (assign, nonatomic) int tapImageView;
@property (strong, nonatomic) NSString *headPhoto;
@property (strong, nonatomic) NSString *idPhone;
@property (nonatomic,assign) BOOL isHeadPhoto;
@property (nonatomic,assign) BOOL isIdphone;
@property (nonatomic,assign) float centerY;
@property (nonatomic, strong) UIWebView *wb;
@property (nonatomic, strong) UITextField *gameName;//一个伪参数

@end

@implementation AskForPlayWithViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    labelArray = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
    
    [_nicknameInGame setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_address setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_phone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    self.tabBarController.tabBar.hidden=YES;
    self.isIdphone = NO;
    self.isHeadPhoto = NO;
    self.centerY = self.view.center.y;
    
    self.gameName = [[UITextField alloc] init];
    self.gameName.text = @"伪装参数";
    
    NSString *agreementStr = @"当你使用本软件代表你同意";
    NSMutableAttributedString *agreementAs = [[NSMutableAttributedString alloc]initWithString:agreementStr];
    [agreementAs addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:12]  range:NSMakeRange(0, agreementStr.length)];
    [agreementAs addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 10)];
    [agreementAs addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, 2)];
    self.agreement.attributedText = agreementAs;
    
    NSString *promptStr = @"《美玩达人协议》";
    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc]initWithString:promptStr];
    [promptAs addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:12]  range:NSMakeRange(0, promptStr.length)];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#36C8FF"] range:NSMakeRange(0, 8)];
    [promptAs addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, 8)];
    self.protolc.attributedText = promptAs;
    
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.agreement.hidden = YES;
        self.protolc.hidden = YES;
    }else{
        if (![setting canOpen]) {
            self.agreement.hidden = YES;
            self.protolc.hidden = YES;
        }
        [setting getOpen];
    
    }
    // Do any additional setup after loading the view.
}
- (IBAction)userPrompt:(UITapGestureRecognizer *)sender {
    self.wb=[[UIWebView alloc]initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width-20,self.view.bounds.size.height-50)];
    self.wb.delegate = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"peiwan_protocol" ofType:@"htm"];
    
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self.wb loadHTMLString:html baseURL:baseURL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, self.wb.bounds.size.height-30, self.wb.bounds.size.width, 30);
    [btn addTarget:self action:@selector(MakeSure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wb addSubview:btn];
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.hidden = YES;
    self.view.userInteractionEnabled = NO;
    [[ShowMessage mainWindow] addSubview:self.wb];

}
-(void)MakeSure{
    self.view.alpha = 1;
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.wb removeFromSuperview];
}

- (IBAction)next:(UITextField *)sender {
    if (sender.tag == 801) {
        [self.nicknameInGame becomeFirstResponder];
    }else if(sender.tag == 802){
        [self.address becomeFirstResponder];
    }else if(sender.tag == 803){
        [self.phone becomeFirstResponder];
    }else{
        [sender resignFirstResponder];
        if (self.view.bounds.size.height<500) {
            self.view.center = CGPointMake(self.view.center.x,self.centerY);
        }

    }
}
- (IBAction)textfiledTimeLabelClick:(UIButton *)sender {
    [self creat_timeLabelView];
}
- (void)creat_timeLabelView
{
    [self.view endEditing:YES];
    timelabelView = [[UIView alloc]init];
    timelabelView.center = self.view.center;
    timelabelView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*3/4, [UIScreen mainScreen].bounds.size.height*2/3);
    timelabelView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:timelabelView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, timelabelView.frame.size.height-40, timelabelView.frame.size.width, 40);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectCancel:) forControlEvents:UIControlEventTouchUpInside];
    [timelabelView addSubview:button];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, timelabelView.frame.size.width, timelabelView.frame.size.height-40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [timelabelView addSubview:tableView];
    
}
- (void)selectCancel:(UIButton *)sender
{
    timelabelView.hidden = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return labelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = labelArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _nicknameInGame.text = labelArray[indexPath.row];
    timelabelView.hidden = YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)phoneBeginEditing:(UITextField *)sender {
    if (self.view.bounds.size.height<500) {
        self.view.center = CGPointMake(self.view.center.x,self.view.center.y-40);
    }
}
- (IBAction)done:(UIBarButtonItem *)sender {
//    self.nameOfGame.text
    if (self.gameName.text.length != 0 && self.nicknameInGame.text.length != 0 && self.address.text.length != 0 &&self.phone.text.length != 0 && self.isHeadPhoto && self.isIdphone) {
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector createPeiwanForm:session phone:self.phone.text gameName:self.nameOfGame.text gameNickname:self.nicknameInGame.text headPhoto:self.headPhoto idPhoto:self.idPhone address:self.address.text receiver:^(NSData *data,NSError *error    ){
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [self showMessage:@"您的表单我们已经收到，亲请耐心等待，我们的审核工作人员会在24小时内处理您的信息"];
            }else if (status == 1){
                dispatch_async(dispatch_get_main_queue()
                , ^{
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];

                });
            }
         }];
        
    
    }else{
        [self showMessage:@"请填写完整表单"];
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

- (IBAction)tapImage:(UITapGestureRecognizer *)sender {
    self.tapImageView = (int)sender.view.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
           // NSLog(@"硬件不支持");
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
-(void)passImage:(UIImage*)image{
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
            [ShowMessage showMessage:@"上传成功"];
            if (self.tapImageView == 1000) {
                
                if (isTest){
                    self.headPhoto = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                }else{
                    self.headPhoto = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                }
                self.isHeadPhoto = YES;
                self.personPhoto.image = image;
                [HUD hide:YES afterDelay:0];
                
                //NSLog(@"%@",self.headPhoto);
            }else{
                if (isTest){
                    self.idPhone = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                }else{
                    self.idPhone = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
                }
                self.isIdphone = YES;
                self.gamePhoto.image = image;
                [HUD hide:YES afterDelay:0];
                //NSLog(@"%@",self.idPhone);
            }
            //NSLog(@"%@",result);
        }else {
            [ShowMessage showMessage:@"上传失败"];
            [HUD hide:YES afterDelay:0];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
