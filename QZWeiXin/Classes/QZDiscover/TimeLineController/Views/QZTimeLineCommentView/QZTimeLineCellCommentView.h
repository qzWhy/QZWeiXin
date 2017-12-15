//
//  QZTimeLineCellCommentView.h
//  QZWeiXin
//
//  Created by 000 on 17/12/15.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZTimeLineCellCommentView : UIView

- (void)setupWithLikeItmesArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);


@end
