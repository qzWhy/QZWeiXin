//
//  QZShortVideoController.h
//  QZWeiXin
//
//  Created by 000 on 17/11/14.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZShortVideoController : UIViewController

- (void)show;
- (void)hidde;

@property (nonatomic, copy) void (^cancleOperationBlock)();

@property (nonatomic, assign, readonly) BOOL isRecordingVideo;



@end
