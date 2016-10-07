//
//  UserInfoViewController.m
//  MeiWan
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "UserAssessTableViewCell.h"
#import "PlagerinfoViewController.h"
#import "UserInfoTableViewCell.h"

#import "MJRefresh.h"
#import "UserInfo.h"
#import "CWStarRateView.h"
#import "Meiwan-Swift.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "RandNumber.h"
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "CorlorTransform.h"
#import "SDWebImage/SDImageCache.h"
#import "userEditCell.h"
#import "editdescription.h"
#import "editOwnMessage.h"
#import "emotionalState.h"
#import "JobChooseViewController.h"
#import "ChangeImageController.h"
#import "schoolChooseVC.h"
#import "insterestChooseVC.h"
#import "bookChooseVC.h"
#import "movieChooseVC.h"
#import "musicChooseVC.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    userEditCell * cell;
    UITableView * tableview;
    NSInteger tagIndex;
    
}
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UIView *userInfoHeadView;
@property (nonatomic, strong)UIImageView *userInfoHead;
@property (nonatomic, strong)UserInfo *userinfo;
@property (nonatomic, strong) NSDictionary *userInfoData;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sigen;
@property (nonatomic,strong)NSDictionary *playerInfo;
@property (nonatomic,strong)NSArray * titleone;
@property (nonatomic,strong)NSArray * titletwo;
@property (nonatomic,strong)NSArray * titlethree;

@property (nonatomic,strong)NSArray * contentone;
@property (nonatomic,strong)NSArray * contenttwo;
@property (nonatomic,strong)NSArray * contentthree;

/** 省 */
@property (nonatomic,strong)NSString *state;
/** 市 */
@property (nonatomic,strong)NSString *city;
/** 区 */
@property (nonatomic,strong)NSString *subLocality;
/** 街道 */
@property (nonatomic,strong)NSString *street;

@property (nonatomic,strong)NSString * IMAGE;

@property (nonatomic,strong)UIImageView * headerImageView;


@property (nonatomic,strong)UIImageView * touchesImageView;

@property (nonatomic,copy)NSString * headerimageTag;

@end

