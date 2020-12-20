//
//  TestBaiDuRESTController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/3/24.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestBaiDuRESTController.h"
#import <AVFoundation/AVFoundation.h>

@interface TestBaiDuRESTController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation TestBaiDuRESTController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"百度REST"];
    [self playContent:@"中国加油"];
}

///---------------------------------------- 百度语音识别REST测试区域 ---------------------------------------

- (void)playContent:(NSString *)content{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[self requestBaiDuREST:content]] options:nil];
    AVPlayerItem *songitem = [[AVPlayerItem alloc] initWithAsset:asset];
    self.player = [[AVPlayer alloc] initWithPlayerItem:songitem];
    //播放音量
    self.player.volume = 1;
    //一个布尔值，指示播放机的音频输出是否被静音
    self.player.muted = NO;
    //添加观察者
    [songitem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

///观察者执行的函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            //开始播放当前项
            [self.player play];
        }
    }
}


///请求百度语音识别REST
- (NSString *)requestBaiDuREST:(NSString *)content{
    
    NSString *unencodedString = [self URLEncodedString:content];
    
    static NSString * const BaiduKey = @"LsbRMxbscnky63IXqfThXvwC5vk95Hnm";
    static NSString * const BaiduSpeechSecretKey = @"pnO3KvW2FGB649PsalbRFQDOMiTsYTvP";
    //路径
    NSURL *url = [[NSURL alloc]initWithString:@"https://aip.baidubce.com/oauth/2.0/token"];
    //可变URL加载请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    //设置要请求的路径
    [request setURL:url];
    //设置HTTP请求方式
    [request setHTTPMethod:@"POST"];
    //字符串格式化百度key与百度语音key
    NSString *valueStr = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@",BaiduKey,BaiduSpeechSecretKey];
    //返回一个NSData对象，该对象包含使用给定编码编码的接收器的表示形式。
    NSData *postData = [valueStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //设置请求主体
    [request setHTTPBody:postData];
    //纪录completionHandler代码块中的异常
    NSError __block *blockError = nil;
    //纪录completionHandler代码块中的数据
    NSData __block *blockdData = nil;
    //纪录completionHandler代码块中的响应对象
    NSURLResponse __block *URLResponse = nil;
    //使用初始值创建新的计数信号量。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        blockError = error;
        blockdData = data ;
        URLResponse = response;
        //信号量（递增）,唤醒线程
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    //等待（减少）信号量。阻塞线程
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //如果blockdData为nil说明发生了异常
    if (blockdData == nil) {
        NSLog(@"send request failed: %@", blockError);
    }else{
        //将blockdData以NSUTF8StringEncoding解析为字符串
        NSString *receiveStr = [[NSString alloc]initWithData:blockdData encoding:NSUTF8StringEncoding];
        //返回以NSUTF8StringEncoding编码NSData对象
        NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        //将datas转换为字典
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
        //如果字典中有access_token对应的值
        if([[jsonDict objectForKey:@"access_token"] length] > 0){
            //字符串格式化access_token对应的值
            NSString *valueStr = [NSString stringWithFormat:@"tex=%@&tok=%@&cuid=013473005841386&ctp=1&lan=zh",unencodedString,[jsonDict objectForKey:@"access_token"]];
            
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tsn.baidu.com/text2audio?%@",valueStr]]
                      completionHandler:^(NSData *data,
                                          NSURLResponse *response,
                                          NSError *error) {
                if(error != nil){
                    NSLog(@"发生异常了");
                }
                
              }] resume];
            //将这段字符串返回
            NSString *urlStr = [NSString stringWithFormat:@"https://tsn.baidu.com/text2audio?%@",valueStr];
            return urlStr;
        }
    }
    return nil;
}

///URL编码的字符串
- (NSString *)URLEncodedString:(NSString *)str{
    
    NSString *unencodedString = str;
    NSString *encodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return encodedString;
}

///URL解码字符串
- (NSString *)URLDecodedString:(NSString *)str{
    
    NSString *encodedString = str;
    NSString *decodedString = [encodedString stringByRemovingPercentEncoding];
    return decodedString;
}

///---------------------------------------- 百度语音识别REST测试区域结束 ------------------------------------

@end
