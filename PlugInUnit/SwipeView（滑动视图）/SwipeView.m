//
//  SwipeView.m
//
//  Version 1.3.2
//
//  Created by Nick Lockwood on 03/09/2010.
//  Copyright 2010 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version of SwipeView from here:
//
//  https://github.com/nicklockwood/SwipeView
//


#import "SwipeView.h"
#import <objc/message.h>

#pragma GCC diagnostic ignored "-Wdirect-ivar-access"
#pragma GCC diagnostic ignored "-Warc-repeated-use-of-weak"
//#pragma GCC diagnostic ignored "-Wreceiver-is-weak"
#pragma GCC diagnostic ignored "-Wconversion"
#pragma GCC diagnostic ignored "-Wselector"
#pragma GCC diagnostic ignored "-Wgnu"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation NSObject (SwipeView)

///返回滑动视图项目大小的默认实现
- (CGSize)swipeViewItemSize:(__unused SwipeView*)swipeView {
    return CGSizeZero;
}
///当scrollView的contentOffset改变时调用的默认实现
- (void)swipeViewDidScroll:(__unused SwipeView*)swipeView {
}
///当前项目索引更新时调用的默认实现
- (void)swipeViewCurrentItemIndexDidChange:(__unused SwipeView*)swipeView {
}
///当开始滚动视图时，执行方法的默认实现
- (void)swipeViewWillBeginDragging:(__unused SwipeView*)swipeView {
}
///滑动视图，当手指离开时的默认实现
- (void)swipeViewDidEndDragging:(__unused SwipeView*)swipeView
                 willDecelerate:(__unused BOOL)decelerate {
}
///滑动减速时调用方法的默认实现
- (void)swipeViewWillBeginDecelerating:(__unused SwipeView*)swipeView {
}
///滚动视图减速完成，滚动将停止时，调用方法的默认实现
- (void)swipeViewDidEndDecelerating:(__unused SwipeView*)swipeView {
}
///滑动视图结束滚动时执行方法的默认实现
- (void)swipeViewDidEndScrollingAnimation:(__unused SwipeView*)swipeView {
}
///该索引处的项目是否选中的默认实现
- (BOOL)swipeView:(__unused SwipeView*)swipeView shouldSelectItemAtIndex:(__unused NSInteger)index {
    return YES;
}
///滑动视图点击事件的默认实现
- (void)swipeView:(__unused SwipeView*)swipeView didSelectItemAtIndex:(__unused NSInteger)index {
}

@end

@interface SwipeView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;//滚动视图
@property (nonatomic, strong) NSMutableDictionary* itemViews;//项目视图字典
@property (nonatomic, strong) NSMutableSet* itemViewPool;//项目视图池
@property (nonatomic, assign) NSInteger previousItemIndex;//上一项目的索引
@property (nonatomic, assign) CGPoint previousContentOffset;//上一个内容偏移
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) BOOL suppressScrollEvent;
@property (nonatomic, assign) NSTimeInterval scrollDuration;//滚动持续时间
@property (nonatomic, assign, getter=isScrolling) BOOL scrolling;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) CGFloat startOffset;
@property (nonatomic, assign) CGFloat endOffset;
@property (nonatomic, assign) CGFloat lastUpdateOffset;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation SwipeView

#pragma mark -
#pragma mark Initialisation

///设置
- (void)setUp {
    //初始化属性值
    _scrollEnabled = YES;  //默认允许滚动
    _pagingEnabled = YES;  //默认启用分页
    _delaysContentTouches = YES;  //默认延迟响应触摸事件
    _bounces = YES;  //默认有弹簧效果
    _wrapEnabled = NO;  //默认不轮询
    _itemsPerPage = 1;  //每页的项目数为1
    _truncateFinalPage = NO;  //不截断最后一页
    _defersItemViewLoading = NO;  //不延迟视图加载
    _vertical = NO; //不垂直滚动
    //初始化滚动视图
    _scrollView = [[UIScrollView alloc] init];
    //autoresizingMask 该属性用于自动调节子控件在父控件中的位置和宽高。枚举类型。默认是UIViewAutoresizingNone
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //autoresizesSubviews 属性声明被设置为YES，则其子视图会根据autoresizingMask属性的值自动进行尺寸调整
    _scrollView.autoresizesSubviews = YES;
    //设置代理
    _scrollView.delegate = self;
    //delaysContentTouches 默认值为YES。如果设置为NO，则会立即把触摸事件传递给subView
    _scrollView.delaysContentTouches = _delaysContentTouches;
    //bounces 是否有弹簧效果
    _scrollView.bounces = _bounces && !_wrapEnabled;
    //alwaysBounceHorizontal 总是水平反弹
    _scrollView.alwaysBounceHorizontal = !_vertical && _bounces;
    //alwaysBounceVertical 总是垂直反弹
    _scrollView.alwaysBounceVertical = _vertical && _bounces;
    //pagingEnabled 是否启动分页
    _scrollView.pagingEnabled = _pagingEnabled;
    //scrollEnabled 是否允许滚动
    _scrollView.scrollEnabled = _scrollEnabled;
    //decelerationRate 手势滑动的减速率
    _scrollView.decelerationRate = _decelerationRate;
    //showsHorizontalScrollIndicator 是否显示水平方向的滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    //showsVerticalScrollIndicator 是否显示垂直方向的滚动条
    _scrollView.showsVerticalScrollIndicator = NO;
    //scrollsToTop 触摸状态栏，视图是否自动滚动的最顶端，默认值YES，多个滚动视图的话，要确保只有一个滚动视图scrollsToTop的值为YES
    _scrollView.scrollsToTop = NO;
    //clipsToBounds 是否裁剪超出父视图范围的子视图部分
    _scrollView.clipsToBounds = NO;
    //手势滑动的减速率
    _decelerationRate = _scrollView.decelerationRate;
    //初始化项目视图字典
    _itemViews = [[NSMutableDictionary alloc] init];
    //上一项目的索引为0
    _previousItemIndex = 0;
    //上一个内容偏移量
    _previousContentOffset = _scrollView.contentOffset;
    //默认滚动偏移量为0.0f
    _scrollOffset = 0.0f;
    //当前项目索引的索引为0
    _currentItemIndex = 0;
    //滑动视图项目数为0
    _numberOfItems = 0;
    
    //UITapGestureRecognizer 手势识别器对象
    UITapGestureRecognizer* tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (didTap:)];
    //设置代理
    tapGesture.delegate = self;
    //addGestureRecognizer 添加手势识别器到对应的view上
    [_scrollView addGestureRecognizer:tapGesture];
    //裁剪超出父视图范围的子视图部分
    self.clipsToBounds = YES;
    
    // 将ScrollView置于层次结构的底部
    [self insertSubview:_scrollView atIndex:0];
    //如果当前数据源对象存在
    if (_dataSource) {
        //重新加载数据
        [self reloadData];
    }
}

