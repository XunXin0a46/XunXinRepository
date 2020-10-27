//
//  MessageListItemCell.m


#import "MessageListItemCell.h"

NSString * const MessageListItemCellReuseIdentifier = @"MessageListItemCellReuseIdentifier";
static CGSize const ReadIdentifierViewSize = {10.0, 10.0};

@interface MessageListItemCell()

@property (nonatomic, strong) CALayer *separatorLineLayer;//底部分割线

@end


@implementation MessageListItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    ///消息图标视图
    self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.customImageView];
    
    ///未读消息标记视图
    self.readIdentifierView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.readIdentifierView];
    self.readIdentifierView.backgroundColor = [UIColor greenColor];
    self.readIdentifierView.layer.cornerRadius = ReadIdentifierViewSize.height * 0.5;
    self.readIdentifierView.layer.masksToBounds = YES;
    
    ///消息标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    
    ///消息内容标签
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.textColor = [UIColor grayColor];
    
    ///日期标签
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = [UIFont systemFontOfSize:11];
    _dateLabel.textColor = [UIColor grayColor];
    
    ///底部分割线
    self.separatorLineLayer = [[CALayer alloc] init];
    [self.contentView.layer addSublayer:_separatorLineLayer];
    self.separatorLineLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    [self setupConstraints];
    
}

///设置布局
- (void)setupConstraints {
    
    ///消息图标视图
    [self.customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
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

///底部分割线
- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorLineLayer.frame = CGRectMake(59, CGRectGetHeight(self.contentView.frame) - 0.5, CGRectGetWidth(self.contentView.frame), 0.6);
}

///格式化时间戳
- (NSString *)formatDate:(NSString *)timeStr{
    
    //返回当前时间的时间戳
    double timeStamp = [timeStr doubleValue];
    //NSTimeInterval 时间间隔，double类型
    NSTimeInterval time = timeStamp;
    //得到Date类型的时间，这个时间是1970-1-1 00:00:00经过你时间戳的秒数之后的时间
    NSDate * detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //转换成字符串
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
    
}

///设置模型
- (void)setMdoel:(MessageItemModel *)mdoel{
    self.titleLabel.text = mdoel.title;
    self.contentLabel.text = mdoel.content;
    self.dateLabel.text = [self formatDate:mdoel.send_time];
    self.customImageView.image = [UIImage imageNamed:@"bg_message_notice"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
