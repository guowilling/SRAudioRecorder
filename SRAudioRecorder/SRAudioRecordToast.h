//
//  SRAudioRecordToast.h
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRAudioRecordToast : UIView

@end


@interface SRRecordToastRecording : SRAudioRecordToast

- (void)updateAudioPower:(CGFloat)power;

@end


@interface SRRecordToastAudioPower : SRAudioRecordToast

- (void)updatePower:(CGFloat)power;

@end


@interface SRRecordToastReleaseToCancel : SRAudioRecordToast

@end


@interface SRRecordToastCountdown : SRAudioRecordToast

- (void)updateCountdown:(CGFloat)countdown;

@end


@interface SRRecordToastTips : SRAudioRecordToast

- (void)showMessage:(NSString *)msg;

@end
