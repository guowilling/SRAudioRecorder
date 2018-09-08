//
//  SRRecordingAudioPlayer.m
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRRecordingAudioPlayerManager.h"

@interface SRRecordingAudioPlayerManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer;

@end

@implementation SRRecordingAudioPlayerManager

+ (instancetype)sharedManager {
    static SRRecordingAudioPlayerManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // init setting
    }
    return self;
}

- (AVAudioPlayer *)playerWithFilePath:(NSString *)filePath {
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    _audioPlayer.delegate = self;
    return _audioPlayer;
}

- (AVAudioPlayer *)playerWithURL:(NSURL *)URL {
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    _audioPlayer.delegate = self;
    return _audioPlayer;
}

- (void)play {
    if (self.audioPlayer.prepareToPlay) {
        [self.audioPlayer play];
    }
}

- (void)pause {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
    }
}

- (void)stop {
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"audioPlayerDecodeErrorDidOccur error: %@", error);
}

@end
