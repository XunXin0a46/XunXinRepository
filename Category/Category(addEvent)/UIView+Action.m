//
//  UIView+Action.m

#import "UIView+Action.h"
#import "UIView+ExtraTag.h"
#import <objc/runtime.h>

static void * KEY_ITEM_TARGET = &KEY_ITEM_TARGET;//事件处理者
static void * KEY_ITEM_ACTION = &KEY_ITEM_ACTION;//事件
static void * KEY_ITEM_POSITION = &KEY_ITEM_POSITION;//view在列表中所在的row
static void * KEY_ITEM_SECTION = &KEY_ITEM_SECTION;//view在列表中所在的section

@implementation UIView(Action)

- (SEL)itemAction {
    //返回与&KEY_ITEM_ACTION关联的选择器
    return NSSelectorFromString(objc_getAssociatedObject(self, KEY_ITEM_ACTION));
}

- (id)itemTarget {
    //返回与&KEY_ITEM_TARGET关联的事件处理者
    return objc_getAssociatedObject(self, KEY_ITEM_TARGET);
}

- (NSInteger)itemPosition {
    //返回与&KEY_ITEM_POSITION关联的view所在列表中的row number
    return [objc_getAssociatedObject(self, KEY_ITEM_POSITION) integerValue];
}

- (NSInteger)itemSection {
    //返回与&KEY_ITEM_SECTION关联的view所在列表中的section number
    return [objc_getAssociatedObject(self, KEY_ITEM_SECTION) integerValue];
}

/**
 为视图添加事件
 参数：
 target：事件的处理者对象，通常为self
 action：添加的事件
 section：view在列表中所在的section，如未在列表中，传递0
 */
- (void)addTarget:(id _Nonnull)target
           action:(SEL _Nonnull)action
          section:(NSInteger)section{
    [self addTarget:target action:action position:0 section:section];
}

/**
 为视图添加事件
 参数：
 target：事件的处理者对象，通常为self
 action：添加的事件
 position：view所在列表中的row number
 section：view在列表中所在的section number
*/
- (void)addTarget:(id _Nonnull)target
           action:(SEL _Nonnull)action
         position:(NSInteger)position
          section:(NSInteger)section {
    //为&KEY_ITEM_TARGET与事件处理者设置关联
    objc_setAssociatedObject(self, KEY_ITEM_TARGET, target, OBJC_ASSOCIATION_ASSIGN);
    //为&KEY_ITEM_ACTION与事件设置关联
    objc_setAssociatedObject(self, KEY_ITEM_ACTION, NSStringFromSelector(action), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //&KEY_ITEM_POSITION与view所在列表中的row number设置关联
    objc_setAssociatedObject(self, KEY_ITEM_POSITION, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //&KEY_ITEM_SECTION与view在列表中所在的section number设置关联
    objc_setAssociatedObject(self, KEY_ITEM_SECTION, @(section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///添加事件的视图为UIButton时执行的函数
- (void)onButtonClicked:(UIView *)sender {
    [self callTarget:sender];
}

///添加事件的视图为UITextField时执行的函数
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self callTarget:textField];
}

///添加事件的视图为UIView时执行的函数
- (void)onTap:(UIGestureRecognizer *)gesture {
    [self callTarget:gesture.view];
}

///执行与&KEY_ITEM_ACTION关联的函数
- (void)callTarget:(UIView *)sender {
    //与&KEY_ITEM_TARGET关联的事件处理者如果没有响应与&KEY_ITEM_ACTION关联的选择器
    if (![self.itemTarget respondsToSelector:self.itemAction]) {
        //结束函数
        return;
    }
    //为添加事件的视图设置与&KEY_POSITION的关联，参数为view所在列表中的row number
    [sender setPositionForTag:self.itemPosition];
    //为添加事件的视图设置与&KEY_SECTION的关联，参数为view所在列表中的section number
    [sender setSectionForTag:self.itemSection];
    //获取与&KEY_ITEM_TARGET关联的事件处理者中与&KEY_ITEM_ACTION关联的选择器的IMP（函数指针）
    IMP imp = [self.itemTarget methodForSelector:self.itemAction];
    //通过IMP（函数指针）获取函数
    void (*function) (id, SEL, UIView *) = (void *)imp;
    //执行函数
    function (self.itemTarget, self.itemAction, sender);
}

/**
 为添加事件视图的子视图添加事件
 参数：
 view ：通过addTarget:(id _Nonnull)target action:(SEL _Nonnull)action position:(NSInteger)position section:(NSInteger)section函数添加事件的视图的子视图
 */
- (void)addEvent:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        //如果添加事件的视图是UIButton
        UIButton *button = (UIButton*)view;
        //添加点击事件
        [button addTarget:self
                   action:@selector (onButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    } else if ([view isKindOfClass:[UITextField class]]) {
        //如果添加事件的视图是UITextField
        UITextField *textFiled = (UITextField *)view;
        //添加UITextField结束编辑事件
        [textFiled addTarget:self
                      action:@selector (textFieldDidEndEditing:)
            forControlEvents:UIControlEventEditingDidEnd];
    } else if ([view isKindOfClass:[UIView class]]) {
        //如果添加事件的视图是UIView
        view.userInteractionEnabled = YES;
        //初始化点击手势识别
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (onTap:)];
        //遍历清除view已经添加的点击手势识别
        [view.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [view removeGestureRecognizer:obj];
        }];
        //添加点击手势识别到view
        [view addGestureRecognizer:gesture];
    }
}
@end
