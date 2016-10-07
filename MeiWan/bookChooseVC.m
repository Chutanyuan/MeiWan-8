//
//  bookChooseVC.m
//  MeiWan
//
//  Created by user_kevin on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "bookChooseVC.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
#import "AFNetworking/AFNetworking.h"
#import "UICollectionViewWaterfallLayout.h"
#import "MJRefresh.h"
#import "books.h"
@interface bookChooseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateWaterfallLayout>
{
    UICollectionViewWaterfallLayout * _layout;
    UICollectionView * _collectionView;
    int page;
}
@property(nonatomic,strong)NSMutableArray * bookname;
@end

@implementation bookChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.bookname = [[NSMutableArray alloc]initWithCapacity:0];
    [self creatPubuliu];
    [self beginRequestWithBooks:1];
    


}

- (void)creatPubuliu
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, dtScreenWidth, dtScreenHeight-5)];
    _layout = [[UICollectionViewWaterfallLayout alloc]init];
    _layout.columnCount = 3;//设置两列
    _layout.itemWidth = (dtScreenWidth-20)/3;//设置每个item的宽
    _layout.delegate = self;//通过代理设置item的高
    _layout.sectionInset = UIEdgeInsetsMake(0, 5, 145, 5);//设置区和四周边界的距离
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = self.view.backgroundColor;
    [_collectionView registerClass:[books class] forCellWithReuseIdentifier:@"cell"];
    [view addSubview:_collectionView];
    [self.view addSubview:view];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self beginRequestWithBooks:page];
        
    }];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self beginRequestWithBooks:page];
    }];
}


#pragma mark----collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _bookname.count;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    books * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [CorlorTransform colorWithHexString:@"#D4D4D4"];
    cell.label.text = _bookname[indexPath.item];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"瀑布流 选择第%ld个",(long)indexPath.item);
    
    NSString * session = [PersistenceManager getLoginSession];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_bookname[indexPath.item],@"book", nil];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                [PersistenceManager setLoginUser:json[@"entity"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_nickname" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];

}
#pragma mark - UICollectionViewDelegateWaterfallLayout

//返回每个 item 的高度。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}


- (void)beginRequestWithBooks:(int)pages{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pages],@"pageNum", nil];
    [manager POST:@"http://api1.zongheng.com/ios/bookstore/query/" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * dic = [parser objectWithData:responseObject];
        NSMutableArray * bookarray = dic[@"result"][@"bookList"];
        NSLog(@"%ld",bookarray.count);
        [bookarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (pages==0) {
                [self.bookname removeAllObjects];
                [self.bookname addObject:obj[@"name"]];
                [_collectionView.mj_header endRefreshing];
            }else{
                [self.bookname addObject:obj[@"name"]];
                [_collectionView.mj_footer endRefreshing];
            }
            [_collectionView reloadData];
        }];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end