///初始化函数
- (id)initWithCoder:(NSCoder*)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setUp];
    }
    return self;
}

///初始化函数
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUp];
    }
    return self;
}

///释放接收器占用的内存
- (void)dealloc {
    //停止计时器的再次触发并请求将其从运行循环中移除。
    [_timer invalidate];
}

///设置数据源
- (void)setDataSource:(id<SwipeViewDataSource>)dataSource {
    //如果当前的数据源对象不等于设置的数据源对象
    if (_dataSource != dataSource) {
        //将设置的数据源对象赋值到当前的数据源对象
        _dataSource = dataSource;
        //如果当前数据源对象存在
        if (_dataSource) {
            //重新加载数据
            [self reloadData];
        }
    }
}

///设置代理
- (void)setDelegate:(id<SwipeViewDelegate>)delegate {
    //如果当前的代理对象不等于设置的代理对象
    if (_delegate != delegate) {
        //将设置的代理对象赋值到当前的代理对象
        _delegate = delegate;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
    }
}

///设置对齐方式
- (void)setAlignment:(SwipeViewAlignment)alignment {
    //如果当前的对齐方式的值不等于设置的对齐方式的值
    if (_alignment != alignment) {
        //将设置的对齐方式的值赋值到当前的对齐方式的值
        _alignment = alignment;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
    }
}

///设置每页的项目数（一页翻过几个项目）
- (void)setItemsPerPage:(NSInteger)itemsPerPage {
    //如果当前的每页的项目数的值不等于设置的每页的项目数的值
    if (_itemsPerPage != itemsPerPage) {
        //将设置的每页的项目数的值赋值到当前的每页的项目数的值
        _itemsPerPage = itemsPerPage;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
    }
}

///设置是否截断最后一页
- (void)setTruncateFinalPage:(BOOL)truncateFinalPage {
    //如果当前的是否截断最后一页的值不等于设置的是否截断最后一页的值
    if (_truncateFinalPage != truncateFinalPage) {
        //将设置的是否截断最后一页的值赋值到当前的是否截断最后一页的值
        _truncateFinalPage = truncateFinalPage;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
    }
}

///设置是否允许滚动
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    //如果当前的是否允许滚动的值不等于设置的是否允许滚动的值
    if (_scrollEnabled != scrollEnabled) {
        //将设置的是否允许滚动的值赋值到当前的是否允许滚动的值
        _scrollEnabled = scrollEnabled;
        //设置滚动视图是否允许滚动
        _scrollView.scrollEnabled = _scrollEnabled;
    }
}

///设置是否启动分页
- (void)setPagingEnabled:(BOOL)pagingEnabled {
    //如果当前的是否启动分页的值不等于设置的是否启动分页的值
    if (_pagingEnabled != pagingEnabled) {
        //将设置的是否启动分页的值赋值到当前的是否启动分页的值
        _pagingEnabled = pagingEnabled;
        //设置滚动视图是否启动分页
        _scrollView.pagingEnabled = pagingEnabled;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
    }
}

///设置是否轮询
- (void)setWrapEnabled:(BOOL)wrapEnabled {
    //如果当前的是否轮询的值不等于设置的是否轮询的值
    if (_wrapEnabled != wrapEnabled) {
        //上一偏移量
        CGFloat previousOffset = [self clampedOffset:_scrollOffset];
        //将设置的是否轮询的值赋值到当前的是否轮询的值
        _wrapEnabled = wrapEnabled;
        //设置滚动视图是否有弹簧效果
        _scrollView.bounces = _bounces && !_wrapEnabled;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
        //如果布局更新挂起，则立即布局子视图。使用此方法强制视图立即更新其布局。
        [self layoutIfNeeded];
        //设置滚动偏移量
        self.scrollOffset = previousOffset;
    }
}

///设置是否延迟响应触摸事件
- (void)setDelaysContentTouches:(BOOL)delaysContentTouches {
    //将设置的是否延迟响应触摸事件的值赋值到当前的是否延迟响应触摸事件的值
    _delaysContentTouches = delaysContentTouches;
    //设置滚动视图是否延迟响应触摸事件
    _scrollView.delaysContentTouches = delaysContentTouches;
}

