//
//  QZTimeLineCell.h
//  QZWeiXin
//
//  Created by 000 on 17/12/7.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZTimeLineCellDelegate <NSObject>

- (void)didClickLinkButtonInCell:(UITableViewCell *)cell;
@end
@class QZTimeLineCellModel;
@interface QZTimeLineCell : UITableViewCell

@property (nonatomic, weak) id<QZTimeLineCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) QZTimeLineCellModel *model;

@property (nonatomic, copy) void(^moreButtonClickedBlock)(NSIndexPath *indexPath);


@end
