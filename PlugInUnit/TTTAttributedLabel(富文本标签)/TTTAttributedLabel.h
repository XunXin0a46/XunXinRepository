// TTTAttributedLabel.h
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
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

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

//! Project version number for TTTAttributedLabel.
/// TTTAttributedLabel的项目版本号。
FOUNDATION_EXPORT double TTTAttributedLabelVersionNumber;

//! Project version string for TTTAttributedLabel.
/// TTTAttributedLabel的项目版本字符串。
FOUNDATION_EXPORT const unsigned char TTTAttributedLabelVersionString[];

@class TTTAttributedLabelLink;

/**
 Vertical alignment for text in a label whose bounds are larger than its text bounds
 
 译：边界大于其文本边界的标签中文本的垂直对齐方式
 */
typedef NS_ENUM(NSInteger, TTTAttributedLabelVerticalAlignment) {
    TTTAttributedLabelVerticalAlignmentCenter   = 0,
    TTTAttributedLabelVerticalAlignmentTop      = 1,
    TTTAttributedLabelVerticalAlignmentBottom   = 2,
};

/**
 Determines whether the text to which this attribute applies has a strikeout drawn through itself.
 
 译：确定应用此属性的文本本身是否有删除线。
 */
extern NSString * const kTTTStrikeOutAttributeName;

/**
 The background fill color. Value must be a `CGColorRef`. Default value is `nil` (no fill).
 
 译：背景填充颜色。值必须是“CGColorRef”。默认值为“nil”（无填充）。
 */
extern NSString * const kTTTBackgroundFillColorAttributeName;

/**
 The padding for the background fill. Value must be a `UIEdgeInsets`. Default value is `UIEdgeInsetsZero` (no padding).
 
 译：背景内间距的填充。值必须是“UIEdgeInsets”。默认值为“UIEdgeInsetsZero”（无填充）。
 */
extern NSString * const kTTTBackgroundFillPaddingAttributeName;

/**
 The background stroke color. Value must be a `CGColorRef`. Default value is `nil` (no stroke).
 
 背景笔划颜色。值必须是“CGColorRef”。默认值为“nil”（无笔划）。
 */
extern NSString * const kTTTBackgroundStrokeColorAttributeName;

/**
 The background stroke line width. Value must be an `NSNumber`. Default value is `1.0f`.
 
 背景笔划线条宽度。值必须是“NSNumber”。默认值为“1.0f”。
 */
extern NSString * const kTTTBackgroundLineWidthAttributeName;

/**
 The background corner radius. Value must be an `NSNumber`. Default value is `5.0f`.
 
 背景角半径。值必须是“NSNumber”。默认值为“5.0f”。
 */
extern NSString * const kTTTBackgroundCornerRadiusAttributeName;

@protocol TTTAttributedLabelDelegate;

// Override UILabel @property to accept both NSString and NSAttributedString
// 重写UILabel @property 以同时接受NSString和NSAttributedString
@protocol TTTAttributedLabel <NSObject>
@property (nonatomic, copy) IBInspectable id text;
@end

IB_DESIGNABLE

