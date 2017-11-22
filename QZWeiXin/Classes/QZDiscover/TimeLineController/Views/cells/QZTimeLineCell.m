//
//  QZTimeLineCell.m
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineCell.h"
#import "QZTimeLineCellModel.h"
#import "LEETheme.h"
#import "QZTimeLineCellOperationMenu.h"
const CGFloat contentLabelFoneSize = 15;
CGFloat maxContentLabelHeight = 0;//根据具体font而定

NSString *const kQZTImeLineCellOperationButtonClickedNotification = @"QZTimeLineCellOperationButtonClickedNotification";

@implementation QZTimeLineCell
{
    UIImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    
    
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    
    QZTimeLineCellOperationMenu *_operationMenu;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kQZTImeLineCellOperationButtonClickedNotification object:nil];
    
    _iconView = [UIImageView new];
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor =  [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFoneSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtomClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    NSArray *views = @[_iconView,_nameLabel,_contentLabel,_moreButton,_operationButton];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin +5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
}
- (void)configTheme
{
    self.lee_theme
    .LeeAddBackgroundColor(DAY, [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT, [UIColor blackColor]);
    
    _contentLabel.lee_theme
    .LeeAddTextColor(DAY, [UIColor blackColor])
    .LeeAddTextColor(NIGHT, [UIColor grayColor]);
    
    _timeLabel.lee_theme
    .LeeAddTextColor(DAY, [UIColor blackColor])
    .LeeAddTextColor(NIGHT, [UIColor grayColor]);
}

- (void)setModel:(QZTimeLineCellModel *)model
{
    _model = model;
    
    if (model.shouldShowMoreButton) {//如果文字高度超过60
        _moreButton.sd_layout
        .heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { //如果需要展开
            _contentLabel.sd_layout
            .maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout
            .maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
        
    } else {
        _moreButton.sd_layout
        .heightIs(0);
        _moreButton.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    if (_operationButton) {
//        <#statements#>
//    }
}
#pragma mark - private actions
- (void)moreButtonClicked
{
    if (self.moreButtonClickBlock) {
        self.moreButtonClickBlock(self.indexPath);
    }
}
- (void)operationButtonClicked
{
    
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
//    if (btn != _operationButton && _oper) {
//        <#statements#>
//    }
//    
}
@end
