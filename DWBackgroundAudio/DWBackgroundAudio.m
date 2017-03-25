//
//  DWBackgroundAudio.m
//  DWBackgroundAudioDemo
//
//  Created by 四海全球 on 2017/3/25.
//  Copyright © 2017年 dwang. All rights reserved.
//

#import "DWBackgroundAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface DWBackgroundAudio ()

/** 播放器对象 */
@property(nonatomic, strong) AVPlayer *player;

/** 视图路径 */
@property(nonatomic, strong) NSURL *urlPath;

/** 填充方式 */
@property(nonatomic, assign) FillType fillType;

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
     //创建播放器层
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    switch (self.fillType) {
        case 0:
            playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
            case 1:
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case 2:
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
    }
    playerLayer.frame=self.bounds;
    playerLayer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer addSublayer:playerLayer];
    [self.player play];
}

-(AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem];
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addNotification];
    }
    return _player;
}

-(AVPlayerItem *)getPlayItem{
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.urlPath];
    return playerItem;
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
