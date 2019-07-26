//
//  ViewController.m
//  MoviePlay
//
//  Created by 张奥 on 2019/7/26.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import "ViewController.h"
#import "MovieDownLoadManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ZAPlayView.h"
@interface ViewController ()
@property (strong, nonatomic) AVPlayer *avPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [[MovieDownLoadManager shareManager] downLoadMovieWithUrl:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"] progressBlock:^(CGFloat progress) {
//
//    } success:^(NSURL *URL) {
//
//    } fail:^(NSString *message) {
//
//    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, 100, 80, 80);
    [button setTitle:@"点我" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8.f;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}

-(void)clickButton:(UIButton*)button{
//    NSString *path = [MovieDownLoadManager filePath];
//
//    AVPlayerViewController *playVC = [[AVPlayerViewController alloc] init];
//    playVC.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
//    [self presentViewController:playVC animated:YES completion:nil];
    
//    //网络视频播放
//    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
//    NSURL *url = [NSURL URLWithString:playString];
//    //设置播放的项目
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
//    //初始化player对象
//    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
//    //设置播放页面
//    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
//    //设置播放页面的大小
//    layer.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 230);
//    layer.backgroundColor = [UIColor cyanColor].CGColor;
//    //设置播放窗口和当前视图之间的比例显示内容
//    //1.保持纵横比；适合层范围内
//    //2.保持纵横比；填充层边界
//    //3.拉伸填充层边界
//    /*
//     第1种AVLayerVideoGravityResizeAspect是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
//     第2种AVLayerVideoGravityResizeAspectFill是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了；
//     第3种AVLayerVideoGravityResize是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
//     */
//    layer.videoGravity = AVLayerVideoGravityResizeAspect;
//    //添加播放视图到self.view
//    [self.view.layer addSublayer:layer];
//    //视频播放
//    [self.avPlayer play];
//    //视频暂停
//    //[self.avPlayer pause];
    
    ZAPlayView *playView = [[ZAPlayView alloc] initWithFrame:self.view.bounds];
    playView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:playView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
