//
//  LateralArrangementStyleRightView.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/29.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "LateralArrangementStyleRightView.h"

@implementation LateralArrangementStyleRightView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        
        ///图片视图一
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.imageView1];
        self.imageView1.contentMode = UIViewContentModeScaleToFill;
        self.imageView2.layer.masksToBounds = YES;
        self.imageView1.userInteractionEnabled = YES;
        
        ///图片视图二
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.imageView2];
        self.imageView2.contentMode = UIViewContentModeScaleToFill;
        self.imageView2.userInteractionEnabled = YES;
        self.imageView2.layer.masksToBounds = YES;
        
        //更新控制视图的约束
        [self setNeedsUpdateConstraints];
    }
    return self;
}

///更新视图的约束
- (void)updateConstraints {
    //判断有几张图片
    if (self.imageModels.count > 1){
        //两张图片时
        //获取第一张图片显示大小
        CGSize size1 = self.imageModels[0].displaySize;
        //获取第二张图片显示大小
        CGSize size2 = self.imageModels[1].displaySize;
        //设置图片视图一约束
        [self.imageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.height.mas_equalTo(size1.height);
            make.width.mas_equalTo(size1.width);
        }];
        //设置图片视图二约束
        [self.imageView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView1.mas_bottom).offset(1);
            make.width.mas_equalTo(size2.width);
            make.height.mas_equalTo(size2.height);
            make.left.equalTo(self);
        }];
        
    } else if (self.imageModels.count == 1){
        //只有一张图片时
        //设置图片视图一约束
        [self.imageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //设置图片视图二约束
        [self.imageView2 mas_remakeConstraints:^(MASConstraintMaker *make) {//处理约束冲突-2019.8.22
            make.top.equalTo(self.imageView1.mas_bottom).offset(1);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
            make.left.equalTo(self);
        }];
    }
    //更新视图的约束
    [super updateConstraints];
}

///设置边框高度
- (void)setBorderHeight:(CGFloat)borderHeight {
    _borderHeight = borderHeight;
}

///设置图片数据数组
- (void)setImageModels:(NSArray<LateralArrangementItemDataPicItemModel *> *)imageModels{
    //图片数据数组为空，不执行操作
    if (imageModels == nil) {
        return;
    }
    //记录图片数据数组
    _imageModels = [imageModels copy];
    //判断模型类型
    if ([self.imageModels.firstObject isMemberOfClass:[LateralArrangementItemDataPicItemModel class]]) {
        //获取第一张图片模型
        LateralArrangementItemDataPicItemModel *model1 = self.imageModels[0];
        //设置第一张图片
        [self.imageView1 setImage:model1.image];
        //判断是否有第二张图
        if (self.imageModels.count > 1) {
            //获取第二张图片模型
            LateralArrangementItemDataPicItemModel *model2 = self.imageModels[1];
             //设置第二张图片
            [self.imageView2 setImage:model2.image];
        }
        //更新控制视图的约束
        [self setNeedsUpdateConstraints];
    }
}

///移除所有显示图片
- (void)removeAllImages {
    self.imageView1.image = nil;
    self.imageView2.image = nil;
}

@end
