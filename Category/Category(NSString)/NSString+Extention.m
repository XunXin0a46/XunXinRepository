//
//  NSString+Extention.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/12/6.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "NSString+Extention.h"


@implementation NSString (Extention)

///为URL字符串添加键值对参数
-(NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key{
    
    NSMutableString *string = [[NSMutableString alloc]initWithString:self];
    @try {
        NSRange range = [string rangeOfString:@"?"];
        if (range.location != NSNotFound) {//找到了
            //如果?是最后一个直接拼接参数
            if (string.length == (range.location + range.length)) {
                NSLog(@"最后一个是?");
                string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }else{//如果不是最后一个需要加&
                if([string hasSuffix:@"&"]){//如果最后一个是&,直接拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                }else{//如果最后不是&,需要加&后拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
                }
            }
        }else{//没找到
            if([string hasSuffix:@"&"]){//如果最后一个是&,去掉&后拼接
                string = (NSMutableString *)[string substringToIndex:string.length-1];
            }
            string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,value]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return string.copy;
}

///文本添加删除线
- (NSAttributedString *)attributeSingleLine{
    //富文本设置（删除线）
    NSMutableAttributedString *Att = [[NSMutableAttributedString alloc]initWithString:self];
    NSUInteger length = [Att length];
    [Att addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    return Att;

}

///判断字符串是否包含符号
- (BOOL)judgeTheillegalCharacter{
    
    NSString *str =@"^[A-Za-z\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

/**
 调整文本间距
 @parameter string 要调整的文本
 @parameter lineSpace 行间距
 @parameter kern 字符间距
 @parameter font 字体
 */
- (NSAttributedString *)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self attributes:attriDict];
    return attributedString;
}

///删除字符串两端的空字符
- (instancetype)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

///去掉小数末尾无意义的0
- (NSString*)deleteFloatAllZero{
    NSArray * arrStr=[self componentsSeparatedByString:@"."];
    NSString *str=arrStr.firstObject;
    NSString *str1=arrStr.lastObject;
    while ([str1 hasSuffix:@"0"]) {
        str1=[str1 substringToIndex:(str1.length-1)];
    }
    return (str1.length>0)?[NSString stringWithFormat:@"%@.%@",str,str1]:str;
}

///是否是数字
- (BOOL)isNumeric {
    return [self isPureInteger] || [self isPureDouble];
}

///是否是整数
- (BOOL)isPureInteger {
    //NSScanner对象将NSString对象的字符解释并转换为数字和字符串值
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scanner scanInteger:&val] && [scanner isAtEnd];
}

///是否是浮点数
- (BOOL)isPureDouble {
    //NSScanner对象将NSString对象的字符解释并转换为数字和字符串值
    NSScanner *scanner = [NSScanner scannerWithString:self];
    double val;
    return[scanner scanDouble:&val] && [scanner isAtEnd];
}


///字符串转double精度丢失问题
- (double)StringChangeToDoubleForJingdu
{
    if (self == nil || [self isEqualToString:@""]) {
        return 0.0;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [[formatter numberFromString:self]doubleValue];
}

@end
