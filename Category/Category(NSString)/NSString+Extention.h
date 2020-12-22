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

///判断字符串是否包含符号,包含返回YES
- (BOOL)judgeTheillegalCharacter;

///调整文本间距
- (NSAttributedString *)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font;

@end

