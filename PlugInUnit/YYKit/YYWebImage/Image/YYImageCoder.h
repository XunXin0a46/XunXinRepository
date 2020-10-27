//
//  YYImageCoder.h
//  YYImage <https://github.com/ibireme/YYImage>
//
//  Created by ibireme on 15/5/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 图像文件类型。
 */
typedef NS_ENUM(NSUInteger, YYImageType) {
    YYImageTypeUnknown = 0, ///< unknown
    YYImageTypeJPEG,        ///< jpeg, jpg
    YYImageTypeJPEG2000,    ///< jp2
    YYImageTypeTIFF,        ///< tiff, tif
    YYImageTypeBMP,         ///< bmp
    YYImageTypeICO,         ///< ico
    YYImageTypeICNS,        ///< icns
    YYImageTypeGIF,         ///< gif
    YYImageTypePNG,         ///< png
    YYImageTypeWebP,        ///< webp
    YYImageTypeOther,       ///< other image format
};


/**
 Dispose method 指定在画布上呈现下一帧之前如何处理当前帧使用的区域。
 */
typedef NS_ENUM(NSUInteger, YYImageDisposeMethod) {
    
    /**
     在渲染下一帧之前，不会对此帧进行任何处理；画布的内容保持原样。
     */
    YYImageDisposeNone = 0,
    
    /**
     在渲染下一帧之前，画布的帧区域将被清除为完全透明的黑色。
     */
    YYImageDisposeBackground,
    
    /**
     在呈现下一帧之前，画布的帧区域将还原为上一个内容。
     */
    YYImageDisposePrevious,
};

/**
 混合操作指定如何将当前帧的透明像素与上一画布的透明像素混合。
 */
typedef NS_ENUM(NSUInteger, YYImageBlendOperation) {
    
    /**
     帧的所有颜色组件（包括alpha）将覆盖帧画布区域的当前内容。
     */
    YYImageBlendNone = 0,
    
    /**
     帧应该基于其alpha合成到输出缓冲区上。
     */
    YYImageBlendOver,
};

/**
 图像Frame对象。
 */
@interface YYImageFrame : NSObject <NSCopying>
@property (nonatomic) NSUInteger index;    ///< Frame index (zero based)
@property (nonatomic) NSUInteger width;    ///< Frame width
@property (nonatomic) NSUInteger height;   ///< Frame height
@property (nonatomic) NSUInteger offsetX;  ///< Frame origin.x in canvas (left-bottom based)
@property (nonatomic) NSUInteger offsetY;  ///< Frame origin.y in canvas (left-bottom based)
@property (nonatomic) NSTimeInterval duration;          ///< Frame duration in seconds
@property (nonatomic) YYImageDisposeMethod dispose;     ///< Frame dispose method.
@property (nonatomic) YYImageBlendOperation blend;      ///< Frame blend operation.
@property (nullable, nonatomic, strong) UIImage *image; ///< The image.
+ (instancetype)frameWithImage:(UIImage *)image;
@end


#pragma mark - Decoder （解码）

/**
 解码图像数据的图像解码器。
 
 @discussion 这个类支持解码动画webp、apng、gif和系统图像格式，如png、jpg、jp2、bmp、tiff、pic、icns和ico。它可用于解码完整的图像数据，或在图像下载期间解码增量图像数据。这个类是线程安全的。
 
 例子:
 
    // 解码单个图像:
    NSData *data = [NSData dataWithContentOfFile:@"/tmp/image.webp"];
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:2.0];
    UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
 
    // 下载时解码图像:
    NSMutableData *data = [NSMutableData new];
    YYImageDecoder *decoder = [[YYImageDecoder alloc] initWithScale:2.0];
    while(newDataArrived) {
        [data appendData:newData];
        [decoder updateData:data final:NO];
        if (decoder.frameCount > 0) {
            UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
            // progressive display...
        }
    }
    [decoder updateData:data final:YES];
    UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    // final display...
 
 */
@interface YYImageDecoder : NSObject

@property (nullable, nonatomic, readonly) NSData *data;    ///< Image data.
@property (nonatomic, readonly) YYImageType type;          ///< Image data type.
@property (nonatomic, readonly) CGFloat scale;             ///< Image scale.
@property (nonatomic, readonly) NSUInteger frameCount;     ///< Image frame count.
@property (nonatomic, readonly) NSUInteger loopCount;      ///< Image loop count, 0 means infinite.
@property (nonatomic, readonly) NSUInteger width;          ///< Image canvas width.
@property (nonatomic, readonly) NSUInteger height;         ///< Image canvas height.
@property (nonatomic, readonly, getter=isFinalized) BOOL finalized;

