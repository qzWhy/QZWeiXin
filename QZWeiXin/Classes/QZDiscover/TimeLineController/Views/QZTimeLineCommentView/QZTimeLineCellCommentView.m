//
//  QZTimeLineCellCommentView.m
//  QZWeiXin
//
//  Created by 000 on 17/11/22.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCellCommentView.h"
#import "LEETheme.h"
#import "MLLinkLabel.h"
#import "QZTimeLineCellModel.h"

@interface QZTimeLineCellCommentView ()

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) MLLinkLabel *likeLabel;

@property (nonatomic, strong) UIView *likeLabelBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@end

@implementation QZTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        
        //设置主题
        [self comfigTheme];
    }
    return self;
}

- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : TimeLineCellHighlightedColor};
    _likeLabel.isAttributedContent = YES;
    [self addSubview:_likeLabel];
    
    _likeLabelBottomLine = [UIView new];
    [self addSubview:_likeLabelBottomLine];
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)comfigTheme
{
    self.lee_theme
    .LeeAddBackgroundColor(DAY,[UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT,[UIColor blackColor]);
    
    _bgImageView.lee_theme
    .LeeAddTintColor(DAY,QZColor(230, 230, 230, 1.0f))
    .LeeAddTintColor(NIGHT,QZColor(30, 30, 30, 1.0f));
    
    _likeLabel.lee_theme
    .LeeAddTextColor(DAY,[UIColor blackColor])
    .LeeAddTextColor(NIGHT,[UIColor grayColor]);
    
    _likeLabelBottomLine.lee_theme
    .LeeAddBackgroundColor(DAY, QZColor(210, 210, 210, 1.0f))
    .LeeAddBackgroundColor(NIGHT, QZColor(60, 60, 60, 1.0f));
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ?(commentItemsArray.count - originalLabelsCount) : 0;
    
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = TimeLineCellHighlightedColor;
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.lee_theme
        .LeeAddTextColor(DAY, [UIColor blackColor])
        .LeeAddTextColor(NIGHT, [UIColor grayColor]);
        
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < commentItemsArray.count; i ++) {
        QZTimeLineCellCommentItemModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
        }
        label.attributedText = model.attributedContent;
    }
}

- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeItemsArray.count; i++) {
        QZTimeLineCellLikeItemModel *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
        }
        if (!model.attriutedContent) {
            model.attriutedContent = [self generateAttributedStringWithLikeItemModel:model];
        }
        [attributedText appendAttributedString:model.attriutedContent];
    }
    _likeLabel.attributedText = [attributedText copy];
}

- (NSArray *)commentItemsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
        
    }
    return _commentLabelsArray;
}

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentsItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentItemsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES;//重用时先隐藏所有评论label，然后根据评论个数显示label
        }];
    }
    
    if (!commentItemsArray.count && !likeItemsArray.count) {
        self.fixedWidth = @(0);//如果没有评论或者点赞，设置commentView的固定宽度为0（设置了fixedwith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0);//如果没有评论或点赞，设置commentView的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil;//取消固定宽度约束
        self.fixedWidth = nil;//取消固定高度约束
    }
    
    CGFloat margin = 5;
    
    UIView *lastTopView = nil;
    
    if (likeItemsArray.count) {
        _likeLabel.sd_resetLayout
        .leftSpaceToView(self,margin)
        .rightSpaceToView(self,margin)
        .topSpaceToView(lastTopView,10)
        .autoHeightRatio(0);
        
        lastTopView = _likeLabel;
    } else {
        _likeLabel.attributedText = nil;
        _likeLabel.sd_resetLayout
        .heightIs(0);
    }
    
    if (self.commentItemsArray.count && self.likeItemsArray.count) {
        _likeLabelBottomLine.sd_resetLayout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .heightIs(0);
    }
}

#pragma mark - parivate actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(QZTimeLineCellCommentItemModel *)model
{
    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@",model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",model.commentString]];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName :model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    
    if (model.secondUserName) {
        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(QZTimeLineCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *hightLightColor = [UIColor blueColor];;
    [attString setAttributes:@{NSForegroundColorAttributeName : hightLightColor , NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    return attString;
}

@end
