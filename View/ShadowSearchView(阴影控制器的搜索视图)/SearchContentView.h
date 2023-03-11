//
//  SearchContentView.h
//  YiShopCustomer
//
//  Created by 王刚 on 2020/8/18.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchContentView : UIView

@property (nonatomic, strong) UITableView *tableView;//列表视图
@property (nonatomic, copy) void (^searchTextChangeBlock)(NSString *searchText);//搜索文本改变回调

@end


