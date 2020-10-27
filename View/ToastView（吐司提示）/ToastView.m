//
//  ToastView.m
//  FrameworksTest


#import "ToastView.h"
#import "Masonry.h"

@interface ToastView()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, strong)UIImageView *toastImageView;

@end

@implementation ToastView

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andMessage:(NSString *)meaage andTitle:(NSString *)tilte{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self drawViewAndImage:image andMessage:meaage andTitle:tilte];
    }
    return self;
}

- (void)drawViewAndImage:(UIImage *)image andMessage:(NSString *)meaage andTitle:(NSString *)tilte{
    
    self.toastImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.toastImageView setImage:image];
    [self addSubview:self.toastImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.text = tilte;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor redColor];
    [self addSubview:self.titleLabel];
    
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.messageLabel.text = meaage;
    self.messageLabel.font = [UIFont boldSystemFontOfSize:15];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textColor = [UIColor redColor];
    [self addSubview:self.messageLabel];
    
    [self setUpdateConstraints];

}

- (void)setUpdateConstraints{
    
    [self.toastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toastImageView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
}
@end
