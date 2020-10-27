//
//  UIScrollView+EmptyDataSet.m
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2016 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIScrollView+EmptyDataSet.h"
#import <objc/runtime.h>

@interface UIView (DZNConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;

@end

@interface DZNWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end

@interface DZNEmptyDataSetView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


#pragma mark - UIScrollView+EmptyDataSet

static char const * const kEmptyDataSetSource =     "emptyDataSetSource";
static char const * const kEmptyDataSetDelegate =   "emptyDataSetDelegate";
static char const * const kEmptyDataSetView =       "emptyDataSetView";

#define kEmptyImageViewAnimationKey @"com.dzn.emptyDataSet.imageViewAnimation"

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;
@end

@implementation UIScrollView (DZNEmptyDataSet)

#pragma mark - Getters (Public)

- (id<DZNEmptyDataSetSource>)emptyDataSetSource
{
    DZNWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetSource);
    return container.weakObject;
}

- (id<DZNEmptyDataSetDelegate>)emptyDataSetDelegate
{
    DZNWeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetDelegate);
    return container.weakObject;
}

///空数据集视图是否可见
- (BOOL)isEmptyDataSetVisible
{
    UIView *view = objc_getAssociatedObject(self, kEmptyDataSetView);
    return view ? !view.hidden : NO;
}


#pragma mark - Getters (Private)

///懒加载空数据集视图
- (DZNEmptyDataSetView *)emptyDataSetView
{
    //获取与kEmptyDataSetView关联的空数据视图
    DZNEmptyDataSetView *view = objc_getAssociatedObject(self, kEmptyDataSetView);
    //如果空数据视图不存在
    if (!view)
    {
        //初始化空数据集视图
        view = [DZNEmptyDataSetView new];
        //在其父视图的边界更改时通过扩展或缩小视图的宽度或高度来调整大小
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //设置数据集视图隐藏
        view.hidden = YES;
        YSC_WEAK_SELF
        //添加点击手势识别
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dzn_didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        //设置空数据视图与kEmptyDataSetView的关联
        [self setEmptyDataSetView:view];
    }
    //返回初始化的空数据视图
    return view;
}

///空数据集是否可以显示
- (BOOL)dzn_canDisplay
{
    //空数据集数据源对象是否存在并且符合给定的DZNEmptyDataSetSource协议
    if (self.emptyDataSetSource && [self.emptyDataSetSource conformsToProtocol:@protocol(DZNEmptyDataSetSource)]) {
        //接收器是否是UITableView、UICollectionView、UIScrollView类或其子类
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            //返回YES，可以显示
            return YES;
        }
    }
    //返回NO，不可以显示
    return NO;
}

///返回项目的数量
- (NSInteger)dzn_itemsCount
{
    NSInteger items = 0;
    
    // UIScollView没有响应“dataSource”，所以退出
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView支持
    if ([self isKindOfClass:[UITableView class]]) {
        //获取self代表的表视图对象
        UITableView *tableView = (UITableView *)self;
        //获取self代表的表视图对象的数据源
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        //默认section为1
        NSInteger sections = 1;
        //通过数据源代理获取实际的section数
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        //通过数据源代理获取实际的row数
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView支持
    else if ([self isKindOfClass:[UICollectionView class]]) {
        //获取self代表的集合视图对象的数据源
        UICollectionView *collectionView = (UICollectionView *)self;
        //获取self代表的集合视图对象的数据源
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        //默认section为1
        NSInteger sections = 1;
        //通过数据源代理获取实际的section数
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        //通过数据源代理获取实际的row数
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    //返回项目的数量
    return items;
}


#pragma mark - Data Source Getters

///数据集的标题标签富文本字符串
- (NSAttributedString *)dzn_titleLabelString
{
    //如果数据源对象存在，并且数据源对象响应了titleForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(titleForEmptyDataSet:)]) {
        //调用数据源对象的titleForEmptyDataSet:代理函数获取标题富文本字符串
        NSAttributedString *string = [self.emptyDataSetSource titleForEmptyDataSet:self];
        //验证标题字符串的有效性
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -titleForEmptyDataSet:");
        //返回标题富文本字符串
        return string;
    }
    //默认返回nil
    return nil;
}

///数据集的描述标签富文本字符串
- (NSAttributedString *)dzn_detailLabelString
{
    //如果数据源对象存在，并且数据源对象响应了descriptionForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(descriptionForEmptyDataSet:)]) {
        //调用数据源对象的descriptionForEmptyDataSet:代理函数获取描述富文本字符串
        NSAttributedString *string = [self.emptyDataSetSource descriptionForEmptyDataSet:self];
        //验证描述字符串的有效性
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -descriptionForEmptyDataSet:");
        //返回描述富文本字符串
        return string;
    }
    //默认返回nil
    return nil;
}

