//
//  QZTimeLineCellOperationMenu.h
//  QZWeiXin
//
//  Created by 000 on 17/11/22.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZTimeLineCellOperationMenu : UIView

@property (nonatomic, assign,getter=isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();



@end
