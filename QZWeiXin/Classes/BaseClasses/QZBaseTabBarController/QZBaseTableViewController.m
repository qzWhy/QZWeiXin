//
//  QZBaseTableViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/6.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZBaseTableViewController.h"

@interface QZBaseTableViewController ()

@end

@implementation QZBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
