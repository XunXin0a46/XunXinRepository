//
//  AlertView.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "AlertBaseView.h"


@interface AlertView : AlertBaseView

@property(nonatomic,copy)   NSString *title;//标题
@property(nonatomic,strong) UIFont *titleFont;//标题字号
@property(nonatomic,assign) NSTextAlignment titleAlign;//标题展示位置
@property(nonatomic,strong) UIColor *titleColor;//标题颜色

@property(nonatomic,copy)   NSString *content;//内容
@property(nonatomic,strong) UIFont *contentFont;//内容字号
@property(nonatomic,strong) UIColor *contentColor;//内容颜色
@property(nonatomic,assign) NSTextAlignment contentAlign;//内容展示位置

@property(nonatomic,copy)   NSString *describe;//内容
@property(nonatomic,strong) UIFont *describeFont;//内容字号
@property(nonatomic,strong) UIColor *describeColor;//内容颜色
@property(nonatomic,assign) NSTextAlignment describeAlign;//内容展示位置

@property(nonatomic,copy)   NSString *leftBtnTitle;//左边按钮
@property(nonatomic,strong) UIColor *leftBtnBackGroundColor;//左边按钮底部颜色
@property(nonatomic,strong) UIColor *leftBtnColor;//左边按钮颜色
@property(nonatomic,strong) UIFont *leftBtnFont;//左边按钮字号
@property(nonatomic,copy)   dispatch_block_t leftBtnBlock;//左边按钮操作

@property(nonatomic,copy)   NSString *rightBtnTitle;//右边按钮
@property(nonatomic,strong) UIColor *rightBtnBackGroundColor;//右边按钮底部颜色
@property(nonatomic,strong) UIColor *rightBtnColor;//右边按钮颜色
@property(nonatomic,strong) UIFont *rightBtnfont;//右边按钮字号
@property(nonatomic,copy)   dispatch_block_t rightBtnBlock;//右边按钮操作

@property(nonatomic,strong) UIColor *lineColor;//线条颜色
@property(nonatomic,assign) NSInteger buttonHeight;//底部按钮高度
@property(nonatomic,strong) UIColor *alertBorderColor;//边框颜色
@property(nonatomic,assign) CGFloat alertNcornerRadius;//圆角
@property(nonatomic,strong) UIColor *alertViewbackColor;//弹窗背景色
@property(nonatomic,assign) BOOL hasTitleHLine;//是否显示标题和内容中间横线
@property(nonatomic,assign) CGFloat alertWidth;//弹框宽度

@property(nonatomic,assign) NSInteger textHGap;//内容距左右边距
@property(nonatomic,assign) NSInteger titleVGap;//标题距上边距
@property(nonatomic,assign) NSInteger contentVGap;//内容距标题上边距
@property(nonatomic,assign) NSInteger describeVGap;//描述距标题下边距
@property(nonatomic,assign) NSInteger fieldVGap;//文本输入框距下边距
@property(nonatomic,assign) NSInteger lineHGap;//横线距离左右边距

@property(nonatomic,copy)   NSString *placeholder;//文本输入框占位符
@property(nonatomic,assign) NSInteger fieldHeight;//文本输入框高度
@property(nonatomic,strong) UIColor *fieldBorderColor;//文本输入框边框颜色
@property(nonatomic,assign) CGFloat fieldNcornerRadius;//文本输入框圆角
@property(nonatomic,strong) UIFont *fieldFont;//文本输入框字号
@property(nonatomic,strong) UIColor *fieldPlaceColor;//文本输入框站位文字颜色
@property(nonatomic,strong) UIColor *fieldColor;//文本输入框文字颜色

@end


