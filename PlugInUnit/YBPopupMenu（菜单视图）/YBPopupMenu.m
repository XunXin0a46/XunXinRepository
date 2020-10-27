//
//  YBPopupMenu.m
//  YBPopupMenu
//
//  Created by LYB on 16/11/8.
//  Copyright © 2016年 LYB. All rights reserved.
//

#import "YBPopupMenu.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainWindow  [UIApplication sharedApplication].keyWindow

#pragma mark - /////////////////
#pragma mark - private categorys

@interface UIView (YBFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@end


@implementation UIView (YBFrame)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end


#pragma mark - /////////////
#pragma mark - private cell

@interface YBPopupMenuCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isShowSeparator;
@property (nonatomic, strong) UIColor *separatorColor;

@end

static NSString * const YBPopupMenuCellReuseIdentifier = @"YBPopupMenuCellReuseIdentifier";

@implementation YBPopupMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isShowSeparator = YES;
        _separatorColor = [UIColor lightGrayColor];
        [self setNeedsDisplay];
    }
    return self;
}

///是否显示分割线
- (void)setIsShowSeparator:(BOOL)isShowSeparator
{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!_isShowSeparator) return;
    //绘制分割线
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(10, rect.size.height - 0.5, rect.size.width - 20, 0.5)];
    //将后续填充操作的颜色设置为接收器表示的颜色。
    [_separatorColor setFill];
    //使用指定的混合模式和透明度值绘制由接收器路径包围的区域
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:0.4];
    //关闭最近添加的子路径
    [bezierPath closePath];
}

@end


#pragma mark - ///////////
#pragma mark - YBPopupMenu

@interface YBPopupMenu () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation YBPopupMenu
{
    
    UIView * _mainView; //主视图
    UITableView * _contentView; //内容表视图
    UIView * _bgView; //背景视图
    
    CGPoint _anchorPoint; //箭头位置
    
    CGFloat kArrowHeight; //箭头高度
    CGFloat kArrowWidth;  //箭头宽度
    CGFloat kArrowPosition; //参与箭头起点计算的值
    CGFloat kButtonHeight;
    
    NSArray * _icons;
    
    UIColor * _contentColor;
    UIColor * _separatorColor;
}

@synthesize cornerRadius = kCornerRadius; //圆角半径

- (instancetype)initWithTitles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                    itemHeight:(CGFloat)itemHeight
                      delegate:(id<YBPopupMenuDelegate>)delegate
{
    if (self = [super init]) {
        
        kArrowHeight = 8.0;
        kArrowWidth = 15.0;
        kButtonHeight = itemHeight;
        kCornerRadius = 3.0;
        _titles = titles;
        _icons = icons;
        _dismissOnSelected = YES;
        _fontSize = 15.0;
        _textColor = [UIColor blackColor];
        _offset = 0.0;
        _type = YBPopupMenuTypeDefault;
        _arrowDirection = YBArrowDirectionTop;
        _contentColor = [UIColor whiteColor];
        _separatorColor = [UIColor lightGrayColor];
        
        if (delegate) self.delegate = delegate;
        
        self.width = itemWidth;
        self.height = (titles.count > 6 ? 6 * kButtonHeight : titles.count * kButtonHeight) + 2 * kArrowHeight;
        
        kArrowPosition = 0.5 * self.width - 0.5 * kArrowWidth;
        
        //设置菜单的透明度
        self.alpha = 0;
        //设置菜单的阴影不透明度
        self.layer.shadowOpacity = 0.5;
        //设置菜单的阴影偏移量
        self.layer.shadowOffset = CGSizeMake(0, 0);
        //设置菜单的阴影圆角
        self.layer.shadowRadius = 2.0;
        
        //主视图
        _mainView = [[UIView alloc] initWithFrame: self.bounds];
        _mainView.backgroundColor = _contentColor;
        _mainView.layer.cornerRadius = kCornerRadius;
        _mainView.layer.masksToBounds = YES;
        
        //内容表视图
        _contentView = [[UITableView alloc] initWithFrame: _mainView.bounds style:UITableViewStylePlain];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.bounces = titles.count > 5 ? YES : NO;
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.rowHeight = kButtonHeight;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentView.height -= 2 * kArrowHeight;
        _contentView.centerY = _mainView.centerY;
        [_contentView registerClass:[YBPopupMenuCell class] forCellReuseIdentifier:YBPopupMenuCellReuseIdentifier];
        
        [_mainView addSubview: _contentView];
        [self addSubview: _mainView];
        
        //设置菜单背景遮罩视图的默认背景颜色
        _bgViewBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        //菜单背景遮罩视图
        _bgView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
        [_bgView addGestureRecognizer: tap];
    }
    return self;
}

