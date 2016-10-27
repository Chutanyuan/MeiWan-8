//
//  EditPersonalMessageVC.m
//  MeiWan
//
//  Created by user_kevin on 16/10/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EditPersonalMessageVC.h"
#import "photosView.h"
#import "MeiWan-Swift.h"
#import "SBJsonParser.h"

#import "UMUUploaderManager.h"
#import "CompressImage.h"
#import "ShowMessage.h"
#import "RandNumber.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "EditPersonalFootView.h"
#import "editOwnMessage.h"
#import "editdescription.h"
#import "JobChooseViewController.h"
#import "emotionalState.h"
#import "schoolChooseVC.h"
#import "insterestChooseVC.h"
#import "MJRefresh.h"
#import "EditpersonalMessageTableViewCell.h"



@interface EditPersonalMessageVC ()<UITableViewDelegate,UITableViewDataSource,photosTouchUpdataDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSNumber * ID_number;
@property(nonatomic,strong)NSDictionary * UserMessage;

@property(nonatomic,strong)NSDictionary * loginUserMessage;

@property(nonatomic,strong)UIImageView * TapImageView;


@end

@implementation EditPersonalMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
    
    self.UserMessage = [[NSDictionary alloc]init];
    NSDictionary * loginUserMessage = [PersistenceManager getLoginUser];
    self.loginUserMessage = loginUserMessage;
    self.ID_number = [NSNumber numberWithDouble:[loginUserMessage[@"id"] doubleValue]];
    
    [self UseMessageNetWorking];

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveNickname:) name:@"finish_nickname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveHeight:) name:@"finish_height" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveWeight:) name:@"finish_weight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveSign:) name:@"finish_sign" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveJob:) name:@"finish_job" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveZodiac:) name:@"finish_zodiac" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveAddress:) name:@"finish_address" object:nil];

}
- (void)finishSaveNickname:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.rightlabel.text = test.object;
}
- (void)finishSaveHeight:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.rightlabel.text = test.object;

}
- (void)finishSaveWeight:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.rightlabel.text = test.object;
    
}
- (void)finishSaveSign:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.rightlabel.text = test.object;
    
}
- (void)finishSaveJob:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.rightlabel.text = test.object;
    
}
- (void)finishSaveZodiac:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.rightlabel.text = test.object;
    
}
- (void)finishSaveAddress:(NSNotification *)test
{
    EditpersonalMessageTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    cell.rightlabel.text = test.object;
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark----网络请求
- (void)UseMessageNetWorking
{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:self.ID_number receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                self.UserMessage = json[@"entity"];
                NSMutableDictionary * saveMessage = json[@"entity"];
                [saveMessage removeObjectForKey:@"userStates"];
                [PersistenceManager setLoginUser:saveMessage];
                [self.tableview reloadData];
            }
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * zeroname = @[@"用户名",@"身高",@"体重",@"个性签名"];
    NSArray * onename = @[@"职业",@"星座",@"所在地"];
        EditpersonalMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[EditpersonalMessageTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
             
    }
    if (indexPath.section==0) {
        cell.textLabel.text = zeroname[indexPath.row];
        
        if (indexPath.row==0) {
                cell.rightlabel.text = [NSString stringWithFormat:@"%@",self.loginUserMessage[@"nickname"]];
        
        }else if (indexPath.row==1){
                cell.rightlabel.text = [NSString stringWithFormat:@"%@cm",self.loginUserMessage[@"height"]];
        
        }else if (indexPath.row==2){
                cell.rightlabel.text = [NSString stringWithFormat:@"%@kg",self.loginUserMessage[@"weight"]];
        
        }else if (indexPath.row==3){
                cell.rightlabel.text = [NSString stringWithFormat:@"%@",self.loginUserMessage[@"description"]];
        
        }
        
    }else if (indexPath.section==1){
        cell.textLabel.text = onename[indexPath.row];
        
        if (indexPath.row==0) {
            cell.rightlabel.text = [NSString stringWithFormat:@"%@",self.loginUserMessage[@"job"]];
        }else if (indexPath.row==1){
            cell.rightlabel.text = [NSString stringWithFormat:@"%@",self.loginUserMessage[@"xingzuo"]];
        }else if (indexPath.row==2){
            cell.rightlabel.text = [NSString stringWithFormat:@"%@",self.loginUserMessage[@"location"]];
        }
    }

    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    editOwnMessage * editVC = [[editOwnMessage alloc]init];
                    editVC.title = @"编辑昵称";
                    [self.navigationController pushViewController:editVC animated:YES];
                }
                    break;
                case 1:
                {
//身高
                    emotionalState * emotional = [[emotionalState alloc]init];
                    emotional.title = @"身高";
                    [self.navigationController pushViewController:emotional animated:YES];
                }
                    break;
                case 2:
                {
//体重
                    schoolChooseVC * schoolVC = [[schoolChooseVC alloc]init];
                    schoolVC.title = @"体重";
                    [self.navigationController pushViewController:schoolVC animated:YES];
                }
                    break;
                case 3:
                {
                    editdescription * description = [[editdescription alloc]init];
                    description.title = @"编辑签名";
                    [self.navigationController pushViewController:description animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    JobChooseViewController * jobChoose = [[JobChooseViewController alloc]init];
                    jobChoose.title = @"职业";
                    [self.navigationController pushViewController:jobChoose animated:YES];
                }
                    break;
                case 1:
                {
//星座
                    insterestChooseVC * insterest = [[ insterestChooseVC alloc]init];
                    insterest.title = @"星座";
                    [self.navigationController pushViewController:insterest animated:YES];
                }
                    break;
                case 2:
                {
//所在地
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 4;
        
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return dtScreenWidth;
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        photosView * view = [[photosView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenWidth)];
        view.UserMessage = self.UserMessage;
        view.delegate = self;
        
        return view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 200;
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        EditPersonalFootView * view = [[EditPersonalFootView  alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 200)];
        return view;
    }else{
        return nil;
    }
}


