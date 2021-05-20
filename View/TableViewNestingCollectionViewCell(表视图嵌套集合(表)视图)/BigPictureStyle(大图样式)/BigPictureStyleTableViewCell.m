//
//  BigPictureStyleTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/19.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "BigPictureStyleTableViewCell.h"
#import "BigPictureStyleTableViewItemCell.h"

NSString * const BigPictureStyleTableViewCellReuseIdentifier = @"BigPictureStyleTableViewCellReuseIdentifier";

static NSArray *staticDataSource;//记录数据源

@interface BigPictureStyleTableViewCell()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;//记录数据源
@property (nonatomic, strong) UITableView *tableView;//表视图

@end

@implementation BigPictureStyleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //初始化分组样式表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //添加表视图
    [self.contentView addSubview:self.tableView];
    //禁止表视图滚动
    self.tableView.scrollEnabled = NO;
    //表视图数据源
    self.tableView.dataSource = self;
    //表视图代理
    self.tableView.delegate = self;
    //表视图分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //表视图每组尾部视图预估高度
    self.tableView.estimatedSectionFooterHeight = 0;
    //表视图每组头部视图预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    //表视图每行预估高度
    self.tableView.estimatedRowHeight = 80 * 1.5 + 10 * 2.0;
    //注册cell
    //大图样式
    [self.tableView registerClass:[BigPictureStyleTableViewItemCell class] forCellReuseIdentifier:BigPictureStyleTableViewItemCellReuseIdentifier];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

///创建数据源
- (void)createDataSource{
    //初始化数据源
    self.dataSource = [[NSMutableArray alloc]init];
    //添加图片链接1
    [self.dataSource addObject:@"https://68test.oss-cn-beijing.aliyuncs.com/images/746/shop/358/gallery/2021/04/27/16194943647199.png?x-oss-process=image/resize,m_pad,limit_0,h_320,w_320"];
    //添加图片链接2
    [self.dataSource addObject:@"https://68test.oss-cn-beijing.aliyuncs.com/images/746/shop/358/gallery/2021/04/27/16194943647199.png?x-oss-process=image/resize,m_pad,limit_0,h_320,w_320"];
    //记录数据源
    staticDataSource = self.dataSource;
}

///返回cell高度
+ (CGFloat)calculateCellHeight{
    CGFloat contentHeight = (SCREEN_WIDTH * 0.64 + [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:15]].height + [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:18]].height + 18 + 10 * 5) * staticDataSource.count;
    return contentHeight;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BigPictureStyleTableViewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:BigPictureStyleTableViewItemCellReuseIdentifier];
    cell.goodsImageLink = self.dataSource[indexPath.section];
    return cell;
}

#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
