//
//  TestTableViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/12/4.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "TestTableViewController.h"
#import "LMJDropdownMenu.h"

@interface TestTableViewController ()

@property (nonatomic, strong) NSMutableArray *menuTitleArray;
@end

@implementation TestTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"表视图简单下拉选";
    [self createNavigationTitleView:@"下拉选"];
    
    LMJDropdownMenu *menuView = [[LMJDropdownMenu alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMidY(self.view.frame) - 20,100,40)] ;
    [menuView setMenuTitles:self.menuTitleArray rowHeight:30];
    [self.view addSubview:menuView];
}

- (NSMutableArray *)menuTitleArray{
    
    if(_menuTitleArray == nil){
        _menuTitleArray = [[NSMutableArray alloc]initWithObjects:@"选项一",@"选项二",@"选项三", nil];
    }
    return _menuTitleArray;
}

@end