@implementation UserInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.userInfoDic = [PersistenceManager getLoginUser];
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:self.userInfoDic[@"id"] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            if ([json[@"status"] intValue]==0) {
                self.userInfoDic = json[@"entity"];
            }
        }
    }];
    
}
- (void)viewDidLoad
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    _titleone = @[@"用户名",@"年龄",@"个人签名",@"情感状态",@"职业",@"学校",@"兴趣爱好"];
    _titletwo = @[@"所在地",@"工作地点",@"游荡地"];
    _titlethree = @[@"书籍",@"电影",@"音乐"];
    [self initializeLocationService];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveNickname:) name:@"finish_nickname" object:nil];
        
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)changeImage
{
    ChangeImageController * changeImage = [[ChangeImageController alloc]init];
    changeImage.title = @"更改背景";
    [self.navigationController pushViewController:changeImage animated:YES];

}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 请求访问使用地理位置
    [_locationManager requestWhenInUseAuthorization];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //取出当前位置的坐标
    static int i = 0;
    i++;

    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:locations.lastObject.coordinate.latitude longitude:locations.lastObject.coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            self.state = state;
            NSString *city=[addressDic objectForKey:@"City"];

            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];

            NSString *street=[addressDic objectForKey:@"Street"];
            self.street = street;

            NSString * session = [PersistenceManager getLoginSession];
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:city,@"location",subLocality,@"jobLocation", nil];
            [UserConnector update:session parameters:userInfoDic receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    SBJsonParser * parser = [[SBJsonParser alloc]init];
                    NSDictionary * json = [parser objectWithData:data];
                    int status = [json[@"status"] intValue];
                    if (status==0) {
                        [PersistenceManager setLoginUser:json[@"entity"]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_nickname" object:nil];
                    }
                }
            }];

        }
        
    }];

    [manager stopUpdatingLocation];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[userEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    if (indexPath.section==0) {
        cell.textLabel.text = _titleone[indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                if ([self.userInfoDic[@"nickname"] isEqualToString:@""]) {
                    
                }else{
                    cell.showMessage.text = self.userInfoDic[@"nickname"];
                }
            }
                break;
            case 1:
            {
                NSDate *today = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy";
                NSString *year = [formatter stringFromDate:today];
                int yearnow = year.intValue;
                int age = yearnow - [self.userInfoDic[@"year"] intValue];
                NSString *userAge = [NSString stringWithFormat:@"%d",age];
                cell.showMessage.text = [NSString stringWithFormat:@"%@ 岁",userAge];
            }
                break;
                
            case 2:
            {
                if ([self.userInfoDic[@"description"] isEqualToString:@""]) {
                    
                }else{
                    cell.showMessage.text = self.userInfoDic[@"description"];
                }
            }
                break;
                
            case 3:
            {
                /** 情感状态 */
                cell.showMessage.text = self.userInfoDic[@"love"];
            }
                break;
                
            case 4:
            {
                /** 职业 */
                if ([self.userInfoDic[@"job"] isEqualToString:@""]) {
                  cell.showMessage.text = @"未设置";
                }else{
                  cell.showMessage.text = self.userInfoDic[@"job"];
                }
                
            }
                break;
                
            case 5:
            {
                /** 学校 */
                if ([self.userInfoDic[@"school"] isEqualToString:@""]) {
                    cell.showMessage.text = @"未设置";
                }else{
                    cell.showMessage.text = self.userInfoDic[@"school"];
                }
            }
                break;
                
            case 6:
            {
                /** 兴趣爱好 */
                if ([self.userInfoDic[@"interest"] isEqualToString:@""]) {
                    cell.showMessage.text = @"未设置";
                }else{
                    cell.showMessage.text = self.userInfoDic[@"interest"];
                }
            }
                break;
                
            default:
                break;
        }

        cell.showMessage.textColor = [UIColor grayColor];
        
    }else if (indexPath.section==1){
        cell.textLabel.text = _titletwo[indexPath.row];
        cell.showMessage.textColor = [UIColor blackColor];

        if (indexPath.row==0) {
            if ([self.userInfoDic[@"location"] isEqualToString:@""]) {
                cell.showMessage.text = @"未设置";
            }else{
                cell.showMessage.text = self.userInfoDic[@"location"];
            }
        }else if (indexPath.row == 1){
            if ([self.userInfoDic[@"jobLocation"] isEqualToString:@""]) {
                cell.showMessage.text = @"未设置";
            }else{
                cell.showMessage.text = self.userInfoDic[@"jobLocation"];
            }
        }else{
            cell.showMessage.text = self.street;
        }
   
    }else if (indexPath.section==2){
        cell.textLabel.text = _titlethree[indexPath.row];
        if (indexPath.row==0) {
            if ([self.userInfoDic[@"book"] isEqualToString:@""]) {
                cell.showMessage.text = @"未设置";
            }else{
                cell.showMessage.text = self.userInfoDic[@"book"];
            }
        }else if (indexPath.row==1){
            if ([self.userInfoDic[@"movie"] isEqualToString:@""]) {
                cell.showMessage.text = @"未设置";
            }else{
                cell.showMessage.text = self.userInfoDic[@"movie"];
            }
        }else{
            if ([self.userInfoDic[@"music"] isEqualToString:@""]) {
                cell.showMessage.text = @"未设置";
            }else{
                cell.showMessage.text = self.userInfoDic[@"music"];
            }
        }
        cell.showMessage.textColor = [UIColor grayColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}




#pragma mark 表的行数头高，行高

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 7;
    }else{
        return 3;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 200;
    }else{
        return 0.1;
    }
}

