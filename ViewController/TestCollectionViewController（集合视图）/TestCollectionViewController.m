//
//  TestCollectionViewController.m


#import "TestCollectionViewController.h"

@interface GoodsSalesDiscountItem : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GoodsSalesDiscountItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = HEXCOLOR(0x657CDA);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 2.0;
        self.contentView.layer.borderColor = self.titleLabel.textColor.CGColor;
        self.contentView.layer.borderWidth = 1.0;
    }
    
    return self;
}

//写在cell中的自适应代码
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height = size.height;
    layoutAttributes.frame = cellFrame;
    return layoutAttributes;
}

@end

@interface TestCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGSize size;

@end

@implementation TestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"集合视图"];
    [self createUI];
    if(ARRAY_IS_NOT_EMPTY([[self getIntent]objectForKey:TestCollectionViewControllerDataSource])){
        [self setArray:[[NSMutableArray alloc]initWithArray:[[self getIntent]objectForKey:TestCollectionViewControllerDataSource]]];
    } 
}

- (void)createUI {
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backgroundView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 200));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    //预估计cellf大小
    layout.estimatedItemSize = CGSizeMake(150, 50);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.backgroundView.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor greenColor];
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[GoodsSalesDiscountItem class] forCellWithReuseIdentifier:@"item"];
    [self.backgroundView addSubview:self.collectionView];
    //给collectionView约束，让其显示
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView);
        make.left.equalTo(self.backgroundView);
        make.right.equalTo(self.backgroundView);
        make.height.mas_equalTo(ceil(self.size.height)).priorityHigh();
    }];
}

///通过Label计算文本的高度
- (CGSize)adoptLabelCalculationTextHeight:(NSString *)text andFont:(UIFont *)font andTextWidth:(CGFloat)textWidth{
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.text = text;
    label.font = font;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(textWidth, MAXFLOAT)];
    return labelSize;
}

- (void)setArray:(NSMutableArray *)array{
    _array = array;
    [self.collectionView reloadData];
    //触发视图布局，执行createUI，createUI执行完毕后会访问collectionView的代理方法每一cell都会执行一次cell中的preferredLayoutAttributesFittingAttributes，最后拿到collectionView内容的大小
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    self.size =  self.collectionView.collectionViewLayout.collectionViewContentSize;
    //重新设置约束
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView);
        make.left.equalTo(self.backgroundView);
        make.right.equalTo(self.backgroundView);
        make.height.mas_equalTo(ceil(self.size.height)).priorityHigh();
    }];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsSalesDiscountItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    NSString *one = self.array[0];
    
    if ([one isEqualToString:@"满减"]&&indexPath.row == 1) {
        
        item.titleLabel.text =  self.array[indexPath.row];
        item.titleLabel.textColor = [UIColor redColor];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        item.titleLabel.textAlignment = NSTextAlignmentLeft;
        item.contentView.layer.borderWidth = 0;
        
    }else{
        item.titleLabel.text = self.array[indexPath.row];
    }
    
    return item;
}

#pragma mark -- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    if(indexPath.item == 0){
        NSLog(@"出现了");
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item == 0){
        NSLog(@"消失了");
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *titleString = self.array[indexPath.row];
    NSString *one = self.array[0];
    
    if(indexPath.row == 0 && titleString.length > 0){
        CGRect rect = [titleString boundingRectWithSize:CGSizeMake (WIDTH (collectionView) - 20, 60)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                context:nil];
        CGSize size = rect.size;
        size.width += 10;
        size.height += 2;
        return size;
    } else if ([one isEqualToString:@"满减"]&&indexPath.row == 1) {
        
        CGSize size = [self adoptLabelCalculationTextHeight:titleString andFont:[UIFont systemFontOfSize:15] andTextWidth:WIDTH (collectionView) - 50];
        if (size.width < WIDTH (collectionView) - 50) {
            size.width = WIDTH (collectionView) - 50;
        }
        
        size.height += 6;
        return size;
    }else{
        CGRect rect = [titleString boundingRectWithSize:CGSizeMake (WIDTH (collectionView) - 20, 60)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                context:nil];
        CGSize size = rect.size;
        size.width += 10;
        size.height += 2;
        return size;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

@end
