//
//  YBPopupMenu.h
//  YBPopupMenu
//
//  Created by LYB on 16/11/8.
//  Copyright © 2016年 LYB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,  YBPopupMenuType) {
    YBPopupMenuTypeDefault = 0,
    YBPopupMenuTypeDark,
    YBPopupMenuTypeGray,
};

typedef NS_ENUM(NSInteger, YBArrowDirection) {
    YBArrowDirectionTop = 0,
    YBArrowDirectionBottom,
};

typedef NS_ENUM(NSInteger, YBArrowLocation) {
    YBArrowLocationLeft = 1,
    YBArrowLocationRight,
    YBArrowLocationCentre
};

@class YBPopupMenu;
@protocol YBPopupMenuDelegate <NSObject>

@optional
/**
 点击事件回调
 */
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu;

@end


@interface YBPopupMenu : UIView

@property (nonatomic, copy, readonly) NSArray *titles;

/**
 圆角半径 Default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, assign,  getter=isShadowShowing) BOOL isShowShadow;

/**
 阴影透明度
 */
@property (nonatomic, assign) CGFloat frameShadowOpacity;

/**
 选择菜单项后消失 Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnSelected;

/**
 点击菜单外消失  Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnTouchOutside;

/**
 设置字体大小 Default is 15
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 设置字体颜色 Default is [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 设置偏移距离 (>= 0) Default is 0.0 
 */
@property (nonatomic, assign) CGFloat offset;

/**
 设置显示模式 Default is YBPopupMenuTypeDefault
 */
@property (nonatomic, assign) YBPopupMenuType type;

/**
 设置箭头指向 (指向上或者指向下)
 */
@property (nonatomic, assign) YBArrowDirection arrowDirection;

/**
 设置尖头位置 (居左、居右、居中，未设置会根据视图与屏幕的位置进行调整)
 */
@property (nonatomic, assign) YBArrowLocation arrowLocation;

/**
 设置菜单背景遮罩视图的背景颜色
 */
@property (nonatomic, strong) UIColor *bgViewBackgroundColor;

/**
 设置菜单背景遮罩视图的背景颜色透明度
 */
@property (nonatomic, assign) CGFloat bgViewBackgroundColorAlpha;

/**
 代理
 */
@property (nonatomic, weak) id <YBPopupMenuDelegate> delegate;

/**
 初始化popupMenu

 @param titles    标题数组
 @param icons     图标数组
 @param itemWidth 菜单宽度
 @parma itemHeight 菜单高度
 @param delegate  代理
 */
- (instancetype)initWithTitles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                     menuHeight:(CGFloat)itemHeight
                      delegate:(id<YBPopupMenuDelegate>)delegate;


/**
 初始化popupMenu
 
 @param titles    标题数组
 @param type      样式类型
 @param itemWidth 菜单宽度
 @param delegate  代理
 */
+ (instancetype)showRelyOnView:(UIView *)view
                        titles:(NSArray *)titles
                          type:(YBPopupMenuType)type
                      fontSize:(CGFloat)fontSize
                     menuWidth:(CGFloat)itemWidth
                    itemHeight:(CGFloat)itemHeight
                      delegate:(id<YBPopupMenuDelegate>)delegate;


/**
 在指定位置弹出类方法
 */
+ (instancetype)showAtPoint:(CGPoint)point
                     titles:(NSArray *)titles
                      icons:(NSArray *)icons
                  menuWidth:(CGFloat)itemWidth
                   delegate:(id<YBPopupMenuDelegate>)delegate;


/**
  依赖指定view弹出类方法
 */
+ (instancetype)showRelyOnView:(UIView *)view
                        titles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                      delegate:(id<YBPopupMenuDelegate>)delegate;


/**
 在指定位置弹出

 @param point 需要弹出的point
 */
- (void)showAtPoint:(CGPoint)point;


/**
 依赖指定view弹出

 @param view 需要依赖的view
 */
- (void)showRelyOnView:(UIView *)view;

/**
 消失
 */
- (void)dismiss;

@end
