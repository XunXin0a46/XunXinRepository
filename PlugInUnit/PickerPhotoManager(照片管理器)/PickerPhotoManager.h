//
//  PickerPhotoManager.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

//媒体选择类型
typedef enum : NSUInteger {
    MediaSelectType_Photo = 1,//照片
    MediaSelectType_Camera = 2//相机
} MediaSelectType;

@interface PickerPhotoManager : NSObject

///选择拍照或相册
+ (void)openImagePickerViewController:(void (^)(NSArray <UIImage *> *imgs,MediaSelectType type))comp;

///开启扫码
+ (BOOL)showCameraScanning ;

///开启录音的alert
+ (void)showVoiceAlert;

@end

