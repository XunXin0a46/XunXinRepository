//
//  CommonImageCellModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/16.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "CommonImageCellModel.h"

@implementation CommonImageCellModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _imageCodes = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

@end
