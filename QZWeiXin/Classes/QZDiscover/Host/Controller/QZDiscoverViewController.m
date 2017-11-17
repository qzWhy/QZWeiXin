//
//  QZDiscoverViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZDiscoverViewController.h"

@interface QZDiscoverViewController ()

@end

@implementation QZDiscoverViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [[UIStoryboard storyboardWithName:@"QZDiscoverViewController" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
