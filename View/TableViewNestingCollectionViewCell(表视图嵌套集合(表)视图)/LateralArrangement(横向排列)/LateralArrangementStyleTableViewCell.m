//
//  LateralArrangementStyleTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/22.
//  Copyright © 2021 王刚. All rights reserved.
//  

NSString *const LateralArrangementStyleTableViewCellReuseIdentifier = @"LateralArrangementStyleTableViewCellReuseIdentifier";

#import "LateralArrangementStyleTableViewCell.h"
#import "LateralArrangementStyleRightView.h"
#import "LateralArrangementItemDataPicItemModel.h"

static NSArray *LeftDataSource;//记录左侧数据源
static NSArray *RightDataSource;//记录右侧数据源
static id ExtraInfo;//用于存放图片显示大小的属性，可能是NSValue，也可能NSDictionary
static NSInteger const border = 1;

@interface LateralArrangementStyleTableViewCell()

@property (nonatomic, strong) UIImageView *leftImageView;//左侧图片视图
@property (nonatomic, strong) LateralArrangementStyleRightView *rightView;//右侧图片视图

@end

@implementation LateralArrangementStyleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //监听通知，更新显示数据
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showData) name:@"updateShowData" object:nil];
        //创建视图
        [self createUI];
    }
    return self;
}

///创建视图
- (void)createUI{
    ///左侧图片视图
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.leftImageView];
    self.leftImageView.userInteractionEnabled = YES;
    self.leftImageView.contentMode = UIViewContentModeScaleToFill;
    self.leftImageView.layer.masksToBounds = YES;
    ///右侧图片视图
    self.rightView = [[LateralArrangementStyleRightView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.rightView];
}

///创建数据
- (void)createDataSource{
    //初始化左侧图片模型
    LateralArrangementItemDataPicItemModel *leftModel = [[LateralArrangementItemDataPicItemModel alloc]init];
    //初始化存放左侧模型数组
    NSMutableArray *leftArray = [[NSMutableArray alloc]init];
    [leftArray addObject:[leftModel initLeftItemModel]];
    //记录左侧数据源
    LeftDataSource = leftArray.count ? leftArray : nil;
    //初始化左侧第一张图片模型
    LateralArrangementItemDataPicItemModel *rightOneModel = [[LateralArrangementItemDataPicItemModel alloc]init];
    //初始化左侧第二张图片模型
    LateralArrangementItemDataPicItemModel *rightTwoModel = [[LateralArrangementItemDataPicItemModel alloc]init];
    //初始化存放右侧模型数组
    NSMutableArray *rightArray = [[NSMutableArray alloc]init];
    [rightArray addObject:[rightOneModel initRightOneItemModel]];
    [rightArray addObject:[rightTwoModel initRightTwoItemModel]];
    //记录右侧数据源
    RightDataSource = rightArray.count ? rightArray : nil;
    //显示数据
    [self showData];
}

