//
//  QZTimeLineRefreshHeader.h
//  QZWeiXin
//
//  Created by 000 on 17/12/18.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZBaseRefreshView.h"
#import <UIKit/UIKit.h>

@interface QZTimeLineRefreshHeader : QZBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void (^refreshingBlock)();


@end
