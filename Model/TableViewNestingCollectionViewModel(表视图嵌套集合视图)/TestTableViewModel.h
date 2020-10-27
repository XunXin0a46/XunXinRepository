//
//  TestTableViewModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestCollectionViewModel.h"

@interface TestTableViewModel : NSObject
//cell编号
@property (nonatomic, assign) NSInteger cellCode;
//cell名称
@property (nonatomic, copy) NSString *cellName;
//TestCollectionViewModel模型数组
@property (nonatomic, copy) NSMutableArray<TestCollectionViewModel *> *collectionViewModelArray;
//是否有边框
@property (nonatomic, assign) NSInteger style_border;
//记录collectionView的Item大小
@property (nonatomic, strong) id extraInfo;

- (instancetype)initWithCellCode:(NSInteger)cellCode withCellName:(NSString *)cellName withImageArray:(NSMutableArray *)imageArray;

@end

