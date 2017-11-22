//
//  QZTimeLineCellCommentView.h
//  QZWeiXin
//
//  Created by 000 on 17/11/22.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZTimeLineCellCommentView : UIView

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentsItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClickCommmentLabelBlock)(NSString *commentId,CGRect rectInWindow);


@end
