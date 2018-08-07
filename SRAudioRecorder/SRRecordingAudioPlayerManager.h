//
//  SRRecordingAudioPlayer.h
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SRRecordingAudioPlayerManager : NSObject

+ (instancetype)sharedManager;

- (AVAudioPlayer *)playerWithFilename:(NSString *)filename;
- (AVAudioPlayer *)playerWithFilePath:(NSString *)filePath;
- (AVAudioPlayer *)playerWithURL:(NSURL *)URL;

- (void)play;
- (void)pause;
- (void)stop;

@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;

@end
