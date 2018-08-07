//
//  SRRecordToastManager.h
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRAudioRecorderManager.h"

@interface SRAudioRecordToastManager : NSObject

+ (instancetype)sharedManager;

- (void)updateUIWithRecorderState:(SRAudioRecorderState)state;

- (void)updateAudioPower:(CGFloat)power;

- (void)showCountdown:(CGFloat)countdown;

- (void)showToastTips:(NSString *)msg;

@end
