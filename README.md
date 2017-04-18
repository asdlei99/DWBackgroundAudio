# DWBackgroundAudio
# 音频背景

---
    pod 'DWBackgroundAudio'
    
![示例图](https://github.com/dwanghello/DWBackgroundAudio/blob/master/视频背景.gif)

    DWBackgroundAudio *back1 = [DWBackgroundAudio
     backgroundAudioCGRect:self.view.bounds 
     FillType:0 
     URLPath:[NSURL fileURLWithPath:[[NSBundle mainBundle]
      pathForResource:@"video.mp4" ofType:nil]]];    
    [self.view addSubview:back1];

