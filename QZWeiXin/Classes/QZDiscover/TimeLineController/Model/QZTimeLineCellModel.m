//
//  QZTimeLineCellModel.m
//  QZWeiXin
//
//  Created by 000 on 17/12/7.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCellModel.h"

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation QZTimeLineCellModel
{
    CGFloat _lastContentWidth;
}

@synthesize msgContent = _msgContent;

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    return _msgContent;
    
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end

@implementation QZTimeLineCellLikeItemModel


@end

@implementation QZTimeLineCellCommentItemModel


@end
