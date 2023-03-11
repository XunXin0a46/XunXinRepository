//
//  TestKMGestureRecognizerViewController.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/15.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMGestureRecognizer.h"


@interface TestKMGestureRecognizerViewController : UIViewController

@property (strong, nonatomic) UIImageView *imgV;
@property (strong, nonatomic) UIImageView *imgV2;
@property (strong, nonatomic) KMGestureRecognizer *customGestureRecognizer;

@end

