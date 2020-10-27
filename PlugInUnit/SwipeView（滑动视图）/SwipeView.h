//
//  SwipeView.h
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
//  滑动视图


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wauto-import"
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <Availability.h>
#undef weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SwipeViewAlignment) {
    ///滑动视图边缘对齐
    SwipeViewAlignmentEdge = 0,
    ///滑动视图居中对齐
    SwipeViewAlignmentCenter
};


@protocol SwipeViewDataSource, SwipeViewDelegate;

@interface SwipeView : UIView
///滑动视图数据源
@property (nonatomic, weak_delegate) IBOutlet id<SwipeViewDataSource> dataSource;
///滑动视图代理
@property (nonatomic, weak_delegate) IBOutlet id<SwipeViewDelegate> delegate;
///滑动视图项目数（只读）
@property (nonatomic, readonly) NSInteger numberOfItems;
///滑动视图所分页数（只读）
@property (nonatomic, readonly) NSInteger numberOfPages;
///滑动视图项目大小(只读)
@property (nonatomic, readonly) CGSize itemSize;
///每页的项目数（一页翻过几个项目）
@property (nonatomic, assign) NSInteger itemsPerPage;
///截断最后一页(到最会一页将阻止轮询)
@property (nonatomic, assign) BOOL truncateFinalPage;
///可见项的索引集合（只读）
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
///可见项视图（只读）
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
///当前项目视图对象
@property (nonatomic, strong, readonly) UIView *currentItemView;
///当前项目索引
@property (nonatomic, assign) NSInteger currentItemIndex;
///当前页
@property (nonatomic, assign) NSInteger currentPage;
///滑动视图对齐方式，枚举
@property (nonatomic, assign) SwipeViewAlignment alignment;
///滚动偏移量
@property (nonatomic, assign) CGFloat scrollOffset;
///是否启动分页
@property (nonatomic, assign, getter = isPagingEnabled) BOOL pagingEnabled;
///是否允许滚动
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;
///是否轮询
@property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;
///是否延迟响应触摸事件
@property (nonatomic, assign) BOOL delaysContentTouches;
///弹簧效果（不轮询时有效）
@property (nonatomic, assign) BOOL bounces;
///手势滑动的减速率
@property (nonatomic, assign) float decelerationRate;
///自动返回（数值越大返回动画越快）
@property (nonatomic, assign) CGFloat autoscroll;
///是否正在拖动（只读）
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
///是否正在减速（只读）
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
///是否正在滚动（只读）
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;
///延迟视图加载
@property (nonatomic, assign) BOOL defersItemViewLoading;
///是否垂直滑动
@property (nonatomic, assign, getter = isVertical) BOOL vertical;

///重新加载数据
- (void)reloadData;
///重新加载某一项
- (void)reloadItemAtIndex:(NSInteger)index;
///在指定时间按偏移量滚动
- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
///在指定时间滚动到指定偏移量
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
///在指定时间按项目数滚动
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
///在指定时间滚动到索引处的项目
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
///在指定时间滚动到滚动到指定页面
- (void)scrollToPage:(NSInteger)page duration:(NSTimeInterval)duration;
///返回索引处的项目视图
- (UIView *)itemViewAtIndex:(NSInteger)index;
///返回项目视图的索引
- (NSInteger)indexOfItemView:(UIView *)view;
///返回项目视图子视图或子视图的索引索引
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;

@end


@protocol SwipeViewDataSource <NSObject>
///滑动视图中的项目数
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView;
///滑动视图中的每一个项目
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

@end


@protocol SwipeViewDelegate <NSObject>
@optional
///滑动视图项目大小
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView;
///当scrollView的contentOffset改变时调用
- (void)swipeViewDidScroll:(SwipeView *)swipeView;
///当前项目索引更新时调用
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView;
///当开始滚动视图时，执行该方法，一次有效滑动只执行一次（开始滑动，滑动一小段距离，只要手指不松开，算一次滑动）
- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView;
///滑动视图，当手指离开时，调用该方法，一次有效滑动只执行一次
- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate;
///滑动减速时调用该方法
- (void)swipeViewWillBeginDecelerating:(SwipeView *)swipeView;
///滚动视图减速完成，滚动将停止时，调用该方法，一次有效滑动，只执行一次
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView;
///滑动视图结束滚动时
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView;
///该索引处的项目是否选中
- (BOOL)swipeView:(SwipeView *)swipeView shouldSelectItemAtIndex:(NSInteger)index;
///滑动视图点击事件
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index;

@end


#pragma GCC diagnostic pop

