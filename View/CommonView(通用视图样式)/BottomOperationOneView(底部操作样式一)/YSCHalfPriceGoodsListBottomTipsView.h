//
//  YSCHalfPriceGoodsListBottomTipsView.h
//  YiShopCustomer
//
//  Created by 王刚 on 2021/5/12.
//  Copyright © 2021 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCHalfPriceGoodsListBottomTipsViewModel : NSObject

@property(nonatomic, assign) CGFloat total_goods_amount;//第二件半价商品合计金额
@property(nonatomic, assign) NSInteger total_goods_num;//第二件半价商品合计数量(控制总金额下方的提示文案)
@property(nonatomic, copy) NSString *discount_num;//折扣数量
@property(nonatomic, copy) NSString *package_num;//享受折扣需要购买的商品数量

@end

@interface YSCHalfPriceGoodsListBottomTipsView : UIView

@property (nonatomic, strong) YSCHalfPriceGoodsListBottomTipsViewModel *halfPriceModel;//第二件半价模型

@end


