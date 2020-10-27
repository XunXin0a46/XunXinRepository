//
//  LMJDropdownMenu.m
//  下拉菜单

#import "LMJDropdownMenu.h"


#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

#define FRAME_ORIGIN(aFrame)     ((aFrame).origin)
#define FRAME_X(aFrame)          ((aFrame).origin.x)
#define FRAME_Y(aFrame)          ((aFrame).origin.y)

#define FRAME_SIZE(aFrame)       ((aFrame).size)
#define FRAME_HEIGHT(aFrame)     ((aFrame).size.height)
#define FRAME_WIDTH(aFrame)      ((aFrame).size.width)



#define VIEW_BOUNDS(aView)       ((aView).bounds)

#define VIEW_FRAME(aView)        ((aView).frame)

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)


#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)

#define AnimateTime 0.25f   // 下拉动画时间

@interface LMJDropdownMenu()

@property (nonatomic, strong) UIImageView *arrowMark; // 箭头图标
@property (nonatomic, strong) UIView *listView;       // 下拉列表背景View
@property (nonatomic, strong) UITableView *tableView; // 下拉列表
@property (nonatomic, strong) NSArray *titleArr;      // 选项数组
@property (nonatomic, assign) CGFloat rowHeight;      // 下拉列表行高

@end


@implementation LMJDropdownMenu

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //根据frame创建主按钮
        [self createMainBtnWithFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //根据frame创建主按钮
    [self createMainBtnWithFrame:frame];
}

///根据frame创建主按钮
- (void)createMainBtnWithFrame:(CGRect)frame{
    //取消视图与其父视图及其窗口的链接，并将其从响应程序链中移除。
    [_mainBtn removeFromSuperview];
    _mainBtn = nil;
    //初始化主按钮 显示在界面上的点击按钮，样式可以自定义
    _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮Frame
    [_mainBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //设置控件的正常或默认状态时按钮标题颜色
    [_mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置控件的正常或默认状态时按钮的标题为全部
    [_mainBtn setTitle:@"全部" forState:UIControlStateNormal];
    //设置按钮的点击事件
    [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮边界内内容的水平对齐方式为左侧水平对
    _mainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //设置主按钮标题的字体大小
    _mainBtn.titleLabel.font    = [UIFont systemFontOfSize:15];
    //设置主按钮题文本的内边距
    _mainBtn.titleEdgeInsets    = UIEdgeInsetsMake(0, 10, 0, 0);
    //设置按钮的选定状态为NO
    _mainBtn.selected           = NO;
    //设置主按钮的背景颜色
    _mainBtn.backgroundColor    = [UIColor whiteColor];
    //设置主按钮的边框宽度
    _mainBtn.layer.borderWidth  = 0.5;
    //设置主按钮的边框颜色
    _mainBtn.layer.borderColor  = [UIColor blackColor].CGColor;
    //添加主按钮到视图中
    [self addSubview:_mainBtn];
    
    //初始化旋转箭头视图
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(_mainBtn.frame.size.width - 15, 0, 9, 9)];
    //设置旋转箭头视图的中心点
    _arrowMark.center = CGPointMake(VIEW_CENTER_X(_arrowMark), VIEW_HEIGHT(_mainBtn)/2);
    //设置旋转箭头视图的图片
    _arrowMark.image  = [UIImage imageNamed:@"dropdownMenu_cornerIcon.png"];
    //添加旋转箭头视图到主按钮
    [_mainBtn addSubview:_arrowMark];

}

///设置选项标题与选项行高
- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight{
    //如果自身为nil，直接返回
    if (self == nil) {
        return;
    }
    //初始化选项数组
    _titleArr  = [NSArray arrayWithArray:titlesArr];
    //设置选项行高
    _rowHeight = rowHeight;

    //初始化下拉列表背景View
    _listView = [[UIView alloc] init];
    //设置下拉列表背景View的frame
    _listView.frame = CGRectMake(VIEW_X(self) , VIEW_Y_Bottom(self), VIEW_WIDTH(self),  0);
    //设置超出视图范围的内容被裁减为YES
    _listView.clipsToBounds       = YES;
    //设置超出视图层的子层内容是否被裁减为NO
    _listView.layer.masksToBounds = NO;
    //设置视图的边框颜色为深色背景上文本的不可调整的系统颜色
    _listView.layer.borderColor   = [UIColor lightTextColor].CGColor;
    //设置视图的边框宽度
    _listView.layer.borderWidth   = 0.5f;

    //初始化下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView))];
    //设置TableView的代理对象
    _tableView.delegate        = self;
    //设置TableView的数据源对象
    _tableView.dataSource      = self;
    //设置TableView的单元格分隔线样式为无明显的样式
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    //设置TableView的弹簧效果为NO
    _tableView.bounces         = NO;
    //添加TableView到下拉列表背景
    [_listView addSubview:_tableView];
}

///主按钮的点击事件
- (void)clickMainBtn:(UIButton *)button{
    //将下拉视图添加到控件的父视图上
    [self.superview addSubview:_listView];
    //如果主按钮的选中状态为NO
    if(button.selected == NO) {
        //显示下拉列表
        [self showDropDown];
    }
    //如果主按钮的选中状态为YES
    else {
        [self hideDropDown];
    }
}

///显示下拉列表
- (void)showDropDown{
    //将下拉列表置于最上层
    [_listView.superview bringSubviewToFront:_listView];
    //如果代理对象响应了下拉列表将要显示的代理函数
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        //执行将要显示回调代理
        [self.delegate dropdownMenuWillShow:self];
    }
    //设置对象为弱饮用
    __weak typeof(self) weakSelf = self;
    //在指定的持续时间设置对一个或多个视图的更改的动画，并执行完成处理程序代码块
    [UIView animateWithDuration:AnimateTime animations:^{
        //更改箭头图标视图的相对于其边界中心的转换为提供的旋转值构造的仿射变换矩阵
        weakSelf.arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        //更改下拉列表背景View的frame
        weakSelf.listView.frame  = CGRectMake(VIEW_X(weakSelf.listView), VIEW_Y(weakSelf.listView), VIEW_WIDTH(weakSelf.listView), weakSelf.rowHeight * weakSelf.titleArr.count);
        //更改下拉列表TableView的frame
        weakSelf.tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(weakSelf.listView), VIEW_HEIGHT(weakSelf.listView));
        
    }completion:^(BOOL finished) {
        //如果代理对象响应了下拉列表已经显示的代理函数
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
            //执行已经显示回调代理
            [self.delegate dropdownMenuDidShow:self];
        }
    }];
    //设置主按钮的选择状态为YES
    _mainBtn.selected = YES;
}

