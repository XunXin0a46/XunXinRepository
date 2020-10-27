//
//  TestNavigationController.m


#import "TestNavigationController.h"
#import "YSCUITextField.h"

@interface TestNavigationController ()<UITextFieldDelegate>

@property (nonatomic, strong) YSCUITextField *searchTextField;
@property (nonatomic, strong) UIColor *backBarTintColor;
@property (nonatomic, copy) NSDictionary *backTitleAttributes;
@property (nonatomic, strong) UIImage *backShadowImage;
@property (nonatomic, assign) BOOL isHaveDian;//是否是小数

@end

@implementation TestNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //备份导航栏属性
    [self backupNavigationBarAttributes];
    //设置导航栏透明
    [self setNavigationBarAttributes];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //设置导航项左侧返回按钮
    [self setNavigationLeftBlockItem];
    //设置导航栏右侧按钮
    [self setNavigationRightBlockItem];
    //设置导航栏搜索视图
    [self setNavigationItemTitleView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //重置导航栏属性
    [self resetNavigationBarAttributes];
    //将导航栏左侧返回按钮重置为黑色图标
    UIButton *leftButton = self.navigationItem.leftBarButtonItem.customView;
    [leftButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateHighlighted];
}


///---------------------------------------- UINavigationController代码测试区 -------------------------------

///备份导航栏属性
- (void)backupNavigationBarAttributes {
    _backBarTintColor = self.navigationController.navigationBar.barTintColor;
    _backTitleAttributes = self.navigationController.navigationBar.titleTextAttributes;
    _backShadowImage = self.navigationController.navigationBar.shadowImage;
}

///重置导航栏属性
- (void)resetNavigationBarAttributes {
    //栏标题文本的属性
    self.navigationController.navigationBar.titleTextAttributes = self.backTitleAttributes;
    //导航栏背景的色调颜色
    self.navigationController.navigationBar.barTintColor = self.backBarTintColor;
    //导航栏的阴影图像
    self.navigationController.navigationBar.shadowImage = self.backShadowImage;
    //导航栏是否半透明
    self.navigationController.navigationBar.translucent = NO;
}

///设置导航项左侧返回按钮
- (void)setNavigationLeftBlockItem{
    [((UIButton *)self.navigationItem.leftBarButtonItem.customView) setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [((UIButton *)self.navigationItem.leftBarButtonItem.customView) setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [((UIButton *)self.navigationItem.leftBarButtonItem.customView) setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateHighlighted];
}

///设置导航栏透明
- (void)setNavigationBarAttributes {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:54.0f/255.0f green:53.0f/255.0f blue:58.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //去掉透明后导航栏下边的黑边
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}

///设置导航栏搜索视图
- (void)setNavigationItemTitleView{
    //初始化文本框
    self.searchTextField = [[YSCUITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33.0)];
    //设置文本输入框样式
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.cornerRadius = 16.5;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.font = [UIFont systemFontOfSize:13];
    self.searchTextField.textColor = [UIColor blackColor];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入搜索内容" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    //初始化放大镜按钮视图
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"ic_search_black"] forState:UIControlStateNormal];
    searchButton.contentMode = UIViewContentModeScaleAspectFit;
    searchButton.frame = CGRectMake (7.5, 7.5, 18.0, 18.0);
    //放大镜图标视图添加点击事件
    UITapGestureRecognizer *searchImageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchImageViewTouchUpInside)];
    [searchButton addGestureRecognizer:searchImageViewTapGestureRecognizer];
    //初始化文本清空按钮
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0.0, 7, 19.0, 19.0);
    [clearButton setImage:[UIImage imageNamed:@"btn_clear_content_cricled"] forState:UIControlStateNormal];
    clearButton.imageEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    [clearButton addTarget:self action:@selector(clearSearchText:) forControlEvents:UIControlEventTouchUpInside];
    //添加清空按钮到文本输入框右侧
    self.searchTextField.rightView = clearButton;
    //添加放大镜图标视图到文本输入框左侧
    self.searchTextField.leftView = searchButton;
    //将文本输入框作为导航栏视图
    self.navigationItem.titleView = self.searchTextField;
}

///设置导航栏右侧按钮
- (void)setNavigationRightBlockItem{
    
    //初始化更多按钮
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮矩形框架
    moreButton.frame = CGRectMake(0, 0, 25.0, 25.0);
    //添加点击事件
    [moreButton addTarget:self action:@selector(navigationBarButtonItemOnclick:) forControlEvents:UIControlEventTouchUpInside];
    //设置图片内间距
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6.0);
    //设置...图标
    [moreButton setImage:[UIImage imageNamed:@"btn_more_white"] forState:UIControlStateNormal];
    //初始化条形按钮项
    UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    //添加标签
    moreButton.tag = 3000;
    
    //初始化扫描按钮
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮矩形框架
    scanButton.frame = CGRectMake(0, 0, 25.0, 25.0);
    //添加点击事件
    [scanButton addTarget:self action:@selector(navigationBarButtonItemOnclick:) forControlEvents:UIControlEventTouchUpInside];
    //设置图片内间距
    scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6.0);
    //设置扫描图标
    [scanButton setImage:[UIImage imageNamed:@"btn_scan_white"] forState:UIControlStateNormal];
    //初始化条形按钮项
    UIBarButtonItem *scanBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    //添加标签
    scanButton.tag = 3001;
    //将条形按钮项数组添加到导航栏右侧按钮
    NSArray *rightBarButtonItems = @[moreBarButtonItem, scanBarButtonItem];
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}

///清空输入的搜索内容
- (void)clearSearchText:(UIButton *)sender {
    self.searchTextField.text = nil;
}

///点击视图文本输入框以外内容时文本框放弃第一响应对象
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
}

///导航栏右侧按钮点击事件
- (void)navigationBarButtonItemOnclick:(UIButton *)sender {
    if(sender.tag == 3000){
        NSLog(@"点击了更多按钮");
    }else if(sender.tag == 3001){
        NSLog(@"点击了扫描按钮");
    }
}

///放大镜图标视图点击事件
- (void)searchImageViewTouchUpInside{
    NSLog(@"放大镜点击了");
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
    NSLog(@"搜索%@",textField.text);
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByAppendingString:string] ? : string;

    if (text.floatValue > 50.0) {
        [self.view makeToast:@"最多可使用的余额50.0元"];
        return NO;
    }
    //#####验证输入的内容
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        //验证是否是数字
        NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{0,2})?$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        if(single != '.' && ![phoneTest evaluateWithObject:string]){
            [self.view makeToast:@"请输入数字格式"];
            return NO;
        }
        
        [NSString stringWithFormat:@"single = %c",single];
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            [self.view makeToast:@"最多只能输入一个小数点"];
            return NO;
        }
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [self.view makeToast:@"第二个字符需要是小数点"];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    [self.view makeToast:@"第二个字符需要是小数点"];
                    return NO;
                }
            }
        }
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [self.view makeToast:@"小数点后最多有两位小数"];
                    return NO;
                }
            }
        }
        
    }
    return YES;
}

///------------------------------------ UINavigationController代码测试区结束 --------------------------------


@end
