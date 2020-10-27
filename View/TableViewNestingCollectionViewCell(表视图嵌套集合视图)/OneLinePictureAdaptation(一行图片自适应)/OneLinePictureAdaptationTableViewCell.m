//
//  OneLinePictureAdaptationTableViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "OneLinePictureAdaptationTableViewCell.h"
#import "TestCollectionViewModel.h"
#import "OneLinePictureAdaptationCollectionViewCell.h"

NSString * const OneLinePictureAdaptationTableViewCellReuseIdentifier = @"NSString * const OneLinePictureAdaptationTableViewCellReuseIdentifier";

@interface OneLinePictureAdaptationTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation OneLinePictureAdaptationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor greenColor];
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
    [self.collectionView reloadData];
}

+ (CGFloat)calculateDynamicHeightWithModel:(id)model{
    if([model isMemberOfClass:[TestTableViewModel class]]){
        //获取模型
        TestTableViewModel *tableViewModel = model;
        //获取模型中的TestCollectionViewModel模型数组
        NSArray<TestCollectionViewModel *> *collectionViewModelArray = tableViewModel.collectionViewModelArray;
        //获取图片宽度之和
        CGFloat totalWidth = [[collectionViewModelArray valueForKeyPath:@"@sum.image_width"] floatValue];
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
        CGFloat totalScreenWidth = SCREEN_WIDTH - padding * (collectionViewModelArray.count - 1);
        //记录最后一张图片之前所有图片累积的宽度
        CGFloat widths = 0;
        //遍历TestCollectionViewModel模型数组
        for (int i = 0; i < collectionViewModelArray.count; i++) {
            //取出TestCollectionViewModel模型
            TestCollectionViewModel *collectionViewModel = collectionViewModelArray[i];
            //计算单张图片宽与在所有图片宽之和中的所占比例
            CGFloat widthRatio = collectionViewModel.image_width / totalWidth;
            //计算单张图片显示的宽度
            CGFloat displayWidth = roundf((totalScreenWidth * widthRatio) * 1000) / 1000;
            //图片的宽高比
            CGFloat imageRatio = collectionViewModel.image_width / collectionViewModel.image_height;
            //计算单张图片显示的高度
            CGFloat displayHeight = floor(displayWidth / imageRatio);
            //初始化单张图片显示的大小
            CGSize displaySize = CGSizeZero;
            //判断是否是最后一张图片
            if (i != collectionViewModelArray.count - 1) {
                //不是最后一张图片时，设置显示的大小
                displaySize = CGSizeMake(displayWidth, displayHeight);
                //记录最后一张图片之前所有图片累积的宽度
                widths += displayWidth;
            }else{
                //是最后一张图片时，设置显示的大小
                displaySize = CGSizeMake(SCREEN_WIDTH - ceilf(widths) - (collectionViewModelArray.count - 1) * padding, displayHeight);
            }
            //转换显示大小的值
            NSValue *displaySizeValue = [NSValue valueWithCGSize:displaySize];
            //记录集合视图Item的大小
            [itemSizes addObject:displaySizeValue];
            //设置self显示的高度
            if (displayHeight > maxHeight) {
                maxHeight = displayHeight;
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


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
