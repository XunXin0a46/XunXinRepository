//
//  UIImage+YYWebImage.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 提供一些常用的“UIImage”方法。
 图像处理是基于CoreGraphic和vImage的。
 */
@interface UIImage (YYWebImage)

#pragma mark - Create image （创建图像）
///=============================================================================
/// @name Create image
///=============================================================================

/**
 使用gif数据创建动画图像。创建后，您可以通过属性“.images”访问图像。如果数据不是动画gif，则此函数与[UIImage imageWithData:data scale:scale]相同；
 
 @discussion     它有更好的显示性能，但占用更多内存（宽度*高度*帧字节）。它只适合显示小gif，如动画表情。如果要显示较大的gif，请参见“yyimage”。
 
 @param data     GIF数据。
 
 @param scale    尺寸比例系数
 
 @return 从gif创建的新图像，或出现错误时为nil。
 */
+ (nullable UIImage *)yy_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

/**
 创建并返回具有给定颜色的1x1点大小图像。
 
 @param color  颜色。
 */
+ (nullable UIImage *)yy_imageWithColor:(UIColor *)color;

/**
 创建并返回具有给定颜色和大小的纯色图像。
 
 @param color  颜色。
 @param size   新图像的类型。
 */
+ (nullable UIImage *)yy_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 创建并返回带有自定义绘图代码的图像。
 
 @param size      图像大小。
 @param drawBlock 绘图块。
 
 @return 新图像
 */
+ (nullable UIImage *)yy_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

#pragma mark - Image Info（图像信息）
///=============================================================================
/// @name Image Info
///=============================================================================

/**
 此图像是否有Alpha通道。
 */
- (BOOL)yy_hasAlphaChannel;


#pragma mark - Modify Image (修改图像)
///=============================================================================
/// @name Modify Image
///=============================================================================

/**
 在指定的矩形中绘制整个图像，内容随contentMode更改。
 
 @discussion 此方法根据图像的方向设置，在当前图形上下文中绘制整个图像。在默认坐标系中，图像位于指定矩形原点的下方和右侧。但是，此方法尊重应用于当前图形上下文的任何转换。
 
 @param rect        用来绘制图像的矩形。
 
 @param contentMode 绘制内容模式
 
 @param clips       一个布尔值，用于确定内容是否限于矩形。
 */
- (void)yy_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips;

/**
 返回从该图像缩放的新图像。该图像将根据需要拉伸。
 
 @param size  要缩放的新大小，值应为正。
 
 @return      给定大小的新图像。
 */
- (nullable UIImage *)yy_imageByResizeToSize:(CGSize)size;

/**
 返回从该图像缩放的新图像。图像内容将使用ContentMode更改。
 
 @param size        要缩放的新大小，值应为正。
 
 @param contentMode 图像内容的内容模式。
 
 @return 给定大小的新图像。
 */
- (nullable UIImage *)yy_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 返回从此图像中剪切的新图像。
 
 @param rect  图像的内部矩形。
 
 @return      新图像，如果出现错误，则为nil。
 */
- (nullable UIImage *)yy_imageByCropToRect:(CGRect)rect;

/**
 返回从该图像插入边缘的新图像。
 
 @param insets  对于每个边的插入（正），值可以为负到“开始”。
 
 @param color   扩展边的填充颜色，nil表示透明的颜色。
 
 @return        新图像，如果出现错误，则为nil。
 */
- (nullable UIImage *)yy_imageByInsetEdge:(UIEdgeInsets)insets withColor:(nullable UIColor *)color;

/**
 使用给定的角大小对新图像进行圆角。
 
 @param radius  每个角椭圆的半径。大于矩形宽度或高度一半的值将被适当地钳制为宽度或高度的一半。
 */
- (nullable UIImage *)yy_imageByRoundCornerRadius:(CGFloat)radius;

/**
 使用给定的角大小对新图像进行圆角。
 
 @param radius       每个角椭圆的半径。大于矩形宽度或高度一半的值将被适当地钳制为宽度或高度的一半。

 @param borderWidth  插入边框的线条宽度。大于矩形宽度或高度一半的值将被适当地钳制为宽度或高度的一半。
 
 @param borderColor  边框颜色。nil表示透明的颜色。
 */
- (nullable UIImage *)yy_imageByRoundCornerRadius:(CGFloat)radius
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(nullable UIColor *)borderColor;

