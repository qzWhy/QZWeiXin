//
//  QZHomeTableViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/6.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZHomeTableViewController.h"

const CGFloat kHomeTableViewAnimationDuration = 0.25;

#define kCraticalProgressHeight 80

@interface QZHomeTableViewController ()

//@property (nonatomic, weak) <#type#> *<#name#>;

@end

@implementation QZHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUnreadCount];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollView delegate

- (void)startTableViewAnimationWithHidden:(BOOL)hidden
{
    
}

- (void)setupUnreadCount
{
    //通知  NSNotification 不可见
    //本地通知
    //远程推送通知
    
    NSString *status = @"3";
    self.tabBarItem.badgeValue = status;
    [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
    [[[[[self tabBarController] tabBar]items] objectAtIndex:0] setBadgeValue:@"5"];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //ios 8以前 ，不能带，iOS8 以后必须带
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

@end
