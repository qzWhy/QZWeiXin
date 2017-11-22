//
//  QZTimeLineCell.h
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableView *)cell;
- (void)didClickCommentButtonInCell:(UITableViewCell *)cell;

@end

@class QZTimeLineCellModel;

@interface QZTimeLineCell : UITableViewCell

@property (nonatomic, weak) id<QZTimeLineCellDelegate> delegate;

@property (nonatomic, strong) QZTimeLineCellModel *model;


@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^moreButtonClickBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);


@end
