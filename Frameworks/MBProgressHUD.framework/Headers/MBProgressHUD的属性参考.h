//
//  MBProgressHUD.h
//  Version 1.1.0
//  Created by Matej Bukovinski on 2.4.09.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright © 2009-2016 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class MBBackgroundView;
@protocol MBProgressHUDDelegate;


extern CGFloat const MBProgressMaxOffset;

typedef NS_ENUM(NSInteger, MBProgressHUDMode) {
    /// UIActivityIndicatorView.
    /// 活动指示器视图。
    MBProgressHUDModeIndeterminate,
    /// A round, pie-chart like, progress view.
    /// 一个圆形的饼状进度视图。
    MBProgressHUDModeDeterminate,
    /// Horizontal progress bar.
    /// 水平进度条。
    MBProgressHUDModeDeterminateHorizontalBar,
    /// Ring-shaped progress view.
    MBProgressHUDModeAnnularDeterminate,
    /// Shows a custom view.
    /// 显示自定义视图。
    MBProgressHUDModeCustomView,
    /// Shows only labels.
    /// 仅显示标签。
    MBProgressHUDModeText
};

typedef NS_ENUM(NSInteger, MBProgressHUDAnimation) {
    /// Opacity animation
    /// 不透明度动画
    MBProgressHUDAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    /// 不透明度+缩放动画（出现时放大消失时缩小）
    MBProgressHUDAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    /// 不透明度+缩放动画（缩小样式）
    MBProgressHUDAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    /// 不透明度+缩放动画（放大样式）
    MBProgressHUDAnimationZoomIn
};

typedef NS_ENUM(NSInteger, MBProgressHUDBackgroundStyle) {
    /// Solid color background
    /// 纯色背景
    MBProgressHUDBackgroundStyleSolidColor,
    /// UIVisualEffectView or UIToolbar.layer background view
    /// UIVisualEffectView或UIToolbar.layer背景视图
    MBProgressHUDBackgroundStyleBlur
};

typedef void (^MBProgressHUDCompletionBlock)(void);


NS_ASSUME_NONNULL_BEGIN


/** 
 * Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
 *
 * This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
 * The MBProgressHUD window spans over the entire space given to it by the initWithFrame: constructor and catches all
 * user input on this region, thereby preventing the user operations on components below the view.
 *
 * @note To still allow touches to pass through the HUD, you can set hud.userInteractionEnabled = NO.
 * @attention MBProgressHUD is a UI class and should therefore only be accessed on the main thread.
 *
 *  显示一个简单的HUD窗口，其中包含一个进度指示器和两个用于短消息的可选标签。
    这是一个简单的下拉类，用于显示进度HUD视图，类似于苹果的私有UIProgressHUD类。
    MBProgressHUD窗口跨越initWithFrame:constructor给它的整个空间，并捕获该区域上的所有用户输入，从而阻止用户对视图下方的组件进行操作。
    @注意，要让触摸通过HUD，您可以设置已启用hud.userInteractionEnabled=NO。
    @注意MBProgressHUD是一个UI类，因此只能在主线程上访问。
 */
@interface MBProgressHUD : UIView

/**
 * Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
 *
 * @note This method sets removeFromSuperViewOnHide. The HUD will automatically be removed from the view hierarchy when hidden.
 *
 * @param view The view that the HUD will be added to
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 * @return A reference to the created HUD.
 *
 * @see hideHUDForView:animated:
 * @see animationType
 *
 *  创建一个新的HUD，将其添加到提供的视图并显示它。与此方法对应的是hideHUDForView:animated:。
    这个方法设置removeFromSuperViewOnHide。当隐藏时，HUD将自动从视图层次结构中移除。
    @param view HUD将被添加到的视图
    @param animated 如果设置为YES, HUD将使用当前的animationType显示。如果设置为NO, HUD在显示时将不会使用动画。
    @return对创建的HUD的引用。
 */
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/// @name Showing and hiding