///数据集的图像
- (UIImage *)dzn_image
{
    //如果数据源对象存在，并且数据源对象响应了imageForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(imageForEmptyDataSet:)]) {
        //调用数据源对象的imageForEmptyDataSet:代理函数获取图像
        UIImage *image = [self.emptyDataSetSource imageForEmptyDataSet:self];
        //验证图像的有效性
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -imageForEmptyDataSet:");
        //返回数据集的图像
        return image;
    }
    //默认返回nil
    return nil;
}

///数据集的图像动画
- (CAAnimation *)dzn_imageAnimation
{
    //如果数据源对象存在，并且数据源对象响应了imageAnimationForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(imageAnimationForEmptyDataSet:)]) {
        //调用数据源对象的imageAnimationForEmptyDataSet:代理函数获取图像动画
        CAAnimation *imageAnimation = [self.emptyDataSetSource imageAnimationForEmptyDataSet:self];
        //验证图像动画的有效性
        if (imageAnimation) NSAssert([imageAnimation isKindOfClass:[CAAnimation class]], @"You must return a valid CAAnimation object for -imageAnimationForEmptyDataSet:");
        //返回图像动画
        return imageAnimation;
    }
    //默认返回nil
    return nil;
}

///数据集的图像的颜色
- (UIColor *)dzn_imageTintColor
{
    //如果数据源对象存在，并且数据源对象响应了imageTintColorForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(imageTintColorForEmptyDataSet:)]) {
        //调用数据源对象的imageTintColorForEmptyDataSet:代理函数获取图像颜色
        UIColor *color = [self.emptyDataSetSource imageTintColorForEmptyDataSet:self];
        //验证图像颜色的有效性
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -imageTintColorForEmptyDataSet:");
        //返回图像颜色
        return color;
    }
    //默认返回nil
    return nil;
}

///数据集的指定状态下的按钮标题
- (NSAttributedString *)dzn_buttonTitleForState:(UIControlState)state
{
    //如果数据源对象存在，并且数据源对象响应了buttonTitleForEmptyDataSet:forState:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonTitleForEmptyDataSet:forState:)]) {
        //调用数据源对象的buttonTitleForEmptyDataSet:代理函数获取指定状态的按钮标题
        NSAttributedString *string = [self.emptyDataSetSource buttonTitleForEmptyDataSet:self forState:state];
        //验证按钮标题的有效性
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -buttonTitleForEmptyDataSet:forState:");
        //返回按钮标题
        return string;
    }
    //默认返回nil
    return nil;
}

///数据集按钮imageview的图像
- (UIImage *)dzn_buttonImageForState:(UIControlState)state
{
    //如果数据源对象存在，并且数据源对象响应了buttonImageForEmptyDataSet:forState:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonImageForEmptyDataSet:forState:)]) {
        //调用数据源对象的buttonImageForEmptyDataSet:forState:代理函数获取指定状态的按钮imageview的图像
        UIImage *image = [self.emptyDataSetSource buttonImageForEmptyDataSet:self forState:state];
        //验证按钮imageview的图像的有效性
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonImageForEmptyDataSet:forState:");
        //返回按钮imageview的图像
        return image;
    }
    //默认返回nil
    return nil;
}

///数据集的指定状态下的按钮背景视图
- (UIImage *)dzn_buttonBackgroundImageForState:(UIControlState)state
{
    //如果数据源对象存在，并且数据源对象响应了buttonBackgroundImageForEmptyDataSet:forState:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonBackgroundImageForEmptyDataSet:forState:)]) {
        //调用数据源对象的buttonBackgroundImageForEmptyDataSet:forState:代理函数获取指定状态的按钮背景图像
        UIImage *image = [self.emptyDataSetSource buttonBackgroundImageForEmptyDataSet:self forState:state];
        //验证按钮背景图像的有效性
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonBackgroundImageForEmptyDataSet:forState:");
        //返回按钮背景图像
        return image;
    }
    //默认返回nil
    return nil;
}

///数据集的背景颜色
- (UIColor *)dzn_dataSetBackgroundColor
{
    //如果数据源对象存在，并且数据源对象响应了backgroundColorForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(backgroundColorForEmptyDataSet:)]) {
        //调用数据源对象的backgroundColorForEmptyDataSet:代理函数获取数据集的背景颜色
        UIColor *color = [self.emptyDataSetSource backgroundColorForEmptyDataSet:self];
        //验证数据集的背景颜色的有效性
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -backgroundColorForEmptyDataSet:");
        //返回数据集的背景颜色
        return color;
    }
    //默认返回透明的颜色
    return [UIColor clearColor];
}

