//
//  PictureFoldingDisplayTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "PictureFoldingDisplayTableViewCell.h"
#import "OneLinePictureAdaptationCollectionViewCell.h"
#import "XLPhotoBrowser.h"

NSString * const PictureFoldingDisplayTableViewCellReuseIdentifier = @"PictureFoldingDisplayTableViewCellReuseIdentifier";

@interface PictureFoldingDisplayTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,XLPhotoBrowserDatasource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PictureFoldingDisplayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor redColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //初始化集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    
    //集合视图注册cell
    [self.collectionView registerClass:[OneLinePictureAdaptationCollectionViewCell class] forCellWithReuseIdentifier:OneLinePictureAdaptationCollectionViewCellReuseIdentifier];
    
    [self setupConstraints];
}

///设置约束
- (void)setupConstraints {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(TestTableViewModel *)model{
    _model = model;
    //默认边框
    CGFloat padding = 0;
    //判断是否有边框
    BOOL hasBorder = (self.model.style_border == 1) ? YES : NO;
    if (hasBorder) {
        //设置边框
        padding = 1.0;
    }
    //更新集合视图布局
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    [self.collectionView reloadData];
}

+ (CGFloat)calculateDynamicHeightWithModel:(id)model{
    if([model isMemberOfClass:[TestTableViewModel class]]){
        //获取模型
        TestTableViewModel *tableViewModel = model;
        //获取模型中的TestCollectionViewModel模型数组
        NSArray<TestCollectionViewModel *> *collectionViewModelArray = tableViewModel.collectionViewModelArray;
        //设置一行显示几张图片
        NSInteger showImageNumber = 2;
        //存放显示高度的数组
        NSMutableArray<NSNumber *> *showHeigthArray = [[NSMutableArray alloc]init];
        //集合视图Item的大小
        NSMutableArray<NSValue *> *itemSizes = [[NSMutableArray alloc] initWithCapacity:collectionViewModelArray.count];
        //self显示的高度
        CGFloat maxHeight = 0;
        //默认边框为0
        CGFloat padding = 0;
        //是否设置了边框
        BOOL hasBorder = (tableViewModel.style_border == 1) ? YES : NO;
        if (hasBorder) {
            //如果设置了，边框为1
            padding = 1;
        }
        //屏幕出去边框后剩余总宽度
        CGFloat totalScreenWidth = SCREEN_WIDTH - padding * (showImageNumber - 1);
        //保证数据可以除尽
        while (collectionViewModelArray.count % showImageNumber != 0) {
            TestCollectionViewModel *model = [[TestCollectionViewModel alloc]init];
            NSMutableArray *collectionViewModelMutableArray = collectionViewModelArray.mutableCopy;
            [collectionViewModelMutableArray addObject:model];
            collectionViewModelArray = collectionViewModelMutableArray;
        }
        //遍历TestCollectionViewModel模型数组
        for (int i = 0; i < collectionViewModelArray.count; i++) {
            //取出TestCollectionViewModel模型
            TestCollectionViewModel *collectionViewModel = collectionViewModelArray[i];
            //计算单张图片显示的宽度
            CGFloat displayWidth = floor((totalScreenWidth / showImageNumber) * 1000) / 1000;
            //图片的宽高比
            CGFloat imageRatio = collectionViewModel.image_width / collectionViewModel.image_height;
            //计算单张图片显示的高度
            CGFloat displayHeight = floor(displayWidth / imageRatio);
            //根据一行显示几张图片处理高度，以图片较高的高度为准
            [showHeigthArray addObject:@(displayHeight)];
            //显示高度的数组的长度等于一行显示几张图片的数量
            if(showHeigthArray.count == showImageNumber){
                //对数组进行升序排序
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:nil ascending:YES];
                NSArray *sortArray = [NSArray arrayWithObjects:descriptor,nil];
                NSArray *sortedArray = [showHeigthArray sortedArrayUsingDescriptors:sortArray];
                //执行循环，保证存放的Item的大小的数量与图片数量一致
                for (int i = 0; i < sortedArray.count; i++) {
                    //设置图片的高度，以最大的为准
                    NSNumber *heiget = sortedArray.lastObject;
                    //设置图片的显示高度
                    displayHeight = heiget.floatValue;
                    //初始化单张图片显示的大小
                    CGSize displaySize = CGSizeZero;
                    //设置图片显示的大小
                        displaySize = CGSizeMake(displayWidth, displayHeight);
                    //转换显示大小的值
                    NSValue *displaySizeValue = [NSValue valueWithCGSize:displaySize];
                    //记录集合视图Item的大小
                    [itemSizes addObject:displaySizeValue];
                }
                //设置self显示的高度
                maxHeight += displayHeight;
                [showHeigthArray removeAllObjects];
            }
        }
        //存储collectionView的Item大小
        tableViewModel.extraInfo = itemSizes;
        return maxHeight + padding;;
    }else{
        return 0;
    }
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *dataSource = self.model.collectionViewModelArray;
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCollectionViewModel *collectionViewModel = self.model.collectionViewModelArray[indexPath.row];
    OneLinePictureAdaptationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OneLinePictureAdaptationCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = collectionViewModel.image;
    return cell;
}

#pragma mark -- UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray<NSValue *> *sizes = (NSArray *)self.model.extraInfo;
    return [sizes[indexPath.item] CGSizeValue];
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //存储图片的数组
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    //获取模型中的图片
    [self.model.collectionViewModelArray enumerateObjectsUsingBlock:^(TestCollectionViewModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArray addObject:model.image];
    }];
    //大图展示图片
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:imageArray currentImageIndex:indexPath.row];
    browser.datasource = self;
    browser.pageDotColor = [UIColor grayColor]; // 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor whiteColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
