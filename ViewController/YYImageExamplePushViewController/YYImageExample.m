//
//  YYImageExample.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/9/21.
//  Copyright © 2019 王刚. All rights reserved.
//  图像示例

#import "YYImageExample.h"
#import "YYImage.h"
#import "UIView+YYAdd.h"
#import <ImageIO/ImageIO.h>
#import <WebP/demux.h>

@interface YYImageExample ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation YYImageExample

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"YYWebImage"];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"Animated Image" class:@"YYImageDisplayExample"];
    [self addCell:@"Progressive Image" class:@"YYImageProgressiveExample"];
    [self addCell:@"Web Image" class:@"YYWebImageExample"];
    [self.tableView reloadData];
    
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        NSLog(@"%@",className);
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
