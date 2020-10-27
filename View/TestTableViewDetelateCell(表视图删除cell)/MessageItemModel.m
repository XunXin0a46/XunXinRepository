//
//  MessageItemModel.m


#import "MessageItemModel.h"

@implementation MessageItemModel

- (instancetype)initWithModel{
    
    self = [super init];
    if(self){
        self.send_time = @"1576139886";
        self.content = @"亲爱的顾客小懒，您的账户有余额变动，变动资金-103.40元，请您及时查看账户资金明细。";
        self.title = @"余额变动提醒";
        self.selected = NO;
    }
    
    return self;
}

@end
