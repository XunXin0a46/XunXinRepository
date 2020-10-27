//
//  FSCalendar.h
//  FSCalendar
//
//  Created by Wenchao Ding on 29/1/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
// 
//  https://github.com/WenchaoD
//
//  FSCalendar is a superior awesome calendar control with high performance, high customizablility and very simple usage.
//
//  @see FSCalendarDataSource
//  @see FSCalendarDelegate
//  @see FSCalendarDelegateAppearance
//  @see FSCalendarAppearance
//  日历

#import <UIKit/UIKit.h>
#import "FSCalendarAppearance.h"
#import "FSCalendarConstants.h"
#import "FSCalendarCell.h"
#import "FSCalendarWeekdayView.h"
#import "FSCalendarHeaderView.h"

//! Project version number for FSCalendar.
/// FSCalendar的项目版本号。
FOUNDATION_EXPORT double FSCalendarVersionNumber;

//! Project version string for FSCalendar.
/// FSCalendar的项目版本字符串。
FOUNDATION_EXPORT const unsigned char FSCalendarVersionString[];

typedef NS_ENUM(NSUInteger, FSCalendarScope) {
    FSCalendarScopeMonth,
    FSCalendarScopeWeek
};

typedef NS_ENUM(NSUInteger, FSCalendarScrollDirection) {
    FSCalendarScrollDirectionVertical,
    FSCalendarScrollDirectionHorizontal
};

typedef NS_ENUM(NSUInteger, FSCalendarPlaceholderType) {
    //隐藏所有占位符
    FSCalendarPlaceholderTypeNone          = 0,
    //占位符填充头尾
    FSCalendarPlaceholderTypeFillHeadTail  = 1,
    //占位符填充6行
    FSCalendarPlaceholderTypeFillSixRows   = 2
};

typedef NS_ENUM(NSUInteger, FSCalendarMonthPosition) {
    FSCalendarMonthPositionPrevious,
    FSCalendarMonthPositionCurrent,
    FSCalendarMonthPositionNext,
    
    FSCalendarMonthPositionNotFound = NSNotFound
};

NS_ASSUME_NONNULL_BEGIN

@class FSCalendar;

/**
 * FSCalendarDataSource is a source set of FSCalendar. The basic role is to provide event、subtitle and min/max day to display, or customized day cell for the calendar.
   FSCalendarDataSource是FSCalendar的源集。基本角色是提供要显示的事件、副标题和最小/最大日期，或自定义日历的日期单元格。
 */
@protocol FSCalendarDataSource <NSObject>

@optional

/**
 * Asks the dataSource for a title for the specific date as a replacement of the day text
   向数据源请求特定日期的标题，作为日期文本的替换
 */
