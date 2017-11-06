//
//  QZHomeTableViewCell.m
//  QZWeiXin
//
//  Created by 000 on 17/11/6.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZHomeTableViewCell.h"

#define kDeleteButtonWidth      60.0f
#define kTagButtomWidth         100.0f
#define kCriticalTranslationX   30
#define kShouldSlideX           -2

@interface QZHomeTableViewCell ()

@property (nonatomic, assign) BOOL isSlided;

@end

@implementation QZHomeTableViewCell
{
    UIButton *_deleteButton;
    UIButton *_tagButton;
    
    UIPanGestureRecognizer *_pan;
    UITapGestureRecognizer *_tap;
    
    BOOL _shouldSlide;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
