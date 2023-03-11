//
//  YSCOrderTypeSelectionView.m
//  YiShopCustomer
//
//  Created by 王刚 on 2020/5/6.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "TestCollectionView.h"
#import "TestCollectionViewItem.h"
#import "ViewController.h"

@interface TestCollectionView()<CAAnimationDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIControl * backControl;//视图控制层
@property (nonatomic, strong) UIView *selfSuperView;
@property (nonatomic, strong) UICollectionView *collectionView;//选项集合视图
@property (nonatomic, assign) CGSize size;//集合视图的大小

@end

@implementation TestCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.hidden = YES;
    
    ///视图控制层
    self.backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEAD_BAR_HEIGHT)];
    self.backControl.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.backControl addTarget:self action:@selector(backControlClick) forControlEvents:UIControlEventTouchUpInside];
    self.backControl.alpha = 0;
    
    ///选项集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    //预估计cellf大小
    layout.estimatedItemSize = CGSizeMake(110, 30);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TestCollectionViewItem class] forCellWithReuseIdentifier:TestCollectionViewItemReuseIdentifier];
    [self addSubview:self.collectionView];
    //给collectionView约束，让其显示
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(ceil(self.size.height)).priorityHigh();
    }];
    
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        self.size =  self.collectionView.collectionViewLayout.collectionViewContentSize;
        //重新设置约束
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(ceil(self.size.height + HEAD_BAR_HEIGHT)).priorityHigh();
        }];
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selfSuperView);
            make.size.mas_equalTo(CGSizeMake(self.selfSuperView.frame.size.width, self.size.height + HEAD_BAR_HEIGHT));
        }];
    });
}

///显示视图
- (void)showInView:(UIView *)superView{
    
    self.selfSuperView = superView;
    if([self isHidden]){
        
        self.hidden = NO;
        self.collectionView.hidden = NO;
        
        if(self.backControl.superview == nil){
            [self.selfSuperView addSubview:self.backControl];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backControl.alpha = 1;
        }];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.2;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.type = kCATransitionFromTop;
        [self.layer addAnimation:animation forKey:@"animation1"];
        
        [self.selfSuperView addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selfSuperView);
            make.size.mas_equalTo(CGSizeMake(self.selfSuperView.frame.size.width, self.size.height + HEAD_BAR_HEIGHT));
        }];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

///隐藏视图
- (void)hideInView{
    
    if(![self isHidden]){
        
        self.hidden = YES;
        self.collectionView.hidden = YES;
        
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFade;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backControl.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
    
}

///阴影层点击事件
- (void)backControlClick{
    
    [self hideInView];
    self.HideInViewyBlock();
    
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestCollectionViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:TestCollectionViewItemReuseIdentifier forIndexPath:indexPath];
    item.titleLabel.text =  self.dataSource[indexPath.row];
    //设置Item是否选中
    if([[TestSharedInstance sharedInstance].selectControllerName isEqualToString:self.dataSource[indexPath.row]]){
        item.selection = YES;
    }else{
        item.selection = NO;
    }
    return item;
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //如果要前往的控制器名称与进入页面时的控制器名称相同，不执行操作
    if([self.dataSource[indexPath.row] isEqualToString:[TestSharedInstance sharedInstance].selectControllerName]){
        return;
    }else{
        //记录点击的控制器名称
        [TestSharedInstance sharedInstance].selectControllerName = self.dataSource[indexPath.row];
        //刷新集合视图
        [self.collectionView reloadData];
        //初始化inteny对象
        YSUIntent *intent = [[YSUIntent alloc]init];
        NSDictionary *dic = [TestSharedInstance sharedInstance].buttonCorrespondingControllerDictionary;
        intent.className = [dic objectForKey:self.dataSource[indexPath.row]];
        //一些控制器需要处理数据
        if([intent.className isEqualToString:@"BaseWebViewControlle"]){
            [intent setObject:@"https://www.68mall.com" forKey:BaseWebViewControlleURL];
        }
        //在当前控制器跳转
        UIViewController *viewController = [TestUtils getCurrentVC];
        intent.hidesBottomBarWhenPushed = YES;
        intent.method = OPEN_METHOD_PUSH;
        [viewController openIntent:intent];
        [self backControlClick];
        //移除当前控制器
        NSMutableArray *controllerArray = [viewController.navigationController.viewControllers mutableCopy];
        for (UIViewController *newViewController in controllerArray) {
            if (newViewController == viewController && ![viewController isMemberOfClass:[ViewController class]]) {
                 [controllerArray removeObject:newViewController];
                 break;
             }
         }
        [viewController.navigationController setViewControllers:controllerArray animated:NO];
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

@end
