//
//  TestArchiverModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2023/1/30.
//  Copyright © 2023 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestArchiverModel : NSObject<NSCoding, NSSecureCoding>

@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
