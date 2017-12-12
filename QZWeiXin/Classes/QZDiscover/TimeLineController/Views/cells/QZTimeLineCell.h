//
//  QZTimeLineCell.h
//  QZWeiXin
//
//  Created by 000 on 17/12/7.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QZTimeLineCellModel;
@interface QZTimeLineCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) QZTimeLineCellModel *model;

@end
