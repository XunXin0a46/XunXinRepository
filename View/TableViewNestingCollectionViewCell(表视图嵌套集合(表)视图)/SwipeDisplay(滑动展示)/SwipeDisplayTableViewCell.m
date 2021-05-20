//
//  SwipeDisplayTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/4/24.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "SwipeDisplayTableViewCell.h"
#import "SwipeDisplayItemModel.h"
#import "SwipeDisplayItemView.h"
#import "DateCountdown.h"

static NSInteger const OrginTag = 4000;

NSString * const SwipeDisplayTableViewCellReuseIdentifier = @"SwipeDisplayTableViewCellReuseIdentifier";


@interface SwipeDisplayTableViewCell()<SwipeViewDataSource,SwipeViewDelegate>

@property (nonatomic, strong) SwipeView *swipeView;//滑动视图
@property (nonatomic, strong) NSMutableArray *dataSource;//滑动视图数据源
@property (nonatomic, strong) dispatch_source_t timer;//GCD定时器
@property (nonatomic, strong) NSMutableArray *startTimeArray;//倒计时时间数组
@property (nonatomic, strong) DateCountdown *countdown;//倒计时定时器

@end

@implementation SwipeDisplayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///顶部分割线
        UIView *topLine = [[UIView alloc]init];
        topLine.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        
        ///头部视图
        UIView *headerView = [[UIView alloc]init];
        [self.contentView addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(topLine);
            make.top.equalTo(topLine.mas_bottom);
            make.height.mas_equalTo(10 * 5 - 0.5);
        }];
        
        ///头部视图标题视图
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 5, 19.5)];
        [headerView addSubview:titleView];
        
        ///头部视图标题视图渐变层
        CAGradientLayer *grandientLayer = [[CAGradientLayer alloc] init];
        grandientLayer.frame = CGRectMake(0, 0, 5, 19.5);
        [titleView.layer insertSublayer:grandientLayer atIndex:0];
        grandientLayer.startPoint = CGPointZero;
        grandientLayer.endPoint = CGPointMake(0.0, 1.0);
        grandientLayer.colors = @[(id)HEXCOLOR(0xf2270c).CGColor, (id)HEXCOLOR(0xf9bfb7).CGColor];
        grandientLayer.type = kCAGradientLayerAxial;
        
        ///头部视图标题标签
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"以下小伙伴已发起拼团，快来参与吧";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(titleView.mas_right).offset(10);
        }];
        
        ///头部视图分割线
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor blackColor];
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(headerView);
            make.left.equalTo(headerView.mas_left).offset(10);
            make.height.mas_equalTo(0.5);
        }];
        
        
        ///滑动视图
        //初始化滑动视图
        self.swipeView = [[SwipeView alloc] init];
        //设置滑动视图代理
        self.swipeView.delegate = self;
        //设置滑动视图数据源
        self.swipeView.dataSource = self;
        //是否启动分页
        self.swipeView.pagingEnabled = YES;
        //每页的项目数
        self.swipeView.itemsPerPage = 2;
        //截断最后一页
        self.swipeView.truncateFinalPage = NO;
        //滑动视图对齐方式
        self.swipeView.alignment = SwipeViewAlignmentEdge;
        //是否手动滚动
        self.swipeView.scrollEnabled = YES;
        //是否轮询
        self.swipeView.wrapEnabled = YES;
        //是否垂直滑动
        self.swipeView.vertical = YES;
        //设置背景色
        self.swipeView.backgroundColor = [UIColor whiteColor];
        //添加滑动视图
        [self.contentView addSubview:self.swipeView];
        //设置约束
        [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10 * 6);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

///计时器开始工作
- (void)openTimer{
    __weak typeof(self) weakSelf = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 4.0 * NSEC_PER_SEC), 4.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf.swipeView scrollToItemAtIndex:(weakSelf.swipeView.currentItemIndex + 2) duration:0.5];
    });
    dispatch_resume(_timer);
}