///设置弹簧效果（不轮询时有效）
- (void)setBounces:(BOOL)bounces {
    //如果当前的是否有弹簧效果的值不等于设置的是否有弹簧效果的值
    if (_bounces != bounces) {
        //将设置的是否有弹簧效果的值赋值到当前的是否有弹簧效果的值
        _bounces = bounces;
        //设置滚动视图水平滚动到达内容视图的结尾时是否始终发生反弹
        _scrollView.alwaysBounceHorizontal = !_vertical && _bounces;
        //设置滚动视图垂直滚动到达内容视图的结尾时是否始终发生反弹
        _scrollView.alwaysBounceVertical = _vertical && _bounces;
        //设置滚动视图的弹簧效果
        _scrollView.bounces = _bounces && !_wrapEnabled;
    }
}

///设置手势滑动的减速率
- (void)setDecelerationRate:(float)decelerationRate {
    //fabsf(float i) ： 处理float类型的取绝对值
    //如果当前手势滑动的减速率减去设置的手势滑动的减速率的绝对值大于0.0001
    if (fabsf (_decelerationRate - decelerationRate) > 0.0001f) {
        //将设置的手势滑动的减速率的值赋值到当前的手势滑动的减速率的值
        _decelerationRate = decelerationRate;
        //设置滚动视图的手势滑动的减速率
        _scrollView.decelerationRate = _decelerationRate;
    }
}

///设置自动返回（数值越大返回动画越快）
- (void)setAutoscroll:(CGFloat)autoscroll {
    //fabs(double x) ：处理double类型的取绝对值
    //如果当前自动返回的值减去设置的自动返回的值的绝对值大于0.0001
    if (fabs (_autoscroll - autoscroll) > 0.0001f) {
        //将设置的自动返回的值赋值到当前的自动返回的值
        _autoscroll = autoscroll;
        if (autoscroll)
            //开始动画
            [self startAnimation];
    }
}

///设置是否垂直滚动
- (void)setVertical:(BOOL)vertical {
    //如果当前的是否垂直滚动的值不等于设置的是否垂直滚动的值
    if (_vertical != vertical) {
        //将设置的是否有垂直滚动的值赋值到当前的是否垂直滚动的值
        _vertical = vertical;
        //设置滚动视图水平滚动到达内容视图的结尾时是否始终发生反弹
        _scrollView.alwaysBounceHorizontal = !_vertical && _bounces;
        //设置滚动视图垂直滚动到达内容视图的结尾时是否始终发生反弹
        _scrollView.alwaysBounceVertical = _vertical && _bounces;
        //使接收器的当前布局无效，并在下一个更新周期中触发布局更新
        [self setNeedsLayout];
    }
}

///用户是否已经开始滚动内容
- (BOOL)isDragging {
    return _scrollView.dragging;
}

///滚动视图是否正在减速
- (BOOL)isDecelerating {
    return _scrollView.decelerating;
}

#pragma mark -
#pragma mark View management
///返回可见项的索引
- (NSArray*)indexesForVisibleItems {
    //sortedArrayUsingSelector: 方法可以对字符串简单排序
    //compare: IOS提供的字符串比较方法，在没有制定比较的范围的情况下，那么这个compare只会默认比较第一个字符，也就是25并不大于3
    return [[_itemViews allKeys] sortedArrayUsingSelector:@selector (compare:)];
}

///返回可见项视图
- (NSArray*)visibleItemViews {
    NSArray* indexes = [self indexesForVisibleItems];
    //objectsForKeys:notFoundMarker: 没有对应的value的时候设置特定的mark.
    return [_itemViews objectsForKeys:indexes notFoundMarker:[NSNull null]];
}

///返回索引处的项目视图
- (UIView*)itemViewAtIndex:(NSInteger)index {
    return _itemViews[@(index)];
}

///返回当前项目视图
- (UIView*)currentItemView {
    return [self itemViewAtIndex:_currentItemIndex];
}

///返回项目视图索引
- (NSInteger)indexOfItemView:(UIView*)view {
    NSUInteger index = [[_itemViews allValues] indexOfObject:view];
    //NSNotFound 表示一个整型不存在
    if (index != NSNotFound) {
        return [[_itemViews allKeys][index] integerValue];
    }
    return NSNotFound;
}

///返回项目视图或子视图的索引
- (NSInteger)indexOfItemViewOrSubview:(UIView*)view {
    NSInteger index = [self indexOfItemView:view];
    if (index == NSNotFound && view != nil && view != _scrollView) {
        return [self indexOfItemViewOrSubview:view.superview];
    }
    return index;
}

///设置索引的项视图
- (void)setItemView:(UIView*)view forIndex:(NSInteger)index {
    ((NSMutableDictionary*)_itemViews)[@(index)] = view;
}

