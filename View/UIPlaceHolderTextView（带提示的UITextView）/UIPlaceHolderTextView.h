//
//  UIPlaceHolderTextView.h
//  

#import <UIKit/UIKit.h>


@interface UIPlaceHolderTextView : UITextView<UITextViewDelegate>

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;
@property(nonatomic, strong) NSIndexPath *indexPath;

-(void)textChanged:(NSNotification*)notification;

@end