///设置模型
- (void)setModel:(TestTableViewModel *)model{
    //记录模型
    _model = model;
    //遍历模型中的图片数组，设置数据源
    [model.collectionViewModelArray enumerateObjectsUsingBlock:^(TestCollectionViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SwipeDisplayItemModel *itemModel = [[SwipeDisplayItemModel alloc]init];
        itemModel.headerImage = obj.image;
        itemModel.name = @"虚空掠夺者";
        itemModel.time = [NSString stringWithFormat:@"%ld",(long)floor([[NSDate date]timeIntervalSince1970] + 86400 * idx)];
        [self.dataSource addObject:itemModel];
    }];
    [self.swipeView reloadData];
    //判断是否滚动展示数据
    if(model.collectionViewModelArray.count > 2){
        //计时器开始工作
        [self openTimer];
        //允许滑动视图滚动
        self.swipeView.scrollEnabled = YES;
    }else{
        //不允许滑动视图滚动
        self.swipeView.scrollEnabled = NO;
    }
    //设置倒计时时间数组中存储的倒计时时间
    [self.startTimeArray removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    for (SwipeDisplayItemModel *itemModel in self.dataSource) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[itemModel.time integerValue]];
        NSString *startTimeString = [dateFormatter stringFromDate:date];
        [self.startTimeArray addObject:startTimeString];
    }
    //设置执行倒计时时间(每秒执行)
    self.countdown = [[DateCountdown alloc]init];
    [self.countdown countDownWithPER_SECBlock:^{
        //更新倒计时时间
        [self updateTimeInVisibleCells];
    }];
}

///更新倒计时时间
- (void)updateTimeInVisibleCells{
    if (self.model.collectionViewModelArray.count > 0) {
        // 取出屏幕可见视图
        NSArray *views = self.swipeView.visibleItemViews;
        for (SwipeDisplayItemView *view in views) {
            //设置倒计时文本
            view.countdownTime.text = [self getNowTimeWithStrings:self.startTimeArray[(view.tag - OrginTag)]];
            //判断活动是否结束
            if ([view.countdownTime.text isEqualToString:@"活动已经结束！"]) {
                view.countdownTime.textColor = [UIColor redColor];
            } else {
                view.countdownTime.textColor = [UIColor greenColor];
            }
        }
    }
}

///处理时间字符串
- (NSString *)getNowTimeWithStrings:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    nowDate = [formater dateFromString:nowDateStr];
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    if(days<10)
        dayStr = [NSString stringWithFormat:@"0%d",days];
    else
        dayStr = [NSString stringWithFormat:@"%d",days];
    if(hours<10)
        hoursStr = [NSString stringWithFormat:@"0%d",hours];
    else
        hoursStr = [NSString stringWithFormat:@"%d",hours];
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d", minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d", minutes];
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d", seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"活动已经结束！";
    }
    return [NSString stringWithFormat:@"剩余%@:%@:%@:%@", dayStr, hoursStr, minutesStr, secondsStr];
}

///懒加载活动视图数据源
- (NSMutableArray *)dataSource{
    if(_dataSource == nil){
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

///懒加载倒计时时间数组
- (NSMutableArray *)startTimeArray {
    if (!_startTimeArray) {
        _startTimeArray = [NSMutableArray array];
    }
    return _startTimeArray;
}

///返回self高度
+ (CGFloat)calculateCellHeight:(TestTableViewModel *)model{
    if(model.collectionViewModelArray.count > 2){
        return [SwipeDisplayItemView calculateViewHeight] * 2 + 60;
    }else{
        return [SwipeDisplayItemView calculateViewHeight] * model.collectionViewModelArray.count + 60;
    }
}

#pragma mark -- SwipeViewDataSource

///滑动视图中的项目数
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.dataSource.count;
}

///滑动视图中的每一个项目
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index
          reusingView:(UIView *)view {
    SwipeDisplayItemView *scrollViewStyleView = (SwipeDisplayItemView *)view;
    if(scrollViewStyleView == nil){
        scrollViewStyleView = [[SwipeDisplayItemView alloc] initWithFrame:CGRectZero];
    }
    
    SwipeDisplayItemModel *model = self.dataSource[index];
    [scrollViewStyleView setModel:model];
    scrollViewStyleView.tag = index + OrginTag;
    return scrollViewStyleView;
}

#pragma mark -- SwipeViewDelegate

///滑动视图项目大小（不设置ScrollView只是一条线）
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(SCREEN_WIDTH, [SwipeDisplayItemView calculateViewHeight] );
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
