//
//  YYImageDisplayExample.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/9/22.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "YYImageDisplayExample.h"
#import "UIView+YYAdd.h"
#import <sys/sysctl.h>
#import "YYImageExampleHelper.h"

@interface YYImageDisplayExample ()<UIGestureRecognizerDelegate>

@end

@implementation YYImageDisplayExample{
    UIScrollView *_scrollView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.000];
    
    _scrollView = [UIScrollView new];
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.size = CGSizeMake(self.view.width, 60);
    label.top = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"击点击图像暂停/播放\n滑动图像向前播放/回放图像";
    
    if ([self isSimulator]) {
        label.text = [@"请在设备中运行此应用程序以获得更好的性能。\n\n" stringByAppendingString:label.text];
        label.height = 120;
    }
    
    [_scrollView addSubview:label];
    
    [self addImageWithName:@"FireDragon" text:@"Animated GIF"];
    [self addImageWithName:@"wall-e" text:@"Animated WebP"];
    [self addImageWithName:@"pia" text:@"Animated PNG (APNG)"];
    [self addFrameImageWithText:@"Frame Animation"];
    [self addSpriteSheetImageWithText:@"Sprite Sheet Animation"];
    
    _scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
    
}

///根据名称添加图像与标签文本
- (void)addImageWithName:(NSString *)name text:(NSString *)text {
    YYImage *image = [YYImage imageNamed:name];
    [self addImage:image size:CGSizeZero text:text];
}

///添加一组帧图像与标签文本
- (void)addFrameImageWithText:(NSString *)text {
    
    NSString *basePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"EmoticonWeibo.bundle/com.sina.default"];
    NSMutableArray *paths = [NSMutableArray new];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_aini@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_baibai@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_chanzui@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_chijing@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_dahaqi@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_guzhang@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_haha@2x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_haixiu@3x.png"]];
    
    UIImage *image = [[YYFrameImage alloc] initWithImagePaths:paths oneFrameDuration:0.1 loopCount:0];
    [self addImage:image size:CGSizeZero text:text];
}

///添加精灵工作表图像与标签文本
- (void)addSpriteSheetImageWithText:(NSString *)text {
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"ResourceTwitter.bundle/fav02l-sheet@2x.png"];
    UIImage *sheet = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path] scale:2];
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    
    
    // 单张图片中8*12个精灵
    CGSize size = CGSizeMake(sheet.size.width / 8, sheet.size.height / 12);
    for (int j = 0; j < 12; j++) {
        for (int i = 0; i < 8; i++) {
            CGRect rect;
            rect.size = size;
            rect.origin.x = sheet.size.width / 8 * i;
            rect.origin.y = sheet.size.height / 12 * j;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [durations addObject:@(1 / 60.0)];
        }
    }
    YYSpriteSheetImage *sprite;
    sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:sheet
                                                     contentRects:contentRects
                                                   frameDurations:durations
                                                        loopCount:0];
    [self addImage:sprite size:size text:text];
}

///添加图片及图片大小与图片下面显示的文本
- (void)addImage:(UIImage *)image size:(CGSize)size text:(NSString *)text {
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    
    if (size.width > 0 && size.height > 0) imageView.size = size;
    imageView.centerX = self.view.width / 2;
    imageView.top = [(UIView *)[_scrollView.subviews lastObject] bottom] + 30;
    [_scrollView addSubview:imageView];
    
    //添加点击播放/暂停
    [YYImageExampleHelper addTapControlToAnimatedImageView:imageView];
    //添加滑动前进/后退
    [YYImageExampleHelper addPanControlToAnimatedImageView:imageView];
    
    for (UIGestureRecognizer *g in imageView.gestureRecognizers) {
        g.delegate = self;
    }
    
    UILabel *imageLabel = [UILabel new];
    imageLabel.backgroundColor = [UIColor clearColor];
    imageLabel.frame = CGRectMake(0, 0, self.view.width, 20);
    imageLabel.top = imageView.bottom + 10;
    imageLabel.textAlignment = NSTextAlignmentCenter;
    imageLabel.text = text;
    [_scrollView addSubview:imageLabel];
    
    _scrollView.contentSize = CGSizeMake(self.view.width, imageLabel.bottom + 20);
}

///是否为模拟器
- (BOOL)isSimulator {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *model = [NSString stringWithUTF8String:machine];
    free(machine);
    return [model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"];
}

/// 是否允许同时支持多个手势，默认是不支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
