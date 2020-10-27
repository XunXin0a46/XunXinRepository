//
//  FSCalendarAppearance.h
//  Pods
//
//  Created by DingWenchao on 6/29/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//

#import "FSCalendarConstants.h"

@class FSCalendar;

typedef NS_ENUM(NSInteger, FSCalendarCellState) {
    FSCalendarCellStateNormal      = 0,
    FSCalendarCellStateSelected    = 1,
    FSCalendarCellStatePlaceholder = 1 << 1,
    FSCalendarCellStateDisabled    = 1 << 2,
    FSCalendarCellStateToday       = 1 << 3,
    FSCalendarCellStateWeekend     = 1 << 4,
    FSCalendarCellStateTodaySelected = FSCalendarCellStateToday|FSCalendarCellStateSelected
};

typedef NS_ENUM(NSUInteger, FSCalendarSeparators) {
    FSCalendarSeparatorNone          = 0,
    FSCalendarSeparatorInterRows     = 1
};

typedef NS_OPTIONS(NSUInteger, FSCalendarCaseOptions) {
    FSCalendarCaseOptionsHeaderUsesDefaultCase      = 0,
    FSCalendarCaseOptionsHeaderUsesUpperCase        = 1,
    
    FSCalendarCaseOptionsWeekdayUsesDefaultCase     = 0 << 4,
    FSCalendarCaseOptionsWeekdayUsesUpperCase       = 1 << 4,
    FSCalendarCaseOptionsWeekdayUsesSingleUpperCase = 2 << 4,
};

/**
 * FSCalendarAppearance determines the fonts and colors of components in the calendar.
   FSCalendarAppearance确定日历中组件的字体和颜色。
 *
 * @see FSCalendarDelegateAppearance
 */
@interface FSCalendarAppearance : NSObject

/**
 * The font of the day text.
   日文本的字体。
 */
@property (strong, nonatomic) UIFont   *titleFont;

/**
 * The font of the subtitle text.
   副标题文本的字体。
 */
@property (strong, nonatomic) UIFont   *subtitleFont;

/**
 * The font of the weekday text.
   工作日文本的字体。
 */
@property (strong, nonatomic) UIFont   *weekdayFont;

/**
 * The font of the month text.
   月份文本的字体。
 */
@property (strong, nonatomic) UIFont   *headerTitleFont;

/**
 * The offset of the day text from default position.
   日文本与默认位置的偏移量。
 */
@property (assign, nonatomic) CGPoint  titleOffset;

/**
 * The offset of the subtitle text from default position.
   副标题文本与默认位置的偏移量。
 */
@property (assign, nonatomic) CGPoint  subtitleOffset;

/**
 * The offset of the event dots from default position.
   事件点与默认位置的偏移量。
 */
@property (assign, nonatomic) CGPoint eventOffset;

/**
 * The offset of the image from default position.
   图像与默认位置的偏移量。
 */
@property (assign, nonatomic) CGPoint imageOffset;

/**
 * The color of event dots.
   事件点的颜色。
 */
@property (strong, nonatomic) UIColor  *eventDefaultColor;

/**
 * The color of event dots.
   事件点的颜色。
 */
@property (strong, nonatomic) UIColor  *eventSelectionColor;

/**
 * The color of weekday text.
   工作日文本的颜色。
 */
@property (strong, nonatomic) UIColor  *weekdayTextColor;

/**
 * The color of month header text.
   月标题文本的颜色。
 */
@property (strong, nonatomic) UIColor  *headerTitleColor;

/**
 * The date format of the month header.
   月标题的日期格式。
 */
@property (strong, nonatomic) NSString *headerDateFormat;

/**
 * The alpha value of month label staying on the fringes.
   月份标签的alpha值处于边缘。
 */
@property (assign, nonatomic) CGFloat  headerMinimumDissolvedAlpha;

/**
 * The day text color for unselected state.
   未选定状态的日文本颜色。
 */
@property (strong, nonatomic) UIColor  *titleDefaultColor;

/**
 * The day text color for selected state.
   选定状态的日文本颜色。
 */
@property (strong, nonatomic) UIColor  *titleSelectionColor;

