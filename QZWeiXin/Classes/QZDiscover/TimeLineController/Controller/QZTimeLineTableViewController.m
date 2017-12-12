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
#import "QZTimeLineCell.h"
#import "QZTimeLineCellModel.h"

//#import "QZTimeLineRefreshHeader.h"
//#import "QZTimeLineCellModel.h"

#define kTimeLineTableViewCellId @"QZTimeLineCellIdentifier"
//static CGFloat textFieldH = 40;

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
//
    [self.tableView registerClass:[QZTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
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

- (NSArray *)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        QZTimeLineCellModel *model = [QZTimeLineCellModel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        
        
        // 模拟“随机图片”
        int random = arc4random_uniform(6);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
//            model.picNamesArray = [temp copy];
        }
/*
        // 模拟随机评论数据
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            commentItemModel.firstUserName = namesArray[index];
            commentItemModel.firstUserId = @"666";
            if (arc4random_uniform(10) < 5) {
                commentItemModel.secondUserName = namesArray[arc4random_uniform((int)namesArray.count)];
                commentItemModel.secondUserId = @"888";
            }
            commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        
        // 模拟随机点赞数据
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            SDTimeLineCellLikeItemModel *model = [SDTimeLineCellLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        
        model.likeItemsArray = [tempLikes copy];
        
        
*/
        [resArr addObject:model];
    }
    return [resArr copy];
}


- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        [LEETheme startTheme:NIGHT];
    } else {
        [LEETheme startTheme:DAY];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.dataArray.count);
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QZTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //>>>>>>>>>>>>>>>>> *cell自适应  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//    id model = self.dataArray[indexPath.row];
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[QZTimeLineCell class] contentViewWidth:[self cellContentViewWidth]];
    //上面的为简化版推荐使用  下面的为升级版（适用于cell条数少于100的tableview）
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

- (CGFloat)cellContentViewWidth
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //适配iOS 7横屏
    
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
