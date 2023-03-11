//
//  UIPlaceHolderTextView.m
//  

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setPlaceholder:@""];
    
    [self setPlaceholderColor:[UIColor grayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

}

- (id)initWithFrame:(CGRect)frame{
    
    if((self = [super initWithFrame:frame])){
        //默认提示文本为空
        [self setPlaceholder:@""];
        //默认提示文本颜色
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        //设置键盘return键样式
        self.returnKeyType = UIReturnKeyDefault;
        //设置代理
        [super setDelegate:self];
        //监听文本改变事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
    
}

///文本改变事件
- (void)textChanged:(NSNotification *)notification{
    
    //文本改变时判断文本视图中是否有提示语
    if([[self placeholder] length] == 0){
        
        return;
        
    }
    //如果没有输入文本
    if([[self text] length] == 0){
        //显示文本视图中的提示语
        [[self viewWithTag:999] setAlpha:1];
        
    }else{
        //隐藏文本视图中的提示语
        [[self viewWithTag:999] setAlpha:0];
        
    }
    
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}

- (void)drawRect:(CGRect)rect{
    
    if( [[self placeholder] length] > 0 ){
        //设置文本提示标签
        if (self.placeHolderLabel == nil ){
            
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,5,self.bounds.size.width - 16,0)];
            self.placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping ;
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.textColor = self.placeholderColor;
            self.placeHolderLabel.alpha = 0;
            self.placeHolderLabel.tag = 999;
            [self addSubview:self.placeHolderLabel];
            
        }
        
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
        
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 ){
        
        [[self viewWithTag:999] setAlpha:1];
        
    }
    [super drawRect:rect];
    
}

///隐藏键盘，实现UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        NSLog(@"aa");
        
        return NO;
    }
    
    return YES;
    
}

@end
