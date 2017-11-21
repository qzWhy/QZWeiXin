//
//  QZTimeLineRefreshFooter.m
//  QZWeiXin
//
//  Created by 000 on 17/11/21.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineRefreshFooter.h"

#define kQZTimeLineRefreshFooterHeight 50
@implementation QZTimeLineRefreshFooter

+ (instancetype)refreshFooterWithRefreshText:(NSString *)text
{
    QZTimeLineRefreshFooter *footer = [QZTimeLineRefreshFooter new];
    footer.indictorLabel.text = text;
    return footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)addToScrollView:(UIScrollView *)scrollView refreshOpration:(void (^)())refresh
{
    self.scrollView = scrollView;
    self.refreshBlock = refresh;
}

- (void)setupView
{
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    
    self.indictorLabel = [UILabel new];
    self.indictorLabel.textColor = [UIColor lightGrayColor];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator startAnimating];
    
    [containerView sd_addSubviews:@[self.indictorLabel,self.indicator]];
    
    containerView.sd_layout
    .heightIs(20)
    .centerYEqualToView(self)
    .centerXEqualToView(self);
    [containerView setupAutoWidthWithRightView:self rightMargin:0];//宽度自适应
    
    self.indicator.sd_layout
    .leftEqualToView(containerView)
    .topEqualToView(containerView);//ActiivityIndicatorView 宽高固定不用约束
    
    self.indictorLabel.sd_layout
    .leftSpaceToView(self.indicator,5)
    .topEqualToView(containerView)
    .bottomEqualToView(containerView);
    [self.indictorLabel setSingleLineAutoResizeWithMaxWidth:250];//label宽度自适应
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    
    [scrollView addSubview:self];
    self.hidden = YES;
}

- (void)endRefreshing
{
    [super endRefreshing];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentInset = self.scrollViewOrighinalInsets;
    }];
}

- (void)setRefreshState:(QZWXRefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == QZWXRefreshViewStateRefreshing) {
        self.scrollViewOrighinalInsets = self.scrollView.contentInset;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.bottom += kQZTimeLineRefreshFooterHeight;
        self.scrollView.contentInset = insets;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (keyPath != kQZBaseRefreshViewObserverKeyPath) {
        return;
    }
    if (self.scrollView.contentOffset.y > self.scrollView.contentSize.height - self.scrollView.height && self.refreshState!=QZWXRefreshViewStateRefreshing) {
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.width, kQZTimeLineRefreshFooterHeight);
        self.hidden = NO;
        self.refreshState = QZWXRefreshViewStateRefreshing;
    } else if (self.refreshState == QZWXRefreshViewStateNormal) {
        self.hidden = YES;
    }
}

@end