/**
 使用给定的角大小对新图像进行圆角。
 
 @param radius       每个角椭圆的半径。大于矩形宽度或高度一半的值将被适当地钳制为宽度或高度的一半。
 
 @param corners      用于标识要舍入的角点的位掩码值。您可以使用此参数仅舍入矩形角的子集。
 
 @param borderWidth  插入边框的线条宽度。大于矩形宽度或高度一半的值将被适当地钳制为宽度或高度的一半。
 
 @param borderColor  边框颜色。nil表示透明的颜色。
 
 @param borderLineJoin 边界线连接。
 */
- (nullable UIImage *)yy_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;

/**
 返回新的旋转图像（相对于中心）。
 
 @param radians   逆时针旋转弧度。⟲
 
 @param fitSize   是：新图像的大小将扩展为适合所有内容。
                  否：图像大小不会改变，内容可能会被剪裁。
 */
- (nullable UIImage *)yy_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 返回逆时针旋转四分之一圈（90°）的新图像。 ⤺
 宽度和高度将交换。
 */
- (nullable UIImage *)yy_imageByRotateLeft90;

/**
 返回顺时针旋转四分之一圈（90°）的新图像。 ⤼
 宽度和高度将交换。
 */
- (nullable UIImage *)yy_imageByRotateRight90;

/**
 返回旋转180°的新图像。 ↻
 */
- (nullable UIImage *)yy_imageByRotate180;

/**
 返回垂直翻转的图像。 ⥯
 */
- (nullable UIImage *)yy_imageByFlipVertical;

/**
 返回水平翻转的图像。 ⇋
 */
- (nullable UIImage *)yy_imageByFlipHorizontal;


#pragma mark - Image Effect （图像效应）
///=============================================================================
/// @name Image Effect
///=============================================================================

/**
 用给定的颜色给alpha通道中的图像着色。
 
 @param color  颜色。
 */
- (nullable UIImage *)yy_imageByTintColor:(UIColor *)color;

/**
 返回灰度图像。
 */
- (nullable UIImage *)yy_imageByGrayscale;

/**
 对该图像应用模糊效果。适用于模糊任何内容。
 */
- (nullable UIImage *)yy_imageByBlurSoft;

/**
 对该图像应用模糊效果。适合模糊除纯白色以外的任何内容。（与iOS控制面板相同）
 */
- (nullable UIImage *)yy_imageByBlurLight;

/**
 对该图像应用模糊效果。适合显示黑色文本。（与iOS导航栏白色相同）
 */
- (nullable UIImage *)yy_imageByBlurExtraLight;

/**
 对该图像应用模糊效果。适合显示白色文本。（与iOS通知中心相同）
 */
- (nullable UIImage *)yy_imageByBlurDark;

/**
 将模糊和淡色应用于此图像。
 
 @param tintColor  色彩。
 */
- (nullable UIImage *)yy_imageByBlurWithTint:(UIColor *)tintColor;

/**
 在@a maskimage指定的区域内（可选）对此图像应用模糊、淡色和饱和度调整。
 
 @param blurRadius     以点为单位的模糊半径，0表示没有模糊效果。
 
 @param tintColor      一个可选的UIColor对象，与模糊和饱和度操作的结果统一混合。此颜色的alpha通道决定了色调的强度。nil意味透明。
 
 @param tintBlendMode  @A色调混合模式。默认值为kCGBlendModeNormal (0)。
 
 
 @param saturation     值为1.0不会对结果图像产生任何更改。小于1.0的值将降低结果图像的饱和度，而大于1.0的值将产生相反的效果。0表示灰度。
 
 @param maskImage       如果指定，@a输入图像仅在此掩码定义的区域中修改。必须是图像掩码，否则必须满足CGContextClipToMask的掩码参数的要求。
 
 
 @return               图像有效，或者如果发生错误（例如，没有足够的内存）则为nil。
 */
- (nullable UIImage *)yy_imageByBlurRadius:(CGFloat)blurRadius
                                 tintColor:(nullable UIColor *)tintColor
                                  tintMode:(CGBlendMode)tintBlendMode
                                saturation:(CGFloat)saturation
                                 maskImage:(nullable UIImage *)maskImage;

@end

NS_ASSUME_NONNULL_END
