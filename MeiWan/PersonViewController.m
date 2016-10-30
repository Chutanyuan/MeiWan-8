//
//  PersonViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonViewController.h"
#import "MeiWan-Swift.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"
#import "setting.h"
#import "RandNumber.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "creatAlbum.h"
#import "MJRefresh.h"
#import "AFNetworking/AFNetworking.h"
#import "UMSocial.h"

#import "LoginViewController.h"
#import "EditPersonalMessageVC.h"
#import "personEditViewController.h"
#import "FansViewController.h"
#import "FocusViewController.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)NSArray * cellTitleArray;
@property(nonatomic,strong)NSDictionary * userMessage;
@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign) UIImage * shareImage;
@property(nonatomic,strong)UIView * showView;
@property(nonatomic,strong)UIView * showAlphaView;


@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人";
    
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#5EC8F5"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];

    self.userMessage = [PersistenceManager getLoginUser];
    [self loadUserData];
    self.cellTitleArray =@[
                           @{@"title":@"我要出售时间",@"image":@"chushou"},
                           @{@"title":@"我的钱包",@"image":@"qianbao"},
                           @{@"title":@"记录中心",@"image":@"jilu"},
                           @{@"title":@"公会管理",@"image":@"gonghui"},
                           @{@"title":@"设置",@"image":@"shezhi"},
                           @{@"title":@"分享",@"image":@"fenxinag2"}
                           ];
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    self.tableview = tableview;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * view = [self headeView];
    tableview.tableHeaderView = view;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableview.mj_header beginRefreshing];
        self.userMessage = nil;
        [self loadUserData];
        [self headerImageCherk];
    }];
    [self.view addSubview:tableview];
    [self headerImageCherk];

    
    // Do any additional setup after loading the view.
}
#pragma mark----头像检查
- (void)headerImageCherk
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userMessage[@"headUrl"]]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"http://api.cn.faceplusplus.com/detection/detect?api_key=c18c7df55febcf39feeb52681d40d9a3&api_secret=2QlutmPkapTPUTIPjINh5UaVC4Ex8SSU&url=%@",url] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * json = [parser objectWithData:responseObject];
        NSLog(@"%@",json);
        
        NSArray * face = json[@"face"];
        if (face.count>0) {
            
        }else{
            [self ZDYshowAlertView:@"注意！请上传一张本人可看清脸的真实头像。"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        NSLog(@"---");
    }];

}
- (void)loadUserData{
    //获得个人信息，更新界面
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector getLoginedUser:sesstion receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (error) {
            
            [ShowMessage showMessage:@"服务器未响应"];
            
        }else{
            
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            
            NSMutableDictionary *json = [parser objectWithData:data];
            
            int status = [[json objectForKey:@"status"]intValue];
            
            if (status == 0) {

                [PersistenceManager setLoginUser:json[@"entity"]];
                self.userMessage = json[@"entity"];
                [self.tableview.mj_header endRefreshing];
                [self.tableview reloadData];

            }else if (status == 1){
                
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];

            }
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, dtScreenWidth-10, 1)];
//        label.backgroundColor = [UIColor grayColor];
//        [cell.contentView addSubview:label];
        UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-35, cell.frame.size.height/2-7.5, 15, 15)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [cell.contentView addSubview:jiantou];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_cellTitleArray[indexPath.row][@"image"]]];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",_cellTitleArray[indexPath.row][@"title"]];
    if([self.userMessage[@"isAudit"] intValue] == 0){
        
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text = @"设置专属标签";
        }
    }
    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitleArray.count;
}
-(UIView *)headeView
{
    UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 170)];
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:view.frame];
    imageview.image = [UIImage imageNamed:@"beijin"];
    [view addSubview:imageview];

    UIImageView * headerBord = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 90, 100)];
    headerBord.image = [UIImage imageNamed:@"zhuangshi"];
    [view addSubview:headerBord];
    UIImageView * headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 17, 86, 86)];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",self.userMessage[@"headUrl"]]]];
    headerImage.layer.cornerRadius = 43;
    headerImage.clipsToBounds = YES;
    headerImage.userInteractionEnabled =  YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerimageTapGesture:)];
    [headerImage addGestureRecognizer:tapGesture];
    self.headerImage = headerImage;
    [view addSubview:headerImage];
    
    UIImageView * bianji = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-10-20, 50, 20, 20)];
    bianji.image = [UIImage imageNamed:@"bianji"];
    UITapGestureRecognizer * tapGestureBianji = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EditUserMessage:)];
    bianji.userInteractionEnabled = YES;
    [bianji addGestureRecognizer:tapGestureBianji];

    [view addSubview:bianji];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, dtScreenWidth, 40)];
    bottomView.backgroundColor = [CorlorTransform colorWithHexString:@"418fc0"];
    bottomView.alpha = 0.4;
    [view addSubview:bottomView];
    
    for (int i = 0; i<3; i++) {
        UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake((dtScreenWidth/6-12)+i*(dtScreenWidth/3), 138, 24, 24)];
        if (i==0) {
            threeImage.image = [UIImage imageNamed:@"dongtai"];
        }else if (i==1){
            threeImage.image = [UIImage imageNamed:@"fensi"];
        }else{
            threeImage.image = [UIImage imageNamed:@"guanzhu"];
        }
        [view addSubview:threeImage];
        
        UILabel * threeNumber = [[UILabel alloc]initWithFrame:CGRectMake((dtScreenWidth/6+17)+i*(dtScreenWidth/3), 138, 24, 24)];
        threeNumber.font = [FontOutSystem fontWithFangZhengSize:15.0];
        
        if (i==0) {
            
            threeNumber.text = [NSString stringWithFormat:@"%@",self.userMessage[@"stateCount"]];
            NSLog(@"************************************************%@",self.userMessage[@"stateCount"]);

        }else if (i==1){
            threeNumber.text = [NSString stringWithFormat:@"%@",self.userMessage[@"watchCount"]];
            NSLog(@"************************************************%@",self.userMessage[@"stateCount"]);

        }else{
            threeNumber.text = [NSString stringWithFormat:@"%@",self.userMessage[@"followCount"]];
            NSLog(@"************************************************%@",self.userMessage[@"stateCount"]);

        }
        
        threeNumber.textColor = [UIColor whiteColor];
        [view addSubview:threeNumber];
        
        threeImage.userInteractionEnabled = YES;
        threeImage.tag = i;
        UITapGestureRecognizer * tapGestureThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(threeImageTapGestuer:)];
        [threeImage addGestureRecognizer:tapGestureThree];
    }
    
    UILabel * nickname = [[UILabel alloc]init];
    nickname.text = self.userMessage[@"nickname"];
    nickname.font = [FontOutSystem fontWithFangZhengSize:15.0];
    nickname.textColor = [UIColor whiteColor];
    CGSize size_nickname = [nickname.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nickname.font,NSFontAttributeName, nil]];
    nickname.frame = CGRectMake(headerImage.frame.origin.x+headerImage.frame.size.width+10, headerImage.center.y, size_nickname.width, size_nickname.height);
    [view addSubview:nickname];
    
    UILabel * age = [[UILabel alloc]init];
    age.font = [FontOutSystem fontWithFangZhengSize:12.0];
    age.textColor = [UIColor grayColor];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int userage = yearnow - [self.userMessage[@"year"] doubleValue];
    NSString *userAge = [NSString stringWithFormat:@"%d",userage];
    
    age.text = userAge;
    CGSize size_age = [age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:age.font,NSFontAttributeName, nil]];
    age.frame = CGRectMake(nickname.frame.size.width+nickname.frame.origin.x+10, nickname.center.y-size_age.height/2, size_age.width, size_age.height);
    
    [view addSubview:age];
    
    UIImageView * sexImage = [[UIImageView alloc]init];
    if ([self.userMessage[@"sex"] isEqualToString:@"男"]) {
        sexImage.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        sexImage.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    sexImage.frame = CGRectMake(age.center.x+age.frame.size.width, age.center.y-6, 12, 12);
    [view addSubview: sexImage];
    
    UILabel * qianming = [[UILabel alloc]initWithFrame:CGRectMake(nickname.frame.origin.x, nickname.frame.size.height+nickname.frame.origin.y+10, dtScreenWidth-nickname.frame.origin.x-40, 14)];
    qianming.font = [FontOutSystem fontWithFangZhengSize:14.0];
    qianming.text = self.userMessage[@"description"];
    qianming.textColor = [UIColor whiteColor];
    [view addSubview: qianming];
    
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        if([self.userMessage[@"isAudit"] intValue] == 0){

            [self ZDYshowAlertView:@"只要你够'亮'，只要你够'帅'，就可以通过美玩达人申请，获得属于自己的专属标签，打发自己无聊的闲暇时间，还在等什么，赶快申请，让自己与Ta人与众不同吧!"];
        }else{
            [self performSegueWithIdentifier:@"setting" sender:self.userMessage];
        }

    }else if (indexPath.row==1){
        [self performSegueWithIdentifier:@"walllet" sender:nil];
    }else if (indexPath.row==2){
        [self performSegueWithIdentifier:@"invite" sender:nil];
    }else if (indexPath.row==3){
        [self performSegueWithIdentifier:@"gonghuiguanli" sender:nil];
        
    }else if (indexPath.row==4){
        /** 设置 */
        personEditViewController * personal = [[personEditViewController alloc]init];
        personal.hidesBottomBarWhenPushed = YES;
        personal.title = @"个人设置";
        [self.navigationController pushViewController:personal animated:YES];
    
    }else{
        [self showMessageAlert:@"分享" image:self.headerImage.image];
    }

}
#pragma mark----用户头像被点击
-(void)headerimageTapGesture:(UITapGestureRecognizer *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
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
        
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
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
    HUDImage.dimBackground = YES;
    
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
            //[ShowMessage showMessage:@"头像上传成功"];
            NSString *headUrl;
            if (isTest){
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }else{
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:headUrl,@"headUrl", nil];
            NSString *session = [PersistenceManager getLoginSession];
            [UserConnector update:session parameters:userInfoDic receiver:^(NSData *data, NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser*parser=[[SBJsonParser alloc]init];
                    NSMutableDictionary *json=[parser objectWithData:data];
                    //NSLog(@"%@",json);
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        [HUDImage hide:YES afterDelay:0];
                        self.headerImage.image = image;
                        [ShowMessage showMessage:@"头像上传成功"];
                        self.userMessage = [json objectForKey:@"entity"];
                        [PersistenceManager setLoginUser:self.userMessage];
                        [self.tableview reloadData];
                    }else if(status == 1){
                        [PersistenceManager setLoginSession:@""];
                        
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];
                    }
                }
            }];
            
            //NSLog(@"%@",result);
        }else {
            [HUDImage hide:YES afterDelay:0];
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
#pragma mark----分享到朋友圈
- (void)showMessageAlert:(NSString *)message image:(UIImage *)image
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"保存到相册(头像)" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.shareImage = image;
        
        [creatAlbum createAlbumSaveImage:image];
    }];
    
    
    NSString * URLString = [NSString stringWithFormat:@"http://web.chuangjk.com:8083/promoter/sing.html?userId=%@",self.userMessage[@"id"]];
    NSString * contentext = @"一首歌告诉我你对我的感觉";
    NSString * titleString = @"貌美如花也能赚钱养家";
    
    UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享到微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = URLString;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@。你选歌词，我给你唱",contentext] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];
    
    UIAlertAction * share2Action = [UIAlertAction actionWithTitle:@"分享到微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = contentext;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = URLString;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@。你选歌词，我给你唱",contentext] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }];
    
    UIAlertAction * share3Action = [UIAlertAction actionWithTitle:@"分享到QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.qqData.title = titleString;
        [UMSocialData defaultData].extConfig.qqData.url = URLString;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"%@。你选歌词，我给你唱",contentext] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];
    /***/
    UIAlertAction * share4Action = [UIAlertAction actionWithTitle:@"分享到QQ空间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.qzoneData.title = contentext;
        [UMSocialData defaultData].extConfig.qzoneData.url = URLString;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"你选歌词，我给你唱" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [alertController addAction:shareAction];
    [alertController addAction:share2Action];
    [alertController addAction:share3Action];
    [alertController addAction:share4Action];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark----动态、关注、粉丝 👍点击

-(void)threeImageTapGestuer:(UITapGestureRecognizer *)sender
{
    UIImageView * imageview = (UIImageView *)[sender view];
    if (imageview.tag==0) {
        [self performSegueWithIdentifier:@"dongtai" sender:self.userMessage];
    }else if (imageview.tag==1){
        [self performSegueWithIdentifier:@"fans" sender:self.userMessage];
    }else if (imageview.tag==2){
        [self performSegueWithIdentifier:@"focus" sender:self.userMessage];
    }
}

#pragma mark----编辑图标点击
- (void)EditUserMessage:(UITapGestureRecognizer *)sender
{
    EditPersonalMessageVC * personal = [[EditPersonalMessageVC alloc]init];
    personal.title = @"个人编辑";
    personal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personal animated:YES];
}
#pragma mark----zhanshi
-(void)ZDYshowAlertView:(NSString *)message
{
    UIView * alphaview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight)];
    alphaview.backgroundColor = [UIColor blackColor];
    alphaview.alpha = 0.2;
    [self.view addSubview:alphaview];
    self.showAlphaView = alphaview;
    UIView * view = [[UIView alloc]init];
    view.center = CGPointMake(dtScreenWidth/2, dtScreenHeight/2);
    view.bounds = CGRectMake(0, 0, dtScreenWidth-80, 200);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    view.layer.borderColor = [CorlorTransform colorWithHexString:@"#e8e8e8"].CGColor;
    view.layer.borderWidth = 0.5;
    [self.view addSubview:view];
    self.showView = view;
    
    UILabel * titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
    titlelabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    titlelabel.text = @"温馨提示";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titlelabel];
    
    UILabel * contentText = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, view.frame.size.width, view.frame.size.height-44-40)];
    contentText.textAlignment = NSTextAlignmentCenter;
    contentText.numberOfLines = 0;
    contentText.text = message;
    contentText.backgroundColor = [CorlorTransform colorWithHexString:@"#e8e8e8"];
    contentText.font = [FontOutSystem fontWithFangZhengSize:15.0];
    [view addSubview:contentText];
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0,view.frame.size.height-44, view.frame.size.width/2, 44);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[CorlorTransform colorWithHexString:@"#b2b2b2"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitleColor:[CorlorTransform colorWithHexString:@"#78cdf8"] forState:UIControlStateNormal];
    sure.frame = CGRectMake(view.frame.size.width/2, view.frame.size.height-44, view.frame.size.width/2, 44);
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setBackgroundImage:[UIImage imageNamed:@"OK"] forState:UIControlStateHighlighted];
    if (message.length>70) {
        sure.tag = 100;
    }else{
        sure.tag = 0;
    }
    [sure addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sure];

}
- (void)sureButton:(UIButton *)sender
{
    self.showAlphaView.alpha = 0;
    self.showView.alpha = 0;
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (sender.tag==100) {
            [self performSegueWithIdentifier:@"askfor" sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"fans"]) {
        FansViewController *flv = segue.destinationViewController;
        flv.hidesBottomBarWhenPushed = YES;
    }
    if ([segue.identifier isEqualToString:@"focus"]) {
        FocusViewController *fov = segue.destinationViewController;
        fov.hidesBottomBarWhenPushed = YES;
    }
}


@end
