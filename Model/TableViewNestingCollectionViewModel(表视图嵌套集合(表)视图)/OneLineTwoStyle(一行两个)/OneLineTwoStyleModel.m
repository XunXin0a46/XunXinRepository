//
//  OneLineTwoStyleModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/21.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "OneLineTwoStyleModel.h"

@implementation OneLineTwoStyleModel

///创建模型数据一
- (instancetype)cureateModelI{
    self.image = [UIImage imageNamed:@"螳螂2"];
    self.name = @"霸天异形";
    self.locationl = @"定位:刺客";
    self.price = @"6300精粹";
    self.activityaPrice = @"4800精粹";
    self.radiusStyle = @"1";
    self.shadowStyle = @"1";
    return self;
}

///创建模型数据二
- (instancetype)cureateModelII{
    self.image = [UIImage imageNamed:@"螳螂5"];
    self.name = @"死亡绽放";
    self.locationl = @"定位:刺客";
    self.price = @"6300精粹";
    self.activityaPrice = @"4800精粹";
    self.radiusStyle = nil;
    self.shadowStyle = nil;
    return self;
}

///创建模型数据三
- (instancetype)cureateModelIII{
    self.image = [UIImage imageNamed:@"螳螂3"];
    self.name = @"冠军之刃";
    self.locationl = @"定位:刺客";
    self.price = @"6300精粹";
    self.activityaPrice = @"4800精粹";
    self.radiusStyle = @"1";
    self.shadowStyle = @"1";
    return self;
}

@end
