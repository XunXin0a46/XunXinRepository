//
//  YSCUITextField.m

#import "YSCUITextField.h"

@implementation YSCUITextField

/**
 返回接收器左侧覆盖视图的绘制矩形。不应该直接调用这个方法。如果想将左侧覆盖视图放置在不同的位置，可以覆盖此方法并返回新矩形。注意，在从右到左的用户界面中，绘制矩形保持不变。
 
 参数:
 bounds : 接收器的边框。
 返回值 : 要在其中绘制左覆盖视图的矩形。
 */

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    return iconRect;
}

/**
 返回文本字段的文本的绘制矩形。不应该直接调用这个方法。如果想为文本自定义绘图矩形，可以覆盖此方法并返回一个不同的矩形。此方法的默认实现返回一个矩形，该矩形派生自控件的原始边界，但不包括接收方的边框或覆盖视图占用的区域。
 
 参数:
 bounds : 接收器的边框。
 返回值 : 用于标签文本的计算绘图矩形。
 */

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.size.width += 35.0;
    return CGRectInset(bounds, 35, 0);
}

/**
 返回文本字段的占位符文本的绘制矩形。不应该直接调用这个方法。如果想为占位符文本自定义绘图矩形，可以覆盖此方法并返回一个不同的矩形。如果占位符字符串为空或nil，则不调用此方法。
 
 参数:
 bounds : 接收器的边框。
 返回值 : 占位符文本的计算绘图矩形。
 */

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 35, 0);
}

/**
 返回可编辑文本显示的矩形。不应直接调用此方法。如果要为文本提供不同的编辑矩形，可以重写此方法并返回该矩形。默认情况下，此方法返回文本字段中不被任何覆盖视图占用的区域。
 
 参数 :
 bounds : 接收器的边框。
 返回值 : 可编辑文本显示的矩形。
 
 */

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.size.width += 35.0;
    return CGRectInset(bounds, 35, 0);
}

/**
 返回接收器右覆盖视图的绘图位置。不应直接调用此方法。如果要将右覆盖视图放置在其他位置，可以重写此方法并返回新矩形。请注意，在从右到左的用户界面中，绘图矩形保持不变。
 
 参数:
 bounds : 接收器的边框。
 返回值 : 在其中绘制右覆盖视图的矩形。
 */

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10 * 0.5;
    textRect.size = CGSizeMake(30, 30);
    return textRect;
}


@end
