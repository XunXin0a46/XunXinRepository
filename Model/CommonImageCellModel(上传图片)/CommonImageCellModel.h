//
//  CommonImageCellModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/16.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonImageCellModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSString *> *imageCodes;//存放上图图片表识别与图片编码
@property (nonatomic, assign) NSUInteger maxNum;

@end