/**
 * Finds the top-most HUD subview that hasn't finished and hides it. The counterpart to this method is showHUDAddedTo:animated:.
 *
 * @note This method sets removeFromSuperViewOnHide. The HUD will automatically be removed from the view hierarchy when hidden.
 *
 * @param view The view that is going to be searched for a HUD subview.
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @return YES if a HUD was found and removed, NO otherwise.
 *
 * @see showHUDAddedTo:animated:
 * @see animationType
 *
 *  找到尚未完成的最顶层的HUD子视图并隐藏它。与此方法对应的是showHUDAddedTo:animated:。
    这个方法设置removeFromSuperViewOnHide。当隐藏时，HUD将自动从视图层次结构中移除。
    @param view 这个视图会被搜索到一个HUD子视图。
    @param animated 如果设置为YES, HUD将使用当前的animationType消失。如果设置为NO, HUD在消失时将不会使用动画。
    如果找到并删除了一个HUD，返回YES，否则NO。
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview that hasn't finished and returns it.
 *
 * @param view The view that is going to be searched.
 * @return A reference to the last HUD subview discovered.
 *
 *  找到还没有完成的最顶层的HUD子视图并返回它。
    @param view 要搜索的视图。
 *  @return  对最后发现的HUD子视图的引用。
 */
+ (nullable MBProgressHUD *)HUDForView:(UIView *)view;

/**
 * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
 * view.bounds as the parameter.
 *
 * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the view that the HUD will be added to).
 *
 *  一个方便的构造函数，用视图的边界初始化HUD。用视图调用指定的构造函数。边界作为参数。
    为HUD提供边界的视图实例。应该是与HUD的父视图相同的实例(例如，将会添加到的视图)。
 *
 *  @param view 为HUD提供边界的视图实例。应该是与HUD的父视图相同的实例(例如，将会添加到的视图)。
 */
- (instancetype)initWithView:(UIView *)view;

/** 
 * Displays the HUD. 
 *
 * @note You need to make sure that the main thread completes its run loop soon after this method call so that
 * the user interface can be updated. Call this method when your task is already set up to be executed in a new thread
 * (e.g., when using something like NSOperation or making an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 *
 * @see animationType
 *
 *  显示HUD。
    @注意，您需要确保主线程在这个方法调用之后很快就完成了它的运行循环，以便可以更新用户界面。当您的任务已经设置为在新线程中执行时（例如，当使用类似NSOperation的东西或进行诸如NSURLRequest之类的异步调用时），请调用此方法。
    @param animated如果设置为YES，则HUD将使用当前animationType显示。如果设置为“否”，则HUD在显示时将不使用动画。
 */
- (void)showAnimated:(BOOL)animated;

/** 
 * Hides the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 *
 * @see animationType
 *
 *  隐藏HUD。这仍然称为hudWasHidden:delegate。这是show:方法的对应物。当你的任务完成时，用它来隐藏HUD。
    @param animated如果设置为YES，HUD将使用当前animationType消失。如果设置为“否”，则HUD在消失时将不使用动画。
 */
- (void)hideAnimated:(BOOL)animated;

/** 
 * Hides the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @param delay Delay in seconds until the HUD is hidden.
 *
 * @see animationType
 *
 *  在延迟后隐藏HUD。这仍然调用hudWasHidden: delegate。这是节目的对应物:方法。当任务完成时，使用它隐藏HUD。
    如果设置为YES, HUD将使用当前的animationType消失。如果设置为NO, HUD在消失时将不会使用动画。
    延迟，以秒为单位，直到HUD被隐藏。
 */
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/**
 * The HUD delegate object. Receives HUD state notifications.
 * HUD代理对象。接收HUD状态通知。
 */
@property (weak, nonatomic) id<MBProgressHUDDelegate> delegate;

/**
 * Called after the HUD is hiden.
 * 在HUD隐藏后回调。
 */
@property (copy, nullable) MBProgressHUDCompletionBlock completionBlock;

