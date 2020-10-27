//
//  UIView+Action.h

#import <UIKit/UIKit.h>

@interface UIView(Action)

///返回与&KEY_ITEM_ACTION关联的选择器
- (SEL __nullable)itemAction;

///返回与&KEY_ITEM_TARGET关联的事件处理者
- (id __nullable)itemTarget;

///返回与&KEY_ITEM_POSITION关联的view所在列表中的row number
- (NSInteger)itemPosition;

///返回与&KEY_ITEM_SECTION关联的view所在列表中的section number
- (NSInteger) itemSection;

///为视图添加事件
- (void)addTarget:(id _Nonnull)target
           action:(SEL _Nonnull)action
          section:(NSInteger)section;

///为视图添加事件
- (void)addTarget:(id _Nonnull)target
           action:(SEL _Nonnull)action
         position:(NSInteger)position
          section:(NSInteger)section;

///为添加事件视图的子视图添加事件
- (void)addEvent:(UIView * _Nonnull)view;

@end
