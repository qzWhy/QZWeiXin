//
//  QZAppFrameTabBarController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/6.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZAppFrameTabBarController.h"

#import "QZHomeTableViewController.h"
#import "QZBaseNavgationController.h"

#import "QZDiscoverViewController.h"

#define kClassKey  @"rootVCClassString"
#define kTitleKey  @"title"
#define kImgKey    @"imageName"
#define kSelImgKey @"selectedImageName"

@interface QZAppFrameTabBarController ()

@end

@implementation QZAppFrameTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"QZHomeTableViewController",
                                   kTitleKey  : @"微信",
                                   kImgKey    : @"tabbar_mainframe",
                                   kSelImgKey : @"tabbar_mainframeHL"},
                                 
                                 @{kClassKey  : @"SDContactsTableViewController",
                                   kTitleKey  : @"通讯录",
                                   kImgKey    : @"tabbar_contacts",
                                   kSelImgKey : @"tabbar_contactsHL"},
                                 
                                 @{kClassKey  : @"QZDiscoverViewController",
                                   kTitleKey  : @"发现",
                                   kImgKey    : @"tabbar_discover",
                                   kSelImgKey : @"tabbar_discoverHL"},
                                 
                                 @{kClassKey  : @"SDMeTableViewController",
                                   kTitleKey  : @"我",
                                   kImgKey    : @"tabbar_me",
                                   kSelImgKey : @"tabbar_meHL"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        QZBaseNavgationController *nav = [[QZBaseNavgationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName  : Global_tintColor} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    
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
