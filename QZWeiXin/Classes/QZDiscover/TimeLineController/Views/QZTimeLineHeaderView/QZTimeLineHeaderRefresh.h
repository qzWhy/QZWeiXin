//
//  QZTimeLineHeaderRefresh.h
//  QZWeiXin
//
//  Created by 000 on 17/11/21.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZBaseRefreshView.h"

@interface QZTimeLineHeaderRefresh : QZBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)();


@end
