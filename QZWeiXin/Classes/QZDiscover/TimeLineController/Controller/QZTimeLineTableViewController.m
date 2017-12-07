//
//  QZTimeLineTableViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/12/6.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineTableViewController.h"
#import "LEETheme.h"
#import "QZTimeLineTableHeaderView.h"
//#import "QZTimeLineRefreshHeader.h"
//#import "QZTimeLineCellModel.h"

#define kTimeLineTableViewCellId @"QZTimeLineCell"
static CGFloat textFieldH = 40;

@interface QZTimeLineTableViewController ()

@end

@implementation QZTimeLineTableViewController
{
//    QZTimeLineRefreshHeader *_refreshHeader;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //LEETheme 分为两种模式 ，独立设置模式 JSON设置模式，朋友圈demo展示的是独立设置模式的使用，微信聊天demo 展示的是JSON模式的使用
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日间" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    rightBarButtonItem.lee_theme.LeeAddCustomConfig(DAY,^(UIBarButtonItem *item){
        item.title = @"夜间";
    }).LeeAddCustomConfig(NIGHT,^(UIBarButtonItem *item){
            item.title = @"日间";
    });
    
    //为self.view添加背景颜色设置
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY,[UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT,[UIColor blackColor]);
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
//    [self.dataArray addObjectsFromArray:[self ]]
    QZTimeLineTableHeaderView *headerView = [QZTimeLineTableHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = headerView;
    
    //添加分割线颜色设置
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY,[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
    .LeeAddSeparatorColor(NIGHT,[[UIColor grayColor] colorWithAlphaComponent:0.5f]);
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        [LEETheme startTheme:NIGHT];
    } else {
        [LEETheme startTheme:DAY];
    }
}


@end
