//
//  QZTimeLineHeaderRefresh.m
//  QZWeiXin
//
//  Created by 000 on 17/11/21.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineHeaderRefresh.h"

static  const CGFloat criticalY = -60.0f;

#define kQZTimeLineRefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation QZTimeLineHeaderRefresh
{
    CABasicAnimation *_rotateAnimation;
}

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center
{
    QZTimeLineHeaderRefresh *header = [QZTimeLineHeaderRefresh new];
    header.center = center;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    self.bounds = imageView.bounds;
    [self addSubview:imageView];
    
    _rotateAnimation = [[CABasicAnimation alloc] init];
    _rotateAnimation.keyPath = @"transform.rotation.z";
    _rotateAnimation.fromValue = @0;
    _rotateAnimation.toValue = @(M_PI * 2);
    _rotateAnimation.duration = 1.0;
    _rotateAnimation.repeatCount = MAXFLOAT;
}

- (void)setRefreshState:(QZWXRefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    if (refreshState == QZWXRefreshViewStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self.layer addAnimation:_rotateAnimation forKey:kQZTimeLineRefreshHeaderRotateAnimationKey];
    } else if (refreshState == QZWXRefreshViewStateNormal) {
        [self.layer removeAnimationForKey:kQZTimeLineRefreshHeaderRotateAnimationKey];
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
