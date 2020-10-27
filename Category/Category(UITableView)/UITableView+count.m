//
//  UITableView+count.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/1/6.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "UITableView+count.h"
#import <objc/runtime.h>

static NSInteger count;

@implementation UITableView (count)

///定义一个计数函数
- (void)count{
    if(count == 0){
        count = 1;
    }else{
       count ++;
    }
    
    NSLog(@"%ld",(long)count);
}

- (void)my_rereloadDate{
    [self my_rereloadDate];
    [self count];
}

///在load方法中交换两个方法
+ (void)load{
    
    Method reloadDate = class_getInstanceMethod(self, @selector(reloadData));
    
    Method my_rereloadDate = class_getInstanceMethod(self, @selector(my_rereloadDate));
    
    method_exchangeImplementations(reloadDate, my_rereloadDate);
}


@end
