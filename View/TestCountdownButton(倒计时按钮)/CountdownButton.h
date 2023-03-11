//
//  CountdownButton.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/11/16.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CountdownButton : UIButton

- (void)startCountdownCompletionhander:(void (^)(void))completionHanlder;

@end

