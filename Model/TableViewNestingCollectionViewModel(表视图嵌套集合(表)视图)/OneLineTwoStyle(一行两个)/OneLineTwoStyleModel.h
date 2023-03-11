//
//  OneLineTwoStyleModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/21.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneLineTwoStyleModel : NSObject

@property (nonatomic, strong) UIImage *image;//展示的图片
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *locationl;//定位
@property (nonatomic, copy) NSString *price;//价值
@property (nonatomic, copy) NSString *activityaPrice;//活动价
@property (nonatomic, copy) NSString *radiusStyle;//是否圆角 @"1":圆角 nil:直角
@property (nonatomic, copy) NSString *shadowStyle;//阴影样式 @"1":卡片投影 nil:无边白底

///创建模型数据一
- (instancetype)cureateModelI;

///创建模型数据二
- (instancetype)cureateModelII;

///创建模型数据三
- (instancetype)cureateModelIII;

@end

