//
//  UIScrollView+EmptyDataSet.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2016 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DZNEmptyDataSetSource;
@protocol DZNEmptyDataSetDelegate;

#define DZNEmptyDataSetDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

/**
 A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display.
 @discussion It will work automatically, by just conforming to DZNEmptyDataSetSource, and returning the data you want to show.
 
 译：一个可随时访问UITableView/UICollectionView的超类类别，用于在视图没有要显示的内容时显示空数据集。它将自动工作，只需遵从DZNEmptyDataSetSource并返回想要显示的数据。
 */
@interface UIScrollView (EmptyDataSet)

/** The empty datasets data source.
 
 译：空数据集数据源。
 */
@property (nonatomic, weak, nullable) IBOutlet id <DZNEmptyDataSetSource> emptyDataSetSource;
/** The empty datasets delegate.
 
 译：空数据集代理。
 */
@property (nonatomic, weak, nullable) IBOutlet id <DZNEmptyDataSetDelegate> emptyDataSetDelegate;
/** YES if any empty dataset is visible.
 
 译：如果任何空数据集可见，则为“YES”。
 */
@property (nonatomic, readonly, getter = isEmptyDataSetVisible) BOOL emptyDataSetVisible;

/**
 Reloads the empty dataset content receiver.
 @discussion Call this method to force all the data to refresh. Calling -reloadData is similar, but this forces only the empty dataset to reload, not the entire table view or collection view.
 
 译：重新加载空数据集内容接收器。
 @讨论 调用此方法以强制刷新所有数据。调用-reloadData类似，但这只会强制重新加载空数据集，而不是整个表视图或集合视图。
 */
- (void)reloadEmptyDataSet;

@end


/**
 The object that acts as the data source of the empty datasets.
 @discussion The data source must adopt the DZNEmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
 
 译：充当空数据集的数据源的对象。
 @讨论 数据源必须采用DZNEmptyDataSetSource协议。不保留数据源。所有数据源方法都是可选的。
 */
@protocol DZNEmptyDataSetSource <NSObject>
@optional

/**
 Asks the data source for the title of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset title, combining font, text color, text pararaph style, etc.
 
 译：向数据源询问数据集的标题。如果未设置属性，则默认情况下，数据集使用固定字体样式。如果需要其他字体样式，请返回属性字符串。
 
 参数 ：
 
 scrollView：通知数据源的scrollView子类。
 
 返回值：数据集标题的属性字符串，包括字体、文本颜色、文本段落样式等。
 
 */
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 
 译：向数据源询问数据集的描述。如果未设置属性，则默认情况下，数据集使用固定字体样式。如果需要其他字体样式，请返回属性字符串。
 
 参数：
 
 scrollView：通知数据源的scrollView子类。
 
 返回值：用于数据集描述文本的属性字符串，包括字体、文本颜色、文本段落样式等。
 
 */