///显示数据
- (void)showData{
    //两侧都没有图
    if (LeftDataSource.count == 0 &&
        RightDataSource.count == 0) {
        return;
    }
    // 左侧有图，右侧无图
    else if (LeftDataSource.count > 0 &&
             RightDataSource.count == 0) {
        //右侧移除所有显示图片
        [self.rightView removeAllImages];
        //获取左侧数据模型
        LateralArrangementItemDataPicItemModel *leftItem = LeftDataSource.firstObject;
        //设置左侧图片视图图片
        [self.leftImageView setImage:leftItem.image];
        //获取左侧图显示大小
        CGSize leftImageSize = [(NSValue *)ExtraInfo CGSizeValue];
        //设置左侧图片视图约束
        [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(leftImageSize.height).priorityHigh();
            make.width.mas_equalTo(leftImageSize.width);
        }];
    }
    // 左侧无图右侧有图
    else if (LeftDataSource.count == 0 && RightDataSource.count > 0) {
        //置空左侧图片视图图片
        self.leftImageView.image = nil;
        //设置边框高度
        self.rightView.borderHeight = border;
        //设置图片数据数组
        self.rightView.imageModels = RightDataSource;
        //记录右侧第一张图显示大小
        self.rightView.imageModels[0].displaySize = [(NSValue *)ExtraInfo[@"2_1"] CGSizeValue];
        //判断右侧是否有第二张图
        if(RightDataSource.count > 1){
            //记录右侧第二张图显示大小
            self.rightView.imageModels[1].displaySize = [(NSValue *)ExtraInfo[@"2_2"] CGSizeValue];
        }
        //设置右侧图片视图约束
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.bottom.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.5);
        }];
    }
    // 两侧都有图
    else if (LeftDataSource.count > 0 && RightDataSource.count > 0) {
        //左侧图
        //获取左侧数据模型
        LateralArrangementItemDataPicItemModel *leftItem = LeftDataSource.firstObject;
        //设置左侧图片视图图片
        [self.leftImageView setImage:leftItem.image];
        //获取存储图片显示大小的字典
        NSDictionary *extraInfo = (NSDictionary *)ExtraInfo;
        //获取左侧图显示大小
        CGSize leftImageSize = [extraInfo[@"1_1"] CGSizeValue];
        //设置左侧图片视图约束
        [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView);
            make.width.mas_equalTo(leftImageSize.width);
            make.bottom.equalTo(self.contentView).offset(-border);
        }];
        
        // 右侧图
        //边框高度
        self.rightView.borderHeight = border;
        //设置图片数据数组
        self.rightView.imageModels = RightDataSource;
        //记录右侧第一张图显示大小
        self.rightView.imageModels[0].displaySize = [(NSValue *)ExtraInfo[@"2_1"] CGSizeValue];
        //判断右侧是否有第二张图
        if(RightDataSource.count > 1){
            //记录右侧第二张图显示大小
            self.rightView.imageModels[1].displaySize = [(NSValue *)ExtraInfo[@"2_2"] CGSizeValue];
        }
        //设置右侧图片视图约束
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-border);
            make.left.equalTo(self.leftImageView.mas_right).offset(border);
        }];
    }
}