///移除菜单
- (void)dismiss
{
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self->_bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self removeFromSuperview];
        [self->_bgView removeFromSuperview];
    }];
}

///在指定位置弹出
- (void)showAtPoint:(CGPoint)point
{
    _mainView.layer.mask = [self getMaskLayerWithPoint:point];
    [self show];
}

/// 依赖指定view弹出
- (void)showRelyOnView:(UIView *)view
{
    //获取视图转换到窗口的矩形
    CGRect absoluteRect = [view convertRect:view.bounds toView:kMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    //根据箭头位置调整视图位置
    switch (_arrowLocation) {
        case YBArrowLocationLeft:
            relyPoint.x = relyPoint.x + self.width / 2 - kArrowWidth / 2;
            break;
        case YBArrowLocationRight:
            relyPoint.x = relyPoint.x - self.width / 2 + kArrowWidth / 2;
            break;
        default:
            break;
    }
    _mainView.layer.mask = [self getMaskLayerWithPoint:relyPoint];
    if (self.y < _anchorPoint.y) {
        self.y -= absoluteRect.size.height;
    }
    [self show];
}

- (instancetype)initWithTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth menuHeight:(CGFloat)itemHeight delegate:(id<YBPopupMenuDelegate>)delegate{
    YBPopupMenu *popupMenu = [[YBPopupMenu alloc] initWithTitles:titles icons:icons menuWidth:itemWidth itemHeight:itemHeight delegate:delegate];
    return popupMenu;
}

+ (instancetype)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth delegate:(id<YBPopupMenuDelegate>)delegate{
    YBPopupMenu *popupMenu = [[YBPopupMenu alloc] initWithTitles:titles icons:nil menuWidth:itemWidth itemHeight:44 delegate:delegate];
    popupMenu.type = YBPopupMenuTypeDefault;
    popupMenu.textColor = [UIColor whiteColor];
    [popupMenu showRelyOnView:view];
    return popupMenu;
}

+ (instancetype)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth delegate:(id<YBPopupMenuDelegate>)delegate
{
    YBPopupMenu *popupMenu = [[YBPopupMenu alloc] initWithTitles:titles icons:icons menuWidth:itemWidth itemHeight:44.0 delegate:delegate];
    popupMenu.type = YBPopupMenuTypeDark;
    popupMenu.textColor = [UIColor whiteColor];
    [popupMenu showAtPoint:point];
    return popupMenu;
}

+ (instancetype)showRelyOnView:(UIView *)view titles:(NSArray *)titles type:(YBPopupMenuType)type fontSize:(CGFloat)fontSize menuWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight delegate:(id<YBPopupMenuDelegate>)delegate {

    YBPopupMenu *popupMenu = [[YBPopupMenu alloc] initWithTitles:titles icons:nil menuWidth:itemWidth itemHeight:itemHeight delegate:delegate];
    popupMenu.type = type;
    popupMenu.textColor = [UIColor whiteColor];
    popupMenu.fontSize = fontSize;
    popupMenu.isShowShadow = NO;
    [popupMenu showRelyOnView:view];
    return popupMenu;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:YBPopupMenuCellReuseIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    cell.textLabel.text = _titles[indexPath.row];
    
    cell.separatorColor = _separatorColor;
    if (_icons.count >= indexPath.row + 1) {
        if ([_icons[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.imageView.image = [UIImage imageNamed:_icons[indexPath.row]];
        }else if ([_icons[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _icons[indexPath.row];
        }else {
            cell.imageView.image = nil;
        }
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else {
        cell.imageView.image = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnSelected) [self dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ybPopupMenuDidSelectedAtIndex:ybPopupMenu:)]) {
        
        [self.delegate ybPopupMenuDidSelectedAtIndex:indexPath.row ybPopupMenu:self];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    YBPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    YBPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
}

///获取最后一个可见单元格
- (YBPopupMenuCell *)getLastVisibleCell
{
    //获取索引路径的数组
    NSArray <NSIndexPath *>*indexPaths = [_contentView indexPathsForVisibleRows];
    //返回一个数组，该数组按升序列出接收数组的元素，由给定NSComparator块指定的比较方法确定。
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    //获取排序后的索引路径的数组的第一个元素
    NSIndexPath *indexPath = indexPaths.firstObject;
    //返回指定索引处的单元格
    return [_contentView cellForRowAtIndexPath:indexPath];
}

#pragma mark private functions
- (void)setType:(YBPopupMenuType)type
{
    _type = type;
    switch (type) {
        case YBPopupMenuTypeDark:
            _textColor = [UIColor lightGrayColor];
            _contentColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            _separatorColor = [UIColor lightGrayColor];
            break;
        case YBPopupMenuTypeGray:
            _textColor = [UIColor whiteColor];
            _contentColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.0];
            _separatorColor = [UIColor clearColor];
            break;
        default:
            _textColor = [UIColor blackColor];
            _contentColor = [UIColor whiteColor];
            _separatorColor = [UIColor lightGrayColor];
            break;
    }
    _mainView.backgroundColor = _contentColor;
    [_contentView reloadData];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [_contentView reloadData];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [_contentView reloadData];
}

- (void)setDismissOnTouchOutside:(BOOL)dismissOnTouchOutside
{
    _dismissOnSelected = dismissOnTouchOutside;
    if (!dismissOnTouchOutside) {
        for (UIGestureRecognizer *gr in _bgView.gestureRecognizers) {
            [_bgView removeGestureRecognizer:gr];
        }
    }
}

- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    if (!isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }
}

- (void)setFrameShadowOpacity:(CGFloat)frameShadowOpacity{
    self.layer.shadowOpacity = frameShadowOpacity;
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    if (offset < 0) {
        offset = 0.0;
    }
    self.y += self.y >= _anchorPoint.y ? offset : -offset;
}

///设置圆角半径
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    kCornerRadius = cornerRadius;
    //绘制遮罩层
    _mainView.layer.mask = [self drawMaskLayer];
    if (self.y < _anchorPoint.y) {
        _mainView.layer.mask.affineTransform = CGAffineTransformMakeRotation(M_PI);
    }
}

///设置菜单背景遮罩视图的背景颜色
- (void)setBgViewBackgroundColor:(UIColor *)bgViewBackgroundColor{
    _bgViewBackgroundColor = bgViewBackgroundColor;
    _bgView.backgroundColor = bgViewBackgroundColor;
}

///设置菜单背景遮罩视图的背景颜色透明度
- (void)setBgViewBackgroundColorAlpha:(CGFloat)bgViewBackgroundColorAlpha{
    _bgView.backgroundColor = [_bgViewBackgroundColor colorWithAlphaComponent:bgViewBackgroundColorAlpha];
}

///显示
- (void)show {
    //在窗口上添加背景视图
    [kMainWindow addSubview: _bgView];
    //在窗口上添加菜单
    [kMainWindow addSubview: self];
    //获取最后一个可见单元格
    YBPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
    //设置层变换的仿射
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    //显示的动画块
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self->_bgView.alpha = 1;
    }];
}

