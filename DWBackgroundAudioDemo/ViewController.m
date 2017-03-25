//
//  ViewController.m
//  DWBackgroundAudioDemo
//
//  Created by 四海全球 on 2017/3/25.
//  Copyright © 2017年 dwang. All rights reserved.
//

#import "ViewController.h"
#import "DWBackgroundAudio.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //DWBackgroundAudio *back = [DWBackgroundAudio backgroundAudioCGRect:self.view.bounds FillType:0 URLPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ne-Yo-Closer.mp3" ofType:nil]]];
    
    DWBackgroundAudio *back1 = [DWBackgroundAudio backgroundAudioCGRect:self.view.bounds FillType:0 URLPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video.mp4" ofType:nil]]];
        
    //[self.view addSubview:back];
    [self.view addSubview:back1];
    [back1 getAudioTime:^(float currentTime, float totalTime) {
        
        NSLog(@"%.2f---%.2f", currentTime, totalTime);
        
    }];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/4, self.view.bounds.size.height-150, self.view.bounds.size.width/2, 55)];
    [button addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"啦啦啦" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    
}

- (void)Click {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"啦啦啦" message:@"啦啦啦啦啦啦啦" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"啦啦啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert willMoveToParentViewController:nil];
        [alert.view removeFromSuperview];
        [alert removeFromParentViewController];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