#pragma mark -
#pragma mark View layout
///更新滚动偏移量
- (void)updateScrollOffset {
    if (_wrapEnabled) {
        CGFloat itemsWide = (_numberOfItems == 1) ? 1.0f : 3.0f;
        if (_vertical) {
            CGFloat scrollHeight = _scrollView.contentSize.height / itemsWide;
            if (_scrollView.contentOffset.y < scrollHeight) {
                _previousContentOffset.y += scrollHeight;
                [self setContentOffsetWithoutEvent:CGPointMake (0.0f, _scrollView.contentOffset.y + scrollHeight)];
            } else if (_scrollView.contentOffset.y >= scrollHeight * 2.0f) {
                _previousContentOffset.y -= scrollHeight;
                [self setContentOffsetWithoutEvent:CGPointMake (0.0f, _scrollView.contentOffset.y - scrollHeight)];
            }
            _scrollOffset = [self clampedOffset:_scrollOffset];
        } else {
            CGFloat scrollWidth = _scrollView.contentSize.width / itemsWide;
            if (_scrollView.contentOffset.x < scrollWidth) {
                _previousContentOffset.x += scrollWidth;
                [self setContentOffsetWithoutEvent:CGPointMake (_scrollView.contentOffset.x + scrollWidth, 0.0f)];
            } else if (_scrollView.contentOffset.x >= scrollWidth * 2.0f) {
                _previousContentOffset.x -= scrollWidth;
                [self setContentOffsetWithoutEvent:CGPointMake (_scrollView.contentOffset.x - scrollWidth, 0.0f)];
            }
            _scrollOffset = [self clampedOffset:_scrollOffset];
        }
    }
    if (_vertical && fabs (_scrollView.contentOffset.x) > 0.0001f) {
        [self setContentOffsetWithoutEvent:CGPointMake (0.0f, _scrollView.contentOffset.y)];
    } else if (!_vertical && fabs (_scrollView.contentOffset.y) > 0.0001f) {
        [self setContentOffsetWithoutEvent:CGPointMake (_scrollView.contentOffset.x, 0.0f)];
    }
}

//更新滚动视图大小
- (void)updateScrollViewDimensions {
    CGRect frame = self.bounds;
    CGSize contentSize = frame.size;
    
    if (_vertical) {
        contentSize.width -= (_scrollView.contentInset.left + _scrollView.contentInset.right);
    } else {
        contentSize.height -= (_scrollView.contentInset.top + _scrollView.contentInset.bottom);
    }
    
    switch (_alignment) {
        case SwipeViewAlignmentCenter: {
            if (_vertical) {
                frame = CGRectMake (0.0f, (self.bounds.size.height - _itemSize.height * _itemsPerPage) / 2.0f,
                                    self.bounds.size.width, _itemSize.height * _itemsPerPage);
                contentSize.height = _itemSize.height * _numberOfItems;
            } else {
                frame = CGRectMake ((self.bounds.size.width - _itemSize.width * _itemsPerPage) / 2.0f,
                                    0.0f, _itemSize.width * _itemsPerPage, self.bounds.size.height);
                contentSize.width = _itemSize.width * _numberOfItems;
            }
            break;
        }
        case SwipeViewAlignmentEdge: {
            if (_vertical) {
                frame = CGRectMake (0.0f, 0.0f, self.bounds.size.width, _itemSize.height * _itemsPerPage);
                contentSize.height =
                _itemSize.height * _numberOfItems - (self.bounds.size.height - frame.size.height);
            } else {
                frame = CGRectMake (0.0f, 0.0f, _itemSize.width * _itemsPerPage, self.bounds.size.height);
                contentSize.width = _itemSize.width * _numberOfItems - (self.bounds.size.width - frame.size.width);
            }
            break;
        }
    }
    
    if (_wrapEnabled) {
        CGFloat itemsWide = (_numberOfItems == 1) ? 1.0f : _numberOfItems * 3.0f;
        if (_vertical) {
            contentSize.height = _itemSize.height * itemsWide;
        } else {
            contentSize.width = _itemSize.width * itemsWide;
        }
    } else if (_pagingEnabled && !_truncateFinalPage) {
        if (_vertical) {
            contentSize.height = ceilf (contentSize.height / frame.size.height) * frame.size.height;
        } else {
            contentSize.width = ceilf (contentSize.width / frame.size.width) * frame.size.width;
        }
    }
    
    if (!CGRectEqualToRect (_scrollView.frame, frame)) {
        _scrollView.frame = frame;
    }
    
    if (!CGSizeEqualToSize (_scrollView.contentSize, contentSize)) {
        _scrollView.contentSize = contentSize;
    }
}

///返回索引处项目的偏移量
- (CGFloat)offsetForItemAtIndex:(NSInteger)index {
    // 计算相对位置
    CGFloat offset = index - _scrollOffset;
    if (_wrapEnabled) {
        if (_alignment == SwipeViewAlignmentCenter) {
            if (offset > _numberOfItems / 2) {
                offset -= _numberOfItems;
            } else if (offset < -_numberOfItems / 2) {
                offset += _numberOfItems;
            }
        } else {
            CGFloat width = _vertical ? self.bounds.size.height : self.bounds.size.width;
            CGFloat x = _vertical ? _scrollView.frame.origin.y : _scrollView.frame.origin.x;
            CGFloat itemWidth = _vertical ? _itemSize.height : _itemSize.width;
            if (offset * itemWidth + x > width) {
                offset -= _numberOfItems;
            } else if (offset * itemWidth + x < -itemWidth) {
                offset += _numberOfItems;
            }
        }
    }
    return offset;
}

