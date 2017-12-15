//
//  QZTimeLineCellCommentView.m
//  QZWeiXin
//
//  Created by 000 on 17/12/15.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCellCommentView.h"
#import "MLLinkLabel.h"
#import "LEETheme.h"

@interface QZTimeLineCellCommentView ()<MLLinkLabelDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) MLLinkLabel *likeLabel;

@end

@implementation QZTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        
        //设置主题
        [self configTheme];
    }
    return self;
}

- (void)setupViews
{
    _bgImageView = [UIImageView new];
    //创建一个内容可拉伸的图片，需要两个参数，第一个是左边不拉伸区域宽度，第二个参数是上面不拉伸的高度
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : TimeLineCellHighlightedColor};
    _likeLabel.isAttributedContent = YES;
    [self addSubview:_likeLabel];
    
    _bgImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)configTheme{
    self.lee_theme
    .LeeAddBackgroundColor(DAY, [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT, [UIColor blackColor]);
    
    _bgImageView.lee_theme
    .LeeAddTintColor(DAY, QZColor(230, 230, 230, 1.0f))
    .LeeAddTintColor(NIGHT, QZColor(30, 30, 30, 1.0f));
    
    _likeLabel.lee_theme
    .LeeAddTextColor(DAY, [UIColor blackColor])
    .LeeAddTextColor(NIGHT, [UIColor grayColor]);
    
    
}

- (void)setupWithLikeItmesArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    
}


@end
