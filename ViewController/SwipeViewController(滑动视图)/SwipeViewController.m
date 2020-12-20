//
//  SwipeViewController.m

#import "SwipeViewController.h"

@interface SwipeViewController ()<SwipeViewDataSource,SwipeViewDelegate>

@property (nonatomic, strong) SwipeView *swipeView;//滑动视图
@property (nonatomic, strong) NSMutableArray *swipeViewDataSource;//滑动视图数据源
@property (nonatomic, strong) dispatch_source_t timer;//GCD定时器
@property(nonatomic,strong) NSTimer *delayTimer;//定时器

@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"滑动视图"];
    [self setSwipeView];
    [self setSwipeViewDataSource];
    [self.swipeView reloadData];
    //第一张图要展示3秒，延迟3秒后打开定时器
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(openTimer) userInfo:nil repeats:NO];
    
}

///设置滑动视图
- (void)setSwipeView{
    //初始化滑动视图
    self.swipeView = [[SwipeView alloc] init];
    //设置滑动视图代理
    self.swipeView.delegate = self;
    //设置滑动视图数据源
    self.swipeView.dataSource = self;
    //是否启动分页
    self.swipeView.pagingEnabled = YES;
    //每页的项目数
    self.swipeView.itemsPerPage = 1;
    //当前项目索引
    self.swipeView.currentItemIndex = 0;
    //当前页
    self.swipeView.currentPage = 0;
    //滚动偏移量(滚动到某一项目)
    self.swipeView.scrollOffset = 1;
    //截断最后一页
    self.swipeView.truncateFinalPage = NO;
    //滑动视图对齐方式
    self.swipeView.alignment = SwipeViewAlignmentCenter;
    //是否手动滚动
    self.swipeView.scrollEnabled = NO;
    //是否轮询
    self.swipeView.wrapEnabled = YES;
    //延迟内容接触
    self.swipeView.delaysContentTouches = YES;
    //弹簧效果
    self.swipeView.bounces = YES;
    //减速率
    self.swipeView.decelerationRate = 0.5;
    //是否垂直滑动
    self.swipeView.vertical = YES;
    //自动滚动
    //self.swipeView.autoscroll = 1.0;
    //添加滑动视图
    [self.view addSubview:self.swipeView];
    //设置约束
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT + NAVIGATIONBAR_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT / 2);
    }];
    [self.swipeView reloadData];
}

///计时器开始工作
- (void)openTimer{
    __weak typeof(self) weakSelf = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf.swipeView scrollToPage:(weakSelf.swipeView.currentPage + 1) duration:0.5];
    });
    dispatch_resume(_timer);
}

///数据源
- (NSMutableArray *)setSwipeViewDataSource{
    if(_swipeViewDataSource == nil){
        _swipeViewDataSource = [[NSMutableArray alloc]init];
        UIImage *image1 = [UIImage imageNamed:@"pl_user_avatar"];
        UIImage *image2 = [UIImage imageNamed:@"test"];
        UIImage *image3 = [UIImage imageNamed:@"Toast"];
        UIImage *image4 = [UIImage imageNamed:@"btn_back_dark"];
        [_swipeViewDataSource addObject:image1];
        [_swipeViewDataSource addObject:image2];
        [_swipeViewDataSource addObject:image3];
        [_swipeViewDataSource addObject:image4];
    }
    return _swipeViewDataSource;
}

#pragma make -- SwipeViewDataSource
///滑动视图中的项目数
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.swipeViewDataSource.count;
    
}

///滑动视图中的每一个项目
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index
          reusingView:(UIView *)view {
    UIImageView *imageView = (UIImageView *)view;
    if(imageView == nil){
        imageView = [[UIImageView alloc] initWithFrame:swipeView.bounds];
    }
    [imageView setImage:[self.swipeViewDataSource objectAtIndex:index]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

#pragma make -- SwipeViewDelegate
///滑动视图项目大小（不设置ScrollView只是一条线）
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return swipeView.bounds.size;
}

/////滑动视图点击事件
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%@",swipeView.currentItemView);
    [self.swipeView scrollByOffset:1 duration:3];
}
//
///当scrollView的contentOffset改变时调用。
- (void)swipeViewDidScroll:(SwipeView *)swipeView{
    NSLog(@"当scrollView的contentOffset改变时调用");
}

///当前项目索引更新时调用
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    NSLog(@"当前项目索引更新时调用");
}
///当开始滚动视图时，执行改方法，一次有效滑动只执行一次（开始滑动，滑动一小段距离，只要手指不松开，算一次滑动）
- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView{
    NSLog(@"当开始滚动视图时，执行改方法，一次有效滑动只执行一次（开始滑动，滑动一小段距离，只要手指不松开，算一次滑动）");
}
///滑动视图，当手指离开时，调用该方法，一次有效滑动只执行一次
- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate{
    NSLog(@"滑动视图，当手指离开时，调用该方法，一次有效滑动只执行一次");
}
///滑动减速时调用该方法
- (void)swipeViewWillBeginDecelerating:(SwipeView *)swipeView{
    NSLog(@"滑动减速时调用该方法");
}
///滚动视图减速完成，滚动将停止时，调用该方法，一次有效滑动，只执行一次
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    NSLog(@"滚动视图减速完成，滚动将停止时，调用该方法，一次有效滑动，只执行一次");
}
///滑动视图结束滚动时()
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView{
    NSLog(@"滑动视图结束滚动时");
}

@end