/**
 `TTTAttributedLabel` is a drop-in replacement for `UILabel` that supports `NSAttributedString`, as well as automatically-detected and manually-added links to URLs, addresses, phone numbers, and dates.
 
 译：‘TTTAttributedLabel’是对支持“NSAttributedString”的“UILabel”的替换，以及自动检测和手动添加到url、地址、电话号码和日期的链接。
 
 ## Differences Between `TTTAttributedLabel` and `UILabel`
 
 译：“TTTAttributedLabel”和“UILabel”之间的区别
 
 For the most part, `TTTAttributedLabel` behaves just like `UILabel`. The following are notable exceptions, in which `TTTAttributedLabel` may act differently:
 
 译：在大多数情况下，“TTTAttributedLabel”的行为与“UILabel”一样。以下是值得注意的例外情况，其中“TTTAttributedLabel”的行为可能不同：
 
 - `text` - This property now takes an `id` type argument, which can either be a kind of `NSString` or `NSAttributedString` (mutable or immutable in both cases)
 
 译：`text`-这个属性现在接受一个'id'类型参数，它可以是一种'NSString'或'NSAttributedString'（在这两种情况下都是可变的或不可变的）
 
 - `attributedText` - Do not set this property directly. Instead, pass an `NSAttributedString` to `text`.
 
 译：`attributeText`-不要直接设置此属性。相反，请将“NSAttributedString”传递给“text”。
 
 - `lineBreakMode` - This property displays only the first line when the value is `UILineBreakModeHeadTruncation`, `UILineBreakModeTailTruncation`, or `UILineBreakModeMiddleTruncation`
 
 译：`lineBreakMode`-当值为'UILineBreakModeHeadTruncation'、'UILineBreakModeTailTruncation'或'UILineBreakModeMiddleTruncation'时，此属性仅显示第一行`
 
 - `adjustsFontsizeToFitWidth` - Supported in iOS 5 and greater, this property is effective for any value of `numberOfLines` greater than zero. In iOS 4, setting `numberOfLines` to a value greater than 1 with `adjustsFontSizeToFitWidth` set to `YES` may cause `sizeToFit` to execute indefinitely.
 
 译：`adjustsFontsizeToFitWidth`- 在iOS 5及更高版本中受支持，此属性对任何大于0的“numberOfLines”值都有效。在iOS 4中，将“numberOfLines”设置为大于1的值，并将“adjustsFontSizeToFitWidth”设置为“YES”，可能会导致“sizeToFit”无限期执行。
 
 - `baselineAdjustment` - This property has no affect.
 
 译：`baselineAdjustment`- 此属性没有影响。
 
 - `textAlignment` - This property does not support justified alignment.
 
 译：`textAlignment`- 此属性不支持对齐。
 
 - `NSTextAttachment` - This string attribute is not supported.
 
 译：`NSTextAttachment`- 不支持此字符串属性。
 
 Any properties affecting text or paragraph styling, such as `firstLineIndent` will only apply when text is set with an `NSString`. If the text is set with an `NSAttributedString`, these properties will not apply.
 
 译：任何影响文本或段落样式的属性（如“firstLineIndent”）仅在使用“NSString”设置文本时适用。如果文本设置为“NSAttributedString”，则这些属性将不适用。
 
 ### NSCoding
 
 `TTTAttributedLabel`, like `UILabel`, conforms to `NSCoding`. However, if the build target is set to less than iOS 6.0, `linkAttributes` and `activeLinkAttributes` will not be encoded or decoded. This is due to an runtime exception thrown when attempting to copy non-object CoreText values in dictionaries.
 
 译：`TTTAttributedLabel类似于UILabel，符合NSCoding。但是，如果生成目标设置为低于
 iOS6，则不会对“linkAttributes”和“activeLinkAttributes”进行编码或解码。这是由于尝试在字典中复制非对象CoreText值时引发运行时异常所致。

 
 @warning Any properties changed on the label after setting the text will not be reflected until a subsequent call to `setText:` or `setText:afterInheritingLabelAttributesAndConfiguringWithBlock:`. This is to say, order of operations matters in this case. For example, if the label text color is originally black when the text is set, changing the text color to red will have no effect on the display of the label until the text is set once again.
 
 译：设置文本后标签上的任何属性改变都不会反映出来，直到随后调用' setText: '或' setText:afterInheritingLabelAttributesAndConfiguringWithBlock: '。也就是说，在这种情况下，操作的顺序很重要。例如，如果在设置文本时，标签文本的颜色最初是黑色的，那么在再次设置文本之前，将文本颜色更改为红色将对标签的显示没有影响。
 
 @bug Setting `attributedText` directly is not recommended, as it may cause a crash when attempting to access any links previously set. Instead, call `setText:`, passing an `NSAttributedString`.
 
 译：不建议直接设置“attributedText”，因为在尝试访问之前设置的链接时可能会导致崩溃。相反，调用“setText:”，传递一个“NSAttributedString”。
 */
@interface TTTAttributedLabel : UILabel <TTTAttributedLabel, UIGestureRecognizerDelegate>

/**
 * The designated initializers are @c initWithFrame: and @c initWithCoder:.
 *
 *译：指定的初始化器是initWithFrame:和initWithCoder:
 *
 * init will not properly initialize many required properties and other configuration.
 *
 * 译：init无法正确初始化许多必需的属性和其他配置。
 */
- (instancetype) init NS_UNAVAILABLE;

///-----------------------------
/// @name Accessing the Delegate
///
/// 译：访问代理
///-----------------------------

/**
 The receiver's delegate.
 
 译：接收器的代理。
 
 @discussion A `TTTAttributedLabel` delegate responds to messages sent by tapping on links in the label. You can use the delegate to respond to links referencing a URL, address, phone number, date, or date with a specified time zone and duration.
 
 译：一个“TTTAttributedLabel”委托通过点击标签中的链接来响应发送的消息。可以使用委托响应引用URL、地址、电话号码、日期或具有指定时区和持续时间的日期的链接。
 */
@property (nonatomic, unsafe_unretained) IBOutlet id <TTTAttributedLabelDelegate> delegate;

///--------------------------------------------
/// @name Detecting, Accessing, & Styling Links
/// 译：检测和访问样式化链接
///--------------------------------------------

/**
 A bitmask of `NSTextCheckingType` which are used to automatically detect links in the label text.
 
 译：一个' NSTextCheckingType '的位掩码，用于自动检测标签文本中的链接。

 @warning You must specify `enabledTextCheckingTypes` before setting the `text`, with either `setText:` or `setText:afterInheritingLabelAttributesAndConfiguringWithBlock:`.
 
 译：在设置“text”之前，你必须指定“enabledTextCheckingTypes”，使用“setText:”或“setText:afterInheritingLabelAttributesAndConfiguringWithBlock:”。
 */
@property (nonatomic, assign) NSTextCheckingTypes enabledTextCheckingTypes;