#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            editOwnMessage * editVC = [[editOwnMessage alloc]init];
            editVC.title = @"编辑昵称";
            [self.navigationController pushViewController:editVC animated:YES];
        }else if (indexPath.row==2){
            editdescription * description = [[editdescription alloc]init];
            description.title = @"编辑签名";
            [self.navigationController pushViewController:description animated:YES];
        }else if (indexPath.row==3){
            emotionalState * emotional = [[emotionalState alloc]init];
            emotional.title = @"情感状态";
            [self.navigationController pushViewController:emotional animated:YES];
        }else if (indexPath.row==4){
            JobChooseViewController * jobChoose = [[JobChooseViewController alloc]init];
            jobChoose.title = @"职业";
            [self.navigationController pushViewController:jobChoose animated:YES];
        }else if (indexPath.row==5){
//            schoolChooseVC * schoolVC = [[schoolChooseVC alloc]init];
//            schoolVC.title = @"学校";
//            [self.navigationController pushViewController:schoolVC animated:YES];
        }else if (indexPath.row==6){
            insterestChooseVC * insterest = [[ insterestChooseVC alloc]init];
            insterest.title = @"兴趣爱好";
            [self.navigationController pushViewController:insterest animated:YES];

        }
        
    }else if (indexPath.section==1){
        
        if (indexPath.row==0) {
            
        }else if (indexPath.row==1){
            
        }else{
            
        }

    }else{
        
        if (indexPath.row==0) {
            bookChooseVC * book  = [[bookChooseVC alloc]init];
            book.title = @"书籍";
            [self.navigationController pushViewController:book animated:YES];
            
        }else if (indexPath.row==1){
            movieChooseVC * movie = [[movieChooseVC alloc]init];
            movie.title = @"电影";
            [self.navigationController pushViewController:movie animated:YES];
            
        }else{
            musicChooseVC * music = [[musicChooseVC alloc]init];
            music.title = @"音乐";
            [self.navigationController pushViewController:music animated:YES];
        }
        
    }
}
- (void)finishSaveNickname:(NSNotification *)text
{
    [tableview reloadData];
}

#pragma mark headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
/**第一个*/
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 200-((dtScreenWidth-80)/2)-20, (dtScreenWidth-80)/4, (dtScreenWidth-80)/4)];
        imageview.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview.userInteractionEnabled = YES;
        imageview.tag = 0;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview addGestureRecognizer:tapGesture];
/**第二个*/
        UIImageView * imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview.frame.origin.x+imageview.frame.size.width+20, imageview.frame.origin.y, imageview.frame.size.width, imageview.frame.size.height)];
        imageview1.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview1.userInteractionEnabled = YES;
        imageview1.tag = 1;
        UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview1 addGestureRecognizer:tapGesture1];
/**第三个*/
        UIImageView * imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview1.frame.origin.x+imageview1.frame.size.width+20, imageview1.frame.origin.y, imageview1.frame.size.width, imageview1.frame.size.height)];
        imageview2.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview2.userInteractionEnabled = YES;
        imageview2.tag = 2;
        UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview2 addGestureRecognizer:tapGesture2];
/**第四个*/
        UIImageView * imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview2.frame.origin.x+imageview2.frame.size.width+20, imageview2.frame.origin.y, imageview2.frame.size.width, imageview2.frame.size.height)];
        imageview3.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview3.userInteractionEnabled = YES;
        imageview3.tag = 3;
        UITapGestureRecognizer * tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview3 addGestureRecognizer:tapGesture3];
/**第五个*/
        UIImageView * imageview4 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y+imageview.frame.size.height+15, imageview.frame.size.width, imageview.frame.size.height)];
        imageview4.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview4.userInteractionEnabled = YES;
        imageview4.tag = 4;
        UITapGestureRecognizer * tapGesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview4 addGestureRecognizer:tapGesture4];
