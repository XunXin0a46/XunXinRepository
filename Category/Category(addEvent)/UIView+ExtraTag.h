//
//  UIView+ExtraTag.h

#import <UIKit/UIKit.h>
@interface UIView (ExtraTag)
/**
 * viewType为view的类别，例如商品、店铺等
 */
- (void)setViewTypeForTag:(NSInteger)viewType;
/**
 * position一般为view在列表中的row number
 */
- (void)setPositionForTag:(NSInteger)position;
/**
 * section一般为view在列表中section number
 */
- (void)setSectionForTag:(NSInteger)section;
/**
 * extraInfo一般用view在嵌套列表中的row number
 */
- (void)setExtraInfoForTag:(NSInteger)extraInfo;

- (NSInteger)getViewTypeOfTag;
- (NSInteger)getPositionOfTag;
- (NSInteger)getSectionOfTag;
- (NSInteger)getExtraInfoOfTag;
@end