///数据集的自定义视图
- (UIView *)dzn_customView
{
    //如果数据源对象存在，并且数据源对象响应了customViewForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(customViewForEmptyDataSet:)]) {
        //调用数据源对象的customViewForEmptyDataSet:代理函数获取数据集的自定义视图
        UIView *view = [self.emptyDataSetSource customViewForEmptyDataSet:self];
        //验证自定义视图的有效性
        if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -customViewForEmptyDataSet:");
        //返回自定义视图
        return view;
    }
    //默认返回nil
    return nil;
}

///数据集视图的垂直偏移量
- (CGFloat)dzn_verticalOffset
{
    //设置垂直偏移量默认为0.0
    CGFloat offset = 0.0;
    //如果数据源对象存在，并且数据源对象响应了verticalOffsetForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(verticalOffsetForEmptyDataSet:)]) {
        //调用数据源对象的verticalOffsetForEmptyDataSet:代理函数获取数据集的视图的垂直偏移量
        offset = [self.emptyDataSetSource verticalOffsetForEmptyDataSet:self];
    }
    //返回垂直偏移量
    return offset;
}

///数据集视图元素之间的垂直间距
- (CGFloat)dzn_verticalSpace
{
    //如果数据源对象存在，并且数据源对象响应了spaceHeightForEmptyDataSet:函数
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(spaceHeightForEmptyDataSet:)]) {
        //返回调用数据源对象的spaceHeightForEmptyDataSet:代理函数获取数据集元素之间的垂直间距
        return [self.emptyDataSetSource spaceHeightForEmptyDataSet:self];
    }
    //默认返回0.0
    return 0.0;
}


#pragma mark - Delegate Getters & Events (Private)

///显示空数据集时是否应淡入
- (BOOL)dzn_shouldFadeIn {
    //如果代理对象存在，并且代理对象响应了emptyDataSetShouldFadeIn:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldFadeIn:)]) {
        //返回调用代理对象的emptyDataSetShouldFadeIn:代理函数获取显示空数据集时是否应淡入
        return [self.emptyDataSetDelegate emptyDataSetShouldFadeIn:self];
    }
    //默认返回YES
    return YES;
}

///是否应该显示空数据集
- (BOOL)dzn_shouldDisplay
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetShouldDisplay:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldDisplay:)]) {
        //返回调用代理对象的emptyDataSetShouldDisplay:代理函数获是否应该显示空数据集
        return [self.emptyDataSetDelegate emptyDataSetShouldDisplay:self];
    }
    //默认返回YES
    return YES;
}

///是否强制显示空数据集
- (BOOL)dzn_shouldBeForcedToDisplay
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetShouldBeForcedToDisplay:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldBeForcedToDisplay:)]) {
        //返回调用代理对象的emptyDataSetShouldBeForcedToDisplay:代理函数获取是否强制显示空数据集
        return [self.emptyDataSetDelegate emptyDataSetShouldBeForcedToDisplay:self];
    }
    //默认返回NO
    return NO;
}

///空数据集是否接收触摸手势
- (BOOL)dzn_isTouchAllowed
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetShouldAllowTouch:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowTouch:)]) {
        //返回调用代理对象的emptyDataSetShouldAllowTouch:代理函数获取空数据集是否接收触摸手势
        return [self.emptyDataSetDelegate emptyDataSetShouldAllowTouch:self];
    }
    //默认返回YES
    return YES;
}

///空数据集是否可滚动
- (BOOL)dzn_isScrollAllowed
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetShouldAllowScroll:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowScroll:)]) {
        //返回调用代理对象的emptyDataSetShouldAllowScroll:代理函数获取空数据集是否可滚动
        return [self.emptyDataSetDelegate emptyDataSetShouldAllowScroll:self];
    }
    //默认返回NO
    return NO;
}

///数据集的图像的图像动画权限
- (BOOL)dzn_isImageViewAnimateAllowed
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetShouldAnimateImageView:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAnimateImageView:)]) {
        //调用代理对象的emptyDataSetShouldAnimateImageView:代理函数获取图像动画权限并返回
        return [self.emptyDataSetDelegate emptyDataSetShouldAnimateImageView:self];
    }
    //默认返回NO
    return NO;
}

- (void)dzn_willAppear
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetWillAppear:)]) {
        [self.emptyDataSetDelegate emptyDataSetWillAppear:self];
    }
}

///空数据集视图已经显示
- (void)dzn_didAppear
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidAppear:)]) {
        [self.emptyDataSetDelegate emptyDataSetDidAppear:self];
    }
}

///空数据集视图将要消失
- (void)dzn_willDisappear
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetWillDisappear:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetWillDisappear:)]) {
        //调用代理对象的emptyDataSetWillDisappear:代理函数
        [self.emptyDataSetDelegate emptyDataSetWillDisappear:self];
    }
}

