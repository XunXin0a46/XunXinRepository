//
//  TestTTTAttributedLabelViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/6/6.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestTTTAttributedLabelViewController.h"
#import "TTTAttributedLabel.h"
#import "UIImage+YSCTintColor.h"

@interface TestTTTAttributedLabelViewController ()<TTTAttributedLabelDelegate>

@end

@implementation TestTTTAttributedLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"富文本标签"];
    
    NSString *text=@"弱者普遍易怒如虎，而且容易暴怒。强者通常平静如水，并且相对平和。一个内心不强大的人，自然内心不够平静。内心不平静的人，处处是风浪。再小的事，都会被无限放大。一个内心不强大的人，心中永远缺乏安全感  https://github.com/TTTAttributedLabel/TTTAttributedLabel  15112345678  2017-05-06 天安门";
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 200)];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.text = text;
    //设置代理
    label.delegate = self;
    //设置行间距
    label.lineSpacing = 8;
    //可自动识别url，显示为蓝色+下划线
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    //此属性可以不显示下划线，点击的颜色默认为红色
    label.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:NO],(NSString *)kCTUnderlineStyleAttributeName,nil];
    
    //此属性可以改变点击的颜色
    label.activeLinkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor purpleColor],(NSString *)kCTForegroundColorAttributeName,nil];
    
    //设置需要点击的文字的颜色大小
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //得到需要点击的文字的位置
        NSRange selRange=[text rangeOfString:@"强者通常平静如水"];
        //设定可点击文字的的大小
        UIFont *selFont=[UIFont systemFontOfSize:14];
        CTFontRef selFontRef = CTFontCreateWithName((__bridge CFStringRef)selFont.fontName, selFont.pointSize, NULL);
        //设置可点击文本的大小
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)selFontRef range:selRange];
        //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:selRange];
        //设置可点击文本的背景颜色
         [mutableAttributedString addAttribute:(NSString*)kCTBackgroundColorAttributeName value:(id)[[UIColor redColor] CGColor] range:selRange];
        //释放核心基础对象。
        CFRelease(selFontRef);
    
        //得到需要点击的文字的位置
        NSRange selRange1=[text rangeOfString:@"一个内心不强大的人，心中永远缺乏安全感"];
        //设定可点击文字的的大小
        UIFont *selFont1=[UIFont systemFontOfSize:14];
        CTFontRef selFontRef1 = CTFontCreateWithName((__bridge CFStringRef)selFont1.fontName, selFont1.pointSize, NULL);
        //设置可点击文本的大小
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)selFontRef1 range:selRange1];
        //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:selRange1];
        //设置可点击文本的背景颜色
        [mutableAttributedString addAttribute:(NSString*)kCTBackgroundColorAttributeName value:(id)[[UIColor redColor] CGColor] range:selRange1];
        //释放核心基础对象
        CFRelease(selFontRef1);
    
        return mutableAttributedString;
    }];
    
    
    //给  强者通常平静如水   添加点击事件
    NSRange selRange=[text rangeOfString:@"强者通常平静如水"];
    [label addLinkToTransitInformation:@{@"select":@"强者通常平静如水"} withRange:selRange];
    
    //给  强者通常平静如水   添加点击事件
    NSRange selRange1=[text rangeOfString:@"一个内心不强大的人，心中永远缺乏安全感"];
    [label addLinkToTransitInformation:@{@"select":@"一个内心不强大的人，心中永远缺乏安全感"} withRange:selRange1];
    
    //给 电话号码 添加点击事件
    NSRange telRange=[text rangeOfString:@"15112345678"];
    [label addLinkToPhoneNumber:@"15112345678" withRange:telRange];
    
    //给  时间  添加点击事件
    NSRange dateRange=[text rangeOfString:@"2017-05-06"];
    [label addLinkToDate:[NSDate date] withRange:dateRange];
    
    //给  天安门  添加点击事件
    NSRange addressRange=[text rangeOfString:@"天安门"];
    [label addLinkToAddress:@{@"address":@"天安门",@"longitude":@"116.2354",@"latitude":@"38.2145"} withRange:addressRange];
    
    //测试设置属性字符串标签
    [self setAttributedStringTestLabel];
    //测试按比例缩放属性字符串字体
    [self testAttributedStringByScalingFontSize];
    //测试带有a标签内容的标签
    [self testHtmlLabel];
    //测试带标签的富文本
    [self testCarryLabelOfAttributedString];
    
}