/*
 * Grace period is the time (in seconds) that the invoked method may be run without
 * showing the HUD. If the task finishes before the grace time runs out, the HUD will
 * not be shown at all.
 * This may be used to prevent HUD display for very short tasks.
 * Defaults to 0 (no grace time).
    宽限期是调用的方法在不显示HUD的情况下可以运行的时间（以秒为单位）。如果任务没有在任务完成之前显示出来，那么HUD就不会显示出来了。这可用于防止在非常短的任务中显示HUD。默认为0（无宽限时间）。
 */
@property (assign, nonatomic) NSTimeInterval graceTime;

/**
 * The minimum time (in seconds) that the HUD is shown.
 * This avoids the problem of the HUD being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 *
 *  显示HUD的最短时间（以秒为单位）。
    这样可以避免显示HUD的问题，而不是立即隐藏。
    默认为0（无最短显示时间）。
 */
@property (assign, nonatomic) NSTimeInterval minShowTime;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to NO.
 * 隐藏时从其父视图中删除HUD。
   默认为NO。
 */
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

/// @name Appearance

/** 
 * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
 * MBProgressHUD操作模式。默认值为MBProgressHUDModeIndeterminate。
 */
@property (assign, nonatomic) MBProgressHUDMode mode;

/**
 * A color that gets forwarded to all labels and supported indicators. Also sets the tintColor
 * for custom views on iOS 7+. Set to nil to manage color individually.
 * Defaults to semi-translucent black on iOS 7 and later and white on earlier iOS versions.
 * 一种颜色，可以转发给所有标签和支持的指示器。在ios7 +上为自定义视图设置颜色。设置为nil来单独管理颜色。
   iOS 7默认为半透明黑色，之后的版本为白色。
 */
@property (strong, nonatomic, nullable) UIColor *contentColor UI_APPEARANCE_SELECTOR;

/**
 * The animation type that should be used when the HUD is shown and hidden.
 * 在显示和隐藏HUD时应该使用的动画类型。
 */
@property (assign, nonatomic) MBProgressHUDAnimation animationType UI_APPEARANCE_SELECTOR;

/**
 * The bezel offset relative to the center of the view. You can use MBProgressMaxOffset
 * and -MBProgressMaxOffset to move the HUD all the way to the screen edge in each direction.
 * E.g., CGPointMake(0.f, MBProgressMaxOffset) would position the HUD centered on the bottom edge.
 * 相对于视图中心的边框偏移量。你可以使用MBProgressMaxOffset和-MBProgressMaxOffset来移动HUD到屏幕边缘的每个方向。
   例如,CGPointMake(0。(f, MBProgressMaxOffset)将定位HUD在底部边缘的中心。
 */
@property (assign, nonatomic) CGPoint offset UI_APPEARANCE_SELECTOR;

/**
 * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
 * This also represents the minimum bezel distance to the edge of the HUD view.
 * Defaults to 20.f
 * HUD边缘与HUD元素(标签、指示器或自定义视图)之间的空间量。
   这也代表了到HUD视图边缘的最小边框距离。
   默认为20.f
 */
@property (assign, nonatomic) CGFloat margin UI_APPEARANCE_SELECTOR;

/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
 * HUD边框的最小尺寸。默认为CGSizeZero(没有最小大小)。
 */
@property (assign, nonatomic) CGSize minSize UI_APPEARANCE_SELECTOR;

/**
 * Force the HUD dimensions to be equal if possible.
 * 如果可能的话，强制HUD尺寸相等。
 */
@property (assign, nonatomic, getter = isSquare) BOOL square UI_APPEARANCE_SELECTOR;

/**
 * When enabled, the bezel center gets slightly affected by the device accelerometer data.
 * Has no effect on iOS < 7.0. Defaults to YES.
 * 当启用时，bezel center会受到设备加速计数据的轻微影响。
   iOS < 7.0没有影响。默认值为YES。
 */
@property (assign, nonatomic, getter=areDefaultMotionEffectsEnabled) BOOL defaultMotionEffectsEnabled UI_APPEARANCE_SELECTOR;

/// @name Progress

