//
//  FSCalendarDelegationProxy.h
//  FSCalendar
//
//  Created by dingwenchao on 11/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//
//  1. Smart proxy delegation http://petersteinberger.com/blog/2013/smart-proxy-delegation/
//  2. Manage deprecated delegation functions
//

#import <Foundation/Foundation.h>
#import "FSCalendar.h"

NS_ASSUME_NONNULL_BEGIN
//日历代理对象
@interface FSCalendarDelegationProxy : NSProxy

@property (weak  , nonatomic) id delegation;//代理对象
@property (strong, nonatomic) Protocol *protocol;//协议
@property (strong, nonatomic) NSDictionary<NSString *,NSString *> *deprecations;//不推荐选择器的字典

- (instancetype)init;//初始化函数
- (SEL)deprecatedSelectorOfSelector:(SEL)selector;//不推荐的选择器

@end

NS_ASSUME_NONNULL_END

