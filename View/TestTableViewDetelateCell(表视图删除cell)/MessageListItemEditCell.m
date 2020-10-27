//
//  MessageListItemEditCell.m


#import "MessageListItemEditCell.h"

NSString *const MessageListItemEditCellReuseIdentifier = @"MessageListItemEditCellReuseIdentifier";

static CGSize const ReadIdentifierViewSize = {10.0, 10.0};

@interface MessageListItemEditCell()

@property (nonatomic, strong) UIButton *checkoutButton;

@end


@implementation MessageListItemEditCell

- (void)setupConstraints {
    
    ///选中按钮
    [self.checkoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    ///消息图标视图
    [self.customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.checkoutButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(54.0, 54.0));
    }];
    
    ///未读消息标记视图
    [self.readIdentifierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customImageView.mas_top).offset(10 * 0.5);
        make.right.equalTo(self.customImageView.mas_right).offset(-10 * 0.5);
        make.size.mas_equalTo(ReadIdentifierViewSize);
    }];
    
    ///日期标签
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    ///消息标题标签
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.customImageView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    ///消息内容标签
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}

///懒加载选中按钮
- (UIButton *)checkoutButton {
    if (_checkoutButton == nil) {
        _checkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_checkoutButton];
        _checkoutButton.userInteractionEnabled = NO;
        [_checkoutButton setImage:[UIImage imageNamed:@"bg_check_normal"] forState:UIControlStateNormal];
        [_checkoutButton setImage:[UIImage imageNamed:@"bg_check_selected"] forState:UIControlStateSelected];
    }
    return _checkoutButton;
}

///设置模型
- (void)setMdoel:(MessageItemModel *)model{
    [super setMdoel:model];
    //设置按钮的选中状态
    self.checkoutButton.selected = model.selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