/**
 * The day text color for today in the calendar.
   日历中今天的日期文本颜色。
 */
@property (strong, nonatomic) UIColor  *titleTodayColor;

/**
 * The day text color for days out of current month.
   当前月份之外天数的日期文本颜色。
 */
@property (strong, nonatomic) UIColor  *titlePlaceholderColor;

/**
 * The day text color for weekend.
   周末的日文本颜色。
 */
@property (strong, nonatomic) UIColor  *titleWeekendColor;

/**
 * The subtitle text color for unselected state.
   未选定状态的副标题文本颜色。
 */
@property (strong, nonatomic) UIColor  *subtitleDefaultColor;

/**
 * The subtitle text color for selected state.
   选定状态的副标题文本颜色。
 */
@property (strong, nonatomic) UIColor  *subtitleSelectionColor;

/**
 * The subtitle text color for today in the calendar.
   日历中今天的副标题文本颜色
 */
@property (strong, nonatomic) UIColor  *subtitleTodayColor;

/**
 * The subtitle text color for days out of current month.
   当前月份之外天数的副标题文本颜色。
 */
@property (strong, nonatomic) UIColor  *subtitlePlaceholderColor;

/**
 * The subtitle text color for weekend.
   周末的副标题文本颜色。
 */
@property (strong, nonatomic) UIColor  *subtitleWeekendColor;

/**
 * The fill color of the shape for selected state.
   所选状态的填充颜色。
 */
@property (strong, nonatomic) UIColor  *selectionColor;

/**
 * The fill color of the shape for today.
   今天的填充颜色。
 */
@property (strong, nonatomic) UIColor  *todayColor;

/**
 * The fill color of the shape for today and selected state.
   今天选中的填充颜色
 */
@property (strong, nonatomic) UIColor  *todaySelectionColor;

/**
 * The border color of the shape for unselected state.
 未选定状态的边框颜色。
 */
@property (strong, nonatomic) UIColor  *borderDefaultColor;

/**
 * The border color of the shape for selected state.
 选定状态的边框颜色。
 */
@property (strong, nonatomic) UIColor  *borderSelectionColor;

/**
 * The border radius, while 1 means a circle, 0 means a rectangle, and the middle value will give it a corner radius.
   边框半径，而1表示圆，0表示矩形，中间值将为其提供角半径。
 */
@property (assign, nonatomic) CGFloat borderRadius;

/**
 * The case options manage the case of month label and weekday symbols.
   大小写选项管理月份标签和工作日符号的大小写。
 *
 * @see FSCalendarCaseOptions
 */
@property (assign, nonatomic) FSCalendarCaseOptions caseOptions;

/**
 * The line integrations for calendar.
   日历的行集成。
 *
 */
@property (assign, nonatomic) FSCalendarSeparators separators;

#if TARGET_INTERFACE_BUILDER

// For preview only
@property (assign, nonatomic) BOOL      fakeSubtitles;
@property (assign, nonatomic) BOOL      fakeEventDots;
@property (assign, nonatomic) NSInteger fakedSelectedDay;

#endif

@end

/**
 * These functions and attributes are deprecated.
   不推荐使用这些函数和属性。
 */
@interface FSCalendarAppearance (Deprecated)

@property (assign, nonatomic) BOOL useVeryShortWeekdaySymbols FSCalendarDeprecated('caseOptions');
@property (assign, nonatomic) CGFloat titleVerticalOffset FSCalendarDeprecated('titleOffset');
@property (assign, nonatomic) CGFloat subtitleVerticalOffset FSCalendarDeprecated('subtitleOffset');
@property (strong, nonatomic) UIColor *eventColor FSCalendarDeprecated('eventDefaultColor');
@property (assign, nonatomic) FSCalendarCellShape cellShape FSCalendarDeprecated('borderRadius');
@property (assign, nonatomic) BOOL adjustsFontSizeToFitContentSize DEPRECATED_MSG_ATTRIBUTE("The attribute \'adjustsFontSizeToFitContentSize\' is not neccesary anymore.");
- (void)invalidateAppearance FSCalendarDeprecated('FSCalendar setNeedsConfigureAppearance');

@end



