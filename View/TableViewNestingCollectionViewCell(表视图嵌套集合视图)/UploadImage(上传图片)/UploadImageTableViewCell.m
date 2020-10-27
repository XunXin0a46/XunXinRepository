//
//  UploadImageTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/11.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "UploadImageTableViewCell.h"
#import "CommonAddImageCollectionViewCell.h"
#import "CommonAddedImageCollectionViewCell.h"
#import "UIView+Action.h"

NSString * const UploadImageTableViewCellReuseIdentifier = @"UploadImageTableViewCellReuseIdentifier";

//集合视图Item大小
#define COMMENT_IMAGE_SIZE CGSizeMake(ceil((SCREEN_WIDTH - 10 * 5) / 4.0), ceil((SCREEN_WIDTH - 10 * 5) / 4.0))

@interface UploadImageTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;//上传图片的集合视图
@property (nonatomic, strong) NSMutableArray *dataArray;//集合视图数据源

@end

@implementation UploadImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    ///上传图片的集合视图布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = COMMENT_IMAGE_SIZE;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    ///上传图片的集合视图
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(COMMENT_IMAGE_SIZE.height * 3 + 10 * 4);
        make.height.mas_equalTo(self.size.height);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    //集合视图注册Cell
    //添加图片Cell
    [self.collectionView registerClass:[CommonAddImageCollectionViewCell class] forCellWithReuseIdentifier:CommonAddImageCollectionViewCellReuseIdentifier];
    //已经添加图片的Cell
    [self.collectionView registerClass:[CommonAddedImageCollectionViewCell class] forCellWithReuseIdentifier:CommonAddedImageCollectionViewCellReuseIdentifier];
    
}

///懒加载集合视图数据源
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

///初始化数据源
- (void)createDataArray{
    //清空集合视图数据源
    [self.dataArray removeAllObjects];
    //判断是否有需要展示的上传图片
    if(ARRAY_IS_NOT_EMPTY([TestSharedInstance sharedInstance].uploadImageArray)){
        //声明存放图片编码的数组
        NSMutableArray *mutableImageArray = [[NSMutableArray alloc]init];
        //遍历存放图片编码的数组，取出图片编码
        for (int i = 0; i < [TestSharedInstance sharedInstance].uploadImageArray.count; i++) {
            if([TestSharedInstance sharedInstance].uploadImageArray[i]){
                //添加图片编码到数组
                [mutableImageArray addObject:[TestSharedInstance sharedInstance].uploadImageArray[i]];
            }
        }
        //判断图片张数，决定是否加入添加图片的图标
        if(mutableImageArray.count < 5){
            //添加上传图片标识
            [mutableImageArray addObject:@"RefundAddImageCellIdentfier"];
            //添加图片编码数据
            [self.dataArray addObjectsFromArray:mutableImageArray];
        }else{
            //添加图片编码数据
            [self.dataArray addObjectsFromArray:mutableImageArray];
        }
    }else{
        //没有需要展示的上传图片，添加上传图片标识
        [self.dataArray addObject:@"RefundAddImageCellIdentfier"];
    }
    //刷新集合视图
    [self.collectionView reloadData];
    //触发布局，获取集合视图内容大小
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.size = self.collectionView.collectionViewLayout.collectionViewContentSize;
    //重置集合视图高度
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(COMMENT_IMAGE_SIZE.height * 3 + 10 * 4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priorityLow();
        make.height.mas_equalTo(self.size.height).priorityHigh();
        
    }];
}

///添加图片
- (void)itemAddImageAction:(UIView *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openImagePickerViewController)]) {
        [self.delegate openImagePickerViewController];
    }
}

///删除图片
- (void)itemDeleteImageAction:(UIView *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteImageAction:)]){
        [self.delegate deleteImageAction:sender];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = nil;
    NSString *string = self.dataArray[indexPath.row];
    
    if ([string isEqualToString:@"RefundAddImageCellIdentfier"]) {
        //创建上传图片的cell
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CommonAddImageCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        CommonAddImageCollectionViewCell *addCell = (CommonAddImageCollectionViewCell *)cell;
        // 统一model做数据转化，方便以后功能扩展或修改
        CommonImageCellModel * tempModel = [[CommonImageCellModel alloc] init];
        //遍历存储图片数据的数组
        for (NSString *imageString in [TestSharedInstance sharedInstance].uploadImageArray) {
            if([imageString isEqualToString:@"RefundAddImageCellIdentfier"]){
                continue;
            }
            //存储图片编码到模型
            [tempModel.imageCodes addObject:imageString];
        }
        //上传图片最大数量
        tempModel.maxNum = 5;
        //设置模型
        addCell.model = tempModel;
        //添加上传图片的点击事件
        [addCell addTarget:self action:@selector(itemAddImageAction:) position:indexPath.row section:indexPath.section];
    } else {
        //创建已经添加图片的Cell
        cell = [self createImageCollectionViewCellWihtIndexPath:indexPath];
    }
    return cell;
}

///创建已经添加图片的Cell
- (UICollectionViewCell *)createImageCollectionViewCellWihtIndexPath:(NSIndexPath *)indexPath {
    CommonAddedImageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CommonAddedImageCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    //是否启用删除按钮
    cell.editEnable = YES;
    //设置图片
    [cell setImageCode:self.dataArray[indexPath.row]];
    //添加删除事件
    [cell addTarget:self action:@selector(itemDeleteImageAction:) position:indexPath.row section:indexPath.section];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
