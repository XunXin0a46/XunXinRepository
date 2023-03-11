//
//  TestXIBViewConreoller.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/11/9.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestXIBViewConreoller.h"

@interface TestXIBViewConreoller ()

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UISwitch *redSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewHeihgt;

@end

@implementation TestXIBViewConreoller

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)switchValueChanged:(id)sender {
    UISwitch *witch = (UISwitch *)sender;
    //判断开关状态
    BOOL setting = witch.isOn;
    if(setting){
        self.redViewHeihgt.constant += 20;
    }else{
        self.redViewHeihgt.constant -= 20;
    }
}

@end
