//
//  QZTimeLineCell.m
//  QZWeiXin
//
//  Created by 000 on 17/12/7.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCell.h"
#import "QZTimeLineCellModel.h"
#import "QZWeiXinPhotoContainerView.h"
#import "LEETheme.h"
const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定
@implementation QZTimeLineCell
{
    UIImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    QZWeiXinPhotoContainerView *_picContainerView;
    
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        
        //设置主题
        [self configTheme];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    _iconView = [UIImageView new];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithRed:(54/255.0) green:(71/255.0) blue:(121/255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight *3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [QZWeiXinPhotoContainerView new];
    
    NSArray *views = @[_iconView,_nameLabel,_contentLabel,_moreButton,_operationButton,_picContainerView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(contentView,margin+5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,margin)
    .rightSpaceToView(contentView,margin)
    .autoHeightRatio(0);
   
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);//已经在内部实现宽高自适应 所以不需要再设置宽高 ，top值是具体有无图片再setModel方法中设置
    
}

- (void)configTheme
{
    self.lee_theme
    .LeeAddBackgroundColor(DAY,[UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT,[UIColor blackColor]);
    
    _contentLabel.lee_theme
    .LeeAddTextColor(DAY, [UIColor blackColor])
    .LeeAddTextColor(NIGHT, [UIColor grayColor]);
    
//    _timeLabel.lee_theme
//    .LeeAddTextColor(DAY, [UIColor lightGrayColor])
//    .LeeAddTextColor(NIGHT, [UIColor grayColor]);
}

- (void)setModel:(QZTimeLineCellModel *)model
{
    _model = model;
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLabel.text = model.name;
    _contentLabel.text = model.msgContent;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    
    _picContainerView.sd_layout.topSpaceToView(_contentLabel,picContainerTopMargin);
    
    //设置cell高度自适应 这句话 必不可少
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:15];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}
#pragma mark - private actions
- (void)moreButtonClicked
{
    
}
- (void)operationButtonClicked
{
    
}

@end
