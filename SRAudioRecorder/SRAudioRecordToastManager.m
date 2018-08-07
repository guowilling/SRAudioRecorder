//
//  SRRecordToastManager.m
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRAudioRecordToastManager.h"
#import "SRAudioRecordToast.h"

@interface SRAudioRecordToastManager ()

@property (nonatomic, assign) SRAudioRecorderState currentAudioRecorderState;

@property (nonatomic, strong) UIView *toastContainer;
@property (nonatomic, strong) SRRecordToastRecording *recodingToast;
@property (nonatomic, strong) SRRecordToastReleaseToCancel *releaseToCancelToast;
@property (nonatomic, strong) SRRecordToastCountdown *countdownToast;

@property (nonatomic, strong) SRRecordToastTips *toastTips;

@end

@implementation SRAudioRecordToastManager

+ (instancetype)sharedManager {
    static SRAudioRecordToastManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (UIView *)toastContainer {
    if (!_toastContainer) {
        _toastContainer = [UIView new];
        _toastContainer.frame = CGRectMake(0, 0, 150, 150);
        _toastContainer.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        _toastContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _toastContainer.layer.cornerRadius = 5;
        _toastContainer.clipsToBounds = YES;
        
        _recodingToast = [[SRRecordToastRecording alloc] init];
        _releaseToCancelToast = [[SRRecordToastReleaseToCancel alloc] init];
        _countdownToast = [[SRRecordToastCountdown alloc] init];
        
        [_toastContainer addSubview:_recodingToast];
        [_toastContainer addSubview:_releaseToCancelToast];
        [_toastContainer addSubview:_countdownToast];
        
        _recodingToast.hidden = YES;
        _releaseToCancelToast.hidden = YES;
        _countdownToast.hidden = YES;
        
        _recodingToast.frame = _toastContainer.bounds;
        _releaseToCancelToast.frame = _toastContainer.bounds;
        _countdownToast.frame = _toastContainer.bounds;
    }
    return _toastContainer;
}

- (SRRecordToastTips *)toastTips {
    if (!_toastTips) {
        _toastTips = [SRRecordToastTips new];
        _toastTips.frame = CGRectMake(0, 0, 150, 150);
        _toastTips.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    }
    return _toastTips;
}

- (void)updateAudioPower:(CGFloat)power {
    if (self.currentAudioRecorderState != SRAudioRecorderStateRecording) {
        return;
    }
    [self.recodingToast updateAudioPower:power];
}

- (void)showCountdown:(CGFloat)countdown {
    if (self.currentAudioRecorderState != SRAudioRecorderStateCountdown) {
        return;
    }
    [self.countdownToast updateCountdown:countdown];
}

- (void)showToastTips:(NSString *)msg {
    if (self.toastTips.superview == nil) {
        [self.toastTips showMessage:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.toastTips removeFromSuperview];
        });
    }
}

- (void)updateUIWithRecorderState:(SRAudioRecorderState)state {
    self.currentAudioRecorderState = state;
    if (state == SRAudioRecorderStateNormal ||
        state == SRAudioRecorderStateDurationTooShort ||
        state == SRAudioRecorderStateCancel) {
        if (self.toastContainer.superview) {
            [self.toastContainer removeFromSuperview];
        }
    } else {
        if (!self.toastContainer.superview) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.toastContainer];
        }
        if (state == SRAudioRecorderStateRecording) {
            self.recodingToast.hidden = NO;
            self.releaseToCancelToast.hidden = YES;
            self.countdownToast.hidden = YES;
        } else if (state == SRAudioRecorderStateCountdown) {
            self.recodingToast.hidden = YES;
            self.releaseToCancelToast.hidden = YES;
            self.countdownToast.hidden = NO;
        } else if (state == SRAudioRecorderStateDurationTooShort) {
            self.recodingToast.hidden = YES;
            self.releaseToCancelToast.hidden = YES;
            self.countdownToast.hidden = YES;
        } else if (state == SRAudioRecorderStateReleaseToCancel) {
            self.recodingToast.hidden = YES;
            self.releaseToCancelToast.hidden = NO;
            self.countdownToast.hidden = YES;
        } 
    }
}

@end
