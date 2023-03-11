//
//  MessageListItemCell.h


#import <UIKit/UIKit.h>
#import "MessageItemModel.h"

UIKIT_EXTERN NSString * const MessageListItemCellReuseIdentifier;

@interface MessageListItemCell : UITableViewCell

@property (nonatomic, strong) UIView *readIdentifierView;//未读消息标记视图
@property (nonatomic, strong) UIImageView *customImageView;//消息图标视图
@property (nonatomic, strong) UILabel *titleLabel;//消息标题标签
@property (nonatomic, strong) UILabel *contentLabel;//消息内容标签
@property (nonatomic, strong) UILabel *dateLabel;//日期标签

@property (nonatomic, strong)MessageItemModel *mdoel;//模型

@end


