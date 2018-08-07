//
//  SRAudioRecordToast.m
//  SRAudioRecorderDemo
//
//  Created by https://github.com/guowilling on 2018/8/2.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRAudioRecordToast.h"

@implementation SRAudioRecordToast

@end


@interface SRRecordToastRecording ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) SRRecordToastAudioPower *audioPower;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SRRecordToastRecording

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"SRAudioRecorder.bundle/ic_microphone"];
        [self addSubview:_iconImageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"手指上滑, 取消发送";
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:13.5];
        [self addSubview:_textLabel];
        
        _audioPower = [[SRRecordToastAudioPower alloc] init];
        [self addSubview:_audioPower];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake((self.frame.size.width * 0.5 - self.iconImageView.image.size.width),
                                          30,
                                          self.iconImageView.image.size.width,
                                          self.iconImageView.image.size.height);
    
    self.audioPower.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10,
                                       CGRectGetMaxY(self.iconImageView.frame) - self.iconImageView.image.size.height,
                                       30,
                                       self.iconImageView.image.size.height);
    
    self.textLabel.frame = CGRectMake(0,
                                      self.frame.size.height - 25 - 5,
                                      self.frame.size.width,
                                      25);
}

- (void)updateAudioPower:(CGFloat)power {
    [self.audioPower updatePower:power];
}

@end


@interface SRRecordToastAudioPower()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation SRRecordToastAudioPower

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"SRAudioRecorder.bundle/ic_record_volume"];
        [self addSubview:_iconImageView];
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = self.bounds;
    
    [self updatePower:0];
}

- (void)updatePower:(CGFloat)power {
    int itemCount = ceil(fabs(power) * 10);
    if (itemCount == 0) {
        itemCount = 1;
    }
    if (itemCount >= 9) {
        itemCount = 9;
    }
    CGFloat itemHeight = self.iconImageView.frame.size.height / 9;
    CGFloat maskPadding = itemHeight * itemCount;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0,
                                                                     self.iconImageView.frame.size.height,
                                                                     self.iconImageView.frame.size.width,
                                                                     -maskPadding)];
    self.maskLayer.path = path.CGPath;
    self.iconImageView.layer.mask = self.maskLayer;
}

@end


@interface SRRecordToastReleaseToCancel ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SRRecordToastReleaseToCancel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"SRAudioRecorder.bundle/ic_release_to_cancel"];
        [self addSubview:_iconImageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        _textLabel.text = @"松开手指, 取消发送";
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:13.5];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake((self.frame.size.width - self.iconImageView.image.size.width) * 0.5,
                                          30,
                                          self.iconImageView.image.size.width,
                                          self.iconImageView.image.size.height);
    
    self.textLabel.frame = CGRectMake(5, self.frame.size.height - 25 - 5, self.frame.size.width - 10, 25);
    self.textLabel.layer.cornerRadius = 2;
    self.textLabel.clipsToBounds = YES;
}

@end


@interface SRRecordToastCountdown ()

@property (nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SRRecordToastCountdown

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabel.font = [UIFont boldSystemFontOfSize:80];
        _countdownLabel.textColor = [UIColor whiteColor];
        [self addSubview:_countdownLabel];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"手指上滑, 取消发送";
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:13.5];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.countdownLabel sizeToFit];
    [self.countdownLabel setFrame:CGRectMake((self.frame.size.width - self.countdownLabel.frame.size.width) * 0.5,
                                             15,
                                             self.countdownLabel.frame.size.width,
                                             self.countdownLabel.frame.size.height)];
    
    self.textLabel.frame = CGRectMake(0,
                                      self.frame.size.height - 25 - 5,
                                      self.frame.size.width,
                                      25);
}

- (void)updateCountdown:(CGFloat)countdown {
    [self.countdownLabel setText:[NSString stringWithFormat:@"%d", (int)countdown]];
    [self setNeedsLayout];
}

@end

@interface SRRecordToastTips ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SRRecordToastTips

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"SRAudioRecorder.bundle/ic_record_too_short"];
        [self addSubview:_iconImageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:13.5];
        _textLabel.text = @"录音时间太短";
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    self.iconImageView.frame = CGRectMake((self.frame.size.width - self.iconImageView.image.size.width) * 0.5,
                                          30,
                                          self.iconImageView.image.size.width,
                                          self.iconImageView.image.size.height);
    
    self.textLabel.frame = CGRectMake(0,
                                      self.frame.size.height - 25 - 5,
                                      self.frame.size.width,
                                      25);
}

- (void)showMessage:(NSString *)msg {
    [self.textLabel setText:msg];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
