//
//  SRAudioRecorderManager.m
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRAudioRecorderManager.h"
#import "SRAudioRecordToastManager.h"

NSString * const SRAudioRecorderManagerDidFinishRecordingNotification = @"SRAudioRecorderManagerDidFinishRecordingNotification";

@interface SRAudioRecorderManager() <AVAudioRecorderDelegate>

@property (nonatomic, copy) NSString *audioFilePath;

@property (nonatomic, strong, readwrite) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) NSTimer *recordingTimer;

@property (nonatomic, assign, readwrite) NSTimeInterval recordingDuration;

@end

@implementation SRAudioRecorderManager

+ (instancetype)sharedManager {
    static SRAudioRecorderManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _maxDuration = 60;
        _minDuration = 3;
        _showCountdownPoint = 10;
    }
    return self;
}

- (NSString *)audioFilePath {
    if (!_audioFilePath) {
        NSString *cachesDirectoryth = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _audioFilePath = [cachesDirectoryth stringByAppendingPathComponent:@"sr_audio_recording.m4a"];
    }
    return _audioFilePath;
}

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
        setting[AVSampleRateKey] = @(8000);
        setting[AVNumberOfChannelsKey] = @(1);
        setting[AVLinearPCMBitDepthKey] = @(16);
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.audioFilePath] settings:setting error:&error];
        if (error) {
            NSLog(@"AVAudioRecorder init error: %@", error);
        }
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder prepareToRecord];
    }
    return _audioRecorder;
}

- (void)startRecording {
    if (![self isAudioAuthorized]) {
        if ([self.delegate respondsToSelector:@selector(audioRecorderManagerAVAuthorizationStatusDenied)]) {
            [self.delegate audioRecorderManagerAVAuthorizationStatusDenied];
        }
        return;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.audioRecorder record];
    [self startRecordingTimer];
}

- (void)stopRecording {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
        if (self.recordingDuration < self.minDuration || self.audioRecorderState == SRAudioRecorderStateCancel) {
            if ([self.audioRecorder deleteRecording]) {
                NSLog(@"deleteRecording");
            }
        }
        [self stopRecordingTimer];
    }
}

- (void)startRecordingTimer {
    if (_recordingTimer) {
        [_recordingTimer invalidate];
        _recordingTimer = nil;
    }
    _recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(recordingTimerAction:)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopRecordingTimer {
    if (_recordingTimer) {
        [_recordingTimer invalidate];
        _recordingTimer = nil;
    }
}

- (void)recordingTimerAction:(NSTimer *)timer {
    self.recordingDuration += timer.timeInterval;
    NSLog(@"duration %f", self.recordingDuration);
    if (self.maxDuration - self.recordingDuration == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SRAudioRecorderManagerDidFinishRecordingNotification object:nil];
        [self stopRecording];
        [self stopRecordingTimer];
        self.audioRecorderState = SRAudioRecorderStateNormal;
    } else if ([self shouldShowCountdown]) {
        self.audioRecorderState = SRAudioRecorderStateCountdown;
    } else {
        [[SRAudioRecorderManager sharedManager].audioRecorder updateMeters];
        float level = 0.0f;
        float minDecibels = -80.0f;
        float decibels = [[SRAudioRecorderManager sharedManager].audioRecorder peakPowerForChannel:0];
        if (decibels < minDecibels) {
            level = 0.0f;
        } else if (decibels >= 0.0f) {
            level = 1.0f;
        } else {
            float root            = 2.0f;
            float minAmp          = powf(10.0f, 0.05f * minDecibels);
            float inverseAmpRange = 1.0f / (1.0f - minAmp);
            float amp             = powf(10.0f, 0.05f * decibels);
            float adjAmp          = (amp - minAmp) * inverseAmpRange;
            level                 = powf(adjAmp, 1.0f / root);
        }
        [[SRAudioRecordToastManager sharedManager] updateAudioPower:level];
    }
}

- (BOOL)shouldShowCountdown {
    if (self.audioRecorderState == SRAudioRecorderStateReleaseToCancel) {
        return NO;
    }
    if (self.recordingDuration >= (self.maxDuration - self.showCountdownPoint)) {
        return YES;
    }
    return NO;
}

- (BOOL)isAudioAuthorized {
    __block BOOL isAudioAuthorized = YES;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                isAudioAuthorized = YES;
            } else {
                isAudioAuthorized = NO;
            }
        }];
    } else if (status == AVAuthorizationStatusAuthorized) {
        isAudioAuthorized = YES;
    } else {
        isAudioAuthorized = NO;
    }
    return isAudioAuthorized;
}

- (void)setAudioRecorderState:(SRAudioRecorderState)audioRecorderState {
    _audioRecorderState = audioRecorderState;
    
    [[SRAudioRecordToastManager sharedManager] updateUIWithRecorderState:audioRecorderState];
    
    if (audioRecorderState == SRAudioRecorderStateCountdown) {
        [[SRAudioRecordToastManager sharedManager] showCountdown:self.maxDuration - self.recordingDuration];
    } else if (audioRecorderState == SRAudioRecorderStateDurationTooShort) {
        [[SRAudioRecordToastManager sharedManager] showToastTips:@"录音时间太短了"];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.audioFilePath]) {
            if ([self.delegate respondsToSelector:@selector(audioRecorderManagerDidFinishRecordingSuccess:)]) {
                [self.delegate audioRecorderManagerDidFinishRecordingSuccess:self.audioFilePath];
            }
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(audioRecorderManagerDidFinishRecordingFailed)]) {
            [self.delegate audioRecorderManagerDidFinishRecordingFailed];
        }
    }
    self.recordingDuration = 0;
}

@end
