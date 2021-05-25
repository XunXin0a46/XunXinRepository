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
static NSString *style_goods_page_margins;//页面边距(只影响左右)
static NSString *style_goods_item_margins;//商品间距(同时影响上下左右) 默认10
static NSString *style_goods_item_radius;//模版圆角 1:圆角 nil:直角 默认圆角

@interface BigPictureStyleTableViewCell()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;//记录数据源
@property (nonatomic, strong) UITableView *tableView;//表视图

@end

@implementation BigPictureStyleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //设置cell背景色
        self.contentView.backgroundColor = [YSUUtils colorOfHexString:@"#6aa84f"];
        //常见视图
        [self createUI];
    }
    return self;
}

///常见视图
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
    //表视图背景色
    self.tableView.backgroundColor = [UIColor clearColor];
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
    //模版圆角
    style_goods_item_radius = @"1";
    //商品间距
    style_goods_item_margins = @"10";
    //页面间距
    style_goods_page_margins = @"10";
    //设置模版左右间距
    CGFloat paddingSum = style_goods_page_margins.floatValue + style_goods_item_margins.floatValue;
    //设置内间距
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(paddingSum);
        make.right.equalTo(self.contentView.mas_right).offset(- paddingSum);
    }];
}

///返回cell高度
+ (CGFloat)calculateCellHeight{
    //计算内容高度
    CGFloat contentHeight = (SCREEN_WIDTH * 0.64 + [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:15]].height + [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:18]].height + 18 + 10 * 5) * staticDataSource.count;
    //增加商品间距
    contentHeight = contentHeight + ((staticDataSource.count + 1) * style_goods_item_margins.floatValue);
    //返回cell高度
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
    //是否模版圆角
    if([style_goods_item_radius isEqualToString:@"1"]){
        //设置了模版圆角
        cell.layer.cornerRadius = 10.0;
        cell.layer.masksToBounds = YES;
        cell.contentView.layer.cornerRadius = 10.0;
        cell.contentView.layer.masksToBounds = YES;
    }else{
        //未设置模版圆角
        cell.layer.cornerRadius = 0.0;
        cell.layer.masksToBounds = NO;
        cell.contentView.layer.cornerRadius = 0.0;
        cell.contentView.layer.masksToBounds = NO;
    }
    return cell;
}

#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //返回设置的商品间距
    return style_goods_item_margins.floatValue;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //判断是否是最后一组cell
    if(section == self.dataSource.count - 1){
        //最后一组cell返回设置的商品间距
        return style_goods_item_margins.floatValue;
    }else{
        return 0.1;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
