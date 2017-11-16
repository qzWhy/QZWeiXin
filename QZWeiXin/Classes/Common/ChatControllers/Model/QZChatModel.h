//
//  QZChatModel.h
//  QZWeiXin
//
//  Created by 000 on 17/11/15.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    QZMessageTypeSendToOthers,
    QZMessageTyoeSendToMe
} QZMessageType;

@interface QZChatModel : NSObject

@property (nonatomic, assign) QZMessageType messageType;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *imageName;




@end
