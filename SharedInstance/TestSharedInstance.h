//
//  TestSharedInstance.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/7.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestSharedInstance : NSObject

//按钮与控制器对应的字典(用于传递导航集合视图中的点击事件)
@property (nonatomic, copy) NSDictionary *buttonCorrespondingControllerDictionary;
//选中的控制器名称(用于选中导航集合视图中的Item)
@property (nonatomic, copy) NSString *selectControllerName;
//存储上传图片的数组
@property (nonatomic, strong) NSMutableArray *uploadImageArray;
//网络图片基URL，例如：http://68dsw.oss-cn-beijing.aliyuncs.com/images/
@property (nonatomic, copy) NSString *imageBaseURL;

+(instancetype)sharedInstance;

@end

