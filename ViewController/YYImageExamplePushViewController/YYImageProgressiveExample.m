//
//  YYImageProgressiveExample.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/9/24.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "YYImageProgressiveExample.h"
#import "UIView+YYAdd.h"
#import "UIControl+YYAdd.h"

@interface NSData(YYAdd)
@end
@implementation NSData(YYAdd)
+ (NSData *)dataNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSLog(@"%@",path);
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}
@end

@interface YYImageProgressiveExample ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISegmentedControl *seg0;
@property (nonatomic, strong) UISegmentedControl *seg1;
@property (nonatomic, strong) UISlider *slider0;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation YYImageProgressiveExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(300, 300);
    _imageView.backgroundColor = [UIColor colorWithWhite:0.790 alpha:1.000];
    _imageView.centerX = self.view.width / 2;
    
    ///分段控制器
    _seg0 = [[UISegmentedControl alloc] initWithItems:@[@"baseline",@"progressive/interlaced"]];
    _seg0.selectedSegmentIndex = 0;
    _seg0.layer.cornerRadius = 15.0;
    _seg0.layer.masksToBounds = YES;
    _seg0.layer.borderColor = [_seg0.tintColor CGColor];
    _seg0.layer.borderWidth = 1;
    _seg0.size = CGSizeMake(_imageView.width, 30);
    _seg0.centerX = self.view.width / 2;
    
    _seg1 = [[UISegmentedControl alloc] initWithItems:@[@"JPEG", @"PNG", @"GIF"]];
    _seg1.frame = _seg0.frame;
    _seg1.selectedSegmentIndex = 0;
    
    ///滑块控制器
    _slider0 = [UISlider new];
    _slider0.width = _seg0.width;
    [_slider0 sizeToFit];
    _slider0.minimumValue = 0;
    _slider0.maximumValue = 1.05;
    _slider0.value = 0;
    _slider0.centerX = self.view.width / 2;
    
    _imageView.top = 64 + 10;
    _seg0.top = _imageView.bottom + 10;
    _seg1.top = _seg0.bottom + 10;
    _slider0.top = _seg1.bottom + 10;
    
    [self.view addSubview:_imageView];
    [self.view addSubview:_seg0];
    [self.view addSubview:_seg1];
    [self.view addSubview:_slider0];
    
    __weak typeof(self) _self = self;
    ///为控件事件添加块
    [_seg0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_seg1 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_slider0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    
    ///GCD定时器
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_main_queue();
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        //执行的函数或代码块
        [weakSelf changeSliderValue];
        [weakSelf changed];
    });
    dispatch_resume(_timer);
}

///切换图片加载显示方式和图片格式
- (void)changed {
    NSString *name = nil;
    if (_seg0.selectedSegmentIndex == 0) {
        if (_seg1.selectedSegmentIndex == 0) {
            name = @"mew_baseline.jpg";
        } else if (_seg1.selectedSegmentIndex == 1) {
            name = @"mew_baseline.png";
        } else {
            name = @"mew_baseline.gif";
        }
    } else {
        if (_seg1.selectedSegmentIndex == 0) {
            name = @"mew_progressive.jpg";
        } else if (_seg1.selectedSegmentIndex == 1) {
            name = @"mew_interlaced.png";
        } else {
            name = @"mew_interlaced.gif";
        }
    }
    
    NSData *data = [NSData dataNamed:name];
    float progress = _slider0.value;
    if (progress > 1) progress = 1;
    NSData *subData = [data subdataWithRange:NSMakeRange(0, data.length * progress)];
    
    YYImageDecoder *decoder = [[YYImageDecoder alloc] initWithScale:[UIScreen mainScreen].scale];
    [decoder updateData:subData final:NO];
    YYImageFrame *frame = [decoder frameAtIndex:0 decodeForDisplay:YES];
    
    _imageView.image = frame.image;
}

///改变滑块控制器的值
- (void)changeSliderValue{
    _slider0.value += 0.1;
    if(_slider0.value == _slider0.maximumValue){
        _slider0.value = 0;
    }
}

-(void)dealloc{
    
    dispatch_cancel(_timer);
   
}

@end