/**第六个*/
        UIImageView * imageview5 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview4.frame.origin.x+imageview4.frame.size.width+20, imageview4.frame.origin.y, imageview4.frame.size.width, imageview4.frame.size.height)];
        imageview5.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview5.userInteractionEnabled = YES;
        imageview5.tag = 5;
        UITapGestureRecognizer * tapGesture5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview5 addGestureRecognizer:tapGesture5];
/**第七个*/
        UIImageView * imageview6 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview5.frame.origin.x+imageview5.frame.size.width+20, imageview5.frame.origin.y, imageview5.frame.size.width, imageview5.frame.size.height)];
        imageview6.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview6.userInteractionEnabled = YES;
        imageview6.tag = 6;
        UITapGestureRecognizer * tapGesture6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview6 addGestureRecognizer:tapGesture6];
/**第八个*/
        UIImageView * imageview7 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview6.frame.origin.x+imageview6.frame.size.width+20, imageview6.frame.origin.y, imageview6.frame.size.width, imageview6.frame.size.height)];
        imageview7.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview7.userInteractionEnabled = YES;
        imageview7.tag = 7;
        UITapGestureRecognizer * tapGesture7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview7 addGestureRecognizer:tapGesture7];

        NSString * session = [PersistenceManager getLoginSession];
        [UserConnector findMyPhotoes:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                SBJsonParser * parser = [[SBJsonParser alloc]init];
                NSDictionary * json = [parser objectWithData:data];
                NSArray * photosArray = json[@"entity"];
                [photosArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj[@"index"] intValue]==0) {
                        [imageview sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==1) {
                        [imageview1 sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==2) {
                        [imageview2 sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==3) {
                        [imageview3 sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==4) {
                        [imageview4 sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==5) {
                        [imageview5 sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==6) {
                        [imageview6 sd_setImageWithURL:obj[@"url"]];
                    }
                    if ([obj[@"index"] intValue]==7) {
                        [imageview7 sd_setImageWithURL:obj[@"url"]];
                    }
                    
                }];
                if (photosArray.count==0) {
                    imageview1.hidden = YES;
                    imageview2.hidden = YES;
                    imageview3.hidden = YES;
                    imageview4.hidden = YES;
                    imageview5.hidden = YES;
                    imageview6.hidden = YES;
                    imageview7.hidden = YES;
                }else if (photosArray.count==1){
                    imageview1.hidden = NO;
                    imageview2.hidden = YES;
                    imageview3.hidden = YES;
                    imageview4.hidden = YES;
                    imageview5.hidden = YES;
                    imageview6.hidden = YES;
                    imageview7.hidden = YES;
                }else if (photosArray.count==2){
                    imageview1.hidden = NO;
                    imageview2.hidden = NO;
                    imageview3.hidden = YES;
                    imageview4.hidden = YES;
                    imageview5.hidden = YES;
                    imageview6.hidden = YES;
                    imageview7.hidden = YES;
                }else if (photosArray.count==3){
                    imageview1.hidden = NO;
                    imageview2.hidden = NO;
                    imageview3.hidden = NO;
                    imageview4.hidden = YES;
                    imageview5.hidden = YES;
                    imageview6.hidden = YES;
                    imageview7.hidden = YES;
                }else if (photosArray.count==4){
                    imageview1.hidden = NO;
                    imageview2.hidden = NO;
                    imageview3.hidden = NO;
                    imageview4.hidden = NO;
                    imageview5.hidden = YES;
                    imageview6.hidden = YES;
                    imageview7.hidden = YES;
                }else if (photosArray.count==5){
                    imageview1.hidden = NO;
                    imageview2.hidden = NO;
                    imageview3.hidden = NO;
                    imageview4.hidden = NO;
                    imageview5.hidden = NO;
                    imageview6.hidden = YES;
                    imageview7.hidden = YES;
                }else if (photosArray.count==6){
                    imageview1.hidden = NO;
                    imageview2.hidden = NO;
                    imageview3.hidden = NO;
                    imageview4.hidden = NO;
                    imageview5.hidden = NO;
                    imageview6.hidden = NO;
                    imageview7.hidden = YES;
                }else if (photosArray.count==7){
                    imageview1.hidden = NO;
                    imageview2.hidden = NO;
                    imageview3.hidden = NO;
                    imageview4.hidden = NO;
                    imageview5.hidden = NO;
                    imageview6.hidden = NO;
                    imageview7.hidden = NO;
                }
            }
        }];
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:aView.frame];
        self.headerImageView.image = [UIImage imageNamed:@"img_setting0"];
        [aView addSubview:self.headerImageView];
        
        imageview.layer.cornerRadius = 5;
        imageview.clipsToBounds = YES;
        
        imageview1.layer.cornerRadius = 5;
        imageview1.clipsToBounds = YES;
        
        imageview2.layer.cornerRadius = 5;
        imageview2.clipsToBounds = YES;
        
        imageview3.layer.cornerRadius = 5;
        imageview3.clipsToBounds = YES;
        
        imageview4.layer.cornerRadius = 5;
        imageview4.clipsToBounds = YES;
        
        imageview5.layer.cornerRadius = 5;
        imageview5.clipsToBounds = YES;
        
        imageview6.layer.cornerRadius = 5;
        imageview6.clipsToBounds = YES;
        
        imageview7.layer.cornerRadius = 5;
        imageview7.clipsToBounds = YES;
        
        
        [aView addSubview:imageview];
        [aView addSubview:imageview1];
        [aView addSubview:imageview2];
        [aView addSubview:imageview3];
        [aView addSubview:imageview4];
        [aView addSubview:imageview5];
        [aView addSubview:imageview6];
        [aView addSubview:imageview7];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200-((dtScreenWidth-80)/2)-20-30, dtScreenWidth, 30)];
        
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"ID:%@",self.userInfoDic[@"id"]];
        [aView addSubview:label];

        
        return aView;
        
    }else{
        return nil;
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = self.headerImageView.frame;

        rect.origin.y = offset.y;
        rect.size.height = 200 - offset.y;
        rect.size.width = dtScreenWidth-offset.y/3;
        self.headerImageView.frame = rect;
    }
    
}
- (void)addPhoto:(UITapGestureRecognizer *)gesture
{
    self.touchesImageView = (UIImageView *)[gesture view];
    tagIndex = self.touchesImageView.tag;
    /***
     标记 判断是否有图片 有图片时提示的信息不一样
     */
    if (self.touchesImageView.sd_imageURL==nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
        alert.tag=11;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"替换", nil];
        alert.tag=10;
        self.headerimageTag = [NSString stringWithFormat:@"%ld",self.touchesImageView.tag];
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
                [UserConnector findMyPhotoes:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            
                    if (!error) {
                        SBJsonParser * parser = [[SBJsonParser alloc]init];
                        NSDictionary * json = [parser objectWithData:data];
                        [json[@"entity"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            if ([self.headerimageTag integerValue]==idx) {
                                [UserConnector deleteUserPhoto:session userPhotoId:obj[@"id"] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                                    if (!error) {
                                        SBJsonParser * parser = [[SBJsonParser alloc]init];
                                        NSDictionary * json = [parser objectWithData:data];
                                        int status = [json[@"status"] intValue];
                                        if (status==0) {
                                            [tableview reloadData];
                                        }else if (status==1){
            
                                        }else{
                                            
                                        }
                                    }
                                }];
                            }
                        }];
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
            
            [UserConnector updateUserPhoto:session url:headUrl index:[NSNumber numberWithInteger:self.touchesImageView.tag] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    SBJsonParser * parser = [[SBJsonParser alloc]init];
                    NSDictionary * json = [parser objectWithData:data];
                    self.touchesImageView.image = image;
                    [HUDImage hide:YES afterDelay:0.5];
                    [tableview reloadData];
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