#pragma mark----保存按钮action
- (void)save
{
    
}
#pragma mark----photosview  delegate

-(void)phototsTouch:(UIImageView *)imageview
{
    self.TapImageView = imageview;
    if (_TapImageView.tag>100) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alert.tag=10;
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
        [alert show];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    [[ipc navigationBar] setTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    if (buttonIndex == 1) {
        
        if (alertView.tag==10) {
            NSString * session = [PersistenceManager getLoginSession];
            [UserConnector deleteUserPhoto:session userPhotoId:[NSNumber numberWithInteger:self.TapImageView.tag] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                
                if (!error) {
                    
                    SBJsonParser * parser = [[SBJsonParser alloc]init];
                    NSDictionary * json = [parser objectWithData:data];
                    int status = [json[@"status"] intValue];
                    if (status==0) {
                        
                        [self UseMessageNetWorking];
                        
                    }else if (status==1){

                    }else{

                    }
                }
            }];
            
        }else{
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
                ipc.allowsEditing = YES;
                ipc.showsCameraControls  = YES;
                [self presentViewController:ipc animated:YES completion:nil];
                
            }else{
                
            }
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

#pragma mark 图片上传
-(void)passImage:(UIImage *)image{
    
    MBProgressHUD*HUDImage = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUDImage.delegate = self;
    HUDImage.labelText = @"正在上传";
    HUDImage.dimBackground = NO;
    
    NSData *data = UIImagePNGRepresentation(image);
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:data];
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    [manager uploadWithFile:data policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        if (completed) {
            
            NSString *headUrl;
            if (isTest){
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }else{
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }
            /**
             
             
             上传照片
             
             
             */
            NSString * session = [PersistenceManager getLoginSession];
            
            [UserConnector updateUserPhoto:session url:headUrl index:[NSNumber numberWithInteger:self.TapImageView.tag] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    SBJsonParser * parser = [[SBJsonParser alloc]init];
                    NSDictionary * json = [parser objectWithData:data];
                    NSLog(@"%@",json);
                    self.TapImageView.image = image;
                    self.TapImageView.contentMode = UIViewContentModeScaleAspectFill;
                    [self UseMessageNetWorking];
                    [HUDImage hide:YES afterDelay:0.5];

                }
            }];
            
        }else {
            [HUDImage hide:YES afterDelay:0];
            [ShowMessage showMessage:@"头像上传失败"];
        }
        
    }];
}
- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
    NSString * bucket = [setting getImgBuketName];
    NSString * secret = [setting getSecret];
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *time = [NSString stringWithFormat:@"%lld",recordTime];
    NSString *strNumber = [RandNumber getRandNumberString];
    NSString *headUrl = [NSString stringWithFormat:@"%@_%@.jpeg",time,strNumber];
    [mutableDic setObject:headUrl forKey:@"path"];//设置保存路径
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


@end