///隐藏下拉列表
- (void)hideDropDown{
    
    //如果代理对象响应了下拉列表将要隐藏的代理函数
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHidden:)]) {
        //执行将要隐藏回调代理
        [self.delegate dropdownMenuWillHidden:self];
    }
    //设置对象的弱饮用
    __weak typeof(self) weakSelf = self;
    //在指定的持续时间设置对一个或多个视图的更改的动画，并执行完成处理程序代码块
    [UIView animateWithDuration:AnimateTime animations:^{
        //更改箭头图标视图的相对于其边界中心的旋转坐标系
        weakSelf.arrowMark.transform = CGAffineTransformIdentity;
        //更改下拉列表背景View的frame
        weakSelf.listView.frame  = CGRectMake(VIEW_X(weakSelf.listView), VIEW_Y(weakSelf.listView), VIEW_WIDTH(weakSelf.listView), 0);
        //更改下拉列表TableView的frame
        weakSelf.tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(weakSelf.listView), VIEW_HEIGHT(weakSelf.listView));
        
    }completion:^(BOOL finished) {
        //如果代理对象响应了下拉列表已经隐藏的代理函数
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHidden:)]) {
            //执行已经隐藏回调代理
            [self.delegate dropdownMenuDidHidden:self];
        }
    }];
    //设置主按钮的选择状态为NO
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //返回由其标识符定位的可重用表视图单元格对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //如果单元格对象为nil
    if (cell == nil) {
        //初始化单元格对象
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //下拉选项样式，可在此处自定义
        cell.textLabel.font          = [UIFont systemFontOfSize:11.f];
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;
        //分割线
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, VIEW_WIDTH(cell), 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [cell addSubview:line];
        
    }
    
    cell.textLabel.text =[_titleArr objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_mainBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    //如果代理对象响应了选择某个选项时的代理函数
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellNumber:)]) {
        //执行当选择某个选项时的回调代理
        [self.delegate dropdownMenu:self selectedCellNumber:indexPath.row];
    }
    //隐藏下拉列表
    [self hideDropDown];
}
@end