///为视图设置Frame
- (void)setFrameForView:(UIView*)view atIndex:(NSInteger)index {
    if (self.window) {
        CGPoint center = view.center;
        if (_vertical) {
            center.y = ([self offsetForItemAtIndex:index] + 0.5f) * _itemSize.height +
            _scrollView.contentOffset.y;
        } else {
            center.x = ([self offsetForItemAtIndex:index] + 0.5f) * _itemSize.width +
            _scrollView.contentOffset.x;
        }
        
        BOOL disableAnimation = !CGPointEqualToPoint (center, view.center);
        BOOL animationEnabled = [UIView areAnimationsEnabled];
        if (disableAnimation && animationEnabled)
            [UIView setAnimationsEnabled:NO];
        
        if (_vertical) {
            view.center = CGPointMake (_scrollView.frame.size.width / 2.0f, center.y);
        } else {
            view.center = CGPointMake (center.x, _scrollView.frame.size.height / 2.0f);
        }
        
        view.bounds = CGRectMake (0.0f, 0.0f, _itemSize.width, _itemSize.height);
        
        if (disableAnimation && animationEnabled)
            [UIView setAnimationsEnabled:YES];
    }
}

///布局项目视图
- (void)layOutItemViews {
    for (UIView* view in self.visibleItemViews) {
        [self setFrameForView:view atIndex:[self indexOfItemView:view]];
    }
}

///更新布局
- (void)updateLayout {
    [self updateScrollOffset];
    [self loadUnloadViews];
    [self layOutItemViews];
}

///布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateItemSizeAndCount];
    [self updateScrollViewDimensions];
    [self updateLayout];
    if (_pagingEnabled && !_scrolling) {
        [self scrollToItemAtIndex:self.currentItemIndex duration:0.25];
    }
}

#pragma mark -
#pragma mark View queing
///队列项目视图
- (void)queueItemView:(UIView*)view {
    if (view) {
        [_itemViewPool addObject:view];
    }
}

///出列项目视图
- (UIView*)dequeueItemView {
    UIView* view = [_itemViewPool anyObject];
    if (view) {
        [_itemViewPool removeObject:view];
    }
    return view;
}

#pragma mark -
#pragma mark Scrolling
///是否滚动
- (void)didScroll {
    // handle wrap
    [self updateScrollOffset];
    
    // 更新视图
    [self layOutItemViews];
    [_delegate swipeViewDidScroll:self];
    
    if (!_defersItemViewLoading ||
        fabs ([self minScrollDistanceFromOffset:_lastUpdateOffset toOffset:_scrollOffset]) >= 1.0f) {
        // 更新项目索引
        // roundf(float) 四舍五入，返回最邻近的整数
        _currentItemIndex = [self clampedIndex:roundf (_scrollOffset)];
        
        // 加载视图
        _lastUpdateOffset = _currentItemIndex;
        [self loadUnloadViews];
        
        // 发送索引更新事件
        if (_previousItemIndex != _currentItemIndex) {
            _previousItemIndex = _currentItemIndex;
            [_delegate swipeViewCurrentItemIndexDidChange:self];
        }
    }
}

- (CGFloat)easeInOut:(CGFloat)time {
    //powf(float, float):计算以x为底数的y次幂,输入与输出皆为浮点数
    return (time < 0.5f) ? 0.5f * powf (time * 2.0f, 3.0f) : 0.5f * powf (time * 2.0f - 2.0f, 3.0f) + 1.0f;
}

///视图移动
- (void)step {
    //CFAbsoluteTimeGetCurrent() 返回的时钟时间将会网络时间同步
    NSTimeInterval currentTime = CFAbsoluteTimeGetCurrent ();
    double delta = _lastTime - currentTime;
    _lastTime = currentTime;
    
    if (_scrolling) {
        NSTimeInterval time = fminf (1.0f, (currentTime - _startTime) / _scrollDuration);
        delta = [self easeInOut:time];
        _scrollOffset = [self clampedOffset:_startOffset + (_endOffset - _startOffset) * delta];
        if (_vertical) {
            [self setContentOffsetWithoutEvent:CGPointMake (0.0f, _scrollOffset * _itemSize.height)];
        } else {
            [self setContentOffsetWithoutEvent:CGPointMake (_scrollOffset * _itemSize.width, 0.0f)];
        }
        [self didScroll];
        if (time == 1.0f) {
            _scrolling = NO;
            [self didScroll];
            [_delegate swipeViewDidEndScrollingAnimation:self];
        }
    } else if (_autoscroll) {
        if (!_scrollView.dragging)
            self.scrollOffset = [self clampedOffset:_scrollOffset + delta * _autoscroll];
    } else {
        [self stopAnimation];
    }
}

///开始动画
//NSRunLoop运行循环
/**
 Runloop状态:
 1.NSDefaultRunLoopMode:默认状态(空闲状态)，比如点击按钮都是这个状态
 2.UITrackingRunLoopMode:滑动时的Mode。比如滑动UIScrollView时。
 3.UIInitializationRunLoopMode:私有的，APP启动时。就是从iphone桌面点击APP的图标进入APP到第一个界面展示之前，在第一个界面显示出来后，UIInitializationRunLoopMode就被切换成了NSDefaultRunLoopMode。
 4.NSRunLoopCommonModes:它是NSDefaultRunLoopMode和UITrackingRunLoopMode的集合。结构类似于一个数组。在这个mode下执行其实就是两个mode都能执行而已。
 典型的应用场景这样：当前界面有开启一个NSTimer，并且滑动UIScrollView。正常开启NSTimer后，滑动UIScrollView时它是不滑动的。解决办法就是把这个timer加入到当前的RunLoop，并把RunLoop的mode设置为NSRunLoopCommonModes。这样就可以保证不管你是NSDefaultRunLoopMode里跑，还是UITrackingRunLoopMode里跑，这个timer都可以执行。
 */