/**
 An array of `NSTextCheckingResult` objects for links detected or manually added to the label text.
 
 译：一个' NSTextCheckingResult '对象数组检测到的链接或手动添加到标签文本。
 */
@property (readonly, nonatomic, strong) NSArray *links;

/**
 A dictionary containing the default `NSAttributedString` attributes to be applied to links detected or manually added to the label text. The default link style is blue and underlined.
 
 译：包含默认' NSAttributedString '属性的字典，用于检测到的链接或手动添加到标签文本中。默认链接样式是蓝色和下划线。
 
 @warning You must specify `linkAttributes` before setting autodecting or manually-adding links for these attributes to be applied.
 
 译：在为这些属性设置自动绘图或手动添加链接之前，必须指定“linkAttributes”。
 */
@property (nonatomic, strong) NSDictionary *linkAttributes;

/**
 A dictionary containing the default `NSAttributedString` attributes to be applied to links when they are in the active state. If `nil` or an empty `NSDictionary`, active links will not be styled. The default active link style is red and underlined.
 
 译：一个包含默认' NSAttributedString '属性的字典，该属性在链接处于活动状态时应用于链接。如果' nil '或空' NSDictionary '，活动链接将不会被样式化。默认的活动链接样式是红色和下划线。
 */
@property (nonatomic, strong) NSDictionary *activeLinkAttributes;

/**
 A dictionary containing the default `NSAttributedString` attributes to be applied to links when they are in the inactive state, which is triggered by a change in `tintColor` in iOS 7 and later. If `nil` or an empty `NSDictionary`, inactive links will not be styled. The default inactive link style is gray and unadorned.
 
 译：包含默认“NSAttributedString”属性的字典，当链接处于非活动状态时，这些属性将应用于链接，这是由iOS 7及更高版本中的“tintColor”更改触发的。如果“nil”或空的“NSDictionary”，则不设置非活动链接的样式。默认的非活动链接样式为灰色且未修饰。
 */
@property (nonatomic, strong) NSDictionary *inactiveLinkAttributes;

/**
 The edge inset for the background of a link. The default value is `{0, -1, 0, -1}`.
 
 译：链接背景的边插入。默认值是{0，-1，0，-1}。
 */
@property (nonatomic, assign) UIEdgeInsets linkBackgroundEdgeInset;

/**
 Indicates if links will be detected within an extended area around the touch
 to emulate the link detection behaviour of UIWebView. 
 Default value is NO. Enabling this may adversely impact performance.
 
 译：指示是否在触摸周围的扩展区域内检测到链接
 以模拟UIWebView的链接检测行为。
 默认值为“否”。启用此选项可能会对性能产生负面影响。
 */
@property (nonatomic, assign) BOOL extendsLinkTouchArea;

///---------------------------------------
/// @name Acccessing Text Style Attributes
///
/// 译：访问文本样式属性
///---------------------------------------

/**
 The shadow blur radius for the label. A value of 0 indicates no blur, while larger values produce correspondingly larger blurring. This value must not be negative. The default value is 0.
 
 译：标签的阴影模糊半径。值为0表示没有模糊，而较大的值会产生相应的较大模糊。此值不能为负。默认值为0。
 */
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;

/** 
 The shadow blur radius for the label when the label's `highlighted` property is `YES`. A value of 0 indicates no blur, while larger values produce correspondingly larger blurring. This value must not be negative. The default value is 0.
 
 译：标签的“highlighted”属性为“YES”时标签的阴影模糊半径。值为0表示没有模糊，而较大的值会产生相应的较大模糊。此值不能为负。默认值为0。
 */
@property (nonatomic, assign) IBInspectable CGFloat highlightedShadowRadius;
/** 
 The shadow offset for the label when the label's `highlighted` property is `YES`. A size of {0, 0} indicates no offset, with positive values extending down and to the right. The default size is {0, 0}.
 
 译：标签的“highlighted”属性为“YES”时标签的阴影偏移量。大小为{0，0}表示没有偏移，正值向下和向右延伸。默认大小为{0，0}。
 */
@property (nonatomic, assign) IBInspectable CGSize highlightedShadowOffset;
/** 
 The shadow color for the label when the label's `highlighted` property is `YES`. The default value is `nil` (no shadow color).
 
 译：标签的“highlighted”属性为“YES”时标签的阴影颜色。默认值为“nil”（无阴影颜色）。
 */
@property (nonatomic, strong) IBInspectable UIColor *highlightedShadowColor;

/**
 The amount to kern the next character. Default is standard kerning. If this attribute is set to 0.0, no kerning is done at all.
 
 译：紧排下一个字符的量。默认值为标准字距。如果此属性设置为0.0，则根本不进行紧排。
 */
@property (nonatomic, assign) IBInspectable CGFloat kern;

///--------------------------------------------
/// @name Acccessing Paragraph Style Attributes
///
/// 译：访问段落样式属性
///--------------------------------------------

