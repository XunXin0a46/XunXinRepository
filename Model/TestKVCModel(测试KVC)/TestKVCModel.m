//
//  TestKVCModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/10.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestKVCModel.h"

@interface PersonalHobbiesModel : NSObject

@property (nonatomic, copy) NSString *playGame;
@property (nonatomic, copy) NSString *read;

@end

@implementation PersonalHobbiesModel


@end

@interface TestKVCModel(){
    @public NSString *_nickName;
    @public NSString *_isNickName;
    @public NSString *nickName;
    @public NSString *isNickName;
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, strong) PersonalHobbiesModel *hobbiesModel;

@end

@implementation TestKVCModel

- (instancetype)initWithPersonalHobbiesModel{
    self = [super init];
    if(self){
        self.hobbiesModel = [[PersonalHobbiesModel alloc]init];
    }
    return self;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key{
    NSLog(@"设置%@发生异常了，但我重写了函数后不会崩溃",key);
}

- (nullable id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"把这个错误的Key-%@抛给你",key);
    return key;
}

+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}

- (void)logMemberVariable{
    NSLog(@"%@",self->_nickName);
    NSLog(@"%@",self->_isNickName);
    NSLog(@"%@",self->nickName);
    NSLog(@"%@",self->isNickName);
}

@end
