//
//  TableViewNestingCollectionViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TableViewNestingCollectionViewController.h"
#import "TestTableViewModel.h"
#import "OneLinePictureAdaptationTableViewCell.h"
#import "PictureFoldingDisplayTableViewCell.h"
#import "UploadImageTableViewCell.h"
#import "PickerPhotoManager.h"
#import "UIImage+ImageBase64.h"
#import "UIView+ExtraTag.h"

@interface TableViewNestingCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,UploadImageDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;

@end

@implementation TableViewNestingCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"表嵌集"];
    [self createImage];
    [self createModel];
    [self createUI];
}

///初始化图片
- (void)createImage{
    for (int i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"螳螂%d",i+1]];
        [self.imageArray addObject:image];
    }
}

///初始化模型
- (void)createModel{
    TestTableViewModel *tableViewModel = [[TestTableViewModel alloc]initWithCellCode:1 withCellName:@"一行图片自适应" withImageArray:self.imageArray];
    [self.tableViewDataSource addObject:tableViewModel];
    
    TestTableViewModel *tableViewModelII = [[TestTableViewModel alloc]initWithCellCode:2 withCellName:@"图片折行显示" withImageArray:self.imageArray];
    [self.tableViewDataSource addObject:tableViewModelII];
    
    TestTableViewModel *tableViewModelIII = [[TestTableViewModel alloc]initWithCellCode:3 withCellName:@"上传图片" withImageArray:nil];
    [self.tableViewDataSource addObject:tableViewModelIII];
}

///初始化视图
- (void)createUI{
    //初始化表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = HEXCOLOR(0xEEF2F3);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //表视图注册Cell
    //一行图片自适应
    [self.tableView registerClass:[OneLinePictureAdaptationTableViewCell class] forCellReuseIdentifier:OneLinePictureAdaptationTableViewCellReuseIdentifier];
    //图片折行显示
    [self.tableView registerClass:[PictureFoldingDisplayTableViewCell class] forCellReuseIdentifier:PictureFoldingDisplayTableViewCellReuseIdentifier];
    //上传图片
    [self.tableView registerClass:[UploadImageTableViewCell class] forCellReuseIdentifier:UploadImageTableViewCellReuseIdentifier];
}

///懒加载图片
- (NSMutableArray *)imageArray{
    if(_imageArray == nil){
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

///懒加载数据源
- (NSMutableArray *)tableViewDataSource{
    if(_tableViewDataSource == nil){
        _tableViewDataSource = [[NSMutableArray alloc]init];
    }
    return _tableViewDataSource;
}

#pragma mark - UploadImageDelegate
///上传图片
- (void)openImagePickerViewController{
    //使视图放弃第一响应程序状态。
    [self.view endEditing:YES];

    [PickerPhotoManager openImagePickerViewController:^(NSArray <UIImage *> *imgs,MediaSelectType type) {
        if (imgs.count > 0) {
            //存储要上传的图片编码
            for (int i = 0; i < imgs.count; i ++) {
                [[TestSharedInstance sharedInstance].uploadImageArray addObject:[imgs[i] ysc_base64Encoding]];
            }
            //刷新表视图
            [self.tableView reloadData];
        }
    }];
}

///删除图片
- (void)deleteImageAction:(UIView *)sender{
    NSInteger position = [sender getPositionOfTag];
    [[TestSharedInstance sharedInstance].uploadImageArray removeObjectAtIndex:position];
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestTableViewModel *tableViewModel = self.tableViewDataSource[indexPath.row];
    if([tableViewModel.cellName isEqualToString:@"一行图片自适应"]){
        OneLinePictureAdaptationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OneLinePictureAdaptationTableViewCellReuseIdentifier];
        cell.model = tableViewModel;
        return cell;
    }else if([tableViewModel.cellName isEqualToString:@"图片折行显示"]){
        PictureFoldingDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PictureFoldingDisplayTableViewCellReuseIdentifier];
        cell.model = tableViewModel;
        return cell;
    }else if([tableViewModel.cellName isEqualToString:@"上传图片"]){
        UploadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UploadImageTableViewCellReuseIdentifier];
        cell.delegate = self;
        [cell createDataArray];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestTableViewModel *tableViewModel = self.tableViewDataSource[indexPath.row];
    CGFloat cellHeigth = 0;
    if([tableViewModel.cellName isEqualToString:@"一行图片自适应"]){
        cellHeigth = [OneLinePictureAdaptationTableViewCell calculateDynamicHeightWithModel:tableViewModel];
    }else if([tableViewModel.cellName isEqualToString:@"图片折行显示"]){
        cellHeigth = [PictureFoldingDisplayTableViewCell calculateDynamicHeightWithModel:tableViewModel];
    }else{
        cellHeigth = UITableViewAutomaticDimension;
    }
    return cellHeigth;;
}
@end
