//
//  RootViewController.m
//  VideoOrAudioPlayProgressView
//
//  Created by 李海群 on 2019/4/28.
//  Copyright © 2019 hsrd-hq. All rights reserved.
//

#import "RootViewController.h"
#import "PublicAudioPlayProgressView.h"


@interface RootViewController ()<PublicAudioPlayProgressViewDelegate>

/**
 上一曲
 */
@property (nonatomic, strong) UIButton *upPlayButton;

/**
 下一曲
 */
@property (nonatomic, strong) UIButton *downPlayButton;

/**
 播放暂停
 */
@property (nonatomic, strong) UIButton *playButton;

/**
 播放进度条
 */
@property (nonatomic, strong) PublicAudioPlayProgressView *playProgressView;

/**
 自定义播放时长
 */
@property (nonatomic, strong) NSTimer *playTimer;

/**
 总时间
 */
@property (nonatomic, assign) int totalTime;

/**
 当前播放进度
 */
@property (nonatomic, assign) int currentTime;

/**
 是否播放
 */
@property (nonatomic, assign) BOOL play;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认播放
    self.play = YES;
    
    //随机时间
    self.totalTime = [self randomTotalTime];
    
    //初始化定时器
    [self initTimer];
    
    //初始化UI
    [self initUI];
}

- (int) randomTotalTime
{
    //包括100，500
    return random() % (500 - 100 + 1) + 100;
}

- (void) initTimer
{
    [self.playTimer setFireDate:[NSDate date]];
}

- (NSTimer *)playTimer
{
    if (!_playTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timePlayCountdown) userInfo:@"playTimer" repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _playTimer = timer;
    }
    return _playTimer;
}

- (void) initUI{
    [self.view addSubview:self.upPlayButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.downPlayButton];
    [self.view addSubview:self.playProgressView];
}

- (UIButton *)playButton
{
    if (!_playButton) {
        CGFloat x = (KScreenWidth - [HelpTools adaptiveWithPx:144])/2.0f;
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(x, self.playProgressView.frame.size.height + self.playProgressView.frame.origin.y + [HelpTools adaptiveWithPx:70], [HelpTools adaptiveWithPx:144], [HelpTools adaptiveWithPx:144]);
        [_playButton setImage:[UIImage imageNamed:@"playPauseimg"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayAndPauseButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)upPlayButton
{
    if (!_upPlayButton) {
        CGFloat x = self.playButton.frame.origin.x - [HelpTools adaptiveWithPx:120];
        CGFloat y = self.playButton.frame.origin.y + [HelpTools adaptiveWithPx:22];
        _upPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upPlayButton.frame = CGRectMake(x, y, [HelpTools adaptiveWithPx:100], [HelpTools adaptiveWithPx:100]);
        [_upPlayButton setImageEdgeInsets:UIEdgeInsetsMake([HelpTools adaptiveWithPx:32.5], [HelpTools adaptiveWithPx:32.5], [HelpTools adaptiveWithPx:32.5], [HelpTools adaptiveWithPx:32.5])];
        [_upPlayButton setImage:[UIImage imageNamed:@"playUpItemImg"] forState:UIControlStateNormal];
        [_upPlayButton addTarget:self action:@selector(clickUpPlayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upPlayButton;
}

- (UIButton *)downPlayButton
{
    if (!_downPlayButton) {
        CGFloat x = self.playButton.frame.origin.x + self.playButton.frame.size.width + [HelpTools adaptiveWithPx:20];
        CGFloat y = self.playButton.frame.origin.y + [HelpTools adaptiveWithPx:22];
        _downPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downPlayButton.frame = CGRectMake(x, y, [HelpTools adaptiveWithPx:100], [HelpTools adaptiveWithPx:100]);
        [_downPlayButton setImageEdgeInsets:UIEdgeInsetsMake([HelpTools adaptiveWithPx:32.5], [HelpTools adaptiveWithPx:32.5], [HelpTools adaptiveWithPx:32.5], [HelpTools adaptiveWithPx:32.5])];
        [_downPlayButton setImage:[UIImage imageNamed:@"playDownItemImg"] forState:UIControlStateNormal];
        [_downPlayButton addTarget:self action:@selector(clickDownPlayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downPlayButton;
}

- (PublicAudioPlayProgressView *)playProgressView
{
    if (!_playProgressView) {
        _playProgressView = [PublicAudioPlayProgressView publicAudioPlayProgressView:CGRectMake([HelpTools adaptiveWithPx:80], KScreenHeight/2 - [HelpTools adaptiveWithPx:200], KScreenWidth - [HelpTools adaptiveWithPx:160], [HelpTools adaptiveWithPx:48])];
        _playProgressView.delegate = self;
    }
    return _playProgressView;
}

//MARK:        -------------点击播放暂停按钮
- (void) clickPlayAndPauseButton
{
    if (self.play) {
        self.play = NO;
        [self.playTimer setFireDate:[NSDate distantFuture]];
        [self.playButton setImage:[UIImage imageNamed:@"playPlayimg"] forState:UIControlStateNormal];
    } else {
        self.play = YES;
        [self.playTimer setFireDate:[NSDate date]];
        [self.playButton setImage:[UIImage imageNamed:@"playPauseimg"] forState:UIControlStateNormal];
    }
}

//MARK:        -------------点击上一曲按钮
- (void) clickUpPlayButton
{
    self.currentTime = 0.1;
    self.totalTime = [self randomTotalTime];
}

//MARK:        -------------点击下一曲按钮
- (void) clickDownPlayButton
{
    self.currentTime = 0.1;
    self.totalTime = [self randomTotalTime];
}

//MARK:        -------------改变播放进度
- (void)changePlayTimeByPublicAudioPlayProgressView:(int)playCount
{
    self.currentTime = playCount;
}

//MARK:        -------------定时器调用方法
- (void) timePlayCountdown
{
    self.currentTime ++;
    if (self.currentTime >= self.totalTime) {
        self.currentTime = 0.1;
        self.totalTime = [self randomTotalTime];
    }
    [self.playProgressView changePlayProgress:self.currentTime totalLength:self.totalTime];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
