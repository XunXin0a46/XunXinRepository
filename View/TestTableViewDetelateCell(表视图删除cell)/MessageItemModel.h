//
//  MessageItemModel.h


#import <Foundation/Foundation.h>


@interface MessageItemModel : NSObject

@property (nonatomic, copy) NSString *send_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithModel;

@end


