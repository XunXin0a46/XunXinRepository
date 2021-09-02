//
//  LateralArrangementItemDataPicItemModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/24.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "LateralArrangementItemDataPicItemModel.h"

@implementation LateralArrangementItemDataPicItemModel

- (instancetype)initLeftItemModel{
    self = [super init];
    if(self){
        self.image = [UIImage imageNamed:@"螳螂6"];
        self.image_width = self.image.size.width;
        self.image_height = self.image.size.height;
    }
    return self;
}

- (instancetype)initRightOneItemModel{
    self = [super init];
    if(self){
        self.image = [UIImage imageNamed:@"螳螂5"];
        self.image_width = self.image.size.width;
        self.image_height = self.image.size.height;
    }
    return self;
}

- (instancetype)initRightTwoItemModel{
    self = [super init];
    if(self){
        self.image = [UIImage imageNamed:@"螳螂2"];
        self.image_width = self.image.size.width;
        self.image_height = self.image.size.height;
    }
    return self;
}

@end
