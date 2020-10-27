//
//  TestCollectionViewModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCollectionViewModel.h"

@implementation TestCollectionViewModel

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if(self){
        self.image = image;
        self.image_width = image.size.width;
        self.image_height = image.size.height;
    }
    return self;
}

@end
