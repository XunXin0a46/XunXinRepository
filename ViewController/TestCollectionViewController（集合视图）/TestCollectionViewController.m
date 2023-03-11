//
//  TestCollectionViewController.m


#import "TestCollectionViewController.h"

/**
 模型
 */
@interface CategoryItemObject : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *categoryArray;

@end

@implementation CategoryItemObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"分类名称";
        self.categoryArray = @[@"《清明上河图》描绘的是清明时节北宋都城汴京（今河南开封）东角子门内外和汴河两岸的繁华热闹景象，再现了12世纪北宋全盛时期都城汴京的生活面貌。",
            @"《千里江山图》卷是北宋画家王希孟传世的唯一作品。此图描绘了祖园的锦绣河山，一向被视为宋代青绿山水中的巨制杰构。",
            @"《步辇图》画幅描绘的是唐太宗李世民在宫内接见松赞干布派来的吐蕃使臣禄东赞的情景，全画线条纯熟，设色浓重、鲜艳，是一幅出色的工笔重彩人物画作品。",
            @"《平复帖》的书写年代距今己有1700余年，是现存年代最早并真实可信的西晋名家法帖，在中国书法史上占有重要地位。",
            @"长信宫灯，西汉的一件铜鎏金青铜器，大约制成于公元前151年。这盏灯于1968年在中山蜻王刘胜之妻窦绾墓出土，灯身上刻有“长信”的铭文，被誉为“中华第一灯“。",
            @"越王勾践剑，1965年12月出土于湖北江陵望山一号楚墓，出土时插在漆木剑鞘里，出鞘时仍然寒光闪闪，耀人眼目，被誉为“天下第一剑”。",
            @"错金博山炉，这是西汉村作为香薰、薰炉用的青铜器，因为造型象征的是传说中的海上仙山一博山：所以叫做博山炉。整体精致华美，被称为“史上最豪华的香薰”。",
            @"曾侯乙编钟，1978年出土于湖北随州曾候乙墓，架长7.48米、高2.65米，全套编钟共六十五件，能演奏五声、六声或七声音阶的乐曲。",
            @"曾侯乙尊盘，1978年出土于湖北随州市曾侯乙墓，由尊和盘两件器物组成，商周青铜器的巅峰之作。",
            ];
    }
    return self;
}

@end

/**
 布局
 */
@interface UICollectionViewWaterFallLayout : UICollectionViewFlowLayout

@end

@interface UICollectionViewWaterFallLayout()

//一行单元格计数
@property (nonatomic, assign) NSInteger oneRowCountCell;
//存放节中第一行Y轴最小的单元格布局对象字典
@property (nonatomic, strong) NSMutableDictionary<NSString *,UICollectionViewLayoutAttributes *> *oneRowminYCellAttributesDic;
//存放已经更改布局的布局对象字典
@property (nonatomic, strong) NSMutableDictionary<NSString *,UICollectionViewLayoutAttributes *> *layoutedAttributesDic;

@end


@implementation UICollectionViewWaterFallLayout

/// 准备布局
- (void)prepareLayout {
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //集合视图可以显示内容的宽度
        CGFloat collectionContentWidth = self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right;
        //单元格加单元格间距的宽度
        CGFloat cellAndItemSpacingwidth = 0;
        //构造用于检索的框架矩形
        CGSize size = super.collectionViewContentSize;
        CGRect rect = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, size.width, size.height);
        //检索构造的框架矩形中所有可视元素的布局属性
        NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
        //遍历构造的框架矩形中所有可视元素的布局属性
        for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
            //如果可视元素为单元格
            if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                //累加一个单元格的宽度
                cellAndItemSpacingwidth += attributes.size.width;
                //如果单元格加单元格间距的宽度小于等于集合视图显示内容的宽度
                if (cellAndItemSpacingwidth <= collectionContentWidth) {
                    //一行单元格计数增加1
                    self.oneRowCountCell ++;
                    //累加一个单元格间距
                    cellAndItemSpacingwidth += self.minimumInteritemSpacing;
                } else {
                    break;
                }
            }
        }
        //强制一行单元格计数最小为1
        if (self.oneRowCountCell <= 0) {
            self.oneRowCountCell = 1;
        }
    }
}