/**
 创建图像解码器。
 
 @param scale  图像的比例。
 @return 图像解码器.
 */
- (instancetype)initWithScale:(CGFloat)scale NS_DESIGNATED_INITIALIZER;

/**
 用新数据更新增量图像。
 
 @discussion 当您没有完整的图像数据时，可以使用此方法来解码逐行扫描/隔行扫描/基线图像。decoder保留了“data”，解码时不应修改其他线程中的数据。
 
 @param data  要添加到图像解码器的数据。每次调用此函数时，“data”参数必须包含迄今为止累积的所有图像文件数据。
 
 @param final  指定数据是否为最终集的值。如果是，则通过“是”，否则不通过。当数据已经完成时，您不能再更新数据。
 
 @return 是否成功。
 */
- (BOOL)updateData:(nullable NSData *)data final:(BOOL)final;

/**
 使用指定数据创建解码器的方便方法。
 @param data  图像数据。
 @param scale 图像的比例。
 @return 一个新的解码器，如果出现错误则为nil。
 */
+ (nullable instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale;

/**
 解码并返回来自指定索引的帧。
 @param index  帧图像索引（基于零）
 @param decodeForDisplay 是否将图像解码为内存位图以供显示。如果否，它将尝试返回原始帧数据而不混合。
 @return 带有图像的新帧，如果出现错误则为零。
 */
- (nullable YYImageFrame *)frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay;

/**
 返回指定索引的帧持续时间。
 @param index  帧 图像（基于零）。
 @return 持续时间（秒）。
 */
- (NSTimeInterval)frameDurationAtIndex:(NSUInteger)index;

/**
 返回帧的属性。有关详细信息，请参阅ImageIO.framework中的“CGImageProperties.h”。
 
 @param index  帧 图像索引（基于零）。
 @return ImageIO帧属性。
 */
- (nullable NSDictionary *)framePropertiesAtIndex:(NSUInteger)index;

/**
 返回图像的属性。有关详细信息，请参阅ImageIO.framework中的“CGImageProperties.h”。
 */
- (nullable NSDictionary *)imageProperties;

@end



#pragma mark - Encoder （编码）

/**
 将图像编码成数据的图像编码器。
 
 @discussion 它支持使用YYImageType中定义的类型对单帧图像进行编码。它还支持使用gif、apng和webp对多帧图像进行编码。
 
 例子:
    
    YYImageEncoder *jpegEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeJPEG];
    jpegEncoder.quality = 0.9;
    [jpegEncoder addImage:image duration:0];
    NSData jpegData = [jpegEncoder encode];
 
    YYImageEncoder *gifEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
    gifEncoder.loopCount = 5;
    [gifEncoder addImage:image0 duration:0.1];
    [gifEncoder addImage:image1 duration:0.15];
    [gifEncoder addImage:image2 duration:0.2];
    NSData gifData = [gifEncoder encode];
 
 @warning 在编码多帧图像时，它只是将图像打包在一起。如果要减小图像文件的大小，请尝试使用imagemagick/ffmpeg（用于gif和webp）和apngasm（用于apng）。
 */
@interface YYImageEncoder : NSObject

@property (nonatomic, readonly) YYImageType type; ///< Image type.
@property (nonatomic) NSUInteger loopCount;       ///< 循环计数，0表示无穷大，仅适用于gif/apng/webp。
@property (nonatomic) BOOL lossless;              ///< 无损，仅适用于WebP。
@property (nonatomic) CGFloat quality;            ///< 压缩质量，0.0~1.0，仅适用于jpg/jp2/webp。

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 创建具有指定类型的图像编码器。
 @param type 图像类型。
 @return 一个新的编码器，如果发生错误，则为nil。
 */
- (nullable instancetype)initWithType:(YYImageType)type NS_DESIGNATED_INITIALIZER;

/**
 将图像添加到编码器。
 @param image    图像。
 @param duration 动画的图像持续时间。传递0以忽略此参数。
 */
- (void)addImage:(UIImage *)image duration:(NSTimeInterval)duration;

/**
 将带有图像数据的图像添加到编码器。
 @param data    图像数据。
 @param duration 动画的图像持续时间。传递0以忽略此参数。
 */
- (void)addImageWithData:(NSData *)data duration:(NSTimeInterval)duration;

/**
 将图像从文件路径添加到编码器。
 @param path    图像文件路径。
 @param duration 动画的图像持续时间。传递0以忽略此参数。
 */
- (void)addImageWithFile:(NSString *)path duration:(NSTimeInterval)duration;

/**
 对图像进行编码并返回图像数据。
 @return 图像数据，如果发生错误则为零。
 */
- (nullable NSData *)encode;

/**
 将图像编码为文件。
 @param path 文件路径（如果存在，则覆盖）。
 @return 是否成功。
 */
- (BOOL)encodeToFile:(NSString *)path;

/**
 单帧图像编码的简便方法。
 @param image   图像。
 @param type    目标图像类型。
 @param quality 图像质量，0.0~1.0。
 @return 图像数据，如果发生错误则为nil。
 */
+ (nullable NSData *)encodeImage:(UIImage *)image type:(YYImageType)type quality:(CGFloat)quality;

/**
 从解码器编码图像的方便方法。
 @param decoder 图像解码器。
 @param type    目标图像类型；
 @param quality 压缩质量，0.0~1.0，仅适用于jpg/jp2/webp。
 @return 图像数据，如果发生错误则为nil。
 */
+ (nullable NSData *)encodeImageWithDecoder:(YYImageDecoder *)decoder type:(YYImageType)type quality:(CGFloat)quality;

@end


#pragma mark - UIImage

@interface UIImage (YYImageCoder)

/**
 将此图像解压缩为位图，这样当图像显示在屏幕上时，主线程不会被额外的解码阻塞。如果图像已经被解码或无法解码，它只会返回自身。
 
 @return 解码后的图像，或者如果不需要的话返回它自己。
 @see yy_isDecodedForDisplay
 */
- (instancetype)yy_imageByDecoded;

/**
 当图像可以显示在屏幕上而不需要额外的解码时。
 @warning 它只是对你的代码的提示，改变它没有其他效果。
 */
@property (nonatomic) BOOL yy_isDecodedForDisplay;

/**
 将此图像保存到iOS照片集。
 
 @discussion  如果图像是从动画gif/apng创建的，此方法会尝试将原始数据保存到相册中，否则，它会将图像保存为jpeg或png（基于alpha信息）。
 
 @param completionBlock 保存操作完成后调用的块（在主线程中）。assetur：标识保存的图像文件的url。如果图像未保存，则assetur为nil。
    error: 如果未保存图像，则为描述失败原因的错误对象，否则为nil。
 */
- (void)yy_saveToAlbumWithCompletionBlock:(nullable void(^)(NSURL * _Nullable assetURL, NSError * _Nullable error))completionBlock;

/**
 返回此图像的“最佳”数据表示形式。
 
 @discussion 基于这些规则的转换：
 1。如果图像是从动画gif/apng/webp创建的，则返回原始数据。
 2。它根据alpha信息返回png或jpeg（0.9）表示。
 
 @return 图像数据，如果发生错误则为nil。
 */
- (nullable NSData *)yy_imageDataRepresentation;

@end



#pragma mark - Helper

/// 通过读取数据头16字节（非常快）来检测数据的图像类型。
CG_EXTERN YYImageType YYImageDetectType(CFDataRef data);

/// 将YYImageType转换为UTI（例如kUTTypeJPEG）。
CG_EXTERN CFStringRef _Nullable YYImageTypeToUTType(YYImageType type);

/// 将UTI（如kUTTypeJPEG）转换为YYImageType。
CG_EXTERN YYImageType YYImageTypeFromUTType(CFStringRef uti);

/// 获取图像类型的文件扩展名（例如@“jpg”）。
CG_EXTERN NSString *_Nullable YYImageTypeGetExtension(YYImageType type);



/// 返回共享设备的RGB颜色空间。
CG_EXTERN CGColorSpaceRef YYCGColorSpaceGetDeviceRGB(void);

/// 返回共享设备的灰色空间。
CG_EXTERN CGColorSpaceRef YYCGColorSpaceGetDeviceGray(void);

/// 返回颜色空间是否为设备RGB。
CG_EXTERN BOOL YYCGColorSpaceIsDeviceRGB(CGColorSpaceRef space);

/// 返回颜色空间是否为设备灰色。
CG_EXTERN BOOL YYCGColorSpaceIsDeviceGray(CGColorSpaceRef space);



/// 将EXIF方向值转换为UIImageOrientation。
CG_EXTERN UIImageOrientation YYUIImageOrientationFromEXIFValue(NSInteger value);

/// 将UIImageOrientation转换为EXIF orientation值。
CG_EXTERN NSInteger YYUIImageOrientationToEXIFValue(UIImageOrientation orientation);



/**
 创建解码图像。
 
 @discussion 如果源图像是从压缩图像数据（如png或jpeg）创建的，则可以使用此方法对图像进行解码。解码后，您可以使用CGImageGetDataProvider()和CGDataProviderCopyData()访问解码字节，而无需额外的解码过程。如果图像已经解码，此方法只将解码字节复制到新图像。
 
 @param imageRef          源图像。
 @param decodeForDisplay  如果是，此方法将解码图像并将其转换为BGRA8888（预乘）或BGRX8888格式以用于Calayer显示。
 
 @return 解码图像，如果出现错误则为nil。
 */
CG_EXTERN CGImageRef _Nullable YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay);