- (nullable NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the image of the dataset.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An image for the dataset.
 
 译：向数据源询问数据集的图像。
 
 参数：
 
 scrollView：通知数据源的scrollView子类。
 
 返回值：数据集的图像。
 
 */
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;


/**
 Asks the data source for a tint color of the image dataset. Default is nil.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to tint the image of the dataset.
 
 译：询问数据源的图像数据的色调颜色。默认值为nil。
 
 参数：
 
 scrollView：通知数据源的scrollView子类对象。
 
 返回值：为数据集的图像着色的颜色。
 
 */
- (nullable UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView;

/**
 * Asks the data source for the image animation of the dataset.
 *
 * @param scrollView A scrollView subclass object informing the delegate.
 *
 * @return image animation
 *
 * 译：向数据源询问数据集的图像动画。
 *
 * 参数：
 *
 * scrollView：通知代理的scrollView子类对象。
 *
 * 返回值：图像动画
 */
- (nullable CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the title to be used for the specified button state.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 
 译：询问数据源提供用于指定按钮状态的标题。如果未设置属性，则默认情况下，数据集使用固定字体样式。如果需要其他字体样式，请返回属性字符串。
 
 参数：
 
 scrollView：通知数据源的scrollView子类对象。
 
 state：使用指定标题的状态。可能的值在UIControlState状态中描述。
 
 返回值：数据集按钮标题的属性字符串，包括字体、文本颜色、文本段落样式等。
 
 */
- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the image to be used for the specified button state.
 This method will override buttonTitleForEmptyDataSet:forState: and present the image only without any text.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An image for the dataset button imageview.
 
 译：询问数据源将图像用于指定的按钮状态。此方法将覆盖buttonTitleForEmptyDataSet:forState:并只显示图像，不显示任何文本。
 
 参数：
 
 scrollView：通知数据源的scrollView子类对象。
 
 state：使用指定图像的状态。可能的值在UIControlState中描述。
 
 返回值：返回数据集按钮imageview的图像。
 */
- (nullable UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for a background image to be used for the specified button state.
 There is no default style for this call.
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 
 译文：询问数据源提供用于指定按钮状态的背景图像。这个调用没有默认的样式。
 
 参数：
 
 scrollView：通知数据源的scrollView子类。
 
 state：使用指定图像的状态。这些值在UIControlState中描述。
 
 返回值：返回数据集按钮指定按钮状态的背景图像。
 */
- (nullable UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the background color of the dataset. Default is clear color.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to be applied to the dataset background view.
 
 译：向数据源询问数据集的背景颜色。默认是透明的颜色。
 
 参数：
 
 scrollView：通知数据源的scrollView子类对象。
 
 返回值：将应用于数据集背景视图的颜色。
 */
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a custom view to be displayed instead of the default views such as labels, imageview and button. Default is nil.
 Use this method to show an activity view indicator for loading feedback, or for complete custom empty data set.
 Returning a custom view will ignore -offsetForEmptyDataSet and -spaceHeightForEmptyDataSet configurations.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The custom view.
 
 译：询问数据源显示自定义视图，而不是默认视图，如标签、图像视图和按钮。默认值为nil。使用此方法显示用于加载反馈的活动视图指示器，或用于完整的自定义空数据集。返回一个自定义视图将忽略-offsetForEmptyDataSet和-spaceHeightForEmptyDataSet配置。
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：自定义视图。
 */
- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a offset for vertical and horizontal alignment of the content. Default is CGPointZero.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The offset for vertical and horizontal alignment.
 
 译：向数据源询问内容的垂直和水平对齐的偏移量。默认是CGPointZero。不推荐的方法，推荐使用verticalOffsetForEmptyDataSet
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：用于垂直和水平对准的偏移量。
 */
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-verticalOffsetForEmptyDataSet:);
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a vertical space between elements. Default is 11 pts.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The space height between elements.
 
 译：询问数据源元素之间的垂直间距。默认值为11pts。
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：元素之间的空间高度。
 */
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;

@end


/**
 The object that acts as the delegate of the empty datasets.
 @discussion The delegate can adopt the DZNEmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
 
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 
 译：充当空数据集的代理的对象。
 @讨论 代理可以采用DZNEmptyDataSetDelegate协议。代理未被保留。所有代理方法都是可选的。
 */
@protocol DZNEmptyDataSetDelegate <NSObject>
@optional

/**
 Asks the delegate to know if the empty dataset should fade in when displayed. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should fade in.
 
 译：询问代理知道显示空数据集时是否应淡入。默认为“YES”。
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：如果空数据集应该淡入，则返回YES。
 */
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView;

/**
 Asks the delegate to know if the empty dataset should still be displayed when the amount of items is more than 0. Default is NO
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if empty dataset should be forced to display
 
 译：询问代理知道当项目数大于0时是否仍应显示空数据集。默认为NO
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：如果应强制显示空数据集，则为“YES”
 */
- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView;

/**
 Asks the delegate to know if the empty dataset should be rendered and displayed. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should show.
 
 译：询问代理知道是否应呈现和显示空数据集。默认为“YES”。
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：如果应该显示空数据集，则为“YES”。
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;

/**
 Asks the delegate for touch permission. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset receives touch gestures.
 
 译：询问代理是否允许触摸。默认为“YES”。
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：如果空数据集接收到触摸手势，则为“YES”。
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;

/**
 Asks the delegate for scroll permission. Default is NO.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to be scrollable.
 
 译：向代理请求滚动权限。默认为NO。
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：如果允许空数据集可滚动，则为“YES”。
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;

/**
 Asks the delegate for image view animation permission. Default is NO.
 Make sure to return a valid CAAnimation object from imageAnimationForEmptyDataSet:
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to animate
 
 译：询问代理图像视图动画权限。默认为NO。确保从imageAnimationForEmptyDataSet:函数返回一个有效的CAAnimation对象
 
 参数：
 
 scrollView：通知代理的scrollView子类对象。
 
 返回值：如果允许空数据集设置动画，则为YES
 */
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 
 译： 通知代理已点击空数据集视图。使用此方法可以重新指定UITextField或searchBar的第一个响应程序。不推荐的方法，推荐使用emptyDataSet:didTapView:方法
 
 参数：
 
 scrollView：通知代理的scrollView子类。
 */
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataSet:didTapView:);

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 
 译：通知代理操作按钮已被点击。不推荐的方法，推荐使用emptyDataSet:didTapView:方法
 
 参数：
 
 scrollView：通知代理的scrollView子类。
 */
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataSet:didTapButton:);

/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param view the view tapped by the user
 
 译：通知代理已点击空数据集视图。使用此方法可以重新指定UITextField或searchBar的第一个响应程序。
 
 参数：
 
 scrollView：通知代理的scrollView子类。
 
 view：用户点击的视图
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 
 译：通知代理操作按钮已被点击。
 
 参数：
 
 scrollView：通知代理的scrollView子类。
 
 button：用户点击的按钮
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/**
 Tells the delegate that the empty data set will appear.

 @param scrollView A scrollView subclass informing the delegate.
 
 译：通知代理将要显示空数据集。
 
 参数：通知代理的scrollView子类。
 */
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set did appear.

 @param scrollView A scrollView subclass informing the delegate.
 
 译：通知代理已经显示空数据集。
 
 参数：
 
 scrollView：通知代理的scrollView子类。
 */
- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set will disappear.

 @param scrollView A scrollView subclass informing the delegate.
 
 译：通知代理空数据集将要消失。
 
 scrollView：通知代理的scrollView子类。
 */
- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set did disappear.

 @param scrollView A scrollView subclass informing the delegate.
 
 译：通知代理空数据集已经消失。
 
 参数：
 
 scrollView：通知代理的scrollView子类。
 */
- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView;

@end

#undef DZNEmptyDataSetDeprecated

NS_ASSUME_NONNULL_END
