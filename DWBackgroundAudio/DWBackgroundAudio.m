//
//  DWBackgroundAudio.m
//  DWBackgroundAudioDemo
//
//  Created by 四海全球 on 2017/3/25.
//  Copyright © 2017年 dwang. All rights reserved.
//

#import "DWBackgroundAudio.h"
#import <Foundation/Foundation.h>

@interface DWBackgroundAudio ()

/** 视图路径 */
@property(nonatomic, strong) NSURL *urlPath;

/** 填充方式 */
@property(nonatomic, assign) FillType fillType;

/** 播放器层 */
@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation DWBackgroundAudio

+ (instancetype)backgroundAudioCGRect:(CGRect)rect FillType:(FillType)fillType URLPath:(NSURL *)urlPath  {
    DWBackgroundAudio *backgroundAudio = [[self alloc] initWithFrame:rect];
    backgroundAudio.urlPath = urlPath;
    backgroundAudio.fillType = fillType;
    [backgroundAudio setupUI];
    return backgroundAudio;
}

-(void)dealloc{
    [self removeNotification];
}

#pragma mark - 私有方法
-(void)setupUI{
    
    switch (self.fillType) {
        case 0:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
        case 1:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case 2:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
    }
    self.playerLayer.frame = self.bounds;
    self.playerLayer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer addSublayer:self.playerLayer];
    [self.player play];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChange {
    NSLog(@"%ld", [[UIDevice currentDevice] orientation]);
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}

-(AVPlayer *)player{
    if (!_player) {
        _player=[AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:self.urlPath]];
        [self addProgressObserver];
        [self addNotification];
    }
    return _player;
}

#pragma mark - 通知
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

#pragma mark - 监控
-(void)addProgressObserver{
    __weak __typeof(self)weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.audioTime) {
            strongSelf.audioTime(CMTimeGetSeconds(time), CMTimeGetSeconds([strongSelf.player.currentItem duration]));
        }
    }];
}

- (void)getAudioTime:(AudioTime)audioTime {
    self.audioTime = ^(float currentTime, float totalTime) {
        audioTime(currentTime, totalTime);
    };
}



@end