/**
 创建具有方向的图像副本。
 
 @param imageRef       源图像
 @param orientation    将应用于图像的图像方向。
 @param destBitmapInfo 目标图像位图，仅支持32位格式（如argb8888）。
 @return 一个新图像，如果出现错误则为NULL。
 */
CG_EXTERN CGImageRef _Nullable YYCGImageCreateCopyWithOrientation(CGImageRef imageRef,
                                                                  UIImageOrientation orientation,
                                                                  CGBitmapInfo destBitmapInfo);

/**
 使用CGAffineTransform创建图像副本。
 
 @param imageRef       源图像。
 @param transform      应用于图像的变换（基于左下角的坐标系）。
 @param destSize       目标图像大小
 @param destBitmapInfo 目标图像位图，仅支持32位格式（如argb8888）。
 @return 一个新图像，如果出现错误则为NULL。
 */
CG_EXTERN CGImageRef _Nullable YYCGImageCreateAffineTransformCopy(CGImageRef imageRef,
                                                                  CGAffineTransform transform,
                                                                  CGSize destSize,
                                                                  CGBitmapInfo destBitmapInfo);

/**
 使用CGImageDestination将图像编码为数据。
 
 @param imageRef  图像。
 @param type      图像目标数据类型。
 @param quality   压缩质量，0.0~1.0，仅适用于jpg/jp2/webp。
 @return 一个新的图像数据，如果出现错误，则为nil。
 */