///计算cell高度
+ (CGFloat)calculateDynamicHeight{
    //获取左侧数据模型
    LateralArrangementItemDataPicItemModel *leftItem = LeftDataSource.firstObject;
    //获取右侧模型一
    LateralArrangementItemDataPicItemModel *rightItem1 = RightDataSource[0];
    //右侧模型二
    LateralArrangementItemDataPicItemModel *rightItem2 = nil;
    //如果右侧数据源数据数量大于一
    if (RightDataSource.count > 1) {
        //获取右侧模型二
        rightItem2 = RightDataSource[1];
    }
    //如果两侧都没有数据，高度返回0
    if (LeftDataSource.count == 0 && RightDataSource.count == 0) {
        //返回cell高度
        return 0;
    }
    //仅左侧有图时
    else if (LeftDataSource.count > 0 && RightDataSource.count == 0) {
        //计算图片显示大小
        CGSize itemSize = resizeItemInWidth(SCREEN_WIDTH * 0.5, CGSizeMake(leftItem.image_width, leftItem.image_height));
        //存储图片显示大小
        ExtraInfo = [NSValue valueWithCGSize:itemSize];
        //发送通知更新显示数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateShowData" object:nil];
        //返回cell高度
        return itemSize.height;
    }
    // 仅右侧有图
    else if (LeftDataSource.count == 0 && RightDataSource.count > 0) {
        //设置边框宽度
        CGFloat padding = 1;
        //计算右侧第一张图显示大小
        CGSize item1Size = resizeItemInWidth(SCREEN_WIDTH * 0.5, CGSizeMake(rightItem1.image_width, rightItem1.image_height));
        //右侧第二张图默认大小
        CGSize item2Size = CGSizeZero;
        //判断是否有第二张图
        if (RightDataSource.count > 1) {
            //计算右侧第二张图显示大小
            item2Size = resizeItemInWidth(SCREEN_WIDTH * 0.5, CGSizeMake(rightItem2.image_width, rightItem2.image_height));
            
        }
        //存储图片显示大小的字典
        NSDictionary *extraInfo = @{@"1_1": [NSValue valueWithCGSize:CGSizeZero],
                                    @"2_1": [NSValue valueWithCGSize:item1Size],
                                    @"2_2": [NSValue valueWithCGSize:item2Size]};
        //存储图片显示大小
        ExtraInfo = extraInfo;
        //计算cell显示高度
        CGFloat totalHeight = item1Size.height + item2Size.height + padding;
        //发送通知更新显示数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateShowData" object:nil];
        //返回cell显示 高度
        return totalHeight;
    }
    // 左右都有图
    else if (LeftDataSource.count > 0 && RightDataSource.count > 0) {
        //边框宽度
        CGFloat borderWidth = 1;
        //右侧两张图组合宽高比
        CGFloat rightRatio = 1;
        //右侧第二张图宽高比
        CGFloat rightRatio2 = 1;
        @try {
            //右侧第一张图宽高比
            CGFloat rightRatio1 = rightItem1.image_width / rightItem1.image_height;
            //左侧图片宽高比
            CGFloat leftRatio = leftItem.image_width / leftItem.image_height;
            // 右侧有两张图时，计算右侧图片组合
            if (RightDataSource.count > 1) {
                //获取右侧模型二
                rightItem2 = RightDataSource[1];
                //右侧第二张图宽高比
                rightRatio2 = rightItem2.image_width / (rightItem2.image_height);
                // 在width相同的条件下，计算右侧组合宽高比 w/h （表达式为推导后结果）
                rightRatio = (rightRatio1 * rightRatio2) / (rightRatio1 + rightRatio2);
            } else {
                //右侧只有一张图，以右侧第一张图宽高比设置右侧组合宽高比
                rightRatio = rightRatio1;
            }
            // 在左侧图和右侧组合图height相同的条件下，计算左侧width与右侧width的比例 （表达式为推导后结果）
            CGFloat widthRatio = leftRatio / rightRatio;
            //计算两侧图像自适应屏幕后的显示宽度
            CGFloat leftDisplayWidth = (widthRatio * (SCREEN_WIDTH-1)) / (1 + widthRatio);
            CGFloat rightDisplayWidth = (SCREEN_WIDTH-1) - leftDisplayWidth;
            //设置两侧图像自适应屏幕后的具体大小
            //左侧图显示大小
            CGSize leftImageSize = CGSizeMake(leftDisplayWidth , leftDisplayWidth / leftRatio);
            //右侧图一显示大小
            CGSize rightImage1Size = CGSizeMake(rightDisplayWidth, rightDisplayWidth / rightRatio1);
            //右侧图二显示大小
            CGSize rightImage2Size = (RightDataSource.count > 1) ? CGSizeMake(rightDisplayWidth, rightDisplayWidth / rightRatio2) : CGSizeMake(0,0);
            //存储图片显示大小的字典
            NSDictionary *extraInfo = @{@"1_1": [NSValue valueWithCGSize:leftImageSize],
                                        @"2_1": [NSValue valueWithCGSize:rightImage1Size],
                                        @"2_2": [NSValue valueWithCGSize:rightImage2Size]};
            //存储图片显示大小
            ExtraInfo = extraInfo;
            //发送通知更新显示数据
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateShowData" object:nil];
            //返回cell高度
            return leftDisplayWidth / leftRatio + borderWidth;
            
        } @catch (NSException *exception) {
            //计算过程中发生了异常
            YSCLog(@"%s\n%@", __FUNCTION__, exception);
        } @finally {}
    }
    //默认cell高度返回0
    return 0;
}

@end
