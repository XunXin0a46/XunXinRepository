//
//  OneLinePictureAdaptationTableViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestTableViewModel.h"

FOUNDATION_EXTERN NSString * const OneLinePictureAdaptationTableViewCellReuseIdentifier;
 
@interface OneLinePictureAdaptationTableViewCell : UITableViewCell

@property (nonatomic, strong) TestTableViewModel *model;

+ (CGFloat)calculateDynamicHeightWithModel:(id)model;

@end