/// 返回指定矩形中所有单元格和视图的布局属性
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //返回指定矩形中所有单元格和视图的布局属性
        NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
        NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
        //遍历构造的框架矩形中所有可视元素的布局属性
        for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
            //如果可视元素为单元格
            if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                //如果单元格的项索引小于一行单元格计数(说明是第一行单元格)
                if (attributes.indexPath.item < self.oneRowCountCell) {
                    //获取节中Y轴最小的单元格布局对象
                    UICollectionViewLayoutAttributes *minYCellAttributes = [self.oneRowminYCellAttributesDic objectForKey:[NSString stringWithFormat:@"%ld",(long)attributes.indexPath.section]];
                    //如果获取的单元格布局对象为nil
                    if (minYCellAttributes == nil) {
                        //将这个单元格布局对象作为节中Y轴最小的单元格存入字典
                        [self.oneRowminYCellAttributesDic setValue:attributes forKey:[NSString stringWithFormat:@"%ld",(long)attributes.indexPath.section]];
                    } else {
                        //如果在字典中获取了单元格布局对象，将当前这个单元格布局对象与字典中获取的进行最小Y轴比较
                        //利用字典Key相同的值会进行覆盖，保证存储的是第一行单元格中Y轴以最小的单元格布局对象
                        if (CGRectGetMinY(attributes.frame) < CGRectGetMinY(minYCellAttributes.frame)) {
                            [self.oneRowminYCellAttributesDic setValue:attributes forKey:[NSString stringWithFormat:@"%ld",(long)attributes.indexPath.section]];
                        }
                    }
                }
            }
        }
        //再次遍历构造的框架矩形中所有可视元素的布局属性
        for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
            //如果可视元素为单元格
            if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                //获取单元格布局属性对象在数组中的索引
                NSUInteger index = [updatedAttributes indexOfObject:attributes];
                //返回位于指定索引路径的单元格的布局信息
                UICollectionViewLayoutAttributes *cellLayoutAttributes = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
                //如果单元格布局对象的项索引小于一行单元格计数(说明是第一行单元格)
                if (cellLayoutAttributes.indexPath.item < self.oneRowCountCell) {
                    //获取一节中第一行Y轴最小的单元格布局对象
                    UICollectionViewLayoutAttributes *minYCellAttributes = [self.oneRowminYCellAttributesDic objectForKey:[NSString stringWithFormat:@"%ld",(long)cellLayoutAttributes.indexPath.section]];
                    //将位于节中第一行的单元格布局对象的Y轴都设置为最小的那个
                    cellLayoutAttributes.frame = CGRectMake(cellLayoutAttributes.frame.origin.x, minYCellAttributes.frame.origin.y, cellLayoutAttributes.frame.size.width, cellLayoutAttributes.frame.size.height);
                    //将更改过布局属性之的布局属性对象存放到已经更改布局的布局对象字典中，以section-item为Key
                    [self.layoutedAttributesDic setValue:cellLayoutAttributes forKey:[NSString stringWithFormat:@"%ld-%ld",(long)cellLayoutAttributes.indexPath.section,(long)cellLayoutAttributes.indexPath.item]];
                } else {
                    //单元格布局对象的项索引大于或等于一行单元格计数(说明不是第一行单元格)
                    //使用当前遍历出的单元格布局属性对象的项索引减去一行单元格计数，获取当前遍历出的单元格布局属性在垂直布局中对应的它上面显示的那个单元格布局属性索引
                    //例如项索引为3，一行单元格计数为3，结果为0；项索引为4，一行单元格计数为3，结果为1；项索引为5，一行单元格计数为3，结果为2；这就可以计算出当前遍历出的单元格布局属性在垂直布局中对应的它上面的那个单元格布局属性索引
                    NSInteger item = cellLayoutAttributes.indexPath.item - self.oneRowCountCell;
                    //在已经更改布局的布局对象字典获取当前遍历出的单元格布局属性在垂直布局中对应的它上面显示的那个单元格布局属性
                    UICollectionViewLayoutAttributes *layoutedAttributes = [self.layoutedAttributesDic objectForKey:[NSString stringWithFormat:@"%ld-%ld",(long)cellLayoutAttributes.indexPath.section,(long)item]];
                    //设置当前遍历出的单元格布局属性的Y轴值为它上面显示的那个单元格布局属性最大的Y轴值加上列间距
                    cellLayoutAttributes.frame = CGRectMake(cellLayoutAttributes.frame.origin.x, CGRectGetMaxY(layoutedAttributes.frame) + self.minimumLineSpacing, cellLayoutAttributes.frame.size.width, cellLayoutAttributes.frame.size.height);
                    //将当前遍历出的单元格布局属性也存入存放已经更改布局的布局对象字典中
                    [self.layoutedAttributesDic setValue:cellLayoutAttributes forKey:[NSString stringWithFormat:@"%ld-%ld",(long)cellLayoutAttributes.indexPath.section,(long)cellLayoutAttributes.indexPath.item]];
                }
                //设置修改后的当前遍历出的单元格布局属性
                updatedAttributes[index] = cellLayoutAttributes;
            }
        }
        return updatedAttributes;
    } else {
        return [super layoutAttributesForElementsInRect:rect];
    }
}