///数据集视图已经消失
- (void)dzn_didDisappear
{
    //如果代理对象存在，并且代理对象响应了emptyDataSetDidDisappear:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidDisappear:)]) {
        //调用代理对象的emptyDataSetDidDisappear:代理函数
        [self.emptyDataSetDelegate emptyDataSetDidDisappear:self];
    }
}

///点击了空数据集的内容视图
- (void)dzn_didTapContentView:(id)sender
{
    //如果代理对象存在，并且代理对象响应了emptyDataSet:didTapView:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSet:didTapView:)]) {
        //调用代理对象的emptyDataSet:didTapView:代理函数
        [self.emptyDataSetDelegate emptyDataSet:self didTapView:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //如果代理对象存在，并且代理对象响应了emptyDataSetDidTapView:函数
    else if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapView:)]) {
        //调用代理对象的emptyDataSetDidTapView:代理函数
        [self.emptyDataSetDelegate emptyDataSetDidTapView:self];
    }
#pragma clang diagnostic pop
}

///通知代理操作按钮已被点击
- (void)dzn_didTapDataButton:(id)sender
{
    //如果代理对象存在，并且代理对象响应了emptyDataSet:didTapButton:函数
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSet:didTapButton:)]) {
        //调用代理对象的emptyDataSet:didTapButton:代理函数
        [self.emptyDataSetDelegate emptyDataSet:self didTapButton:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //如果代理对象存在，并且代理对象响应了emptyDataSetDidTapButton:函数
    else if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapButton:)]) {
        //调用代理对象的emptyDataSetDidTapButton:代理函数
        [self.emptyDataSetDelegate emptyDataSetDidTapButton:self];
    }
#pragma clang diagnostic pop
}


#pragma mark - Setters (Public)

