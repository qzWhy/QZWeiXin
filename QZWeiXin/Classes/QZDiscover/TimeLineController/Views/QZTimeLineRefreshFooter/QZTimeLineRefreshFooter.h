//
//  QZTimeLineRefreshFooter.h
//  QZWeiXin
//
//  Created by 000 on 17/11/21.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZBaseRefreshView.h"

@interface QZTimeLineRefreshFooter : QZBaseRefreshView

+ (instancetype)refreshFooterWithRefreshText:(NSString *)text;

- (void)addToScrollView:(UIScrollView *)scrollView refreshOpration:(void(^)())refresh;

@property (nonatomic, strong) UILabel *indictorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, copy) void (^refreshBlock)();


@end
