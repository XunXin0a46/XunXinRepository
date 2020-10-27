//
//  TestTableViewModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestTableViewModel.h"

@implementation TestTableViewModel

- (instancetype)initWithCellCode:(NSInteger)cellCode withCellName:(NSString *)cellName withImageArray:(NSMutableArray *)imageArray{
    self = [super init];
    if(self){
        //设置cell编号
        self.cellCode = cellCode;
        //设置cell名称
        self.cellName = cellName;
        //设置TestCollectionViewModel模型数组
        NSMutableArray *collectionViewModelArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < imageArray.count; i++) {
            TestCollectionViewModel *collectionViewModel = [[TestCollectionViewModel alloc]initWithImage:imageArray[i]];
            [collectionViewModelArray addObject:collectionViewModel];
        }
        self.collectionViewModelArray = collectionViewModelArray;
        //设置边框
        self.style_border = 1;
    }
    return self;
}

@end
