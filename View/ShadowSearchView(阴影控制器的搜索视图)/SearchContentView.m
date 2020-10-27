//
//  SearchContentView.m
//  YiShopCustomer
//
//  Created by 王刚 on 2020/8/18.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "SearchContentView.h"
#import "YSCUITextField.h"
#import "UIView+Action.h"
#import "UIView+ExtraTag.h"

@interface SearchContentView()

@property (nonatomic, strong) UIView *topContentView;//头部背景视图
@property (nonatomic, strong) UILabel *titleLabel;//标题标签
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮
@property (nonatomic, strong) UIView *separatorLineView;//分割线
@property (nonatomic, strong) YSCUITextField *searchTextField;//搜索框

@end

@implementation SearchContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        ///头部背景视图
        self.topContentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.topContentView];
        self.topContentView.backgroundColor = [UIColor whiteColor];
        
        ///标题标签
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.topContentView addSubview:self.titleLabel];
        self.titleLabel.text = @"请添加确诊疾病";
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textColor = HEXCOLOR(0x353535);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        ///分割线
        self.separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.separatorLineView];
        self.separatorLineView.backgroundColor = HEXCOLOR(0xebedf0);
        
        ///关闭按钮
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.topContentView addSubview:self.closeButton];
        [self.closeButton setViewTypeForTag:ViewTypeCloseButton];
        [self addEvent:self.closeButton];
        [self.closeButton setImage:[UIImage imageNamed:@"ic_area_closed"] forState:UIControlStateNormal];
        
        ///搜索框
        self.searchTextField = [[YSCUITextField alloc] initWithFrame:CGRectZero];
        self.searchTextField.placeholder = @"请输入商品名称或订单号";
        self.searchTextField.backgroundColor = HEXCOLOR(0xEEF2F3);
        self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
        self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.searchTextField.layer.cornerRadius = 16.5;
        self.searchTextField.font = [UIFont systemFontOfSize:13];
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        [self addSubview:self.searchTextField];
        [self.searchTextField addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventEditingChanged];
        
        ///放大镜图标
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[TestUtils scaleToSize:[UIImage imageNamed:@"ic_search"] size:CGSizeMake(14, 14)]];
        self.searchTextField.leftView = searchImageView;
        searchImageView.contentMode = UIViewContentModeScaleAspectFit;
        searchImageView.frame = CGRectMake(0, 0, 18, 18);

        ///列表视图
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:self.tableView];
        self.tableView.sectionFooterHeight = 0.01;
        self.tableView.sectionHeaderHeight = 0.01;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    ///头部背景视图
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50.0);
    }];
    
    ///标题标签
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.topContentView);
    }];
    
    ///关闭按钮
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.topContentView);
        make.right.equalTo(self.topContentView).offset(-10 * 1.5);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
    }];
    
    ///分割线
    [self.separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.topContentView);
        make.height.mas_equalTo(0.5);
    }];
    
    ///搜索框
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLineView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(33);
    }];
    
    ///列表视图
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.searchTextField.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    
    [super updateConstraints];
}

///搜索框内容改变时执行
- (void)searchTextChange:(UITextField *)sender{
    self.searchTextChangeBlock(sender.text);
}

@end