/**
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
 * 进度指示器的进度，从0.0到1.0。默认为0.0。
 */
@property (assign, nonatomic) float progress;

/// @name ProgressObject

/**
 * The NSProgress object feeding the progress information to the progress indicator.
 * NSProgress对象将进度信息反馈到进度指示器。
 */
@property (strong, nonatomic, nullable) NSProgress *progressObject;

/// @name Views

/**
 * The view containing the labels and indicator (or customView).
 * 包含标签和指示器的视图（或自定义视图）。
 */
@property (strong, nonatomic, readonly) MBBackgroundView *bezelView;

/**
 * View covering the entire HUD area, placed behind bezelView.
 * 视图覆盖整个HUD区域，放置在bezelView后面。
 */
@property (strong, nonatomic, readonly) MBBackgroundView *backgroundView;

/**
 * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
 * The view should implement intrinsicContentSize for proper sizing. For best results use approximately 37 by 37 pixels.
 * 当HUD在MBProgressHUDModeCustomView中显示的UIView(例如，一个UIImageView)。
   视图应该实现intrinsicContentSize以实现适当的大小调整。为了得到最好的结果，使用大约37×37像素。
 */
@property (strong, nonatomic, nullable) UIView *customView;

/**
 * A label that holds an optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
 * the entire text.
 * 一个标签，其中包含要显示在活动指示器下方的可选短消息。HUD会自动调整大小以适应整个文本。
 */
@property (strong, nonatomic, readonly) UILabel *label;

/**
 * A label that holds an optional details message displayed below the labelText message. The details text can span multiple lines.
 * 一个标签，其中包含一个可选的详细信息消息，显示在labelText消息下面。细节文本可以跨越多行。
 */
@property (strong, nonatomic, readonly) UILabel *detailsLabel;

/**
 * A button that is placed below the labels. Visible only if a target / action is added.
 * 放在标签下面的按钮。只有在添加目标/操作时才可见。
 */
@property (strong, nonatomic, readonly) UIButton *button;

@end


@protocol MBProgressHUDDelegate <NSObject>

@optional

/** 
 * Called after the HUD was fully hidden from the screen.
 * 在HUD完全从屏幕上隐藏后调用。
 */
- (void)hudWasHidden:(MBProgressHUD *)hud;

@end


/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 * 用圆(饼状图)表示明确进度的进度视图。
 */
@interface MBRoundProgressView : UIView 

/**
 * Progress (0.0 to 1.0)
 * 进度(0.0到1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor].
 * 指示器进度颜色。默认为白色[UIColor whiteColor]。
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color. 
 * Only applicable on iOS versions older than iOS 7.
 * Defaults to translucent white (alpha 0.1).
 * 指示器背景（非进度）颜色。仅适用于iOS 7之前的iOS版本。默认为半透明白色（alpha 0.1）。
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
   显示模式-NO=圆形或YES=环形。默认为圆形。
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end


/**
 * A flat bar progress view.
 * 扁平条进度视图。
 */
@interface MBBarProgressView : UIView

/**
 * Progress (0.0 to 1.0)
 * 进度（0.0到1.0）
 */
@property (nonatomic, assign) float progress;

/**
 * Bar border line color.
 * Defaults to white [UIColor whiteColor].
 * 条形边框线条颜色。默认为白色[UIColor whiteColor]。
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 * Bar background color.
 * Defaults to clear [UIColor clearColor];
 * 条形背景色。默认为透明[UIColor clearColor]；
 */
@property (nonatomic, strong) UIColor *progressRemainingColor;

/**
 * Bar progress color.
 * Defaults to white [UIColor whiteColor].
 * 进度条颜色。默认为白色[UIColor whiteColor]。
 */
@property (nonatomic, strong) UIColor *progressColor;

@end


@interface MBBackgroundView : UIView

