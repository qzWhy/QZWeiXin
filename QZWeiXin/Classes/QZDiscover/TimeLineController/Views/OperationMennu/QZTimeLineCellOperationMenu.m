//
//  QZTimeLineCellOperationMenu.m
//  QZWeiXin
//
//  Created by 000 on 17/11/22.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCellOperationMenu.h"

@implementation QZTimeLineCellOperationMenu

{
    UIButton *_likeButton;
    UIButton *_commentButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = QZColor(69, 74, 76, 1);
    
    _likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"AlbumLike"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self sd_addSubviews:@[_likeButton,_commentButton,centerLine]];
    
    CGFloat margin = 5;
    
    _likeButton.sd_layout
    .leftSpaceToView(self,margin)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(80);
    
    centerLine.sd_layout
    .leftSpaceToView(_likeButton,margin)
    .topEqualToView(_likeButton)
    .bottomEqualToView(_likeButton)
    .widthRatioToView(_likeButton,1);
    
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
    self.show = NO;
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            [self clearAutoWidthSettings];
            self.sd_layout
            .widthIs(0);
        } else {
            self.fixedWidth = nil;
            [self setupAutoWidthWithRightView:_commentButton rightMargin:5];
        }
        [self updateLayoutWithCellContentView:self.superview];
    }];
}

@end
