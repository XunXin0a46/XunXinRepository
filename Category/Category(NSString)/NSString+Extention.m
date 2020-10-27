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

@end
