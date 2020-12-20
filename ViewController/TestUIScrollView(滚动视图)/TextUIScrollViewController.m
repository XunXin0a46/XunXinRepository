//
//  TextUIScrollViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/5/1.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TextUIScrollViewController.h"

//声明为UIScrollView的代理类
@interface TextUIScrollViewController ()<UIScrollViewDelegate>

//分页视图控件
@property(nonatomic,strong) UIPageControl *pageControl;
//定时器
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation TextUIScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"滚动视图"];
    [self createUI];
}

- (void)createUI{
    //初始化UIScrollWiew大小为屏幕大小
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - HEAD_BAR_HEIGHT)];
    //设置滚动的范围
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 8, CGRectGetHeight(self.view.frame));
    //设置分页效果
    scrollView.pagingEnabled = YES;
    //水平滚动条隐藏
    scrollView.showsHorizontalScrollIndicator = NO;
    //声明图片名称
    NSString *imageName = nil;
    //声明图片
    UIImage *image = nil;
    
    for (int i = 0; i < 8; i++) {
        //为图片名称赋值
        imageName = [NSString stringWithFormat:@"螳螂%d",i + 1];
        //初始化图片
        image= [UIImage imageNamed:imageName];
        //根据宽高比计算图片大小
        CGSize imageSize = resizeForScreen(image.size);
        //初始化图片视图，x轴的坐标在原点随着每次循环增加一个屏幕的宽度，y轴始终为0，宽高为屏幕的宽高
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * i, 0, imageSize.width, imageSize.height)];
        //为图片视图设置图片
        [imageView setImage:image];
        //为每个图片视图设置标签
        imageView.tag = 100 + i;
        //将图片视图添加到滚动视图
        [scrollView addSubview:imageView];
    }
    //viewWithTag的作用就是根据tag属性获取到对应的view、imageview、label等等。
    //获取第一张图片视图
    UIImageView *firstImageView = [scrollView viewWithTag:100];
    //为滚动视图最后面加一个视图，它和第一个视图一样，到这里实际已经有了9张图片视图
    CGSize lastImageSize = resizeForScreen(firstImageView.image.size);
    UIImageView *lastImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * 8, 0, lastImageSize.width, lastImageSize.height)];
    //将第一张图片视图的图片赋值给最后一张图片视图的图片属性
    lastImageView.image = firstImageView.image;
    //将最后一张图片视图添加到滚动视图上
    [scrollView addSubview:lastImageView];
    //将滚动视图添加到控制器视图
    [self.view addSubview:scrollView];
    //为滚动视图添加标签
    scrollView.tag = 100;
    //初始化分页视图控件，并设置好位置
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
    //设置分为多少页
    self.pageControl.numberOfPages = 8;
    //设置当前所在页
    self.pageControl.currentPage = 0;
    //设置页面指示器的颜色（即分页的圆点标记）
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    //设置当前所在页面指示器的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    //将分页视图控件添加到控制器视图
    [self.view addSubview: self.pageControl];
    //初始化定时器，scheduledTimerWithTimeInterval设定间隔时间1.0秒，target指定发送消息给哪个对象，selector指定要调用的方法名，userInfo可以给消息发送参数，repeats设定是否重复
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(circularDisplayView) userInfo:nil repeats:YES];
    //将本类赋值给scrollView的代理属性
    scrollView.delegate = self;
}

//定时器的回调方法，切换页面
-(void)circularDisplayView{
    //得到scrollView
    UIScrollView *scrollView = [self.view viewWithTag:100];
    //通过改变contentOffset来切换滚动视图的子界面
    CGFloat offset_x = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_x +=CGRectGetWidth(self.view.frame);
    //当额外添加的最后一张图片视图开始滚动时，将偏移量改为第一个图片视图的位置
    if(offset_x > CGRectGetWidth(self.view.frame) * 8){
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    //当显示的是额外添加的最后一张图片视图时，将分页控件的当前分页指示器重新开始设置，否则正常显示
    if(offset_x == CGRectGetWidth(self.view.frame) * 8){
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = offset_x / CGRectGetWidth(self.view.frame);
    }
    //设置最终偏移量
    CGPoint finalPoint = CGPointMake(offset_x, 0);
    // 切换视图时带动画效果
    //当额外添加的最后一张图片视图开始滚动时，即相当于第一张图片开始滚动，直接将偏移量设置到第二张图片的位置
    if (offset_x > CGRectGetWidth(self.view.frame) * 8) {
        self.pageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
    }else{
        [scrollView setContentOffset:finalPoint animated:YES];
    }
}

///计算宽高比
CGSize resizeForScreen(CGSize size) {
    //判断参数传递的大小是否等于CGSizeZero
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        //返回CGSizeZero
        return CGSizeZero;
    }
    //获取屏幕的宽度
    CGFloat const displayWidth = [UIScreen mainScreen].bounds.size.width;
    //计算参数传递的大小的宽高比
    CGFloat const ratio = size.width / size.height;   //  宽高比
    //初始化显示尺寸为CGSizeZero
    CGSize displaySize = CGSizeZero;
    //判断宽高比是否是数字
    if (!isnan(ratio)) {
        //计算显示高度
        CGFloat const displayHeight = displayWidth / ratio;
        //设置显示大小
        displaySize = CGSizeMake(displayWidth, displayHeight);
    }
    //返回显示大小
    return displaySize;
}

#pragma mark - 滚动视图的代理方法
//视图被拖拽时调用，在此方法中会暂停控制器，停止图片循环展示
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //setFireDate:设置定时器的启动时间
    //[NSDate distantFuture]：遥远的未来
    [self.timer setFireDate:[NSDate distantFuture]];
}
//视图静止时（没有被拖拽）时调用,在此方法中会开启定时器，让图片循环展示
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //延迟2秒在开启定时器
    //[NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]] 返回值为现在时刻开始在过1.5秒的时刻
    [self.timer setFireDate:[NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]]];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"将要结束滚动");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"结束滚动");
    decelerate = YES;
}

///------------------------------------------ UIScrollView代码测试区 ------------------------------------

- (void)scrollViewCodeTest{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(500, 313);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"宇宙"]];
    [scrollView addSubview:imageView];
    
}

///--------------------------------------- UIScrollView代码测试区结束 -----------------------------------

@end