/**
 * The background style. 
 * Defaults to MBProgressHUDBackgroundStyleBlur on iOS 7 or later and MBProgressHUDBackgroundStyleSolidColor otherwise.
 * @note Due to iOS 7 not supporting UIVisualEffectView, the blur effect differs slightly between iOS 7 and later versions.
 * 背景样式。
   在iOS 7或更高版本上，默认为MBProgressHUDBackgroundStyleBlur，否则默认为MBProgressHUDBackgroundStyleSolidColor。
   @注意，由于iOS 7不支持UIVisualEffectView，因此iOS 7和更高版本的模糊效果略有不同。
 */
@property (nonatomic) MBProgressHUDBackgroundStyle style;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 || TARGET_OS_TV
/**
 * The blur effect style, when using MBProgressHUDBackgroundStyleBlur.
 * Defaults to UIBlurEffectStyleLight.
 * 使用MBProgressHUDBackgroundStyleBlur时的模糊效果样式。
   默认为UIBlurEffectStyleLight。
 */
@property (nonatomic) UIBlurEffectStyle blurEffectStyle;
#endif

/**
 * The background color or the blur tint color.
 * @note Due to iOS 7 not supporting UIVisualEffectView, the blur effect differs slightly between iOS 7 and later versions.
 * 背景色或模糊淡色。
   @注意，由于iOS 7不支持UIVisualEffectView，因此iOS 7和更高版本的模糊效果略有不同。
 */
@property (nonatomic, strong) UIColor *color;

@end

@interface MBProgressHUD (Deprecated)

+ (NSArray *)allHUDsForView:(UIView *)view __attribute__((deprecated("Store references when using more than one HUD per view.")));
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated __attribute__((deprecated("Store references when using more than one HUD per view.")));

- (id)initWithWindow:(UIWindow *)window __attribute__((deprecated("Use initWithView: instead.")));

- (void)show:(BOOL)animated __attribute__((deprecated("Use showAnimated: instead.")));
- (void)hide:(BOOL)animated __attribute__((deprecated("Use hideAnimated: instead.")));
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay __attribute__((deprecated("Use hideAnimated:afterDelay: instead.")));

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(nullable MBProgressHUDCompletionBlock)completion __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
     completionBlock:(nullable MBProgressHUDCompletionBlock)completion __attribute__((deprecated("Use GCD directly.")));
@property (assign) BOOL taskInProgress __attribute__((deprecated("No longer needed.")));

@property (nonatomic, copy) NSString *labelText __attribute__((deprecated("Use label.text instead.")));
@property (nonatomic, strong) UIFont *labelFont __attribute__((deprecated("Use label.font instead.")));
@property (nonatomic, strong) UIColor *labelColor __attribute__((deprecated("Use label.textColor instead.")));
@property (nonatomic, copy) NSString *detailsLabelText __attribute__((deprecated("Use detailsLabel.text instead.")));
@property (nonatomic, strong) UIFont *detailsLabelFont __attribute__((deprecated("Use detailsLabel.font instead.")));
@property (nonatomic, strong) UIColor *detailsLabelColor __attribute__((deprecated("Use detailsLabel.textColor instead.")));
@property (assign, nonatomic) CGFloat opacity __attribute__((deprecated("Customize bezelView properties instead.")));
@property (strong, nonatomic) UIColor *color __attribute__((deprecated("Customize the bezelView color instead.")));
@property (assign, nonatomic) CGFloat xOffset __attribute__((deprecated("Set offset.x instead.")));
@property (assign, nonatomic) CGFloat yOffset __attribute__((deprecated("Set offset.y instead.")));
@property (assign, nonatomic) CGFloat cornerRadius __attribute__((deprecated("Set bezelView.layer.cornerRadius instead.")));
@property (assign, nonatomic) BOOL dimBackground __attribute__((deprecated("Customize HUD background properties instead.")));
@property (strong, nonatomic) UIColor *activityIndicatorColor __attribute__((deprecated("Use UIAppearance to customize UIActivityIndicatorView. E.g.: [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor redColor];")));
@property (atomic, assign, readonly) CGSize size __attribute__((deprecated("Get the bezelView.frame.size instead.")));

@end

NS_ASSUME_NONNULL_END