- (void)startAnimation {
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:1.0 / 60.0
                                             target:self
                                           selector:@selector (step)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

///停止动画
- (void)stopAnimation {
    [_timer invalidate];
    self.timer = nil;
}

///固定索引
- (NSInteger)clampedIndex:(NSInteger)index {
    if (_wrapEnabled) {
        return _numberOfItems ? (index - floorf ((CGFloat)index / (CGFloat)_numberOfItems) * _numberOfItems) : 0;
    } else {
        return MIN (MAX (0, index), MAX (0, _numberOfItems - 1));
    }
}

///返回固定的偏移量
- (CGFloat)clampedOffset:(CGFloat)offset {
    //设置返回值为0
    CGFloat returnValue = 0;
    //如果是轮询状态
    if (_wrapEnabled) {
        //floorf(float)向下取整,返回不大于自变量的最大整数
        returnValue =
        _numberOfItems ? (offset - floorf (offset / (CGFloat)_numberOfItems) * _numberOfItems) : 0.0f;
    } else {
        //fminf(float, float)求最小值
        //fmaxf(float, float)求最大值
        returnValue = fminf (fmaxf (0.0f, offset), fmaxf (0.0f, (CGFloat)_numberOfItems - 1.0f));
    }
    return returnValue;
}

///设置不带事件的内容偏移量
- (void)setContentOffsetWithoutEvent:(CGPoint)contentOffset {
    if (!CGPointEqualToPoint (_scrollView.contentOffset, contentOffset)) {
        //areAnimationsEnabled 返回一个布尔值表示动画是否结束,动画结束返回YES,否则NO
        BOOL animationEnabled = [UIView areAnimationsEnabled];
        //setAnimationsEnabled: 设置是否激活动画
        if (animationEnabled)
            [UIView setAnimationsEnabled:NO];
        _suppressScrollEvent = YES;
        _scrollView.contentOffset = contentOffset;
        _suppressScrollEvent = NO;
        if (animationEnabled)
            [UIView setAnimationsEnabled:YES];
    }
}

///返回当前页
- (NSInteger)currentPage {
    if (_itemsPerPage > 1 && _truncateFinalPage && !_wrapEnabled &&
        _currentItemIndex > (_numberOfItems / _itemsPerPage - 1) * _itemsPerPage) {
        return self.numberOfPages - 1;
    }
    return roundf ((float)_currentItemIndex / (float)_itemsPerPage);
}

///返回页数
- (NSInteger)numberOfPages {
    //ceilf(float) 向上取整,返回不小于自变量的最大整数
    return ceilf ((float)self.numberOfItems / (float)_itemsPerPage);
}

- (NSInteger)minScrollDistanceFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSInteger directDistance = toIndex - fromIndex;
    if (_wrapEnabled) {
        NSInteger wrappedDistance = MIN (toIndex, fromIndex) + _numberOfItems - MAX (toIndex, fromIndex);
        if (fromIndex < toIndex) {
            wrappedDistance = -wrappedDistance;
        }
        return (ABS (directDistance) <= ABS (wrappedDistance)) ? directDistance : wrappedDistance;
    }
    return directDistance;
}

///最小滚动距离偏移量
- (CGFloat)minScrollDistanceFromOffset:(CGFloat)fromOffset toOffset:(CGFloat)toOffset {
    CGFloat directDistance = toOffset - fromOffset;
    if (_wrapEnabled) {
        CGFloat wrappedDistance = fminf (toOffset, fromOffset) + _numberOfItems - fmaxf (toOffset, fromOffset);
        if (fromOffset < toOffset) {
            wrappedDistance = -wrappedDistance;
        }
        //fabs(double) 处理double类型的取绝对值
        return (fabs (directDistance) <= fabs (wrappedDistance)) ? directDistance : wrappedDistance;
    }
    return directDistance;
}

///设置当前项目索引
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex {
    _currentItemIndex = currentItemIndex;
    self.scrollOffset = currentItemIndex;
}

///设置当前页
- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage * _itemsPerPage != _currentItemIndex) {
        [self scrollToPage:currentPage duration:0.5f];
    }
}

///设置滚动偏移量
- (void)setScrollOffset:(CGFloat)scrollOffset {
    if (fabs (_scrollOffset - scrollOffset) > 0.0001f) {
        _scrollOffset = scrollOffset;
        _lastUpdateOffset = _scrollOffset - 1.0f; // force refresh
        _scrolling = NO; // stop scrolling
        [self updateItemSizeAndCount];
        [self updateScrollViewDimensions];
        [self updateLayout];
        CGPoint contentOffset =
        _vertical ? CGPointMake (0.0f, [self clampedOffset:scrollOffset] * _itemSize.height) :
        CGPointMake ([self clampedOffset:scrollOffset] * _itemSize.width, 0.0f);
        [self setContentOffsetWithoutEvent:contentOffset];
        [self didScroll];
    }
}

///在指定时间按偏移量滚动
- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration {
    if (duration > 0.0) {
        _scrolling = YES;
        _startTime = [[NSDate date] timeIntervalSinceReferenceDate];
        _startOffset = _scrollOffset;
        _scrollDuration = duration;
        _endOffset = _startOffset + offset;
        if (!_wrapEnabled) {
            _endOffset = [self clampedOffset:_endOffset];
        }
        [self startAnimation];
    } else {
        self.scrollOffset += offset;
    }
}
///在指定时间滚动到指定偏移量
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration {
    [self scrollByOffset:[self minScrollDistanceFromOffset:_scrollOffset toOffset:offset]
                duration:duration];
}

