//
//  QZTimeLineCellModel.h
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QZTimeLineCellLikeItemModel,QZTimeLineCellCommentItemModel;

@interface QZTimeLineCellModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, assign, getter=isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<QZTimeLineCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<QZTimeLineCellCommentItemModel *> *commentItemsArray;
@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@end

@interface QZTimeLineCellLikeItemModel :NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attriutedContent;

@end

@interface QZTimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *recondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, copy) NSAttributedString *attributedContent;


@end