#pragma TTTAttributedLabel Delegate

//文字的点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSLog(@"didSelectLinkWithTransitInformation :%@",components);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"didSelectLinkWithURL :%@",url);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date {
    NSLog(@"didSelectLinkWithDate :%@",date);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    NSLog(@"didSelectLinkWithAddress :%@",addressComponents);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"didSelectLinkWithPhoneNumber :%@",phoneNumber);
}



//文字的长按事件
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithURL  :%@",url);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithDate:(NSDate *)date atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithDate  :%@",date);

}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithAddress:(NSDictionary *)addressComponents atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithAddress  :%@",addressComponents);

}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithPhoneNumber  :%@",phoneNumber);

}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithTransitInformation:(NSDictionary *)components atPoint:(CGPoint)point {
    NSLog(@"didLongPressLinkWithTransitInformation  :%@",components);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

///设置属性字符串标签
- (void)setAttributedStringTestLabel{
    NSString *termLabelText = @"距离成熟还有：30天";
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 50)];
    testLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:testLabel];
    
    NSRange range = [termLabelText rangeOfString:@"："];
    NSMutableAttributedString *attributedTermLabelText = [[NSMutableAttributedString alloc]initWithString:termLabelText];
    
    [attributedTermLabelText addAttributes:@{
        //文本字体
        NSFontAttributeName : [UIFont systemFontOfSize:20],
        //文本颜色
        NSForegroundColorAttributeName:[UIColor redColor],
        //文本背景色
        NSBackgroundColorAttributeName : [UIColor greenColor],
        //文本字间距
        NSKernAttributeName:@(5.0),
        //下划线
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
        //下划线颜色
        NSUnderlineColorAttributeName : [UIColor blueColor],
        //笔画宽度
        NSStrokeWidthAttributeName:@(3.5),
        //文本特殊效果，目前只有图版印刷效果可用
        NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
        //设置基线偏移值,正值上偏，负值下偏。
        NSBaselineOffsetAttributeName:@(5.0),
        //文本倾斜，正值右倾，负值左倾
        NSObliquenessAttributeName : @(-0.5),
        //文本横向拉伸,正值横向拉伸文本，负值横向压缩文本。
        NSExpansionAttributeName:@(0.5),
        //设置文字书写方向@[@(1)]从左到右，@[@(3)]从右到左
        NSWritingDirectionAttributeName:@[@(3)],
        
    } range:NSMakeRange(range.location + 1, termLabelText.length - (range.location + 2))];
    
    testLabel.attributedText = attributedTermLabelText;
}

///测试按比例缩放属性字符串字体
- (void)testAttributedStringByScalingFontSize{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"城南花已开"];
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 370, self.view.bounds.size.width, 50)];
    [self.view addSubview:testLabel];
    [attributedString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30]} range:NSMakeRange(0, attributedString.length)];
    testLabel.attributedText = NSAttributedStringByScalingFontSize(attributedString,0.5);
    
    UILabel *testLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, 50)];
    testLabel2.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:testLabel2];
    testLabel2.text = @"犹未见君来";
}

///按比例缩放属性字符串字体
static inline NSAttributedString * NSAttributedStringByScalingFontSize(NSAttributedString *attributedString, CGFloat scale) {
    //NSAttributedString转NSMutableAttributedString
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    //为属性字符串中特定属性的每个范围执行指定的块
    [mutableAttributedString enumerateAttribute:(NSString *)kCTFontAttributeName inRange:NSMakeRange(0, [mutableAttributedString length]) options:0 usingBlock:^(id value, NSRange range, BOOL * __unused stop) {
        //获取字体对象
        UIFont *font = (UIFont *)value;
        //如果存在字体对象
        if (font) {
            //声明字体名称变量
            NSString *fontName;
            //获取字体的大小
            CGFloat pointSize;
            //字体对象是UIFont类
            if ([font isKindOfClass:[UIFont class]]) {
                //获取字体名称
                fontName = font.fontName;
                //获取字体大小
                pointSize = font.pointSize;
            } else {
                //通过CFStringRef对象转为NSString获取字体名称
                fontName = (NSString *)CFBridgingRelease(CTFontCopyName((__bridge CTFontRef)font, kCTFontPostScriptNameKey));
                //获取字体大小
                pointSize = CTFontGetSize((__bridge CTFontRef)font);
            }
            //从指定范围内的字符中删除字体属性
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            //设置给定名称的新字体引用。
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, floorf(pointSize * scale), NULL);
            //将字体名称和计算字体大小的值的属性添加到指定范围内的字符
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            //释放CTFontRef对象
            CFRelease(fontRef);
        }
    }];
    //返回新的属性字符串
    return mutableAttributedString;
}

