//
//  TestCollectionViewModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestCollectionViewModel : NSObject

@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, assign) CGFloat image_width;//图片宽
@property (nonatomic, assign) CGFloat image_height;//图片高
@property (nonatomic, assign) CGSize displaySize;//显示的大小

- (instancetype)initWithImage:(UIImage *)image;

@end