///在指定时间按项目数滚动
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration {
    if (duration > 0.0) {
        CGFloat offset = 0.0f;
        if (itemCount > 0) {
            offset = (floorf (_scrollOffset) + itemCount) - _scrollOffset;
        } else if (itemCount < 0) {
            offset = (ceilf (_scrollOffset) + itemCount) - _scrollOffset;
        } else {
            offset = roundf (_scrollOffset) - _scrollOffset;
        }
        [self scrollByOffset:offset duration:duration];
    } else {
        self.scrollOffset = [self clampedIndex:_previousItemIndex + itemCount];
    }
}

///在指定时间滚动到索引处的项目
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration {
    [self scrollToOffset:index duration:duration];
}

///在指定时间滚动到滚动到指定页面
- (void)scrollToPage:(NSInteger)page duration:(NSTimeInterval)duration {
    NSInteger index = page * _itemsPerPage;
    if (_truncateFinalPage) {
        index = MIN (index, _numberOfItems - _itemsPerPage);
    }
    [self scrollToItemAtIndex:index duration:duration];
}

#pragma mark -
#pragma mark View loading
///在索引处加载视图
- (UIView*)loadViewAtIndex:(NSInteger)index {
    UIView* view =
    [_dataSource swipeView:self viewForItemAtIndex:index reusingView:[self dequeueItemView]];
    if (view == nil) {
        view = [[UIView alloc] init];
    }
    
    UIView* oldView = [self itemViewAtIndex:index];
    if (oldView) {
        [self queueItemView:oldView];
        [oldView removeFromSuperview];
    }
    
    [self setItemView:view forIndex:index];
    [self setFrameForView:view atIndex:index];
    view.userInteractionEnabled = YES;
    [_scrollView addSubview:view];
    
    return view;
}

///更新项目大小和计数
- (void)updateItemSizeAndCount {
    // 获取项目数
    _numberOfItems = [_dataSource numberOfItemsInSwipeView:self];
    
    // 获取项目大小
    CGSize size = [_delegate swipeViewItemSize:self];
    if (!CGSizeEqualToSize (size, CGSizeZero)) {
        _itemSize = size;
    } else if (_numberOfItems > 0) {
        UIView* view = [[self visibleItemViews] lastObject] ?: [_dataSource swipeView:self
                                                                   viewForItemAtIndex:0
                                                                          reusingView:[self dequeueItemView]];
        _itemSize = view.frame.size;
    }
    
    // 防止项目相撞
    if (_itemSize.width < 0.0001)
        _itemSize.width = 1;
    if (_itemSize.height < 0.0001)
        _itemSize.height = 1;
}

///加载卸载视图
- (void)loadUnloadViews {
    // 检查项目大小是否已知
    CGFloat itemWidth = _vertical ? _itemSize.height : _itemSize.width;
    if (itemWidth) {
        // 计算偏移量和边界
        CGFloat width = _vertical ? self.bounds.size.height : self.bounds.size.width;
        CGFloat x = _vertical ? _scrollView.frame.origin.y : _scrollView.frame.origin.x;
        
        // 计算范围
        CGFloat startOffset = [self clampedOffset:_scrollOffset - x / itemWidth];
        NSInteger startIndex = floorf (startOffset);
        NSInteger numberOfVisibleItems = ceilf (width / itemWidth + (startOffset - startIndex));
        if (_defersItemViewLoading) {
            startIndex = _currentItemIndex - ceilf (x / itemWidth) - 1;
            numberOfVisibleItems = ceilf (width / itemWidth) + 3;
        }
        
        // 创建索引
        numberOfVisibleItems = MIN (numberOfVisibleItems, _numberOfItems);
        NSMutableSet* visibleIndices = [NSMutableSet setWithCapacity:numberOfVisibleItems];
        for (NSInteger i = 0; i < numberOfVisibleItems; i++) {
            NSInteger index = [self clampedIndex:i + startIndex];
            [visibleIndices addObject:@(index)];
        }
        
        // 删除屏幕外视图
        for (NSNumber* number in [_itemViews allKeys]) {
            if (![visibleIndices containsObject:number]) {
                UIView* view = _itemViews[number];
                [self queueItemView:view];
                [view removeFromSuperview];
                [_itemViews removeObjectForKey:number];
            }
        }
        
        // 添加屏幕视图
        for (NSNumber* number in visibleIndices) {
            UIView* view = _itemViews[number];
            if (view == nil) {
                [self loadViewAtIndex:[number integerValue]];
            }
        }
    }
}

///在索引处重新加载项目
- (void)reloadItemAtIndex:(NSInteger)index {
    // 如果视图可见
    if ([self itemViewAtIndex:index]) {
        // 重新加载视图
        [self loadViewAtIndex:index];
    }
}

///重新加载数据
- (void)reloadData {
    // 删除旧视图
    for (UIView* view in self.visibleItemViews) {
        [view removeFromSuperview];
    }
    
    // 重置视图池
    self.itemViews = [NSMutableDictionary dictionary];
    self.itemViewPool = [NSMutableSet set];
    
    // 获取项目数
    [self updateItemSizeAndCount];
    
    // 布局视图
    [self setNeedsLayout];
    
    // 固定滚动偏移
    if (_numberOfItems > 0 && _scrollOffset < 0.0f) {
        self.scrollOffset = 0;
    }
}
/**
 系统通过-(UIView )hitTest:(CGPoint)point withEvent:(UIEvent )event方法来寻找最合适响应事件的view
 (UIView )hitTest:(CGPoint)point withEvent:(UIEvent )event内部实现：
 - 1 自己是否能接收触摸事件？
 - 2 触摸点是否在自己身上？
 - 3 从后往前遍历子控件，重复前面的两个步骤
 - 4 如果没有符合条件的子控件，那么就自己最适合处理
 */

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView* view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        for (UIView* subview in _scrollView.subviews) {
            CGPoint offset = CGPointMake (point.x - _scrollView.frame.origin.x +
                                          _scrollView.contentOffset.x - subview.frame.origin.x,
                                          point.y - _scrollView.frame.origin.y +
                                          _scrollView.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return _scrollView;
    }
    return view;
}

