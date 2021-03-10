//
//  FSCalendarCollectionView.m
//  FSCalendar
//
//  Created by Wenchao Ding on 10/25/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//
//  Reject -[UIScrollView(UIScrollViewInternal) _adjustContentOffsetIfNecessary]


#import "FSCalendarCollectionView.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarConstants.h"

@interface FSCalendarCollectionView ()

- (void)initialize;

@end

///日历集合视图(继承自UICollectionView)
@implementation FSCalendarCollectionView

@synthesize scrollsToTop = _scrollsToTop, contentInset = _contentInset;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //关闭“滚动到顶部”手势
    self.scrollsToTop = NO;
    //设置内容内间距为0
    self.contentInset = UIEdgeInsetsZero;
    
#ifdef __IPHONE_9_0
    if ([self respondsToSelector:@selector(setSemanticContentAttribute:)]) {
        //内容布局始终使用从左到右布局显示的视图
        self.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
#endif
    
#ifdef __IPHONE_10_0
    //获取setPrefetchingEnabled:函数编号
    SEL selector = NSSelectorFromString(@"setPrefetchingEnabled:");
    //如果函数编号不为空并且响应了函数
    if (selector && [self respondsToSelector:selector]) {
        //将指定的函数消息发送到接收器并返回消息的结果
        [self fs_performSelector:selector withObjects:@NO, nil];
    }
#endif
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:UIEdgeInsetsZero];
    if (contentInset.top) {
        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y+contentInset.top);
    }
}

- (void)setScrollsToTop:(BOOL)scrollsToTop
{
    [super setScrollsToTop:NO];
}

@end

///日历分隔符
@implementation FSCalendarSeparator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FSCalendarStandardSeparatorColor;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.frame = layoutAttributes.frame;
}

@end



