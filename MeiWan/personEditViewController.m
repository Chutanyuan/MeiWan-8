//
//  personEditViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "personEditViewController.h"
#import "MeiWan-Swift.h"
#import "LoginViewController.h"
#import "UIView2.h"
#import "UIView3.h"
#import "FindPassWordViewController.h"


@interface personEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIView2Delegate>

@property(nonatomic,strong)UITableView * tableview;

@property(nonatomic,strong)UIView2 * view2;
@property(nonatomic,strong)UIView3 * view3;

@property(nonatomic,strong)NSString * filesize;


@end

@implementation personEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [CorlorTransform colorWithHexString:@"#F7F7F7"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
    UIView2 * view2 = [[UIView2 alloc]initWithFrame:CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight)];
    view2.backgroundColor = [CorlorTransform colorWithHexString:@"78cdf8"];
    view2.delegate = self;
    [self.view addSubview:view2];
    
    UIView3 * view3 = [[UIView3 alloc]initWithFrame:CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight)];
    view3.backgroundColor = [CorlorTransform colorWithHexString:@"78cdf8"];
    [self.view addSubview:view3];
    
    self.view3 = view3;
    self.view2 = view2;
    
    self.filesize = [NSString stringWithFormat : @"%.2fM" , [ self filePath ]];

}

- ( void )clearFile

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject :nil waitUntilDone : YES ];
    
}

- ( void )clearCachSuccess

{
    
    UIAlertController * alertviewcon = [UIAlertController alertControllerWithTitle:@"提示" message:@"缓存清理完毕" preferredStyle:UIAlertControllerStyleAlert];
    [alertviewcon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    [self presentViewController:alertviewcon animated:YES completion:nil];
    self.filesize = [NSString stringWithFormat : @"(%.2fM)" , [ self filePath ]];
}



//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
        
    }
    
    return 0 ;
    
}

//2: 遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

// 显示缓存大小

- ( float )filePath

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(dtScreenWidth/2, 0, dtScreenWidth/2-40, 44)];
    rightlabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    rightlabel.textAlignment = NSTextAlignmentRight;
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-35, cell.frame.size.height/2-7.5, 15, 15)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [cell.contentView addSubview:jiantou];
    
        if (indexPath.section==2) {
            [cell.contentView addSubview:rightlabel];
        }
        cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    }
    if (indexPath.section==0) {
        cell.textLabel.text = @"更改密码";
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.textLabel.text = @"产品反馈";
        }else{
            cell.textLabel.text = @"关于我们";
        }
    }else{
        cell.textLabel.text = @"清除缓存";
        rightlabel.text = [NSString stringWithFormat:@"%@",self.filesize];
    }
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [CorlorTransform colorWithHexString:@"78cdf8"];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 60)];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, 10, dtScreenWidth-80, 40);
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[CorlorTransform colorWithHexString:@"#75D1FA"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
        
        return footView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 60;
    }else{
        return 0.1;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section==0) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FindPassWordViewController *personvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"changeUserPassWord"];
        [self.navigationController pushViewController:personvc animated:YES];
        
        
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationItem.title = @"产品反馈";
                self.view2.frame = CGRectMake(100, 0, dtScreenWidth-100, dtScreenHeight);
                self.view3.frame = CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight);
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveUpdata)];

            }];

        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationItem.title = @"关于我们";
                self.view3.frame = CGRectMake(100, 0, dtScreenWidth-100, dtScreenHeight);
                self.view2.frame = CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight);
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitBar)];

            }];

        }
    }else{
       
        [self clearFile];

    }
    
    
}
- (void)saveUpdata
{
    /** 提交意见 */
    [UIView animateWithDuration:0.3 animations:^{
        [self.view2.textview endEditing:YES];
        self.navigationItem.title = @"个人设置";
        self.view2.frame = CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight);
        
        
    }];
}
- (void)exitBar
{
    /** 退出当前 */
}
#pragma mark----退出登录
- (void)exitButtonClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [PersistenceManager setLoginSession:@""];
        EMError * error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *lv = [mainStoryboard instantiateViewControllerWithIdentifier:@"login"];
            lv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lv animated:YES];
        }        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationItem.title = @"个人设置";

        self.view2.frame = CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight);
        self.view3.frame = CGRectMake(dtScreenWidth, 0, dtScreenWidth-100, dtScreenHeight);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }];
}


-(void)textFieldEndEditing:(UITextField *)textField
{
    if (textField.tag==111) {
        /* 将密码写进本地 然后需要时用 */
    }else if (textField.tag==222){
        
    }else if (textField.tag==333){
        
    }
    NSLog(@"%@",textField.text);
}
-(void)textViewEndEdit:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
}
@end
