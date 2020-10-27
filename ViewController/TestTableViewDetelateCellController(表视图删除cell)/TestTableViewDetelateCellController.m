//
//  TestTableViewDetelateCellController.m


#import "TestTableViewDetelateCellController.h"
#import "MessageListItemCell.h"
#import "MessageListItemEditCell.h"
#import "MessageItemModel.h"
#import "UIScrollView+EmptyDataSet.h"

///管理视图
@interface MessageManagementView : UIView

@property (nonatomic, strong) UIButton *checkButton;//全部选中按钮
@property (nonatomic, strong) UIButton *deleteButton;//删除按钮
@property (nonatomic, strong) NSString *selectedCount;//选中的消息条数
@property (nonatomic, strong) CALayer *separatorLineLayer;//顶部分割线

@end

@implementation MessageManagementView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        ///顶部分割线
        _separatorLineLayer = [[CALayer alloc] init];
        [self.layer addSublayer:_separatorLineLayer];
        _separatorLineLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        ///全部选中按钮
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_checkButton];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _checkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, -5.0);
        [_checkButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"bg_check_normal"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"bg_check_selected"]forState:UIControlStateSelected];
        
        ///删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_deleteButton];
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    ///全部选中按钮
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self.deleteButton);
    }];
    
    ///删除按钮
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50 * 2.0);
    }];
}

///布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    _separatorLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5);
}

///设置选择了多少条消息
- (void)setSelectedCount:(NSString *)selectedCount {
    _selectedCount = [selectedCount copy];
    if (_selectedCount == nil) {
        _selectedCount = @"0";
    }

    NSString *selectedCountFormat = nil;
    selectedCountFormat = [NSString stringWithFormat:@"已选 %@ 条消息", _selectedCount];
    NSMutableAttributedString *selectedAttrCountFormat = [[NSMutableAttributedString alloc] initWithString:selectedCountFormat];
    //设置按钮标题为黑色
    [selectedAttrCountFormat setAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} range:NSMakeRange(0, selectedCountFormat.length)];
    //设置消息条数为k红色
    [selectedAttrCountFormat setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(3, _selectedCount.length)];
    //设置按钮标题
    [_checkButton setAttributedTitle:selectedAttrCountFormat forState:UIControlStateNormal];
}


@end



@interface TestTableViewDetelateCellController()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic) BOOL editMode;//编辑模式
@property (nonatomic, strong) MessageManagementView *managementView;//消息管理视图
@property (nonatomic, strong) UITableView *tableView;//表视图

@end

@implementation TestTableViewDetelateCellController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self createNavigationTitleView:@"表视图"];
    [self initDataSource];
    [self setupNavigationBarButtonItem];
    [self setupTableView];
    [self setMessageManagementView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}

///初始化导航栏右侧管理按钮
- (void)setupNavigationBarButtonItem {
    
    NSDictionary *textAttribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName: [UIColor grayColor]};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(editCollections:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateHighlighted];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateDisabled];
}

///管理按钮点击事件
- (void)editCollections:(UIBarButtonItem *)sender {
    
    if ([sender.title isEqualToString:@"管理"]) {
        sender.title = @"完成";
        self.editMode = YES;
    } else {
        sender.title = @"管理";
        self.editMode = NO;
    }
    NSInteger count = 0;
    for (MessageItemModel *model in self.dataSource) {
        //如果模型中有一条消息处于未选中的状态
        if (model.selected == YES) {
            //累加选中消息的条数
            count++;
        }
    }
    //设置消息管理视图选中的消息条数
    self.managementView.selectedCount = [NSString stringWithFormat:@"%zd", (size_t)count];
}

///初始化表视图
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70.0;
    [self.tableView registerClass:[MessageListItemCell class] forCellReuseIdentifier:MessageListItemCellReuseIdentifier];
    [self.tableView registerClass:[MessageListItemEditCell class] forCellReuseIdentifier:MessageListItemEditCellReuseIdentifier];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


///设置消息管理视图
- (void)setMessageManagementView {
    
    self.managementView = [[MessageManagementView alloc] initWithFrame:CGRectZero];
    self.managementView.selectedCount = 0;
    self.managementView.hidden = YES;
    [self.view addSubview:self.managementView];
     [self.managementView.checkButton addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.managementView.deleteButton addTarget:self action:@selector(deleteMessage) forControlEvents:UIControlEventTouchUpInside];
}

///消息管理视图选中按钮的点击事件
- (void)selectAll:(UIButton *)sender {
    //对选中状态取反
    sender.selected = !sender.selected;
    if (sender.selected) {
        //是选中状态，设置选中的消息条数作为消息管理视图的选中按钮的标题
        self.managementView.selectedCount = [NSString stringWithFormat:@"%zd", (size_t)self.dataSource.count];
    } else {
        //不是选中状态，设置选中的消息条数为0作为消息管理视图的选中按钮的标题
        self.managementView.selectedCount = @"0";
    }
    
    //修改数据源中模型所有的是否选中的状态
    for (MessageItemModel *model in self.dataSource) {
        model.selected = sender.selected;
    }
    //刷新表视图
    [self.tableView reloadData];
}

///消息管理视图删除按钮的点击事件
- (void)deleteMessage{
    //倒序遍历数据源，防止由于删除元素时索引的变化，会造成删除错误
    [self.dataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MessageItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果模型中的是否选中的状态是选中的，点击删除按钮时将其移出数据源
        if(model.selected){
            [self.dataSource removeObject:model];
        }
    }];
    //设置选中的消息条数为0作为消息管理视图的选中按钮的标题
    self.managementView.selectedCount = @"0";
    //刷新表视图
    [self.tableView reloadData];
    
}

