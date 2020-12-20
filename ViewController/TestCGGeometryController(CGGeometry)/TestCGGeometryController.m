//
//  TestCGGeometryController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/3/25.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCGGeometryController.h"

@interface TestCGGeometryController ()

@end

@implementation TestCGGeometryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"CGGeometry"];
    [self addGridView];
}

///---------------------------------------- CGGeometry代码测试区 -----------------------------------------

///添加网格视图
- (void)addGridView{
    ///背景视图
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 240 / 2, CGRectGetMaxY(self.view.frame) / 2 - 190 / 2, 240, 190)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
    backgroundView.layer.shadowOpacity = 1;
    [self.view addSubview:backgroundView];
    ///设置网格视图
    //每个网格视图宽
    CGFloat gridViewWidth = 40.0;
    //每个网格视图高
    CGFloat gridViewHeight = 30.0;
    //每个网格视图X轴方向间距
    CGFloat paddingX = 10.0;
    //每个网格视图Y轴方向间距
    CGFloat paddingY = 10.0;
    //网格视图的行数
    NSInteger numberOfRow = 5;
    //网格视图的列数
    NSInteger numberOfColumn = 5;
    
    CGRect slice, rowRemainder, columnRemainder;
    
    rowRemainder = backgroundView.bounds;
    for (NSInteger i = 0; i < numberOfRow; i++) {
        //行切割，循环一次切割出两行，一行为视图，一行为间距
        RectCuttingWithPadding(rowRemainder, &slice, &rowRemainder, gridViewHeight, paddingY, CGRectMinYEdge);
        columnRemainder = slice;
        for (NSInteger j = 0; j < numberOfColumn; j++) {
            //列切割，对切割出两行进行多次列切割
           RectCuttingWithPadding(columnRemainder, &slice, &columnRemainder, gridViewWidth, paddingX, CGRectMinXEdge);
            [self addGridView:slice withSuperView:backgroundView];
        }
    }
}

///添加网格视图
- (void)addGridView:(CGRect)rect withSuperView:(UIView *)superView{
    
    UIView *gridView = [[UIView alloc] initWithFrame:rect];
    gridView.backgroundColor = [UIColor colorWithHue:drand48()
                                      saturation:1.0
                                      brightness:1.0
                                           alpha:1.0];
    gridView.layer.borderColor = [[UIColor grayColor] CGColor];
    gridView.layer.borderWidth = 0.5;
    [superView addSubview:gridView];
}

///矩形切割
void RectCuttingWithPadding(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGFloat padding, CGRectEdge edge) {
 
    CGRect tmpSlice;
 
    CGRectDivide(rect, &tmpSlice, &rect, amount, edge);
    if (slice) {
        *slice = tmpSlice;
    }
 
    CGRectDivide(rect, &tmpSlice, &rect, padding, edge);
    if (remainder) {
        *remainder = rect;
    }
}

///--------------------------------------- CGGeometry代码测试区结束 ---------------------------------------

@end