CG_EXTERN CFDataRef _Nullable YYCGImageCreateEncodedData(CGImageRef imageRef, YYImageType type, CGFloat quality);


/**
 webp是否在YYImage中可用。
 */
CG_EXTERN BOOL YYImageWebPAvailable(void);

/**
 获取webp图像帧计数；
 
 @param webpData WebP数据。
 @return 图像帧计数，如果发生错误，则为0。
 */
CG_EXTERN NSUInteger YYImageGetWebPFrameCount(CFDataRef webpData);

/**
 从WebP数据解码图像，如果发生错误，则返回NULL。
 
 @param webpData          WebP 数据。
 @param decodeForDisplay  如果YES，此方法将解码图像并将其转换为BGRA8888（预乘）格式以用于Calayer显示。
 @param useThreads        是以启用多线程解码。（加快速度，但需要更多CPU）
 @param bypassFiltering   YES 跳过循环内筛选。（加速，但可能会失去一些平滑度）
 @param noFancyUpsampling YES，使用更快的逐点上采样。（减速，可能会丢失一些细节）。
 @return 已解码的图像，如果发生错误，则为NULL。
 */
CG_EXTERN CGImageRef _Nullable YYCGImageCreateWithWebPData(CFDataRef webpData,
                                                           BOOL decodeForDisplay,
                                                           BOOL useThreads,
                                                           BOOL bypassFiltering,
                                                           BOOL noFancyUpsampling);

typedef NS_ENUM(NSUInteger, YYImagePreset) {
    YYImagePresetDefault = 0,  ///< 默认预设。
    YYImagePresetPicture,      ///< 数码照片，如人像，内景
    YYImagePresetPhoto,        ///< 室外摄影，自然采光
    YYImagePresetDrawing,      ///< 手绘或线绘，高对比度细节
    YYImagePresetIcon,         ///< 小尺寸彩色图像
    YYImagePresetText          ///< 类文本
};

/**
 将CGImage编码为WebP数据
 
 @param imageRef      图像
 @param lossless      是=无损（类似于PNG），否=有损（类似于JPEG）
 @param quality       0.0~1.0（0=最小文件，1.0=最大文件）对于无损图像，请尝试接近1.0的值；对于有损图像，请尝试接近0.8的值。
 @param compressLevel 0~6（0=快，6=慢更好）。默认值为4。
 @param preset        预设为不同的图像类型，默认为YYImagePresetDefault。
 @return WebP数据，如果发生错误，则为nil。
 */
CG_EXTERN CFDataRef _Nullable YYCGImageCreateEncodedWebPData(CGImageRef imageRef,
                                                             BOOL lossless,
                                                             CGFloat quality,
                                                             int compressLevel,
                                                             YYImagePreset preset);

NS_ASSUME_NONNULL_END
