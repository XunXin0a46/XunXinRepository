//
//  SearchImitateController.m
//  YiShopCustomer
//
//  Created by 王刚 on 2020/8/18.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "SearchImitateController.h"
#import "SearchContentView.h"
#import "UIView+Action.h"
#import "UIView+ExtraTag.h"
#import "UIView+UIViewRoundCorners.h"

@interface SearchImitateController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SearchContentView* contentView;//内容视图
@property (nonatomic, strong) NSMutableArray *dataSourceArray;//作为数据源的数组

@end

@implementation SearchImitateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置内容视图出现时的动画过渡
    [UIView animateWithDuration:0.25 animations:^{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_HEIGHT / 2);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)createUI{
    ///内容视图
    self.contentView = [[SearchContentView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.tableView.dataSource = self;
    self.contentView.tableView.delegate = self;
    [self.contentView addTarget:self action:@selector(contentViewClick:) section:0];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT / 2);
    }];
    [self.view layoutIfNeeded];
    //触发布局后内容添加圆角
    [self.contentView viewAddCornerRadius:self.contentView applyRoundCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10.0];
    self.contentView.clipsToBounds = YES;
    //内容视图中搜索框的文本改变后，触发回调
    YSC_WEAK_SELF
    self.contentView.searchTextChangeBlock = ^(NSString *searchText) {
        NSLog(@"%@",searchText);
        [weakSelf.dataSourceArray addObject:searchText];
        [weakSelf.contentView.tableView reloadData];
    };
}

///内容视图处理点击事件
- (void)contentViewClick:(UIView *)sender{
    YSCViewType viewTypeForTag = [sender getViewTypeOfTag];
    if(viewTypeForTag == ViewTypeCloseButton){
        [self cancel];
    }
}

///内容视图消失时的过度动画
- (void)cancel {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCREEN_HEIGHT / 2);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [super cancel];
    }];
}

///懒加载作为数据源的数组
- (NSMutableArray *)dataSourceArray{
    if(_dataSourceArray == nil){
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsSearchCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResultsSearchCell"];
    }
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
