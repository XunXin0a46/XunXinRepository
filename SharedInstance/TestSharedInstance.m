//
//  TestSharedInstance.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/7.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestSharedInstance.h"

@implementation TestSharedInstance

+ (instancetype)sharedInstance{
    static TestSharedInstance *tSharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化单例对象
        tSharedInstance = [[TestSharedInstance alloc]init];
        //初始化存储图片的数组
        tSharedInstance.uploadImageArray = [[NSMutableArray alloc]init];
    });
    return tSharedInstance;;
}

///设置按钮与控制器对应的字典(用于传递导航集合视图中的点击事件)
- (void)setButtonCorrespondingControllerDictionary:(NSDictionary *)buttonCorrespondingControllerDictionary{
    _buttonCorrespondingControllerDictionary = [[NSDictionary alloc]initWithDictionary:buttonCorrespondingControllerDictionary];
}

///获取按钮与控制器对应的字典(用于传递导航集合视图中的点击事件)
- (NSDictionary *)getButtonCorrespondingControllerDictionary:(NSDictionary *)buttonCorrespondingControllerDictionary{
    return _buttonCorrespondingControllerDictionary;
}

@end
