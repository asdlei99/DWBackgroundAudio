//
//  DWBackgroundAudio.h
//  DWBackgroundAudioDemo
//
//  Created by 四海全球 on 2017/3/25.
//  Copyright © 2017年 dwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VideoGravityResize,//拉伸填充层边界
    VideoGravityResizeAspect,//保持纵横比；适合层范围内
    VideoGravityResizeAspectFill,//保持纵横比；填充层边界
}FillType;

typedef void (^AudioTime)(float currentTime, float totalTime);

@interface DWBackgroundAudio : UIView

/** 当前播放时间/总时长 */
@property(nonatomic, copy) AudioTime audioTime;

/**
 *  初始化
 *
 *  @param rect     初始化尺寸
 *  @param fillType 填充方式
 *  @param urlPath  初始化视频位置
 */
+ (instancetype)backgroundAudioCGRect:(CGRect)rect FillType:(FillType)fillType URLPath:(NSURL *)urlPath;

/** 获取当前播放时间/总时长 */
- (void)getAudioTime:(AudioTime)audioTime;

@end
