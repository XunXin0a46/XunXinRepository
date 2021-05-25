//
//  OneLineTwoStyleTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/21.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "OneLineTwoStyleTableViewCell.h"
#import "OneLineTwoStyleModel.h"
#import "OneLineTwoStyleCollectionViewCell.h"

static const NSArray *staticDataSource;//记录数据源
static const NSString *bargainPageMargin = @"10";//页面边距
static const NSString *bargainGoodsMargin = @"10";//商品间距

NSString * const OneLineTwoStyleTableViewCellReuseIdentifier = @"OneLineTwoStyleTableViewCellReuseIdentifier";

@interface OneLineTwoStyleTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, strong) UICollectionView *collectionView;//集合视图

@end

@implementation OneLineTwoStyleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = HEXCOLOR(0xfdeada);
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //集合视图布局
    NHAlignmentFlowLayout *layout = [[NHAlignmentFlowLayout alloc] init];
    //初始化集合视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    //集合视图背景色
    self.collectionView.backgroundColor = [UIColor clearColor];
    //添加集合视图
    [self.contentView addSubview:self.collectionView];
    //集合视图代理
    self.collectionView.delegate = self;
    //集合视图数据源
    self.collectionView.dataSource = self;
    //滚动集合视图时键盘的收起方式
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //禁止集合视图滚动
    self.collectionView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        //调整内容的偏移行为
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //设置集合视图约束
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    //注册cell
    [self.collectionView registerClass:[OneLineTwoStyleCollectionViewCell class] forCellWithReuseIdentifier:OneLineTwoStyleCollectionViewCellReuseIdentifier];
}

- (void)createDataSource{
    //初始化数据源
    self.dataSource = [[NSMutableArray alloc]init];
    //创建数据
    for (int i = 0; i < 3; i++) {
        if(i == 0){
            OneLineTwoStyleModel *model = [[OneLineTwoStyleModel alloc]init];
            [self.dataSource addObject:[model cureateModelI]];
        }else if(i == 1){
            OneLineTwoStyleModel *model = [[OneLineTwoStyleModel alloc]init];
            [self.dataSource addObject:[model cureateModelII]];
        }else if(i == 2){
            OneLineTwoStyleModel *model = [[OneLineTwoStyleModel alloc]init];
            [self.dataSource addObject:[model cureateModelIII]];
        }
    }
    staticDataSource = self.dataSource;
}

///计算cell高度
+ (CGFloat)calculateDynamicHeight{
    //数据行数
    NSInteger dataRowNumber = 0;
    //判断是否是整行的数据
    if(staticDataSource.count % 2 == 0){
        dataRowNumber = staticDataSource.count / 2;
    }else{
        dataRowNumber = staticDataSource.count / 2 + 1;
    }
    //集合视图高度
    CGFloat contentHeight = ([self calculateDynamicItemHeight] * dataRowNumber) + (bargainGoodsMargin.integerValue * (dataRowNumber - 1)) + bargainPageMargin.integerValue * 2;
    //返回cell高度
    return contentHeight;
}

///计算集合视图cell高度
+ (CGFloat)calculateDynamicItemHeight{
    //返回的内容高度
    CGFloat contentHeight = 0;
    //加cell的宽度(图片高度)
    contentHeight += (SCREEN_WIDTH / 2) - bargainPageMargin.integerValue - (bargainGoodsMargin.integerValue / 2);
    //加名称标签高度
    contentHeight += ceil([TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:15]].height * 2) + 10;
    //加定位标签高度
    contentHeight += [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:14]].height + 5 + 10;
    //加价值标签高度
    contentHeight += ceil([TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:13]].height) + 10;
    //加砍价按钮高度
    contentHeight += 25 + 10;
    //返回内容高度
    return contentHeight;
}

#pragma mark -- UICollectionViewDataSource

///返回指定节中的项数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

///为某个单元格提供显示数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OneLineTwoStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OneLineTwoStyleCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark -- UICollectionViewDelegate

///动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH / 2) - bargainPageMargin.integerValue - (bargainGoodsMargin.integerValue / 2) , [OneLineTwoStyleTableViewCell calculateDynamicItemHeight]);
}

///动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, bargainPageMargin.integerValue);
}

///动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, bargainPageMargin.integerValue);
}

///动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return bargainGoodsMargin.integerValue;
}

///动态设置每个单元格的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return bargainGoodsMargin.integerValue;
}

///动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, bargainPageMargin.integerValue, 0, bargainPageMargin.integerValue);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
