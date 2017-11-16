//
//  QZChatTableViewCell.m
//  QZWeiXin
//
//  Created by 000 on 17/11/15.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZChatTableViewCell.h"

@interface QZChatTableViewCell ()<MLEmojiLabelDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) MLEmojiLabel *label;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation QZChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _label = [MLEmojiLabel new];
    _label.delegate = self;
    _label.font = [UIFont systemFontOfSize:16.0f];
    _label.numberOfLines = 0;
    _label.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _label.isAttributedContent = YES;
    [_container addSubview:_label];
    
    _messageImageView = [UIImageView new];
    [_container addSubview:_messageImageView];
    
    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    
    _maskImageView = [UIImageView new];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    //设置containerBackgroundImageView填充父View
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setModel:(QZChatModel *)model
{
    _model = model;
    
    _label.text = model.text;
    self.iconImageView.image = [UIImage imageNamed:model.iconName];
    
    //根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:model];
}

- (void)setMessageOriginWithModel:(QZChatModel *)model
{
    
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
