//
//  ScanViewController.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/2/6.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "StandardScanView.h"


@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) StandardScanView *scanView;

@end