/**
 The distance, in points, from the leading margin of a frame to the beginning of the 
 paragraph's first line. This value is always nonnegative, and is 0.0 by default. 
 This applies to the full text, rather than any specific paragraph metrics.
 
 译：从frame的前边距到段落第一行开始的距离，以点为单位。此值始终为非负，默认为0.0。这适用于全文，而不是任何特定的段落。
 */
@property (nonatomic, assign) IBInspectable CGFloat firstLineIndent;

/**
 The space in points added between lines within the paragraph. This value is always nonnegative and is 0.0 by default.
 
 译：段落内行与行之间的空格。该值始终是非负的，默认值为0.0。
 */
@property (nonatomic, assign) IBInspectable CGFloat lineSpacing;

/**
 The minimum line height within the paragraph. If the value is 0.0, the minimum line height is set to the line height of the `font`. 0.0 by default.
 
 译：段落内的最小行高。如果值为0.0，则最小行高设置为“字体”的行高。默认情况下为0.0。
 */
@property (nonatomic, assign) IBInspectable CGFloat minimumLineHeight;

/**
 The maximum line height within the paragraph. If the value is 0.0, the maximum line height is set to the line height of the `font`. 0.0 by default.
 
 译：段落内的最大行高。如果值为0.0，则最大行高设置为“字体”的行高。默认情况下为0.0。
 */
@property (nonatomic, assign) IBInspectable CGFloat maximumLineHeight;

/**
 The line height multiple. This value is 1.0 by default.
 
 译：行高倍数。默认情况下，此值为1.0。
 */
@property (nonatomic, assign) IBInspectable CGFloat lineHeightMultiple;

/**
 The distance, in points, from the margin to the text container. This value is `UIEdgeInsetsZero` by default.
 sizeThatFits: will have its returned size increased by these margins.
 drawTextInRect: will inset all drawn text by these margins.
 
 译：从边距到文本容器的距离，以点为单位。默认情况下，此值为“UIEdgeInsetsZero”。
 sizeThatFits：将使其返回的大小增加这些边距。
 drawTextInRect：将按这些边距插入所有绘制的文本。
 */
@property (nonatomic, assign) IBInspectable UIEdgeInsets textInsets;

/**
 The vertical text alignment for the label, for when the frame size is greater than the text rect size. The vertical alignment is `TTTAttributedLabelVerticalAlignmentCenter` by default.
 
 译：当frame大小大于文本矩形大小时，标签的垂直文本对齐方式。默认情况下，垂直对齐方式为“TTTAttributedLabelVerticalAlignmentCenter”。
 */
@property (nonatomic, assign) TTTAttributedLabelVerticalAlignment verticalAlignment;

///--------------------------------------------
/// @name Accessing Truncation Token Appearance
///
/// 译：访问截断标记的外观
///--------------------------------------------

/**
 The attributed string to apply to the truncation token at the end of a truncated line.
 
 译：要应用于截断行末尾的截断标记的带属性字符串。
 */
@property (nonatomic, strong) IBInspectable NSAttributedString *attributedTruncationToken;

///--------------------------
/// @name Long press gestures
///
/// 译：长按手势
///--------------------------

/**
 *  The long-press gesture recognizer used internally by the label.
 *
 *  译：长按手势识别器内部使用的标签。
 */
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

///--------------------------------------------
/// @name Calculating Size of Attributed String
///
/// 译：计算带属性字符串的大小
///--------------------------------------------

/**
 Calculate and return the size that best fits an attributed string, given the specified constraints on size and number of lines.

 @param attributedString The attributed string.
 @param size The maximum dimensions used to calculate size.
 @param numberOfLines The maximum number of lines in the text to draw, if the constraining size cannot accomodate the full attributed string.
 
 @return The size that fits the attributed string within the specified constraints.
 
 译：给定指定的大小和行数限制，计算并返回最适合带属性字符串的大小。
 参数：
 attributedString：属性字符串。
 size：用于计算大小的最大尺寸。
 numberOfLines：如果约束大小不能容纳完整的属性字符串，则在文本中要绘制的最大行数。
 返回值：适合指定约束内的属性字符串的大小。
 */
