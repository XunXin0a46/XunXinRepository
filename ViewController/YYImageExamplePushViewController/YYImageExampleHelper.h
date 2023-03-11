//
//  YYImageExampleHelper.h
//  FrameworksTest
//
//  Created by 王刚 on 2019/9/22.
//  Copyright © 2019 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YYImageExampleHelper : NSObject

/// 点击播放/暂停
+ (void)addTapControlToAnimatedImageView:(YYAnimatedImageView *)view;

/// 滑动前进/后退
+ (void)addPanControlToAnimatedImageView:(YYAnimatedImageView *)view;

@end