///是否移至SuperView
- (void)didMoveToSuperview {
    if (self.superview) {
        [self setNeedsLayout];
        if (_scrolling) {
            [self startAnimation];
        }
    } else {
        [self stopAnimation];
    }
}

#pragma mark Gestures and taps
///返回视图或父视图索引
- (NSInteger)viewOrSuperviewIndex:(UIView*)view {
    if (view == nil || view == _scrollView) {
        return NSNotFound;
    }
    NSInteger index = [self indexOfItemView:view];
    if (index == NSNotFound) {
        return [self viewOrSuperviewIndex:view.superview];
    }
    return index;
}

///是否触摸视图或父视图
- (BOOL)viewOrSuperviewHandlesTouches:(UIView*)view {
    // thanks to @mattjgalloway and @shaps for idea
    // https://gist.github.com/mattjgalloway/6279363
    // https://gist.github.com/shaps80/6279008
    
    Class class = [view class];
    while (class && class != [UIView class]) {
        unsigned int numberOfMethods;
        Method* methods = class_copyMethodList (class, &numberOfMethods);
        for (unsigned int i = 0; i < numberOfMethods; i++) {
            if (method_getName (methods[i]) == @selector (touchesBegan:withEvent:)) {
                free (methods);
                return YES;
            }
        }
        if (methods)
            free (methods);
        class = [class superclass];
    }
    
    if (view.superview && view.superview != _scrollView) {
        return [self viewOrSuperviewHandlesTouches:view.superview];
    }
    
    return NO;
}

///手势识别器响应触摸
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gesture shouldReceiveTouch:(UITouch*)touch {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        // handle tap
        NSInteger index = [self viewOrSuperviewIndex:touch.view];
        if (index != NSNotFound) {
            if ((_delegate && ![_delegate swipeView:self shouldSelectItemAtIndex:index]) ||
                [self viewOrSuperviewHandlesTouches:touch.view]) {
                return NO;
            } else {
                return YES;
            }
        }
    }
    return NO;
}

///是否点击
- (void)didTap:(UITapGestureRecognizer*)tapGesture {
    CGPoint point = [tapGesture locationInView:_scrollView];
    NSInteger index = _vertical ? (point.y / (_itemSize.height)) : (point.x / (_itemSize.width));
    if (_wrapEnabled) {
        index = index % _numberOfItems;
    }
    if (index >= 0 && index < _numberOfItems) {
        [_delegate swipeView:self didSelectItemAtIndex:index];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

///当scrollView的contentOffset改变时调用。
- (void)scrollViewDidScroll:(__unused UIScrollView*)scrollView {
    if (!_suppressScrollEvent) {
        // 停止滚动动画
        _scrolling = NO;
        
        // 更新滚动偏移量
        CGFloat delta = _vertical ? (_scrollView.contentOffset.y - _previousContentOffset.y) :
        (_scrollView.contentOffset.x - _previousContentOffset.x);
        _previousContentOffset = _scrollView.contentOffset;
        _scrollOffset += delta / (_vertical ? _itemSize.height : _itemSize.width);
        
        // 更新视图并调用委托
        [self didScroll];
    } else {
        _previousContentOffset = _scrollView.contentOffset;
    }
}

///当开始滚动视图时，执行改方法，一次有效滑动只执行一次（开始滑动，滑动一小段距离，只要手指不松开，算一次滑动）
- (void)scrollViewWillBeginDragging:(__unused UIScrollView*)scrollView {
    [_delegate swipeViewWillBeginDragging:self];
    
    // 强制刷新
    _lastUpdateOffset = self.scrollOffset - 1.0f;
    [self didScroll];
}

///滑动视图，当手指离开时，调用该方法，一次有效滑动只执行一次
- (void)scrollViewDidEndDragging:(__unused UIScrollView*)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // force refresh
        _lastUpdateOffset = self.scrollOffset - 1.0f;
        [self didScroll];
    }
    [_delegate swipeViewDidEndDragging:self willDecelerate:decelerate];
}

///滑动减速时调用该方法
- (void)scrollViewWillBeginDecelerating:(__unused UIScrollView*)scrollView {
    [_delegate swipeViewWillBeginDecelerating:self];
}

///滚动视图减速完成，滚动将停止时，调用该方法，一次有效滑动，只执行一次
- (void)scrollViewDidEndDecelerating:(__unused UIScrollView*)scrollView {
    // prevent rounding errors from accumulating
    CGFloat integerOffset = roundf (_scrollOffset);
    if (fabs (_scrollOffset - integerOffset) < 0.01f) {
        _scrollOffset = integerOffset;
    }
    
    // force refresh
    _lastUpdateOffset = self.scrollOffset - 1.0f;
    [self didScroll];
    
    [_delegate swipeViewDidEndDecelerating:self];
}

@end
