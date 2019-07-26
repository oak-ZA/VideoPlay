//
//  ZAPlayView.m
//  MoviePlay
//
//  Created by 张奥 on 2019/7/26.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import "ZAPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#define SCREEN_Width [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height [UIScreen mainScreen].bounds.size.height
@interface ZAPlayView()
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *nowLabel;
@property (nonatomic,strong) UILabel *remainLabel;
@property (nonatomic,assign) CGFloat totalTime;
@property (nonatomic) CGFloat fps;
@end
@implementation ZAPlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //播放器状态通知
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 監聽緩存進去，就是大傢所看到的一開始進去底部灰色的View會迅速加載
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        //是否播放完成
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        //旋转屏幕的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        [self addSubview:self.closeButton];
        [self addSubview:self.slider];
        [self addSubview:self.nowLabel];
        [self addSubview:self.remainLabel];
        [self.layer addSublayer:self.playerLayer];
        [self.player play];
        
    }
    return self;
}
-(UIButton*)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.bounds.size.width - 70, 44, 60, 60);
        [_closeButton setImage:[UIImage imageNamed:@"cancel_white_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
-(UISlider*)slider{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(60, (SCREEN_Height+250.f)/2.f + 10, SCREEN_Width - 120, 30.f)];
        _slider.minimumValue = 0.0;
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
-(UILabel*)nowLabel{
    if (!_nowLabel) {
        _nowLabel = [[UILabel alloc] init];
        _nowLabel.backgroundColor = [UIColor greenColor];
        _nowLabel.frame = CGRectMake(SCREEN_Width/2 - 70, (SCREEN_Height+250.f)/2.f + 40,60, 80);
        _nowLabel.textColor = [UIColor redColor];
        _nowLabel.textAlignment = NSTextAlignmentCenter;
        _nowLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _nowLabel;
}
-(UILabel*)remainLabel{
    if (!_remainLabel) {
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.backgroundColor = [UIColor greenColor];
        _remainLabel.frame = CGRectMake(SCREEN_Width/2 + 10, (SCREEN_Height+250.f)/2.f + 40, 60, 80);
        _remainLabel.textColor = [UIColor redColor];
        _remainLabel.textAlignment = NSTextAlignmentCenter;
        _remainLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _remainLabel;
}
-(void)clickCloseButton{
    [self.player pause];
    [self removeFromSuperview];
}
-(void)sliderChange:(UISlider *)slider{
    CMTime time = CMTimeMakeWithSeconds(slider.value, self.fps);
    self.nowLabel.text = [self convertToTime:slider.value];
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}
-(AVPlayerLayer*)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        // layer的填充屬性 和UIImageView的填充屬性類似
        // AVLayerVideoGravityResizeAspect 等比例拉伸，會留白
        // AVLayerVideoGravityResizeAspectFill // 等比例拉伸，會裁剪
        // AVLayerVideoGravityResize // 保持原有大小拉伸
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:_playerLayer];
    }
    return _playerLayer;
}
-(AVPlayer*)player{
    if (!_player) {
        _player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    }
    return _player;
}
-(AVPlayerItem*)playerItem{
    if (!_playerItem) {
        _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
        self.totalTime = CMTimeGetSeconds(_playerItem.asset.duration);
        self.fps = [[[_playerItem.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
        
    }
    return _playerItem;
}
#pragma mark ---   KVO监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
                //准备进行播放
            case AVPlayerItemStatusReadyToPlay:{
                self.slider.maximumValue = self.totalTime;
                [self initTimer];
            }
                break;
            case AVPlayerItemStatusUnknown:{
                
            }
                break;
                //播放失败
            case AVPlayerItemStatusFailed:{
                NSLog(@"播放失败");
            }
                break;
                
            default:
                break;
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }
}

-(void)onDeviceOrientationChange{
    
}
//播放结束
- (void)playDidFinished:(NSNotification *)notification{
    [self.player pause];
}
-(void)initTimer{
    __weak typeof(self) weakSelf = self;
    CMTime interval = self.totalTime > 60 ? CMTimeMake(1, 1) : CMTimeMake(1, 30);
    [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
       //当前时间
        CGFloat nowTime = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
        //总时间
        weakSelf.nowLabel.text = [weakSelf convertToTime:nowTime];
        weakSelf.remainLabel.text = [weakSelf convertToTime:(self.totalTime - nowTime)];
        weakSelf.slider.value = nowTime;
    }];
}
// sec 轉換成指定的格式
- (NSString *)convertToTime:(CGFloat)time{
    // 初始化格式對象
    NSDateFormatter *fotmmatter = [[NSDateFormatter alloc] init];
    // 根據是否大於1H，進行格式賦值
    if (time >= 3600){
        [fotmmatter setDateFormat:@"HH:mm:ss"];
    }else{
        [fotmmatter setDateFormat:@"mm:ss"];
    }
    // 秒數轉換成NSDate類型
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    // date轉字符串
    return [fotmmatter stringFromDate:date];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.player removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
@end
