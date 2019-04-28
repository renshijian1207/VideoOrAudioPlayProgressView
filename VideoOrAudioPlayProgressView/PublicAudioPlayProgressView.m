//
//  PublicAudioPlayProgressView.m
//  ProjectFramework
//
//  Created by 李海群 on 2019/4/24.
//  Copyright © 2019 hsrd-hq. All rights reserved.
//

#import "PublicAudioPlayProgressView.h"
/*
 实现思路：
        已知：总播放时间totalT，当前播放时间t
                   视图总宽度totalW
                   播放显示时长视图宽度timeW
        可计算出 ：
                   播放时间视图移动总距离：totalW - timeW
                   每个时间单位移动的距离：(totalW - timeW)/totalT   moveW
 
        正常播放时：
                   传入当前播放时间及总时间：t/60 + t%60 totalT/60 + totalT%60 直接显示即可
                   时间视图位置x值改变：t*moveW
                   播放结束判断为: t = totalT
 
         移动滑块（显示时间视图）：doMoveAction:
                   获取移动距离 ： moveW = newCenter.x - recognizer.view.frame.size.width/2;
                   获取移动多少时间：
                           假设：移动距离为10 ，总距离为100，
                                      移动距离占总距离为0.1
                                      总时间为300秒
                           得出移动后的时间：0.1*300 = 30秒
                   传入播放器即可
 */

@interface PublicAudioPlayProgressView ()

@property (nonatomic, assign) CGRect tempFrame;

@property (nonatomic, strong) UILabel *playTimeLabel;

@property (nonatomic, strong) UIView *backGaryView;//背景视图

@property (nonatomic, strong) UIView *backLoadProgressView;//加载进度视图

@property (nonatomic, strong) UIView *backGreenView;//已播放进度颜色视图

@property (nonatomic, assign) CGFloat backViewY;

@property (nonatomic, assign) CGFloat backViewH;

@property (nonatomic, assign) CGFloat playTimeW;//时间视图宽度

@property (nonatomic, assign) int totalLength;

@end

@implementation PublicAudioPlayProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tempFrame = frame;
        self.backViewH = 3;
        self.backViewY = (self.tempFrame.size.height - 3)/2.0f;
        self.playTimeW = 88;
        [self addSubview:self.backGaryView];
        [self addSubview:self.backLoadProgressView];
        [self addSubview:self.backGreenView];
        [self addSubview:self.playTimeLabel];
    }
    return self;
}

- (UIView *)backGaryView
{
    if (!_backGaryView) {
        _backGaryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backViewY, self.tempFrame.size.width, self.backViewH)];
        _backGaryView.layer.masksToBounds = YES;
        _backGaryView.layer.cornerRadius = self.backViewH/2.0f;
        _backGaryView.backgroundColor = [UIColor lightGrayColor];
    }
    return _backGaryView;
}

- (UIView *)backLoadProgressView
{
    if (!_backLoadProgressView) {
        _backLoadProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backViewY, 0, self.backViewH)];
        _backLoadProgressView.layer.masksToBounds = YES;
        _backLoadProgressView.layer.cornerRadius = self.backViewH/2.0f;
        _backLoadProgressView.backgroundColor = [UIColor grayColor];
    }
    return _backLoadProgressView;
}

- (UIView *)backGreenView
{
    if (!_backGreenView) {
        _backGreenView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backViewY, 0, self.backViewH)];
        _backGreenView.layer.masksToBounds = YES;
        _backGreenView.layer.cornerRadius = self.backViewH/2.0f;
        _backGreenView.backgroundColor = [UIColor blueColor];
    }
    return _backGreenView;
}

- (UILabel *)playTimeLabel
{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.playTimeW, self.tempFrame.size.height)];
        _playTimeLabel.font = FontSemibold(12);
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.text = @"00:00/00:00";
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.backgroundColor = [UIColor blueColor];
        _playTimeLabel.layer.masksToBounds = YES;
        _playTimeLabel.layer.cornerRadius = self.tempFrame.size.height / 2.0f;
        
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(doMoveAction:)];
        _playTimeLabel.userInteractionEnabled = YES;
        [_playTimeLabel addGestureRecognizer:panGestureRecognizer];
    }
    return _playTimeLabel;
}

-(void)doMoveAction:(UIPanGestureRecognizer *)recognizer{
    
    
    // Figure out where the user is trying to drag the view.
    
    CGPoint translation = [recognizer translationInView:self];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                    recognizer.view.center.y + translation.y);
    //    限制屏幕范围：
    newCenter.y = MAX(recognizer.view.frame.size.height/2, recognizer.view.frame.size.width/2);
    newCenter.y = MIN(self.frame.size.height - recognizer.view.frame.size.height/2, recognizer.view.frame.size.width/2);
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self];
    
    CGRect greenRect = self.backGreenView.frame;
    greenRect.size.width = newCenter.x;
    self.backGreenView.frame = greenRect;
    
    CGFloat totalW = self.tempFrame.size.width - self.playTimeW;
    CGFloat moveW = newCenter.x - recognizer.view.frame.size.width/2;
    int moveX = moveW/totalW*self.totalLength;
    
    if ([self.delegate respondsToSelector:@selector(changePlayTimeByPublicAudioPlayProgressView:)]) {
        [self.delegate changePlayTimeByPublicAudioPlayProgressView:moveX];
    }
}

- (void)changeCanPlayAbleProgress:(int)progressFloat totalLength:(int)totalCount
{
    if (progressFloat <= 0) {
        return;
    }
    if (totalCount <= 0) {
        return;
    }
    self.totalLength = totalCount;
    CGFloat moveX = (self.tempFrame.size.width - self.playTimeW)/totalCount;
    CGRect greenRect = self.backLoadProgressView.frame;
    greenRect.origin.x = moveX*progressFloat;
    self.backLoadProgressView.frame = greenRect;
}

- (void)changePlayProgress:(int)progressFloat totalLength:(int)totalCount
{
    if (progressFloat <= 0) {
        return;
    }
    if (totalCount <= 0) {
        return;
    }
    self.totalLength = totalCount;
    NSString *strShowTime = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",progressFloat/60,progressFloat%60,totalCount/60,totalCount%60];
    CGFloat moveX = (self.tempFrame.size.width - self.playTimeW)/totalCount;
    CGRect timeRect = self.playTimeLabel.frame;
    timeRect.origin.x = moveX*progressFloat;
    self.playTimeLabel.frame = timeRect;
    
    CGRect greenRect = self.backGreenView.frame;
    greenRect.size.width = timeRect.origin.x;
    self.backGreenView.frame = greenRect;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strShowTime];
    [attStr addAttribute:NSForegroundColorAttributeName value:[[UIColor whiteColor] colorWithAlphaComponent:0.7] range:NSMakeRange(5, attStr.length - 5)];
    self.playTimeLabel.attributedText = attStr;
}

+ (instancetype)publicAudioPlayProgressView:(CGRect)frame
{
    PublicAudioPlayProgressView *view = [[PublicAudioPlayProgressView alloc] initWithFrame:frame];
    return view;
}

@end
