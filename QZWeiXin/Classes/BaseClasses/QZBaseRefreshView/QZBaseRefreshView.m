//
//  QZBaseRefreshView.m
//  QZWeiXin
//
//  Created by 000 on 17/11/21.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZBaseRefreshView.h"

NSString *const kQZBaseRefreshViewObserveKeyPath = @"contentOffset";

@implementation QZBaseRefreshView

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [scrollView addObserver:self forKeyPath:kQZBaseRefreshViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:kQZBaseRefreshViewObserveKeyPath];
    }
}

- (void)endRefreshing
{
    self.refreshState = QZWXRefreshViewStateNormal;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //子类实现
}

@end