///编辑模式改变时执行的方法（管理按钮管理与完成切换时）
- (void)setEditMode:(BOOL)editMode {
    _editMode = editMode;
    
    if (self.dataSource.count == 0) {
        return;
    }
    if (_editMode) {
        //点击管理按钮时
        self.managementView.hidden = NO;
        [self.managementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(50 + [self bottomPadding]);
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.managementView.mas_top);
        }];
        
    } else {
        //点击完成按钮时
        self.managementView.hidden = YES;
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    //设置消息管理视图选择按钮位未选中状态
    self.managementView.checkButton.selected = NO;
    //刷新表视图
    [self.tableView reloadData];
}

///初始化数据源
- (void)initDataSource{
    self.dataSource = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        MessageItemModel *model = [[MessageItemModel alloc]initWithModel];
        [self.dataSource addObject: model];
    }
}

///返回底部安全区高度
- (CGFloat)bottomPadding{
    
    if (DEVICE_IS_IPHONE_X) {
        return 34.0;
    } else {
        return 0;
    }
}

///消息管理视图的选择按钮是否要处于相中状态
- (BOOL)checkSelectAll {
    //默认全部是选中的
    BOOL selectAll = YES;
    //继续选中的消息数量
    NSInteger count = 0;
    for (MessageItemModel *model in self.dataSource) {
        //如果模型中有一条消息处于未选中的状态
        if (model.selected == NO) {
            //修改全部选中的状态
            selectAll = NO;
        } else {
            //累加选中消息的条数
            count++;
        }
    }
    //设置消息管理视图选中的消息条数
    self.managementView.selectedCount = [NSString stringWithFormat:@"%zd", (size_t)count];
    //返回消息管理视图的选中按钮是否要选中
    return selectAll;
}


#pragma mark - UITableViewDataSource

///询问数据源每组有多少行数据。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

///为给定的索引路径创建并配置适当的单元格
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (!self.editMode) {
        //未开始管理与管理完成状态的cell
        MessageListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListItemCellReuseIdentifier];
        [cell setMdoel:self.dataSource[indexPath.row]];
        return cell;
    }else{
        //管理状态的cell
        MessageListItemEditCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListItemEditCellReuseIdentifier];
        [cell setMdoel:self.dataSource[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

///选中了UITableView的某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.editMode) {
        //进入管理状态时
        MessageItemModel *model = self.dataSource[indexPath.row];
        //对模型的选中状态进行取反
        model.selected = !model.selected;
        //刷新点击的的行
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //消息管理视图的选择按钮是否要处于选中状态
        self.managementView.checkButton.selected = [self checkSelectAll];
    }
}

///询问数据源某一行是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editMode){
        //进入管理状态时不允许单行删除
        return NO;
    }else{
        return YES;
    }
}

///请求代理在响应指定行的滑动时显示操作
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //滑动单行cell以删除
    UITableViewRowAction *deteleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    deteleAction.backgroundColor = [UIColor blueColor];
    return @[deteleAction];
}

#pragma mark - DZNEmptyDataSetSource

///向数据源询问数据集的标题
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *title = @"数据集标题";
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:title];
    return attributedString;
}

///向数据源询问数据集的描述
- (nullable NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *title = @"数据集描述";
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:title];
    return attributedString;
}

///向数据源询问数据集的图像
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [UIImage imageNamed:@"bg_public"];
    return image;
}

///询问数据源的图像数据的色调颜色。默认值为nil
- (nullable UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

///向数据源询问数据集的图像动画
- (nullable CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    // 设定为缩放
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.1]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    // 返回动画
    return animation;
}

///询问数据源提供用于指定按钮状态的标题
- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *title = @"按钮标题";
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:title];
    state = UIControlStateNormal;
    return attributedString;
}

///询问数据源将图像用于指定的按钮状态。此方法将覆盖buttonTitleForEmptyDataSet:forState:并只显示图像，不显示任何文本
- (nullable UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return nil;
}

///询问数据源提供用于指定按钮状态的背景图像。这个调用没有默认的样式
- (nullable UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return nil;
}

///向数据源询问数据集的背景颜色。默认是透明的颜色
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    UIColor *color = [UIColor whiteColor];
    return color;
}

///询问数据源显示自定义视图，而不是默认视图，如标签、图像视图和按钮。默认值为nil。
- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}

///询问数据源数据集视图垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 10;
}

///询问数据源元素之间的垂直间距。默认值为11pts
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 11;
}

#pragma mark - DZNEmptyDataSetDelegate

///询问代理知道显示空数据集时是否应淡入。默认为“YES”
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView{
    return YES;
}

///询问代理图像视图动画权限。默认为NO。
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView{
    return YES;
}

///询问代理知道当项目数大于0时是否仍应显示空数据集。默认为NO
- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    return NO;
}

///询问代理是否应该显示空数据集，默认为“YES”
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

///询问代理空数据集是否接收触摸手势,默认为“YES”。
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

///向代理请求滚动权限。默认为NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

///通知代理已点击空数据集视图
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    NSLog(@"已点击空数据集视图");
}

///通知代理操作按钮已被点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    NSLog(@"操作按钮已被点击");
}

///空数据集将要消失
- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView{
    NSLog(@"空数据集将要消失");
}

///空数据集已经消失
- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView{
    NSLog(@"空数据集已经消失");
}

@end