///测试带有a标签内容的标签
- (void)testHtmlLabel{
    NSString *htmlText = @"<a href=https://music.163.com/#/song?id=4900975>城南花已开</a>";
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 450, self.view.bounds.size.width, 50)];
    testLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:testLabel];
    
    testLabel.attributedText = [self handleHtmlText:htmlText];
}

///处理带有html标签的富文本
- (NSMutableAttributedString *)handleHtmlText:(NSString *)htmlText{
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                          initWithData:[htmlText dataUsingEncoding:
                                          NSUnicodeStringEncoding]
                                          options:@{
                                            NSDocumentTypeDocumentAttribute:
                                            NSHTMLTextDocumentType,
                                          }
                                          documentAttributes:nil error:nil];
    return attrStr;
}

///测试带标签的富文本
- (void)testCarryLabelOfAttributedString{
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 500, self.view.bounds.size.width, 50)];
    testLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:testLabel];
    testLabel.attributedText = [self carryLabelOfAttributedStringWithLabelContentArray:@[@"满减",@"返现",@"显示折扣"] withContentString:@"测试标签文本"];
}

///带标签的富文本
//参数 labelContentArray：标签内容数组  contentString：要插入标签的内容
- (NSMutableAttributedString *)carryLabelOfAttributedStringWithLabelContentArray:(NSArray<NSString *> *)labelContentArray withContentString:(NSString *)contentString{
    //初始化要加入标签的富文本
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithString:contentString];
    //初始化用于存放转为图片对象的标签内容数组
    NSMutableArray<UIImage *> *labelImages = [[NSMutableArray alloc] initWithCapacity:3];
    //标签内容数组不为空
    if(ARRAY_IS_NOT_EMPTY(labelContentArray)){
        //标签的圆角
        CGFloat const cornerRadius = 3.0;
        //标签的字体
        UIFont * const font = [UIFont systemFontOfSize:12.0];
        //记录转为标签的图片
        UIImage *labelImage;
        //遍历标签内容数组
        for (NSString *labelContentString in labelContentArray) {
            //标签内容不为空
            if(IS_NOT_EMPTY(labelContentString)){
                //获取标签图片
                labelImage = [UIImage imageWithText:labelContentString font:font fillColor:[UIColor redColor].CGColor cornerRadius:cornerRadius];
                //如果标签图片不为空
                if (labelImage) {
                    //添加标签图片到标签图片数组
                    [labelImages addObject:labelImage];
                }
            }
        }
    }else{
        //返回要加入标签的富文本
        return contentAttributedString;
    }
    //遍历标签图片数组
    for (UIImage *image in labelImages.reverseObjectEnumerator.allObjects) {
        //初始化文本与附件排版对象
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        //设置文本附件内容的图像
        attachment.image = image;
        //定义文本坐标系中接收器图形表示的布局界限
        attachment.bounds = CGRectMake(0, -3.0, image.size.width, image.size.height);
        //初始化空格富文本对象
        NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" "];
        //每次循环先插入一个空格
        [contentAttributedString insertAttributedString:spaceString atIndex:0];
        //文本与附件排版对象转为标签富文本
        NSAttributedString *labelContentAttribute = [NSAttributedString attributedStringWithAttachment:attachment];
        //插入标签富文本
        [contentAttributedString insertAttributedString:labelContentAttribute atIndex:0];
    }
    //返回插入标签富文本后的内容
    return contentAttributedString;
}

@end

