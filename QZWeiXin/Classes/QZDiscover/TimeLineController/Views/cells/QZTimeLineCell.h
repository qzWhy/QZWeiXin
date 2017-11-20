//
//  QZTimeLineCell.h
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QZTimeLineCellModel;

@interface QZTimeLineCell : UITableViewCell

@property (nonatomic, strong) QZTimeLineCellModel *model;


@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^moreButtonClickBlock)(NSIndexPath *indexPath);

@end