- (nullable NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date;

/**
 * Asks the dataSource for a subtitle for the specific date under the day text.
   在日期文本下向数据源请求特定日期的副标题。
 */
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date;

/**
 * Asks the dataSource for an image for the specific date.
   向数据源查询特定日期的图像。
 */
- (nullable UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date;

/**
 * Asks the dataSource the minimum date to display.
   要求数据源显示的最小日期。
 */
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar;

/**
 * Asks the dataSource the maximum date to display.
   询问数据源要显示的最大日期。
 */
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar;

/**
 * Asks the data source for a cell to insert in a particular data of the calendar.
   要求数据源将单元格插入到日历的特定数据中
 */
- (__kindof FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

/**
 * Asks the dataSource the number of event dots for a specific date.
   向数据源询问特定日期的事件点数量。
 *
 * @see
 *   - (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date;
 *   - (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorsForDate:(NSDate *)date;
 */
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date;

/**
 * This function is deprecated
   不推荐使用此函数
 */
- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date FSCalendarDeprecated(-calendar:numberOfEventsForDate:);

@end


/**
 * The delegate of a FSCalendar object must adopt the FSCalendarDelegate protocol. The optional methods of FSCalendarDelegate manage selections、 user events and help to manager the frame of the calendar.
   FSCalendar对象的委托必须采用FSCalendarDelegate协议。FSCalendarDelegate的可选方法管理选择、用户事件和帮助管理日历框架。
 */
@protocol FSCalendarDelegate <NSObject>

@optional

/**
 Asks the delegate whether the specific date is allowed to be selected by tapping.
 通过点击询问委托是否允许选择特定的日期。
 */
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;

/**
 Tells the delegate a date in the calendar is selected by tapping.
 通过点击告诉委托日历中的日期被选中。
 */
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;

/**
 Asks the delegate whether the specific date is allowed to be deselected by tapping.
 通过点击询问代表是否允许取消选定的具体日期。
 */
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;

/**
 Tells the delegate a date in the calendar is deselected by tapping.
 通过点击告诉委托日历中取消选择的日期。
 */
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;


/**
 Tells the delegate the calendar is about to change the bounding rect.
 告诉委托日历将更改边界矩形。
 */
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated;

/**
 Tells the delegate that the specified cell is about to be displayed in the calendar.
 告诉委托指定的单元格将在日历中显示。
 */
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition;

/**
 Tells the delegate the calendar is about to change the current page.
 告诉委托日历即将更改当前页。
 */
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar;

/**
 These functions are deprecated
 不推荐使用这些函数
 */
- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated FSCalendarDeprecated(-calendar:boundingRectWillChange:animated:);
- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar FSCalendarDeprecated(-calendarCurrentPageDidChange:);
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date FSCalendarDeprecated(-calendar:shouldSelectDate:atMonthPosition:);- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date FSCalendarDeprecated(-calendar:didSelectDate:atMonthPosition:);
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date FSCalendarDeprecated(-calendar:shouldDeselectDate:atMonthPosition:);
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date FSCalendarDeprecated(-calendar:didDeselectDate:atMonthPosition:);

@end

/**
 * FSCalendarDelegateAppearance determines the fonts and colors of components in the calendar, but more specificly. Basically, if you need to make a global customization of appearance of the calendar, use FSCalendarAppearance. But if you need different appearance for different days, use FSCalendarDelegateAppearance.
   FSCalendarDelegateAppearance决定日历中组件的字体和颜色，但更具体。基本上，如果您需要对日历的外观进行全局定制，那么可以使用FSCalendarAppearance。如果你在不同的时间需要不同的外观，使用FSCalendarDelegateAppearance。
 *
 * @see FSCalendarAppearance
 */
@protocol FSCalendarDelegateAppearance <FSCalendarDelegate>

@optional

/**
 * Asks the delegate for a fill color in unselected state for the specific date.
   向代理询问未选定状态下的具体日期的填充颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date;

/**
 * Asks the delegate for a fill color in selected state for the specific date.
   向代理询问在选定状态中为特定日期提供填充颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date;

/**
 * Asks the delegate for day text color in unselected state for the specific date.
   向代理询问未选定状态下的日期文本颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;

/**
 * Asks the delegate for day text color in selected state for the specific date.
   向代理询问在选定状态中指定日期的日期文本颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date;

/**
 * Asks the delegate for subtitle text color in unselected state for the specific date.
   向代理询问指定日期的未选状态下的副标题文本颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date;

/**
 * Asks the delegate for subtitle text color in selected state for the specific date.
   向代理询问指定日期的选定状态下的副标题文本颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date;

/**
 * Asks the delegate for event colors for the specific date.
   向代理询问特定日期的事件颜色。
 */
- (nullable NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date;

/**
 * Asks the delegate for multiple event colors in selected state for the specific date.
   向代理询问为特定日期提供处于选定状态的多个事件颜色。
 */
- (nullable NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date;

/**
 * Asks the delegate for a border color in unselected state for the specific date.
   向代理询问为特定日期提供未选定状态下的边框颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date;

/**
 * Asks the delegate for a border color in selected state for the specific date.
   向代理询问为特定日期提供处于选定状态的边框颜色。
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date;

/**
 * Asks the delegate for an offset for day text for the specific date.
   向代理询为特定日期的日期文本提供偏移量。
 */
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date;

/**
 * Asks the delegate for an offset for subtitle for the specific date.
   向代理询问特定日期副标题的偏移量。
 */
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleOffsetForDate:(NSDate *)date;

/**
 * Asks the delegate for an offset for image for the specific date.
   向代理询问为特定日期的图像提供偏移量。
 */
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance imageOffsetForDate:(NSDate *)date;

/**
 * Asks the delegate for an offset for event dots for the specific date.
   向代理询问为特定日期的事件点提供偏移量。
 */
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date;


/**
 * Asks the delegate for a border radius for the specific date.
   向代理询问特定日期的边框半径。
 */
- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(NSDate *)date;

/**
 * These functions are deprecated
   不推荐使用这些函数
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillColorForDate:(NSDate *)date FSCalendarDeprecated(-calendar:appearance:fillDefaultColorForDate:);
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date FSCalendarDeprecated(-calendar:appearance:fillSelectionColorForDate:);
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date FSCalendarDeprecated(-calendar:appearance:eventDefaultColorsForDate:);
- (nullable NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorsForDate:(NSDate *)date FSCalendarDeprecated(-calendar:appearance:eventDefaultColorsForDate:);
- (FSCalendarCellShape)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance cellShapeForDate:(NSDate *)date FSCalendarDeprecated(-calendar:appearance:borderRadiusForDate:);
@end

#pragma mark - Primary

IB_DESIGNABLE
@interface FSCalendar : UIView

/**
 * The object that acts as the delegate of the calendar.
   充当日历代理的对象。
 */
@property (weak, nonatomic) IBOutlet id<FSCalendarDelegate> delegate;

/**
 * The object that acts as the data source of the calendar.
   充当日历数据源的对象。
 */
@property (weak, nonatomic) IBOutlet id<FSCalendarDataSource> dataSource;

/**
 * 日历上的“今天”会有一个特别的标记。
 */
@property (nullable, strong, nonatomic) NSDate *today;

/**
 * The current page of calendar
   日历的当前页
 *
 * @desc In week mode, current page represents the current visible week; In month mode, it means current visible month.
   @说明 在周模式下，当前页表示当前可见周；在月模式下，表示当前可见月。
 */
@property (strong, nonatomic) NSDate *currentPage;

/**
 * The locale of month and weekday symbols. Change it to display them in your own language.
   月份和工作日符号的区域设置。更改为以您自己的语言显示它们。
 *
 * e.g. To display them in Chinese:
   例如用中文显示
 * 
 *    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
 */
@property (copy, nonatomic) NSLocale *locale;

/**
 * The scroll direction of FSCalendar.
   FSCalendar的滚动方向。
 *
 * e.g. To make the calendar scroll vertically
   例如，使日历垂直滚动
 *
 *    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
 */
@property (assign, nonatomic) FSCalendarScrollDirection scrollDirection;

/**
 * The scope of calendar, change scope will trigger an inner frame change, make sure the frame has been correctly adjusted in
   日历范围、更改范围将触发内部框架更改，请确保框架已在 -(void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated中正确调整
 *
 *    - (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated;
 */
@property (assign, nonatomic) FSCalendarScope scope;

/**
 A UIPanGestureRecognizer instance which enables the control of scope on the whole day-area. Not available if the scrollDirection is vertical.
 一个uipangestureRecognizer实例，它允许对全天区域的范围进行控制。如果滚动方向是垂直的，则不可用。
 
 @deprecated Use -handleScopeGesture: instead
 @不推荐使用-handlescopegesture:代替
 
 e.g.
 例如
 
    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:calendar action:@selector(handleScopeGesture:)];
    [calendar addGestureRecognizer:scopeGesture];
 
 @see DIYExample
 @see FSCalendarScopeExample
 */
@property (readonly, nonatomic) UIPanGestureRecognizer *scopeGesture FSCalendarDeprecated(handleScopeGesture:);

/**
 * A UILongPressGestureRecognizer instance which enables the swipe-to-choose feature of the calendar.
   一个UILongPressGestureRecognizer实例，支持滑动选择日历功能。
 *
 * e.g.
   例如
 *
 *    calendar.swipeToChooseGesture.enabled = YES;
 */
@property (readonly, nonatomic) UILongPressGestureRecognizer *swipeToChooseGesture;

/**
 * The placeholder type of FSCalendar. Default is FSCalendarPlaceholderTypeFillSixRows.
   FSCalendar的占位符类型。默认是FSCalendarPlaceholderTypeFillSixRows。
 *
 * e.g. To hide all placeholder of the calendar
   隐藏日历的所有占位符
 *
 *    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
 */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger placeholderType;
#else
@property (assign, nonatomic) FSCalendarPlaceholderType placeholderType;
#endif

/**
 The index of the first weekday of the calendar. Give a '2' to make Monday in the first column.
 日历第一个工作日的索引。在第一栏中给“2”表示星期一。
 */
@property (assign, nonatomic) IBInspectable NSUInteger firstWeekday;

/**
 The height of month header of the calendar. Give a '0' to remove the header.
 日历的月标题的高度。给“0”以删除标题。
 */
@property (assign, nonatomic) IBInspectable CGFloat headerHeight;

/**
 The height of weekday header of the calendar.
 日历的工作日标题的高度。
 */
@property (assign, nonatomic) IBInspectable CGFloat weekdayHeight;

/**
 The weekday view of the calendar
 日历的工作日视图
 */
@property (strong, nonatomic) FSCalendarWeekdayView *calendarWeekdayView;

/**
 The header view of the calendar
 日历的标题视图
 */
@property (strong, nonatomic) FSCalendarHeaderView *calendarHeaderView;

/**
 A Boolean value that determines whether users can select a date.
 确定用户是否可以选择日期的布尔值。
 */
@property (assign, nonatomic) IBInspectable BOOL allowsSelection;

/**
 A Boolean value that determines whether users can select more than one date.
 确定用户是否可以选择多个日期的布尔值。
 */
@property (assign, nonatomic) IBInspectable BOOL allowsMultipleSelection;

/**
 A Boolean value that determines whether paging is enabled for the calendar.
 一个布尔值，用于确定是否为日历启用分页。
 */
@property (assign, nonatomic) IBInspectable BOOL pagingEnabled;

/**
 A Boolean value that determines whether scrolling is enabled for the calendar.
 一个布尔值，用于确定是否为日历启用滚动。
 */
@property (assign, nonatomic) IBInspectable BOOL scrollEnabled;

/**
 A Boolean value that determines whether the calendar should show a handle for control the scope. Default is NO;
 一个布尔值，用于确定日历是否应显示控制范围的句柄。默认是NO;
 
 @deprecated Use -handleScopeGesture: instead
 @不推荐使用-handlescopegesture:代替
 
 e.g.
 例如
 
    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    scopeGesture.delegate = ...
    [anyOtherView addGestureRecognizer:scopeGesture];
 
 @see FSCalendarScopeExample
 
 */
@property (assign, nonatomic) IBInspectable BOOL showsScopeHandle FSCalendarDeprecated(handleScopeGesture:);

/**
 The row height of the calendar if paging enabled is NO.;
 如果启用分页是NO，则日历的行高度;
 */
@property (assign, nonatomic) IBInspectable CGFloat rowHeight;

/**
 The calendar appearance used to control the global fonts、colors .etc
 用于控制全局字体、颜色等的日历外观
 */
@property (readonly, nonatomic) FSCalendarAppearance *appearance;

/**
 A date object representing the minimum day enable、visible and selectable. (read-only)
 一个日期对象，表示最小启用日期、可见日期和可选日期。(只读)
 */
@property (readonly, nonatomic) NSDate *minimumDate;

/**
 A date object representing the maximum day enable、visible and selectable. (read-only)
 一个日期对象，表示最大启用日期、可见日期和可选日期。(只读)
 */
@property (readonly, nonatomic) NSDate *maximumDate;

/**
 A date object identifying the section of the selected date. (read-only)
 一个日期对象，用于标识所选日期的部分。(只读)
 */
@property (nullable, readonly, nonatomic) NSDate *selectedDate;

/**
 The dates representing the selected dates. (read-only)
 表示所选日期的日期。(只读)
 */
@property (readonly, nonatomic) NSArray<NSDate *> *selectedDates;

/**
 Reload the dates and appearance of the calendar.
 重新加载日历的日期和外观。
 */
- (void)reloadData;

/**
 Change the scope of the calendar. Make sure `-calendar:boundingRectWillChange:animated` is correctly adopted.
 更改日历的范围。确保' calendar:boundingRectWillChange:animated '被正确使用。
 
 @param scope The target scope to change.（要更改的目标范围）
 @param animated YES if you want to animate the scoping; NO if the change should be immediate.（如果要设置作用域的动画，则为yes；如果更改应立即进行，则为no
 */
- (void)setScope:(FSCalendarScope)scope animated:(BOOL)animated;

/**
 Selects a given date in the calendar.
 选择日历中的给定日期。
 
 @param date A date in the calendar.（日历中的日期）
 */
- (void)selectDate:(nullable NSDate *)date;

/**
 Selects a given date in the calendar, optionally scrolling the date to visible area.
 选择日历中的给定日期，可以选择将日期滚动到可见区域。
 
 @param date A date in the calendar.（日历上的一个日期）
 @param scrollToDate A Boolean value that determines whether the calendar should scroll to the selected date to visible area.（一个布尔值，用于确定日历是否应该滚动到选定的日期到可见区域。）
 */
- (void)selectDate:(nullable NSDate *)date scrollToDate:(BOOL)scrollToDate;

/**
 Deselects a given date of the calendar.
 取消选定某一日历日期。
 
 @param date A date in the calendar.（日历上的一个日期）
 */
- (void)deselectDate:(NSDate *)date;

/**
 Changes the current page of the calendar.
 更改日历的当前页。
 
 @param currentPage Representing weekOfYear in week mode, or month in month mode.（以周模式表示年中的周，或以月模式表示月）
 @param animated YES if you want to animate the change in position; NO if it should be immediate.（如果要设置位置更改的动画，请选择“YES”；如果应该立即更改，请选择“NO”。）
 */
- (void)setCurrentPage:(NSDate *)currentPage animated:(BOOL)animated;

/**
 Register a class for use in creating new calendar cells.
 注册用于创建新日历单元格的类。

 @param cellClass The class of a cell that you want to use in the calendar.（要在日历中使用的单元格的类。）
 @param identifier The reuse identifier to associate with the specified class. This parameter must not be nil and must not be an empty string.（要与指定类关联的重用标识符。此参数不能为nil，也不能为空字符串。）
 */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/**
 Returns a reusable calendar cell object located by its identifier.
 返回由其标识符定位的可重用日历单元格对象。

 @param identifier The reuse identifier for the specified cell. This parameter must not be nil.（指定单元格的重用标识符。该参数不能为nil。）
 @param date The specific date of the cell.（单元格的特定日期）
 @return A valid FSCalendarCell object.（一个有效的FSCalendarCell对象）
 */
- (__kindof FSCalendarCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

/**
 Returns the calendar cell for the specified date.
 返回指定日期的日历单元格。

 @param date The date of the cell（单元格的日期）
 @param position The month position for the cell（单元格的月位置）
 @return An object representing a cell of the calendar, or nil if the cell is not visible or date is out of range.（表示日历单元格的对象，如果单元格不可见或日期超出范围，则为nil。）
 */
- (nullable FSCalendarCell *)cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;


/**
 Returns the date of the specified cell.
 返回指定单元格的日期。
 
 @param cell The cell object whose date you want.（想要其日期的单元格对象）
 @return The date of the cell or nil if the specified cell is not in the calendar.（元格的日期，如果指定的单元格不在日历中，则为nil。）
 */
- (nullable NSDate *)dateForCell:(FSCalendarCell *)cell;

/**
 Returns the month position of the specified cell.
 返回指定单元格的月份位置。
 
 @param cell The cell object whose month position you want.（想要其月份位置的单元格对象。）
 @return The month position of the cell or FSCalendarMonthPositionNotFound if the specified cell is not in the calendar.（如果指定的单元格不在日历中，则为该单元格或FSCalendarMonthPositionNotFound的月份位置）
 */
- (FSCalendarMonthPosition)monthPositionForCell:(FSCalendarCell *)cell;


/**
 Returns an array of visible cells currently displayed by the calendar.
 返回日历当前显示的可见单元格数组。
 
 @return An array of FSCalendarCell objects. If no cells are visible, this method returns an empty array.
 FSCalendarCell对象的数组。如果没有可见的单元格，则此方法返回空数组。
 */
- (NSArray<__kindof FSCalendarCell *> *)visibleCells;

/**
 Returns the frame for a non-placeholder cell relative to the super view of the calendar.
 返回与日历的父视图相关的非占位符单元格的frame。
 
 @param date A date is the calendar.（日历的日期。）
 */
- (CGRect)frameForDate:(NSDate *)date;

/**
 An action selector for UIPanGestureRecognizer instance to control the scope transition
 UIPanGestureRecognizer实例的操作选择器，用于控制范围转换
 
 @param sender A UIPanGestureRecognizer instance which controls the scope of the calendar（控制日历范围的UIPanGestureRecognizer实例）
 */
- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender;

@end


IB_DESIGNABLE
@interface FSCalendar (IBExtension)

#if TARGET_INTERFACE_BUILDER

@property (assign, nonatomic) IBInspectable CGFloat  titleTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  subtitleTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  weekdayTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  headerTitleTextSize;

@property (strong, nonatomic) IBInspectable UIColor  *eventDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *eventSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *weekdayTextColor;

@property (strong, nonatomic) IBInspectable UIColor  *headerTitleColor;
@property (strong, nonatomic) IBInspectable NSString *headerDateFormat;
@property (assign, nonatomic) IBInspectable CGFloat  headerMinimumDissolvedAlpha;

@property (strong, nonatomic) IBInspectable UIColor  *titleDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleTodayColor;
@property (strong, nonatomic) IBInspectable UIColor  *titlePlaceholderColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleWeekendColor;

@property (strong, nonatomic) IBInspectable UIColor  *subtitleDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleTodayColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitlePlaceholderColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleWeekendColor;

@property (strong, nonatomic) IBInspectable UIColor  *selectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *todayColor;
@property (strong, nonatomic) IBInspectable UIColor  *todaySelectionColor;

@property (strong, nonatomic) IBInspectable UIColor *borderDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor *borderSelectionColor;

@property (assign, nonatomic) IBInspectable CGFloat borderRadius;
@property (assign, nonatomic) IBInspectable BOOL    useVeryShortWeekdaySymbols;

@property (assign, nonatomic) IBInspectable BOOL      fakeSubtitles;
@property (assign, nonatomic) IBInspectable BOOL      fakeEventDots;
@property (assign, nonatomic) IBInspectable NSInteger fakedSelectedDay;

#endif

@end


#pragma mark - Deprecate

@interface FSCalendar (Deprecated)
@property (assign, nonatomic) CGFloat lineHeightMultiplier FSCalendarDeprecated(rowHeight);
@property (assign, nonatomic) IBInspectable BOOL showsPlaceholders FSCalendarDeprecated('placeholderType');
@property (strong, nonatomic) NSString *identifier DEPRECATED_MSG_ATTRIBUTE("Changing calendar identifier is NOT RECOMMENDED. ");

// Use NSCalendar.
- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day FSCalendarDeprecated([NSDateFormatter dateFromString:]);
- (NSInteger)yearOfDate:(NSDate *)date FSCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)monthOfDate:(NSDate *)date FSCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)dayOfDate:(NSDate *)date FSCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)weekdayOfDate:(NSDate *)date FSCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)weekOfDate:(NSDate *)date FSCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSDate *)dateByAddingYears:(NSInteger)years toDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingYears:(NSInteger)years fromDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateByAddingMonths:(NSInteger)months toDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingMonths:(NSInteger)months fromDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks toDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingWeeks:(NSInteger)weeks fromDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingDays:(NSInteger)days fromDate:(NSDate *)date FSCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toCalendarUnit:(FSCalendarUnit)unit FSCalendarDeprecated([NSCalendar -isDate:equalToDate:toUnitGranularity:]);
- (BOOL)isDateInToday:(NSDate *)date FSCalendarDeprecated([NSCalendar -isDateInToday:]);


@end

NS_ASSUME_NONNULL_END

