//
//  ChangeImageController.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChangeImageController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "changeImageCollectionViewCell.h"

@interface ChangeImageController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>
{
    UICollectionViewWaterfallLayout * _layout;
    UICollectionView * _collectionView;
    UITableView * tableview;
    NSArray * imageArray;
}
@end

@implementation ChangeImageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray = @[@"cover_avatar_1",@"cover_avatar_1",@"cover_avatar_2",@"cover_avatar_3",@"cover_avatar_4",@"cover_avatar_5",@"cover_avatar_6",@"cover_avatar_7",@"cover_avatar_8",@"cover_avatar_9",@"cover_avatar_10",@"cover_avatar_11",@"cover_avatar_12",@"cover_avatar_13",@"cover_avatar_14",@"cover_avatar_15",@"cover_avatar_16",@"cover_avatar_17"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        _layout = [[UICollectionViewWaterfallLayout alloc]init];
        _layout.columnCount = 2;//设置两列
        _layout.itemWidth = (dtScreenWidth-15)/2;//设置每个item的宽
        _layout.delegate = self;//通过代理设置item的高
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置区和四周边界的距离
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;//禁止collection的滑动
        [_collectionView registerClass:[changeImageCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [cell.contentView addSubview:_collectionView];
        
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _collectionView.contentSize.height+1;
}

#pragma mark----collectionView代理区
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGSize size = [change[@"new"] CGSizeValue];
    //修改 CollectionView 的高度为显示区域的高度。
    CGRect frame = _collectionView.frame;
    frame.size.height = size.height;
    _collectionView.frame = frame;
    [tableview reloadData];
    
}
- (void)dealloc
{
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark----collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 18;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    changeImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.imagename = imageArray[indexPath.item];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:imageArray[indexPath.item] forKey:@"backgroundImageForUser"];
    [userdefaults synchronize];

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - UICollectionViewDelegateWaterfallLayout

//返回每个 item 的高度。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (dtScreenWidth-15)/2;
}

@end
