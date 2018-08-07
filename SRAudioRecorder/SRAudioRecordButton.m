//
//  SRAudioRecorderButton.m
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRAudioRecordButton.h"
#import "SRAudioRecorderManager.h"

@implementation SRAudioRecordButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchDragInside) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(touchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(touchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(touchDragExit) forControlEvents:UIControlEventTouchDragExit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRecorderManagerDidFinishRecording) name:SRAudioRecorderManagerDidFinishRecordingNotification object:nil];
}

- (void)setButtonStateNormal {
    if (self.currentTitle) {
        [self setTitle:@"按住 说话" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

- (void)setButtonStateRecording {
    if (self.currentTitle) {
        [self setTitle:@"松开 结束" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark -- Actions

// 手指按下开始录音
- (void)touchDown {
    if (self.recordButtonTouchDownBlock) {
        self.recordButtonTouchDownBlock(self);
    }
    [self setButtonStateRecording];
    [[SRAudioRecorderManager sharedManager] startRecording];
    [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateRecording;
}

// 手指按钮范围内抬起完成录音
- (void)touchUpInside {
    if ([SRAudioRecorderManager sharedManager].audioRecorderState == SRAudioRecorderStateNormal) {
        return;
    }
    if (self.recordButtonTouchUpInsideBlock) {
        self.recordButtonTouchUpInsideBlock(self);
    }
    [self setButtonStateNormal];
    if ([SRAudioRecorderManager sharedManager].recordingDuration < [SRAudioRecorderManager sharedManager].minDuration) {
        [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateDurationTooShort;
    } else {
        [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateNormal;
    }
    [[SRAudioRecorderManager sharedManager] stopRecording];
}

// 手指按钮范围外抬起取消录音
- (void)touchUpOutside {
    if ([SRAudioRecorderManager sharedManager].audioRecorderState == SRAudioRecorderStateNormal) {
        return;
    }
    if (self.recordButtonTouchUpOutsideBlock) {
        self.recordButtonTouchUpOutsideBlock(self);
    }
    [self setButtonStateNormal];
    [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateCancel;
    [[SRAudioRecorderManager sharedManager] stopRecording];
}

- (void)touchDragInside {
    if (self.recordButtonTouchDragInsideBlock) {
        self.recordButtonTouchDragInsideBlock(self);
    }
}

- (void)touchDragOutside {
    if (self.recordButtonTouchDragOutsideBlock) {
        self.recordButtonTouchDragOutsideBlock(self);
    }
}

// TouchDragOutside -> TouchDragInside
- (void)touchDragEnter {
    if ([SRAudioRecorderManager sharedManager].audioRecorderState == SRAudioRecorderStateNormal) {
        return;
    }
    if (self.recordButtonTouchDragEnterBlock) {
        self.recordButtonTouchDragEnterBlock(self);
    }
    
    if ([SRAudioRecorderManager sharedManager].recordingDuration >= ([SRAudioRecorderManager sharedManager].maxDuration - [SRAudioRecorderManager sharedManager].showCountdownPoint)) {
        [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateCountdown;
    } else {
        [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateRecording;
    }
}

// TouchDragInside -> TouchDragOutside
- (void)touchDragExit {
    if ([SRAudioRecorderManager sharedManager].audioRecorderState == SRAudioRecorderStateNormal) {
        return;
    }
    if (self.recordButtonTouchDragExitBlock) {
        self.recordButtonTouchDragExitBlock(self);
    }
    [SRAudioRecorderManager sharedManager].audioRecorderState = SRAudioRecorderStateReleaseToCancel;
}

- (void)audioRecorderManagerDidFinishRecording {
    [self setButtonStateNormal];
}

@end
