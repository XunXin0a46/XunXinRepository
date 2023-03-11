//
//  YSUBusiness.h
//  Common
//
//  Created by 宗仁 on 2016/12/13.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#ifndef YSUBusiness_h
#define YSUBusiness_h

#pragma mark - Regular pattern
#define PATTERN_PHONE @"^1[3|4|5|7|8][0-9]\\d{8}$"//^1(3|4|5|7|8)\\d{9}$
#define PATTERN_BARCODE @"^[0-9]*$"

#pragma mark - String function
#define YSUBUNDLE [NSBundle bundleWithIdentifier:@"com.68mall.Common"]
#define LOCALIZE(arg) [YSUBUNDLE localizedStringForKey:(arg) value:@"" table:nil]
#define LOCALIZE_FORMAT(format,arg,...) [NSString stringWithFormat:LOCALIZE(format),arg]

#endif /* YSUBusiness_h */
