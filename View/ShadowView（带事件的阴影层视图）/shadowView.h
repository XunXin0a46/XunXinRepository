//
//  shadowView.h

#import <UIKit/UIKit.h>


@interface shadowView : UIView

@property (nonatomic, copy) NSString *signLabel;//红包玩法描述

- (void)showInView:(UIView *)view;
- (void)hideInView;

@end

