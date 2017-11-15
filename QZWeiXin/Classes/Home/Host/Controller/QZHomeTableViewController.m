//
//  QZHomeTableViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/6.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZHomeTableViewController.h"
#import "QZHomeTableViewCell.h"
#import "QZEyeAnimationView.h"
#import "QZAnalogDataGenerator.h"
#import "QZShortVideoController.h"

#define kHomeTableViewControllerCellId @"HomeTableViewController"

#define kHomeObserveKeyPath @"contentOffset"

const CGFloat kHomeTableViewAnimationDuration = 0.25;

#define kCraticalProgressHeight 80

@interface QZHomeTableViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak)  QZEyeAnimationView *eyeAnimationView;

@property (nonatomic, strong) QZShortVideoController *shortVideoController;

@property (nonatomic, assign) BOOL tableViewIsHidden;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, assign) CGFloat tabBarOriginalY;
@property (nonatomic, assign) CGFloat tableViewOriginalY;

@end

@implementation QZHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = [QZHomeTableViewCell fixedHeight];
    
    [self setupDataWithCount:10];
    
    [self.tableView registerClass:[QZHomeTableViewCell class] forCellReuseIdentifier:kHomeTableViewControllerCellId];
    
    self.tableView.backgroundColor = [UIColor clearColor];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.eyeAnimationView) {
        [self setupEyeAnimationView];
        
        self.tabBarOriginalY = self.navigationController.tabBarController.tabBar.top;
        
        self.tableViewOriginalY = self.tableView.top;
        
    }
    if (!self.shortVideoController) {
        self.shortVideoController = [QZShortVideoController new];
        [self.tableView.superview insertSubview:self.shortVideoController.view atIndex:0];
        __weak typeof(self) weakSelf = self;
        [self.shortVideoController setCancleOperationBlock:^{
            [weakSelf startTableViewAnimationWithHidden:NO];
        }];
    }
    
}

- (void)setupEyeAnimationView
{
    QZEyeAnimationView *view = [QZEyeAnimationView new];
    view.bounds = CGRectMake(0, 0, 65, 44);
    view.center = CGPointMake(self.view.bounds.size.width *0.5, 70);
    [self.tableView.superview insertSubview:view atIndex:0];
    self.eyeAnimationView = view;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.tableView.superview addGestureRecognizer:pan];
}

- (void)panView:(UIPanGestureRecognizer *)pan
{
    
    NSLog(@"%f",self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y < - 64) {
        [self performEyeViewAnimation];
    }
    
    CGPoint point = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (self.tableViewIsHidden && ![self.shortVideoController isRecordingVideo]) {
        CGFloat tabBarTop = self.navigationController.tabBarController.tabBar.top;
        CGFloat maxTabBarY = [UIScreen mainScreen].bounds.size.height + self.tableView.height;
        
        if (!(tabBarTop > maxTabBarY && point.y > 0)) {
            self.tableView.top += point.y;
            self.navigationController.tabBarController.tabBar.top += point.y;
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.tableView.contentOffset.y < -(64 + kCraticalProgressHeight) && !self.tableViewIsHidden) {
            [self startTableViewAnimationWithHidden:YES];
        } else if (self.tableViewIsHidden) {
            BOOL shouldHide = NO;
            if (self.tableView.top > [UIScreen mainScreen].bounds.size.height - 150) {
                shouldHide = YES;
            }
            [self startTableViewAnimationWithHidden:shouldHide];
        }
    }
    
}

- (void)performEyeViewAnimation
{
    CGFloat height = kCraticalProgressHeight;
    CGFloat progress = - (self.tableView.contentOffset.y + 64) / height;
    
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.tableView.isDragging) {
        return;
    }
    
    if (![keyPath isEqualToString:kHomeObserveKeyPath] || self.tableView.contentOffset.y > 0) {
        return;
    }
    CGFloat height = 80.0;
    CGFloat progress = - (self.tableView.contentOffset.y + 64) / height;
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:[UIViewController new]];
    }
    return _searchController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollView delegate

- (void)startTableViewAnimationWithHidden:(BOOL)hidden
{
    CGFloat tableViewH = self.tableView.height;
    CGFloat tabBarY = 0;
    CGFloat tableViewY = 0;
    if (hidden) {
        tabBarY = tableViewH + self.tabBarOriginalY;
        NSLog(@"%f",tabBarY);
        tableViewY = tableViewH + self.tableViewOriginalY;
    } else {
        tabBarY = self.tabBarOriginalY ;
        tableViewY = self.tableViewOriginalY;
    }
    [UIView animateWithDuration:kHomeTableViewAnimationDuration animations:^{
        self.tableView.top = tableViewY;
        self.navigationController.tabBarController.tabBar.top = tabBarY;
        self.navigationController.navigationBar.alpha = (hidden ? 0:1);
    } completion:^(BOOL finished) {
        self.eyeAnimationView.hidden = hidden;
    }];
    if (!hidden) {
        [self.shortVideoController hidde];
    } else {
        [self.shortVideoController show];
    }
    self.tableViewIsHidden = hidden;
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

- (void)setupDataWithCount:(CGFloat)count
{
    for (int i = 0; i < count; i++) {
        QZHomeTableViewCellModel *model = [QZHomeTableViewCellModel new];
        model.imageName = [QZAnalogDataGenerator randomIconImageName];
        model.name = [QZAnalogDataGenerator randomName];
        model.message = [QZAnalogDataGenerator randomMessage];
        [self.dataArray addObject:model];
    }
}
#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QZHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewControllerCellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
