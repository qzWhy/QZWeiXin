//
//  QZChatTableViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/15.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZChatTableViewController.h"
#import "QZChatModel.h"
#import "QZAnalogDataGenerator.h"

@interface QZChatTableViewController ()

@end

@implementation QZChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataWithCount:30];
    
}

- (void)setupDataWithCount:(CGFloat)count
{
    for (int i = 0; i < count; i++) {
        QZChatModel *model = [QZChatModel new];
        model.messageType = arc4random_uniform(2);
        if (model.messageType) {
            model.iconName = [QZAnalogDataGenerator randomIconImageName];
            if (arc4random_uniform(10) > 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg",index];
            }
        } else {
            if (arc4random_uniform(10) < 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg",index];
            }
            model.iconName = @"2.jpg";
        }
        model.text = [QZAnalogDataGenerator randomMessage];
        [self.dataArray addObject: model];
    }
}

#pragma mark - tableView delegate and dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
