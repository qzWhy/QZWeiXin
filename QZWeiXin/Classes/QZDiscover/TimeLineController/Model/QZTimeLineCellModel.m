//
//  QZTimeLineCellModel.m
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCellModel.h"

extern const CGFloat maxContentLabelSize;
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
        CGRect rextRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                                 attributes:@{[UIFont systemFontOfSize:contents]} context:<#(nullable NSStringDrawingContext *)#>]
    }
}
    
}

@end