/// 懒加载存放节中第一行Y轴最小的单元格布局对象字典
- (NSMutableDictionary<NSString *,UICollectionViewLayoutAttributes *> *)oneRowminYCellAttributesDic {
    if (_oneRowminYCellAttributesDic == nil) {
        _oneRowminYCellAttributesDic = [[NSMutableDictionary alloc]init];
    }
    return _oneRowminYCellAttributesDic;
}

/// 懒加载存放已经更改布局的布局对象字典
- (NSMutableDictionary<NSString *,UICollectionViewLayoutAttributes *> *)layoutedAttributesDic {
    if (_layoutedAttributesDic == nil) {
        _layoutedAttributesDic = [[NSMutableDictionary alloc]init];
    }
    return _layoutedAttributesDic;
}

@end

/**
 页眉补充视图
 */
UIKIT_EXTERN NSString *const HeaderViewReuseIdentifier;
@interface HeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;

@end

NSString *const HeaderViewReuseIdentifier = @"HeaderViewReuseIdentifier";
@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end

/**
 单元格
 */
UIKIT_EXTERN NSString *const CategoryCellReuseIdentifier;
@interface CategoryCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *categoryNameLabel;

@end

NSString *const CategoryCellReuseIdentifier = @"CategoryCellReuseIdentifier";
@implementation CategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8.0;
        self.layer.borderWidth = 1.0;
        self.categoryNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.categoryNameLabel.font = [UIFont systemFontOfSize:15];
        self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.categoryNameLabel];
        self.categoryNameLabel.numberOfLines = 0;
        self.categoryNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.categoryNameLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:5],
            [self.categoryNameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
            [self.categoryNameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
            [self.categoryNameLabel.bottomAnchor  constraintEqualToAnchor:self.bottomAnchor constant:-5],
        ]];
    }
    return self;
}

@end

/**
 控制器
 */
@interface TestCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<CategoryItemObject *> *dataSource;

@end

@implementation TestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self createNavigationTitleView:@"集合视图"];
    [self createCollectionView];
}

#pragma mark - UICollectionView

- (void)createCollectionView {
    //流布局
    UICollectionViewWaterFallLayout *flowLayout = [[UICollectionViewWaterFallLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.headerReferenceSize = CGSizeMake(45, 45);
    //集合视图
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.collectionView registerClass:CategoryCell.class forCellWithReuseIdentifier:CategoryCellReuseIdentifier];
    [self.collectionView registerClass:HeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewReuseIdentifier];
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

/// 数据源
- (NSMutableArray<CategoryItemObject *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
        for (int i = 0; i < 3; i++) {
            CategoryItemObject *categoryItem = [[CategoryItemObject alloc]init];
            [_dataSource addObject:categoryItem];
        }
    }
    return _dataSource;
}

#pragma mark - UICollectionViewDataSource
//有几节单元格
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

//每节有多少个单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CategoryItemObject *categoryItem = self.dataSource[section];
    return categoryItem.categoryArray.count;
}

//配置单元格
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *categoryName = self.dataSource[indexPath.section].categoryArray[indexPath.row];
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCellReuseIdentifier forIndexPath:indexPath];
    cell.categoryNameLabel.text = categoryName;
    //设置选中与未选中时单元格的样式
    if (cell.isSelected) {
        cell.backgroundColor = [UIColor colorWithRed:226 / 255.0f green:240 / 255.0f blue:253 / 255.0f alpha:1.0];
        cell.layer.borderColor = [UIColor blueColor].CGColor;
        cell.categoryNameLabel.textColor = [UIColor blueColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.categoryNameLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

//配置页眉补充视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CategoryItemObject *categoryItem = self.dataSource[indexPath.section];
        HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewReuseIdentifier forIndexPath:indexPath];
        headerView.titleLabel.text = categoryItem.title;
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
//单元格已被选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    cell.backgroundColor = [UIColor colorWithRed:226 / 255.0f green:240 / 255.0f blue:253 / 255.0f alpha:1.0];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.categoryNameLabel.textColor = [UIColor blueColor];
}

//单元格已被取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.categoryNameLabel.textColor = [UIColor blackColor];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //计算cell宽度
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGFloat cellWidth = (collectionView.bounds.size.width - flowLayout.minimumInteritemSpacing * 2 - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / 3;
    //计算cell高度
    NSString *categoryName = self.dataSource[indexPath.section].categoryArray[indexPath.row];
    CGFloat cellHeight = [categoryName boundingRectWithSize:CGSizeMake(floor(cellWidth) - 10, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    return CGSizeMake(floor(cellWidth), ceil(cellHeight) + 10 );
}


@end