- (void)setAnimationAnchorPoint:(CGPoint)point
{
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

- (void)determineAnchorPoint
{
    CGPoint aPoint;
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        aPoint = CGPointMake(fabs(kArrowPosition) / self.width, 1);
    }else {
        aPoint = CGPointMake(fabs(kArrowPosition) / self.width, 0);
    }
    [self setAnimationAnchorPoint:aPoint];
}

///根据点获取遮罩层
- (CAShapeLayer *)getMaskLayerWithPoint:(CGPoint)point
{
    //在何处设置箭头
    [self setArrowPointingWhere:point];
    //绘制遮罩层
    CAShapeLayer *layer = [self drawMaskLayer];
    [self determineAnchorPoint];
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        
        kArrowPosition = self.width - kArrowPosition - kArrowWidth;
        //绘制遮罩层
        layer = [self drawMaskLayer];
        //设置层变换的仿射版本为提供的旋转值构造的仿射变换矩阵
        layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y - self.height;
    }
    self.y += self.y >= _anchorPoint.y ? _offset : -_offset;
    return layer;
}

///在何处设置箭头
- (void)setArrowPointingWhere: (CGPoint)anchorPoint
{
    _anchorPoint = anchorPoint;
    
    self.x = anchorPoint.x - kArrowPosition - 0.5*kArrowWidth;
    //设置箭头指向
    if(_arrowDirection == YBArrowDirectionTop){
        self.y = anchorPoint.y;
    }else if(_arrowDirection == YBArrowDirectionBottom){
        self.y = anchorPoint.y - CGRectGetHeight(self.frame);
    }
    
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    
    if (maxX > kScreenWidth - 10) {
        self.x = kScreenWidth - 10 - self.width;
    }else if (minX < 10) {
        self.x = 10;
    }
    
    maxX = CGRectGetMaxX(self.frame);
    minX = CGRectGetMinX(self.frame);
    
    //设置箭头位置
    switch (_arrowLocation) {
        case YBArrowLocationLeft:
            //箭头位置居左
            kArrowPosition = kCornerRadius;
            break;
        case YBArrowLocationRight:
            //箭头位置居右
            kArrowPosition = self.width - kCornerRadius - kArrowWidth;
            break;
        case YBArrowLocationCentre:
            //箭头位置居中
            kArrowPosition = anchorPoint.x - minX - 0.5*kArrowWidth;
            break;
        default:
            //未设置箭头位置根据视图与屏幕的位置进行调整
            if ((anchorPoint.x <= maxX - kCornerRadius) && (anchorPoint.x >= minX + kCornerRadius)) {
                kArrowPosition = anchorPoint.x - minX - 0.5*kArrowWidth;
            }else if (anchorPoint.x < minX + kCornerRadius) {
                kArrowPosition = kCornerRadius;
            }else {
                kArrowPosition = self.width - kCornerRadius - kArrowWidth;
            }
            break;
    }

}