///设置空数据集数据源
- (void)setEmptyDataSetSource:(id<DZNEmptyDataSetSource>)datasource
{
    //如果数据源不存在或空数据集是不显示的
    if (!datasource || ![self dzn_canDisplay]) {
        //使空数据集无效
        [self dzn_invalidate];
    }
    //对数据源进行关联
    objc_setAssociatedObject(self, kEmptyDataSetSource, [[DZNWeakObjectContainer alloc] initWithWeakObject:datasource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 我们将sizzling方法用于将-dzn_reloadData实现注入到本机的-reloadData实现中
    [self swizzleIfPossible:@selector(reloadData)];
    
    // 专门为UITableView注入-dzn_reloadData到- endpdates
    if ([self isKindOfClass:[UITableView class]]) {
        [self swizzleIfPossible:@selector(endUpdates)];
    }
}

- (void)setEmptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)delegate
{
    if (!delegate) {
        [self dzn_invalidate];
    }
    
    objc_setAssociatedObject(self, kEmptyDataSetDelegate, [[DZNWeakObjectContainer alloc] initWithWeakObject:delegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Setters (Private)
///设置空数据视图与kEmptyDataSetView的关联
- (void)setEmptyDataSetView:(DZNEmptyDataSetView *)view
{
    //设置空数据视图与kEmptyDataSetView的关联
    objc_setAssociatedObject(self, kEmptyDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Reload APIs (Public)

- (void)reloadEmptyDataSet
{
    [self dzn_reloadEmptyDataSet];
}


#pragma mark - Reload APIs (Private)
///重新加载空数据集
- (void)dzn_reloadEmptyDataSet
{
    //空数据集是否可以显示
    if (![self dzn_canDisplay]) {
        //不可以显示直接返回
        return;
    }
    //如果应该显示空数据集并且数据源代理返回的项目数为0或者强制显示空数据集
    if (([self dzn_shouldDisplay] && [self dzn_itemsCount] == 0) || [self dzn_shouldBeForcedToDisplay])
    {
        // 通知将出现空数据集视图
        [self dzn_willAppear];
        //获取空数据集展示视图
        DZNEmptyDataSetView *view = self.emptyDataSetView;
        
        // 配置空数据集淡入显示
        view.fadeInOnDisplay = [self dzn_shouldFadeIn];
        
        if (!view.superview) {
            // 如果存在页眉和/或页脚，以及部分页眉或任何其他内容，则将视图一直向后发送
            if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }
            else {
                [self addSubview:view];
            }
        }
        
        // 移除视图重置视图及其约束对于保证良好的状态非常重要
        [view prepareForReuse];
        //数据集的自定义视图
        UIView *customView = [self dzn_customView];
        
        // 如果有一个非nil自定义视图可用，那么让来配置它
        if (customView) {
            view.customView = customView;
        }
        else {
            // 从数据源获取数据
            // 获取标题标签的富文本字符串
            NSAttributedString *titleLabelString = [self dzn_titleLabelString];
            // 获取描述标签的富文本字符串
            NSAttributedString *detailLabelString = [self dzn_detailLabelString];
            // 获取数据集按钮imageview的图像
            UIImage *buttonImage = [self dzn_buttonImageForState:UIControlStateNormal];
            // 获取数据集的指定状态下的按钮标题
            NSAttributedString *buttonTitle = [self dzn_buttonTitleForState:UIControlStateNormal];
            // 获取数据集的图像
            UIImage *image = [self dzn_image];
            // 获取数据集的图像的颜色
            UIColor *imageTintColor = [self dzn_imageTintColor];
            // 指定图像可渲染模式
            UIImageRenderingMode renderingMode = imageTintColor ? UIImageRenderingModeAlwaysTemplate : UIImageRenderingModeAlwaysOriginal;
            // 数据集视图元素之间的垂直间距
            view.verticalSpace = [self dzn_verticalSpace];
            
            // 配置图像
            if (image) {
                //如果图像响应了imageWithRenderingMode:函数
                if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
                    //调用imageWithRenderingMode:使用指定的呈现模式配置的图像并返回
                    view.imageView.image = [image imageWithRenderingMode:renderingMode];
                    //设置数据集的图像的颜色
                    view.imageView.tintColor = imageTintColor;
                }
                else {
                    // iOS 6 fallback: 如果需要，插入代码来转换图像
                    view.imageView.image = image;
                }
            }
            
            // 配置标题标签
            if (titleLabelString) {
                view.titleLabel.attributedText = titleLabelString;
            }
            
            // 配置描述标签
            if (detailLabelString) {
                view.detailLabel.attributedText = detailLabelString;
            }
            
            // 配置按钮
            // 如果设置了按钮图片
            if (buttonImage) {
                //分别设置普通状态与高亮状态下的按钮图片
                [view.button setImage:buttonImage forState:UIControlStateNormal];
                [view.button setImage:[self dzn_buttonImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
            //如果设置了按钮标题
            else if (buttonTitle) {
                //设置普通状态与高亮状态下的按钮标题
                [view.button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
                [view.button setAttributedTitle:[self dzn_buttonTitleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
                //设置普通状态与高亮状态下的按钮背景色
                [view.button setBackgroundImage:[self dzn_buttonBackgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
                [view.button setBackgroundImage:[self dzn_buttonBackgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
        }
        
        // 配置偏移量
        view.verticalOffset = [self dzn_verticalOffset];
        
        // 配置空数据集视图
        view.backgroundColor = [self dzn_dataSetBackgroundColor];
        view.hidden = NO;
        view.clipsToBounds = YES;
        
        // 配置空数据集用户交互权限
        view.userInteractionEnabled = [self dzn_isTouchAllowed];
        // 设置约束
        [view setupConstraints];
        
        [UIView performWithoutAnimation:^{
            [view layoutIfNeeded];
        }];
        
        // 配置滚动权限
        self.scrollEnabled = [self dzn_isScrollAllowed];
        
        // 配置图像视图动画
        if ([self dzn_isImageViewAnimateAllowed])
        {
            //获取数据集的图像动画
            CAAnimation *animation = [self dzn_imageAnimation];
            
            if (animation) {
                //添加动画
                [self.emptyDataSetView.imageView.layer addAnimation:animation forKey:kEmptyImageViewAnimationKey];
            }
        }
        else if ([self.emptyDataSetView.imageView.layer animationForKey:kEmptyImageViewAnimationKey]) {
            //移除动画
            [self.emptyDataSetView.imageView.layer removeAnimationForKey:kEmptyImageViewAnimationKey];
        }
        
        //空数据集视图已经显示
        [self dzn_didAppear];
    }
    else if (self.isEmptyDataSetVisible) {
        //使空数据集无效
        [self dzn_invalidate];
    }
}

///使空数据集无效
- (void)dzn_invalidate
{
    // 通知空数据集视图将消失
    [self dzn_willDisappear];
    // 空数据集视图是否存在
    if (self.emptyDataSetView) {
        //将空数据集视图的组件视图移除、置空、清空约束
        [self.emptyDataSetView prepareForReuse];
        //将空数据集视图在父视图中移除
        [self.emptyDataSetView removeFromSuperview];
        //通过nil清除现有关联
        [self setEmptyDataSetView:nil];
    }
    //允许接收器滚动
    self.scrollEnabled = YES;
    
    // 通知空数据集视图已消失
    [self dzn_didDisappear];
}


#pragma mark - Method Swizzling

static NSMutableDictionary *_impLookupTable;
static NSString *const DZNSwizzleInfoPointerKey = @"pointer";
static NSString *const DZNSwizzleInfoOwnerKey = @"owner";
static NSString *const DZNSwizzleInfoSelectorKey = @"selector";

// Based on Bryce Buchanan's swizzling technique http://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
// And Juzzin's ideas https://github.com/juzzin/JUSEmptyViewController

///原始_实现
void dzn_original_implementation(id self, SEL _cmd)
{
    // 从查找表获取原始实现
    //判断self的基类
    Class baseClass = dzn_baseClassToSwizzleForTarget(self);
    //获取实现类名与函数选择器名的组合字符串
    NSString *key = dzn_implementationKey(baseClass, _cmd);
    //获取函数查找表中记录新实现的字典
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    //在录新实现的字典中获取包含指定指针的值对象
    NSValue *impValue = [swizzleInfo valueForKey:DZNSwizzleInfoPointerKey];
    //以非类型化指针的形式返回值
    IMP impPointer = [impValue pointerValue];
    
    // 注入额外的实现以重新加载空数据集
    // 在调用原始实现之前执行此操作会及时更新“isEmptyDataSetVisible”标志.
    [self dzn_reloadEmptyDataSet];
    
    // If found, call original implementation
    if (impPointer) {
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}

///返回实现类名与函数选择器名的组合字符串
NSString *dzn_implementationKey(Class class, SEL selector)
{
    //类或者函数选择器不存在
    if (!class || !selector) {
        //返回nil
        return nil;
    }
    //获取类名
    NSString *className = NSStringFromClass([class class]);
    //获取函数选择器名
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@", className, selectorName];
}

///用于判断目标的基类
Class dzn_baseClassToSwizzleForTarget(id target)
{
    //如果self是UITableView类或其子类的实列
    if ([target isKindOfClass:[UITableView class]]) {
        //返回UITableView类
        return [UITableView class];
    }
    //如果self是UICollectionView类或其子类的实列
    else if ([target isKindOfClass:[UICollectionView class]]) {
        //返回UICollectionView类
        return [UICollectionView class];
    }
    //如果self是UIScrollView类或其子类的实列
    else if ([target isKindOfClass:[UIScrollView class]]) {
        //回UIScrollView类
        return [UIScrollView class];
    }
    //返回nil
    return nil;
}

- (void)swizzleIfPossible:(SEL)selector
{
    // 检查目标是否响应选择器(reloadData)
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // 创建IMP查阅表格
    if (!_impLookupTable) {
        // 3 表示支持的基类
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    
    // 确保UITableView或UICollectionView类型的每个类调用一次setImplementation。
    //遍历IMP查阅表格所有的值
    for (NSDictionary *info in [_impLookupTable allValues]) {
        //获取实现类
        Class class = [info objectForKey:DZNSwizzleInfoOwnerKey];
        //获取选择器名
        NSString *selectorName = [info objectForKey:DZNSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    //获取self的基类
    Class baseClass = dzn_baseClassToSwizzleForTarget(self);
    //获取现类名与函数选择器名的组合字符串
    NSString *key = dzn_implementationKey(baseClass, selector);
    //返回由DZNSwizzleInfoPointerKey标识的属性的值
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:DZNSwizzleInfoPointerKey];
    
    // 如果该类的实现已经存在，则跳过!!
    if (impValue || !key || !baseClass) {
        return;
    }
    
    // 注入额外的实现
    //获取给定类的实例方法
    Method method = class_getInstanceMethod(baseClass, selector);
    //设置方法的实现以改变方法的先前实现并返回新的实现
    IMP dzn_newImplementation = method_setImplementation(method, (IMP)dzn_original_implementation);
    
    // 将新实现存储在查找表中（存储实现类、选择器、包含指定指针的值对象）
    NSDictionary *swizzledInfo = @{DZNSwizzleInfoOwnerKey: baseClass,
                                   DZNSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   DZNSwizzleInfoPointerKey: [NSValue valueWithPointer:dzn_newImplementation]};
    //将新实现存储在查找表中
    [_impLookupTable setObject:swizzledInfo forKey:key];
}


#pragma mark - UIGestureRecognizerDelegate Methods

///询问代理手势识别器是否应开始尝试识别其手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.emptyDataSetView]) {
        return [self dzn_isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

///询问代理是否应允许两个手势识别器同时识别手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIGestureRecognizer *tapGesture = self.emptyDataSetView.tapGesture;
    
    if ([gestureRecognizer isEqual:tapGesture] || [otherGestureRecognizer isEqual:tapGesture]) {
        return YES;
    }
    
    // 如果可用，请遵循emptyDataSetDelegate的实现
    if ( (self.emptyDataSetDelegate != (id)self) && [self.emptyDataSetDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [(id)self.emptyDataSetDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    return NO;
}

@end


#pragma mark - DZNEmptyDataSetView

@interface DZNEmptyDataSetView ()
@end

@implementation DZNEmptyDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

#pragma mark - Initialization Methods

///DZNEmptyDataSetView初始化函数
- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    CGRect superviewBounds = self.superview.bounds;
    self.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(superviewBounds), CGRectGetHeight(superviewBounds));
    
    void(^fadeInBlock)(void) = ^{
        self.contentView.alpha = 1.0;
    };
    
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }
    else {
        fadeInBlock();
    }
}


#pragma mark - Getters

///懒加载DZNEmptyDataSetView组件视图
//内容视图
- (UIView *)contentView
{
    //如果内容视图不存在
    if (!_contentView)
    {
        //初始化内容视图
        _contentView = [UIView new];
        //不将视图的自动调整大小掩码转换为自动布局约束（代码添加视图时,视图的translatesAutoresizingMaskIntoConstraints属性默认为YES）
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        //设置背景颜色为透明
        _contentView.backgroundColor = [UIColor clearColor];
        //设置与用户交互
        _contentView.userInteractionEnabled = YES;
        //设置透明度
        _contentView.alpha = 0;
    }
    //返回初始化内容视图
    return _contentView;
}

//图像视图
- (UIImageView *)imageView
{
    //如果图像视图不存在
    if (!_imageView)
    {
        //初始化图像视图
        _imageView = [UIImageView new];
        //不将视图的自动调整大小掩码转换为自动布局约束
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        //设置背景颜色为透明
        _imageView.backgroundColor = [UIColor clearColor];
        //通过保持纵横比来缩放内容以适应视图大小
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        //不与用户交互
        _imageView.userInteractionEnabled = NO;
        //标识元素的字符串
        _imageView.accessibilityIdentifier = @"empty set background image";
        //添加图像视图到内容视图
        [_contentView addSubview:_imageView];
    }
    //返回图像视图
    return _imageView;
}

//标题标签
- (UILabel *)titleLabel
{
    //如果标题标签不存在
    if (!_titleLabel)
    {
        //初始化标题标签
        _titleLabel = [UILabel new];
        //不将视图的自动调整大小掩码转换为自动布局约束
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //设置背景颜色为透明
        _titleLabel.backgroundColor = [UIColor clearColor];
        //设置字体大小
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        //设置字体颜色灰度
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        //设置文本对齐方式为居中对其
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //换行方式为在单词边界处
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //不限制文本的行数
        _titleLabel.numberOfLines = 0;
        //标识元素的字符串
        _titleLabel.accessibilityIdentifier = @"empty set title";
        //添加标题标签到内容视图
        [_contentView addSubview:_titleLabel];
    }
    //返回标题标签
    return _titleLabel;
}

//描述标签
- (UILabel *)detailLabel
{
    //如果描述标签不存在
    if (!_detailLabel)
    {
        //初始化描述标签
        _detailLabel = [UILabel new];
        //不将视图的自动调整大小掩码转换为自动布局约束
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //设置背景颜色为透明
        _detailLabel.backgroundColor = [UIColor clearColor];
        //设置字体大小
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        //设置文本颜色灰度
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        //设置文本对其方式为居中对齐
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        //换行方式为在单词边界处
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //不限制文本行数
        _detailLabel.numberOfLines = 0;
        //标识元素的字符串
        _detailLabel.accessibilityIdentifier = @"empty set detail label";
        //添加描述标签到内容视图
        [_contentView addSubview:_detailLabel];
    }
    //返回描述标签
    return _detailLabel;
}

//操作按钮
- (UIButton *)button
{
    //如果操作按钮不存在
    if (!_button)
    {
        //初始化操作按钮为自定义样式
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        //不将视图的自动调整大小掩码转换为自动布局约束
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        //设置背景颜色为透明
        _button.backgroundColor = [UIColor clearColor];
        //控件中内容（文本和图像）的水平对齐方式为在控件中心水平对齐
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //控件中内容（文本和图像）的垂直对齐方式为在控件中心垂直对齐
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //标识元素的字符串
        _button.accessibilityIdentifier = @"empty set button";
        //设置圆角
        _button.layer.cornerRadius = 3.0;
        //裁剪到层的边界
        _button.layer.masksToBounds = YES;
        //对象弱引用
        YSC_WEAK_SELF
        //按钮添加点击事件
        [_button addTarget:weakSelf action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        //添加操作按钮到内容视图
        [_contentView addSubview:_button];
    }
    //返回操作按钮
    return _button;
}

///可以显示图像视图
- (BOOL)canShowImage
{
    return (_imageView.image && _imageView.superview);
}

///可以显示标题标签
- (BOOL)canShowTitle
{
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

///可以显示描述标签
- (BOOL)canShowDetail
{
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

///可以显示按钮
- (BOOL)canShowButton
{
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}


#pragma mark - Setters
///设置自定义视图
- (void)setCustomView:(UIView *)view
{
    //如果设为自定义视图对象的视图不存在，直接返回
    if (!view) {
        return;
    }
    //如果存在已经设置的自定义视图，将已经设置的自定义视图在超级视图中移除，将已经设置的自定义视图对象置nil
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    //重新设置自定义视图
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}


#pragma mark - Action Methods
///按钮添加的点击函数
- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"dzn_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        //在延迟之后使用默认模式在当前线程上调用接收方的方法
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

///移除所有约束
- (void)removeAllConstraints
{
    //从视图中删除指定的约束
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

///准备再利用
- (void)prepareForReuse
{
    //通过subviews获取内容视图的子视图数组，并通过makeObjectsPerformSelector向数组中的每个对象发送由给定选择器标识的消息
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //组件视图置nil
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    //移除所有约束
    [self removeAllConstraints];
}


#pragma mark - Auto-Layout Configuration

///设置约束
- (void)setupConstraints
{
    // 首先，配置内容视图内容
    // 内容视图必须始终位于其超级视图的中心
    NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];
    //添加中心点X轴约束
    [self addConstraint:centerXConstraint];
    //添加中心点Y轴约束
    [self addConstraint:centerYConstraint];
    //添加空数据集内容视图的约束，约束为水平方向内容视图和父视图左右两边边对齐
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    // 当自定义偏移可用时，调整垂直约束的常数
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    
    // 如果适用，请设置自定义视图的约束
    if (_customView) {
        //添加自定义视图的约束，约束为水平方向与内容视图左右对齐
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        //添加自定义视图的约束，约束为垂直方向与内容视图上下对齐
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }
    else {
        //获取空数据集视图宽度
        CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
        //计算水平间距
        CGFloat padding = roundf(width/16.0);
        //设置垂直间距
        CGFloat verticalSpace = self.verticalSpace ? : 11.0; // Default is 11 pts
        //存放内容视图的子视图名称字符串的数组
        NSMutableArray *subviewStrings = [NSMutableArray array];
        //存放内容视图的子视图对象的字典
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        //存放水平间距数值的字典
        NSDictionary *metrics = @{@"padding": @(padding)};
        
        // 指定图像视图的水平约束
        // 如果图像视图的父视图存在
        if (_imageView.superview) {
            //将图像视图的字符串名称加入内容视图的子视图名称字符串的数组
            [subviewStrings addObject:@"imageView"];
            //设置内容视图的子视图对象的字典中的图像视图的对象
            views[[subviewStrings lastObject]] = _imageView;
            //添加图像视图的约束，约束为图像视图中心X轴等于内容视图X轴中心
            [self.contentView addConstraint:[self.contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }
        
        // 指定标题标签的水平约束
        // 如果可以显示标题标签
        if ([self canShowTitle]) {
            //将标题标签的字符串名称加入内容视图的子视图名称字符串的数组
            [subviewStrings addObject:@"titleLabel"];
            //设置内容视图的子视图对象的字典中的标题标签的对象
            views[[subviewStrings lastObject]] = _titleLabel;
            //添加标题标签的约束，约束为宽度大于等于0，两侧距内容视图最大间距为750
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // 或者从它的超级视图中删除
        else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        // 指定描述标签的水平约束
        if ([self canShowDetail]) {
            
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // 或者从它的超级视图中删除
        else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        // 指定按钮的水平约束
        if ([self canShowButton]) {
            
            [subviewStrings addObject:@"button"];
            views[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(>=0)]-(padding@750)-|" options:0 metrics:metrics views:views]];
        }
        // 或者从它的超级视图中删除
        else {
            [_button removeFromSuperview];
            _button = nil;
        }
        
        
        NSMutableString *verticalFormat = [NSMutableString new];
        
        // 为垂直约束构建一个动态字符串格式，在每个元素之间添加边距。默认值为11pts。
        for (int i = 0; i < subviewStrings.count; i++) {
            
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
            }
        }
        
        // 将垂直约束指定给内容视图
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0 metrics:metrics views:views]];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // 返回任何UIControl实例，如按钮、分段控件、开关等。
    if ([hitView isKindOfClass:[UIControl class]]) {
        return hitView;
    }
    
    // 返回内容视图或自定义视图
    if ([hitView isEqual:_contentView] || [hitView isEqual:_customView]) {
        return hitView;
    }
    
    return nil;
}

@end


#pragma mark - UIView+DZNConstraintBasedLayoutExtensions

@implementation UIView (DZNConstraintBasedLayoutExtensions)

///与视图同等相关的约束
- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end

#pragma mark - DZNWeakObjectContainer

@implementation DZNWeakObjectContainer

- (instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end
