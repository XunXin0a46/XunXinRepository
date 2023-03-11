//
//  UploadImageTableViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/11.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const UploadImageTableViewCellReuseIdentifier;

@protocol UploadImageDelegate <NSObject>

//上传图片
- (void)openImagePickerViewController;

//删除图片
- (void)deleteImageAction:(UIView *)sender;

@end

@interface UploadImageTableViewCell : UITableViewCell

@property (nonatomic, weak)id<UploadImageDelegate> delegate;

- (void)createDataArray;

@end

