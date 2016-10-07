//
//  AddPlayerBeingViewController.m
//  MeiWan
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddPlayerBeingViewController.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "meiwan-Swift.h"
#import "LoginViewController.h"

@interface AddPlayerBeingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UILabel *serveName;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong) UITableView *menu;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView * vi;
@property (nonatomic,strong) NSArray *gameRole;
@property (nonatomic,strong) NSArray *server;
@property (nonatomic,assign) NSInteger index;
@end

@implementation AddPlayerBeingViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.addBtn.layer.cornerRadius = 5;
    [self.addBtn.layer setMasksToBounds:YES];
    
    self.gameRole = [NSArray arrayWithObjects:@"艾欧尼亚",@"祖安",@"洛克萨斯",@"班德尔城",@"皮尔特沃夫",@"战争学院",@"巨神峰",@"雷瑟守备",@"裁决之地",@"黑色玫瑰",@"暗影岛",@"钢铁烈阳",@"水晶之痕",@"均衡教派",@"影流",@"守望之海",@"征服之海",@"卡拉曼达",@"皮城警备",@"比尔吉沃特",@"德玛西亚",@"弗雷尔卓德",@"无畏先锋",@"努瑞玛",@"扭曲丛林",@"巨龙之巢",@"教育网专区", nil];
    self.server = [NSArray arrayWithObjects:@"电信一", @"电信二", @"电信三", @"电信四",@"电信五", @"电信六", @"电信七", @"电信八", @"电信九", @"电信十", @"电信十一",@"电信十二", @"电信十三", @"电信十四", @"电信十五", @"电信十六", @"电信十七",@"电信十八", @"电信十九", @"网通一", @"网通二", @"网通三", @"网通四",@"网通五", @"网通六", @"网通七", @"教育一", nil];
    // Do any additional setup after loading the view.
}

- (IBAction)regist:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(UIButton *)sender {
    if (self.serveName.text.length == 0 && self.name.text.length != 0) {
        [ShowMessage showMessage:@"错误的服务器名"];
        return;
    }else if (self.name.text.length == 0 && self.serveName.text.length != 0) {
        [ShowMessage showMessage:@"召唤师名不能为空"];
        return;
    }else if (self.name.text.length == 0 && self.serveName.text.length == 0) {
        [ShowMessage showMessage:@"请填写角色资料"];
    }else{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector addRole:session part:self.server[self.index] name:self.name.text receiver:^(NSData *data,NSError *error){
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0){
                [self.navigationController popViewControllerAnimated:YES];
            }else if (status == 1){
                dispatch_async(dispatch_get_main_queue()
                               , ^{
                                   [PersistenceManager setLoginSession:@""];

                                   LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                                   lv.hidesBottomBarWhenPushed = YES;
                                   [self.navigationController pushViewController:lv animated:YES];
                                   
                               });
            }else{
                
            }
        }];
    }
   
}

- (IBAction)chioceServe:(UITapGestureRecognizer *)sender {
    self.vi = [[UIView alloc]initWithFrame:CGRectMake(10, 25, self.view.bounds.size.width-20, self.view.bounds.size.height-35)];
    self.menu = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.vi.bounds.size.width, self.vi.bounds.size.height-40)];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.vi.bounds.size.height-40, self.vi.bounds.size.width, 40)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(removeMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.vi addSubview:self.menu];
    [self.vi addSubview:self.cancelBtn];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.2;
    [[ShowMessage mainWindow] addSubview:self.vi];

    
}
- (void)removeMenu{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1;
    [self.cancelBtn removeFromSuperview];
    [self.menu removeFromSuperview];
    [self.vi removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameRole.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = self.gameRole[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.serveName.text = self.gameRole[indexPath.row];
    self.index = indexPath.row;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1;
    [self.cancelBtn removeFromSuperview];
    [self.menu removeFromSuperview];
    [self.vi removeFromSuperview];
    

};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
