//
//  NSString+Extention.h
//  FrameworksTest
//
//  Created by 王刚 on 2019/12/6.
//  Copyright © 2019 王刚. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (Extention)

///为URL字符串添加键值对参数
-(NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key;

///文本添加删除线
- (NSAttributedString *)attributeSingleLine;

@end

