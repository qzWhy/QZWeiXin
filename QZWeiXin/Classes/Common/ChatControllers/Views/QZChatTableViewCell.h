//
//  QZChatTableViewCell.h
//  QZWeiXin
//
//  Created by 000 on 17/11/15.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZChatModel.h"
#import "MLEmojiLabel.h"

@interface QZChatTableViewCell : UITableViewCell

@property (nonatomic, strong) QZChatModel *model;

@property (nonatomic, copy) void (^didSelectLinkTextOprationBlock)(NSString *link, MLEmojiLabelLinkType type);


@end