///绘制遮罩层
- (CAShapeLayer *)drawMaskLayer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _mainView.bounds;
    //右上弧中心
    CGPoint topRightArcCenter = CGPointMake(self.width-kCornerRadius, kArrowHeight+kCornerRadius);
    //左上弧中心
    CGPoint topLeftArcCenter = CGPointMake(kCornerRadius, kArrowHeight+kCornerRadius);
    //右下弧中心
    CGPoint bottomRightArcCenter = CGPointMake(self.width-kCornerRadius, self.height - kArrowHeight - kCornerRadius);
    //左下弧中心
    CGPoint bottomLeftArcCenter = CGPointMake(kCornerRadius, self.height - kArrowHeight - kCornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //将接收器的当前点移动到指定位置
    [path moveToPoint: CGPointMake(0, kArrowHeight+kCornerRadius)];
    //向接收器的路径追加一条直线(左侧直线)
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    //添加左下角弧线
    [path addArcWithCenter: bottomLeftArcCenter radius: kCornerRadius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    //指向下的箭头
    if(_arrowDirection == YBArrowDirectionBottom){
        [path addLineToPoint: CGPointMake(kArrowPosition, self.height - kArrowHeight)];
        [path addLineToPoint: CGPointMake(kArrowPosition+0.5*kArrowWidth, self.height)];
        [path addLineToPoint: CGPointMake(kArrowPosition+kArrowWidth, self.height - kArrowHeight)];
        [path addLineToPoint: CGPointMake(self.width - kCornerRadius, self.height - kArrowHeight)];
    }
    //添加右下角弧线
    [path addArcWithCenter: bottomRightArcCenter radius: kCornerRadius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    //向接收器的路径追加一条直线(右侧直线)
    [path addLineToPoint: CGPointMake(self.width, kArrowHeight+kCornerRadius)];
    //添加右上角弧线
    [path addArcWithCenter: topRightArcCenter radius: kCornerRadius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    //指向上的箭头
    if(_arrowDirection == YBArrowDirectionTop){
        [path addLineToPoint: CGPointMake(kArrowPosition+kArrowWidth, kArrowHeight)];
        [path addLineToPoint: CGPointMake(kArrowPosition+0.5*kArrowWidth, 0)];
        [path addLineToPoint: CGPointMake(kArrowPosition, kArrowHeight)];
        [path addLineToPoint: CGPointMake(kCornerRadius, kArrowHeight)];
    }
    //添加左上角弧线
    [path addArcWithCenter: topLeftArcCenter radius: kCornerRadius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    //关闭路径
    [path closePath];
    
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}

@end