+ (CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString
                       withConstraints:(CGSize)size
                limitedToNumberOfLines:(NSUInteger)numberOfLines;

///----------------------------------
/// @name Setting the Text Attributes
///
/// 译：设置文本属性
///----------------------------------

/**
 Sets the text displayed by the label.
 
 @param text An `NSString` or `NSAttributedString` object to be displayed by the label. If the specified text is an `NSString`, the label will display the text like a `UILabel`, inheriting the text styles of the label. If the specified text is an `NSAttributedString`, the label text styles will be overridden by the styles specified in the attributed string.
  
 @discussion This method overrides `UILabel -setText:` to accept both `NSString` and `NSAttributedString` objects. This string is `nil` by default.
 
 译：设置标签显示的文本。
 参数：
 text：将要由标签显示的“NSString”或“NSAttributedString”对象设置为文本。如果指定的文本是“NSString”，则标签将像“UILabel”一样显示文本，并继承标签的文本样式。如果指定的文本是“NSAttributedString”，则标签文本样式将被属性字符串中指定的样式覆盖。
 
 讨论：此方法重写“UILabel-setText:”以同时接受“NSString”和“NSAttributedString”对象。默认情况下，此字符串为“nil”。
 */
- (void)setText:(id)text;

/**
 Sets the text displayed by the label, after configuring an attributed string containing the text attributes inherited from the label in a block.
 
 @param text An `NSString` or `NSAttributedString` object to be displayed by the label.
 @param block A block object that returns an `NSMutableAttributedString` object and takes a single argument, which is an `NSMutableAttributedString` object with the text from the first parameter, and the text attributes inherited from the label text styles. For example, if you specified the `font` of the label to be `[UIFont boldSystemFontOfSize:14]` and `textColor` to be `[UIColor redColor]`, the `NSAttributedString` argument of the block would be contain the `NSAttributedString` attribute equivalents of those properties. In this block, you can set further attributes on particular ranges.
 
 @discussion This string is `nil` by default.
 
 译：在配置包含从块中的标签继承的文本属性的属性字符串后，设置标签显示的文本。
 参数：
 text：要由标签显示的“NSString”或“NSAttributedString”对象。
 block：返回“NSMutableAttributedString”对象并接受单个参数的块对象，该对象是一个“NSMutableAttributedString”对象，具有来自第一个参数的文本和从标签文本样式继承的文本属性。例如，如果你指定标签的' font '为' [UIFont boldSystemFontOfSize:14] '和' textColor '为' [UIColor redColor] '，块的' NSAttributedString '参数将包含' NSAttributedString '属性等同的那些属性。在此块中，可以对特定范围设置进一步的属性。
 */
- (void)setText:(id)text
afterInheritingLabelAttributesAndConfiguringWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block;

///------------------------------------
/// @name Accessing the Text Attributes
///
/// 译：访问文本属性
///------------------------------------

/**
 A copy of the label's current attributedText. This returns `nil` if an attributed string has never been set on the label.
 
 @warning Do not set this property directly. Instead, set @c text to an @c NSAttributedString.
 
 译：标签当前attributeText的副本。如果标签上从未设置属性字符串，则返回“nil”。
 不要直接设置此属性。相反，将text设置为NSAttributedString。
 */
@property (readwrite, nonatomic, copy) NSAttributedString *attributedText;

///-------------------
/// @name Adding Links
///
/// 译：添加链接
///-------------------

/**
 Adds a link. You can customize an individual link's appearance and accessibility value by creating your own @c TTTAttributedLabelLink and passing it to this method. The other methods for adding links will use the label's default attributes.
 
 @warning Modifying the link's attribute dictionaries must be done before calling this method.
 
 @param link A @c TTTAttributedLabelLink object.
 
 译：添加一个链接。您可以通过创建自己的TTTAttributedLabelLink并将其传递给这个方法来定制单个链接的外观和可访问性值。添加链接的其他方法将使用标签的默认属性。在调用此方法之前，必须修改链接的属性词典。
 参数：
 link：TTTAttributedLabelLink对象。
 */
- (void)addLink:(TTTAttributedLabelLink *)link;

/**
 Adds a link to an @c NSTextCheckingResult.
 
 @param result An @c NSTextCheckingResult representing the link's location and type.
 
 @return The newly added link object.
 
 译：向NSTextCheckingResult添加链接。
 参数：
 result：表示链接位置和类型的NSTextCheckingResult。
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result;

/**
 Adds a link to an @c NSTextCheckingResult.
 
 @param result An @c NSTextCheckingResult representing the link's location and type.
 @param attributes The attributes to be added to the text in the range of the specified link. If set, the label's @c activeAttributes and @c inactiveAttributes will be applied to the link. If `nil`, no attributes are added to the link.
 
 @return The newly added link object.
 
 译：向NSTextCheckingResult添加链接。
 参数：
 result：表示链接位置和类型的NSTextCheckingResult。
 attributes：要添加到指定链接范围内的文本的属性。如果设置，标签的activeAttributes和inactiveAttributes将应用于链接。如果“nil”，则不向链接添加任何属性。
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                                               attributes:(NSDictionary *)attributes;

/**
 Adds a link to a URL for a specified range in the label text.
 
 @param url The url to be linked to
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 
 @return The newly added link object.
 
 译：为标签文本中指定范围的URL添加链接。
 参数：
 url：要链接到的url
 range：链接的标签文本中的范围。范围不能超过接收器的界限。
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkToURL:(NSURL *)url
                               withRange:(NSRange)range;

/**
 Adds a link to an address for a specified range in the label text.
 
 @param addressComponents A dictionary of address components for the address to be linked to
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 
 @discussion The address component dictionary keys are described in `NSTextCheckingResult`'s "Keys for Address Components." 
 
 @return The newly added link object.
 
 译：将链接添加到标签文本中指定范围的地址。
 参数：
 addressComponents：要链接到的地址的地址组件字典
 range：链接的标签文本中的范围。范围不能超过接收器的界限。
 
 讨论：地址组件字典键在“NSTextCheckingResult”的“地址组件键”中描述
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkToAddress:(NSDictionary *)addressComponents
                                   withRange:(NSRange)range;

/**
 Adds a link to a phone number for a specified range in the label text.
 
 @param phoneNumber The phone number to be linked to.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 
 @return The newly added link object.
 
 译：在标签文本中为指定范围的电话号码添加链接。
 参数：
 phoneNumber：要连接的电话号码。
 range：链接的标签文本中的范围。范围不能超过接收器的范围。
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkToPhoneNumber:(NSString *)phoneNumber
                                       withRange:(NSRange)range;

/**
 Adds a link to a date for a specified range in the label text.
 
 @param date The date to be linked to.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 
 @return The newly added link object.
 
 译：将链接添加到标签文本中指定范围的日期。
 参数：
 date：要链接的日期。
 range：链接的标签文本中的范围。范围不能超过接收器的范围。
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkToDate:(NSDate *)date
                                withRange:(NSRange)range;

/**
 Adds a link to a date with a particular time zone and duration for a specified range in the label text.
 
 @param date The date to be linked to.
 @param timeZone The time zone of the specified date.
 @param duration The duration, in seconds from the specified date.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 
 @return The newly added link object.
 
 译：在标签文本中添加到具有特定时区和指定范围的持续时间的日期的链接。
 参数：
 date：要链接的日期。
 timeZone：指定日期的时区。
 duration：持续时间，以秒为单位，从指定日期开始计算。
 range：链接的标签文本中的范围。范围不能超过接收器的范围。
 */
- (TTTAttributedLabelLink *)addLinkToDate:(NSDate *)date
                                 timeZone:(NSTimeZone *)timeZone
                                 duration:(NSTimeInterval)duration
                                withRange:(NSRange)range;

/**
 Adds a link to transit information for a specified range in the label text.

 @param components A dictionary containing the transit components. The currently supported keys are `NSTextCheckingAirlineKey` and `NSTextCheckingFlightKey`.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 
 @return The newly added link object.
 
 译：添加一个链接，以传输标签文本中指定范围的信息。
 参数：
 components：包含传输组件的字典。当前支持的键是' NSTextCheckingAirlineKey '和' NSTextCheckingFlightKey '。
 range：链接的标签文本中的范围。范围不能超过接收器的范围。
 返回值：新添加的链接对象。
 */
- (TTTAttributedLabelLink *)addLinkToTransitInformation:(NSDictionary *)components
                                              withRange:(NSRange)range;

/**
 Returns whether an @c NSTextCheckingResult is found at the give point.
 
 @discussion This can be used together with @c UITapGestureRecognizer to tap interactions with overlapping views.
 
 @param point The point inside the label.
 
 译：返回是否在给定点找到NSTextCheckingResult。
 讨论：这可以与UITapGestureRecognizer一起使用，以点击与重叠视图的交互。
 参数：
 point：标签内的点。
 */
- (BOOL)containslinkAtPoint:(CGPoint)point;

/**
 Returns the @c TTTAttributedLabelLink at the give point if it exists.
 
 @discussion This can be used together with @c UIViewControllerPreviewingDelegate to peek into links.
 
 @param point The point inside the label.
 
 译：返回给定点的TTTAttributedLabelLink(如果它存在)。
 讨论：这个可以和UIViewControllerPreviewingDelegate一起使用来查看链接。
 参数：
 point：标签内的点。
 */
- (TTTAttributedLabelLink *)linkAtPoint:(CGPoint)point;

@end

/**
 The `TTTAttributedLabelDelegate` protocol defines the messages sent to an attributed label delegate when links are tapped. All of the methods of this protocol are optional.
 
 译：TTTAttributedLabelDelegate协议定义了在点击链接时发送到带属性标签委托的消息。该协议的所有方法都是可选的。
 */
@protocol TTTAttributedLabelDelegate <NSObject>

///-----------------------------------
/// @name Responding to Link Selection
///-----------------------------------
@optional

/**
 Tells the delegate that the user did select a link to a URL.
 
 @param label The label whose link was selected.
 @param url The URL for the selected link.
 
 译：通知代理用户已选择到URL的链接。
 参数：
 label：链接被选中的标签
 url：所选链接的URL。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;

/**
 Tells the delegate that the user did select a link to an address.
 
 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 
 译：通知代理用户已选择到某个地址的链接。
 参数：
 label：链接被选中的标签。
 addressComponents：所选链接的地址组件。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents;

/**
 Tells the delegate that the user did select a link to a phone number.
 
 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 
 译：通知代理用户确实选择了一个到电话号码的链接。
 参数：
 label：链接被选中的标签。
 phoneNumber：所选链接的电话号码。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber;

/**
 Tells the delegate that the user did select a link to a date.
 
 @param label The label whose link was selected.
 @param date The datefor the selected link.
 
 译：通知代理用户已经选择了某个日期的链接。
 参数：
 label：链接被选中的标签。
 date：所选链接的日期。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
  didSelectLinkWithDate:(NSDate *)date;

/**
 Tells the delegate that the user did select a link to a date with a time zone and duration.
 
 @param label The label whose link was selected.
 @param date The date for the selected link.
 @param timeZone The time zone of the date for the selected link.
 @param duration The duration, in seconds from the date for the selected link.
 
 译：通知代理用户已选择了指向具有时区和持续时间的日期的链接。
 参数：
 label：链接被选中的标签。
 date：所选链接的日期。
 timeZone：所选链接的日期的时区。
 duration：持续时间，以秒为单位，从所选链接的日期算起。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
  didSelectLinkWithDate:(NSDate *)date
               timeZone:(NSTimeZone *)timeZone
               duration:(NSTimeInterval)duration;

/**
 Tells the delegate that the user did select a link to transit information

 @param label The label whose link was selected.
 @param components A dictionary containing the transit components. The currently supported keys are `NSTextCheckingAirlineKey` and `NSTextCheckingFlightKey`.
 
 译：通知代理用户已选择传输信息的链接
 参数：
 label：链接被选中的标签。
 components：包含传输组件的字典。当前支持的键是' NSTextCheckingAirlineKey '和' NSTextCheckingFlightKey '。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components;

/**
 Tells the delegate that the user did select a link to a text checking result.
 
 @discussion This method is called if no other delegate method was called, which can occur by either now implementing the method in `TTTAttributedLabelDelegate` corresponding to a particular link, or the link was added by passing an instance of a custom `NSTextCheckingResult` subclass into `-addLinkWithTextCheckingResult:`.
 
 @param label The label whose link was selected.
 @param result The custom text checking result.
 
 译：通知代理告诉委托用户确实选择了指向文本检查结果的链接。
 讨论：如果没有调用其他委托方法，则调用此方法，这可能是由于现在在对应于特定链接的“TTTAttributedLabelDelegate”中实现了该方法，或者通过将自定义“NSTextCheckingResult”子类的实例传递到“-addLinkWithTextCheckingResult:”中添加了该链接。
 参数：
 label：选定其链接的标签。
 result：自定义文本检查结果。
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result;

///---------------------------------
/// @name Responding to Long Presses
///
/// 译：对长按的反应
///---------------------------------

/**
 *  Long-press delegate methods include the CGPoint tapped within the label's coordinate space.
 *  This may be useful on iPad to present a popover from a specific origin point.
 *
 *  译：长按代理方法包括在标签的坐标空间中选定的CGPoint。
 *  这在iPad上可能有用来从一个特定的原点呈现弹窗。
 */

/**
 Tells the delegate that the user long-pressed a link to a URL.
 
 @param label The label whose link was long pressed.
 @param url The URL for the link.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理用户长时间按下指向URL的链接。
 参数：
 label：被长按的标签。
 url：链接的URL。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point;

/**
 Tells the delegate that the user long-pressed a link to an address.
 
 @param label The label whose link was long pressed.
 @param addressComponents The components of the address for the link.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理用户长时间按下指向某个地址的链接。
 参数：
 label：被长按的标签。
 addressComponents：链接地址的组成部分。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithAddress:(NSDictionary *)addressComponents
                atPoint:(CGPoint)point;

/**
 Tells the delegate that the user long-pressed a link to a phone number.
 
 @param label The label whose link was long pressed.
 @param phoneNumber The phone number for the link.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理用户长时间按下了电话号码的链接。
 参数：
 label：被长按的标签。
 phoneNumber：链接的电话号码。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber
                atPoint:(CGPoint)point;


/**
 Tells the delegate that the user long-pressed a link to a date.
 
 @param label The label whose link was long pressed.
 @param date The date for the selected link.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理长按了某个日期的链接。
 参数：
 label：被长按的标签。
 date：所选链接的日期。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithDate:(NSDate *)date
                atPoint:(CGPoint)point;


/**
 Tells the delegate that the user long-pressed a link to a date with a time zone and duration.
 
 @param label The label whose link was long pressed.
 @param date The date for the link.
 @param timeZone The time zone of the date for the link.
 @param duration The duration, in seconds from the date for the link.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理用户长按了指向具有时区和持续时间的日期的链接。
 参数：
 label：被长按的标签。
 date：链接的日期。
 timeZone：链接日期的时区。
 duration：持续时间，以秒为单位，从链接日期算起。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithDate:(NSDate *)date
               timeZone:(NSTimeZone *)timeZone
               duration:(NSTimeInterval)duration
                atPoint:(CGPoint)point;


/**
 Tells the delegate that the user long-pressed a link to transit information.
 
 @param label The label whose link was long pressed.
 @param components A dictionary containing the transit components. The currently supported keys are `NSTextCheckingAirlineKey` and `NSTextCheckingFlightKey`.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理用户长按了传输信息的链接。
 参数：
 label：被长按的标签。
 components：包含传输组件的字典。当前支持的键是' NSTextCheckingAirlineKey '和' NSTextCheckingFlightKey '。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithTransitInformation:(NSDictionary *)components
                atPoint:(CGPoint)point;

/**
 Tells the delegate that the user long-pressed a link to a text checking result.
 
 @discussion Similar to `-attributedLabel:didSelectLinkWithTextCheckingResult:`, this method is called if a link is long pressed and the delegate does not implement the method corresponding to this type of link.
 
 @param label The label whose link was long pressed.
 @param result The custom text checking result.
 @param point the point pressed, in the label's coordinate space
 
 译：通知代理用户长按了指向文本检查结果的链接。
 讨论：类似于`-attributelabel:didSelectLinkWithTextCheckingResult：`，如果长时间按下链接，并且委托未实现与此类型链接对应的方法，则调用此方法。
 参数：
 label：其链接被长按的标签。
 result：自定义文本检查结果。
 point：标签坐标空间中被按下的点
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point;

@end

@interface TTTAttributedLabelLink : NSObject <NSCoding>

typedef void (^TTTAttributedLabelLinkBlock) (TTTAttributedLabel *, TTTAttributedLabelLink *);

/**
 An `NSTextCheckingResult` representing the link's location and type.
 
 译：表示链接位置和类型的“NSTextCheckingResult”。
 */
@property (readonly, nonatomic, strong) NSTextCheckingResult *result;

/**
 A dictionary containing the @c NSAttributedString attributes to be applied to the link.
 
 译：包含要应用于链接的NSAttributedString属性的字典。
 */
@property (readonly, nonatomic, copy) NSDictionary *attributes;

/**
 A dictionary containing the @c NSAttributedString attributes to be applied to the link when it is in the active state.
 
 译：当链接处于活动状态时，包含要应用于该链接的NSAttributedString属性的字典。
 */
@property (readonly, nonatomic, copy) NSDictionary *activeAttributes;

/**
 A dictionary containing the @c NSAttributedString attributes to be applied to the link when it is in the inactive state, which is triggered by a change in `tintColor` in iOS 7 and later.
 
 译：包含NSAttributedString属性的字典，当链接处于非活动状态时，该属性将应用于链接，这是由iOS7及更高版本中的“tintColor”更改触发的。
 */
@property (readonly, nonatomic, copy) NSDictionary *inactiveAttributes;

/**
 Additional information about a link for VoiceOver users. Has default values if the link's @c result is @c NSTextCheckingTypeLink, @c NSTextCheckingTypePhoneNumber, or @c NSTextCheckingTypeDate.
 
 译：关于VoiceOver用户链接的附加信息。如果链接的@c结果是@c NSTextCheckingTypeLink、@c NSTextCheckingTypePhoneNumber或@c NSTextCheckingTypeDate，则具有默认值。
 */
@property (nonatomic, copy) NSString *accessibilityValue;

/**
 A block called when this link is tapped.
 If non-nil, tapping on this link will call this block instead of the 
 @c TTTAttributedLabelDelegate tap methods, which will not be called for this link.
 
 译：点击此链接时调用的块。如果非nil，则单击此链接将调用此块而不是TTTAttributedLabelDelegate的点击方法
 */
@property (nonatomic, copy) TTTAttributedLabelLinkBlock linkTapBlock;

/**
 A block called when this link is long-pressed.
 If non-nil, long pressing on this link will call this block instead of the
 @c TTTAttributedLabelDelegate long press methods, which will not be called for this link.
 
 译：长按此链接时调用的块。如果不是nil，长按此链接将调用此块而不是TTTAttributedLabelDelegate的长按方法，
 */
@property (nonatomic, copy) TTTAttributedLabelLinkBlock linkLongPressBlock;

/**
 Initializes a link using the attribute dictionaries specified.
 
 @param attributes         The @c attributes property for the link.
 @param activeAttributes   The @c activeAttributes property for the link.
 @param inactiveAttributes The @c inactiveAttributes property for the link.
 @param result             An @c NSTextCheckingResult representing the link's location and type.
 
 @return The initialized link object.
 
 译：使用指定的属性字典初始化链接。
 参数：
 attributes：链接的属性字典。
 activeAttributes：链接处于活动状态的属性字典。
 inactiveAttributes：链接的处于非活动的属性字典。
 result：表示链接位置和类型的NSTextCheckingResult。
 返回值：初始化的链接对象。
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes
                  activeAttributes:(NSDictionary *)activeAttributes
                inactiveAttributes:(NSDictionary *)inactiveAttributes
                textCheckingResult:(NSTextCheckingResult *)result;

/**
 Initializes a link using the attribute dictionaries set on a specified label.
 
 @param label  The attributed label from which to inherit attribute dictionaries.
 @param result An @c NSTextCheckingResult representing the link's location and type.
 
 @return The initialized link object.
 
 译：使用设置的属性字典在指定标签上初始化链接。
 参数：
 label：从中继承属性词典的属性标签。
 result：表示链接位置和类型的NSTextCheckingResult。
 返回值：初始化的链接对象。
 */
- (instancetype)initWithAttributesFromLabel:(TTTAttributedLabel*)label
                         textCheckingResult:(NSTextCheckingResult *)result;

@end
