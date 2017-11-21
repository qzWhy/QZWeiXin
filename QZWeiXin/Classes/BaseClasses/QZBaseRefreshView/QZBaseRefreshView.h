//
//  QZBaseRefreshView.h
//  QZWeiXin
//
//  Created by 000 on 17/11/21.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN    NSString *const kQZBaseRefreshViewObserverKeyPath;

typedef enum {
    QZWXRefreshViewStateNormal,
    QZWXRefreshViewStateWillRefresh,
    QZWXRefreshViewStateRefreshing,
} QZWXRefreshViewState;


@interface QZBaseRefreshView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)endRefreshing;

@property (nonatomic, assign) UIEdgeInsets scrollViewOrighinalInsets;
@property (nonatomic, assign) QZWXRefreshViewState refreshState;

@end
