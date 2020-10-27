//
//  BarcodeAndQrCodeViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/13.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "BarcodeAndQrCodeViewController.h"
#import "UIImage+YSCCodeImage.h"

@interface BarcodeAndQrCodeViewController ()

@end

@implementation BarcodeAndQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"条形二维码"];
    //创建条码视图
    [self createBarcodeView];
    //创建二维码视图
    [self createQrCodView];
}

///创建条码视图
- (void)createBarcodeView{
    //条码宽高
    CGFloat BarImageWidth = SCREEN_WIDTH - 120;
    CGFloat BarImageHeight = 70;
    //初始化条码视图
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 80, BarImageWidth, BarImageHeight)];
    barImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:barImageView];
    [barImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self.view).offset (-(BarImageHeight / 2) - 20);
        make.centerX.equalTo (self.view.mas_centerX);
        make.size.mas_equalTo (CGSizeMake(BarImageWidth, BarImageHeight));
    }];
    //设置条码
    UIImage *barImage = [UIImage barcodeImageWithContent:@"361599980595002151"
    codeImageSize:CGSizeMake(BarImageWidth, BarImageHeight)
                                                     red:0.1
                                                   green:0.1
                                                    blue:0.1];
    barImageView.image = barImage;
}

///创建二维码视图
- (void)createQrCodView{
    //二维码的宽
    CGFloat QrCodeWidth = SCREEN_WIDTH - 120;
    //初始化二纬码视图
    UIImageView *qrCodeImageView = [[UIImageView alloc] init];
    qrCodeImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self.view).offset (((QrCodeWidth - 80) / 2 ) + 20);
        make.centerX.equalTo (self.view);
        make.size.mas_equalTo (CGSizeMake(QrCodeWidth - 80, QrCodeWidth - 80));
    }];
    //设置二维码
    UIImage *qrCodeImage = [UIImage qrCodeImageWithContent:@"361599980595002151"
                                             codeImageSize:QrCodeWidth - 70
                                                      logo:nil
                                                 logoFrame:CGRectZero
                                                       red:0.2f
                                                     green:0.2f
                                                      blue:0.2f];
    qrCodeImageView.image = qrCodeImage;
}
@end
