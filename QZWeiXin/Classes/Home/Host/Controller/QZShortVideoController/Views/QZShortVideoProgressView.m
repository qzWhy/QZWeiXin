//
//  QZShortVideoProgressView.m
//  QZWeiXin
//
//  Created by 000 on 17/11/14.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZShortVideoProgressView.h"

@implementation QZShortVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _progressLine = [UIView new];
    _progressLine.backgroundColor = Global_tintColor;
    [self addSubview:_progressLine];
}
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (progress >= 0 && progress <= 1.0) {
        [self updateProgressLineWithProgress:progress];
    }
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _progressLine.frame = self.bounds;
}

- (void)updateProgressLineWithProgress:(CGFloat)Progress
{
    if (_progressLine.width > self.width) {
        _progressLine.frame = self.bounds;
        _progressLine.transform = CGAffineTransformIdentity;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat x = MIN((1- Progress), 1);
        _progressLine.transform = CGAffineTransformMakeScale(x, 1);
        [_progressLine setNeedsDisplay];
    });
    
}

@end
