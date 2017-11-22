//
//  QZTimeLineTableViewController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/17.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZTimeLineTableViewController.h"
#import "LEETheme.h"
#import "QZTimeLineCellModel.h"
#import "QZTimeLineRefreshFooter.h"
#import "QZTimeLineHeaderRefresh.h"

#import "QZTimeLineHeaderView.h"
#import "QZTimeLineCell.h"

#define kTimeLineTableViewCellId @"QZTimeLineCell"

static CGFloat textFieldH = 40;

@interface QZTimeLineTableViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexPath;
@property (nonatomic, copy) NSString *commentToUser;


@end

@implementation QZTimeLineTableViewController
{
    QZTimeLineRefreshFooter *_refreshFooter;
    QZTimeLineHeaderRefresh *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //LEETheme 分为两种模式 ，独立设置模式 JSON设置模式 ， 朋友圈demo展示的是独立设置模式的使用，微信聊天demo 展示的是JSON模式的使用
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日间" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    rightBarButtonItem.lee_theme
    .LeeAddCustomConfig(DAY,^(UIBarButtonItem *item){
        item.title = @"夜间";
    })
    .LeeAddCustomConfig(NIGHT,^(UIBarButtonItem *item){
        item.title = @"日间";
    });
    //为self。view 添加背景颜色设置
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY,[UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT,[UIColor blackColor]);
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
    __weak typeof(self) weakSelf = self;
    
    //上拉加载
    
    _refreshFooter = [QZTimeLineRefreshFooter refreshFooterWithRefreshText:@"正在加载数据..."];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    [_refreshFooter addToScrollView:self.tableView refreshOpration:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModelsWithCount:10]];
            
            
            /**
             [weakSelf.tableView reloadDataWithExistedHeightCache];
             作用等同于
             [weakSelf.tableView reloadData];
             只是"reloadDataWithExistedHeightCache"刷新tableView但不清空之前已经计算好的高度缓存，用于直接将新数据拼接在就数据之后的tableView刷新
             */
            
            [weakSelf.tableView reloadDataWithExistedHeightCache];
            
            [weakRefreshFooter endRefreshing];
        });
    }];
    
    QZTimeLineHeaderView *headerView = [QZTimeLineHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = headerView;
    
    //添加分割线颜色设置
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY,[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
    .LeeAddSeparatorColor(NIGHT,[[UIColor grayColor] colorWithAlphaComponent:0.5f]);
    
    [self.tableView registerClass:[QZTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_refreshHeader.superview) {
        _refreshHeader = [QZTimeLineHeaderRefresh refreshHeaderWithCenter:CGPointMake(40, 45)];
        _refreshHeader.scrollView = self.tableView;
        __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
                [weakHeader endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            });
        }];
        [self.tableView.superview addSubview:_refreshHeader];
    } else {
        [self.tableView.superview bringSubviewToFront:_refreshHeader];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_textField resignFirstResponder];
}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    [_refreshFooter removeFromSuperview];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//右栏目按钮点击事件

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        [LEETheme startTheme:NIGHT];
    } else {
        [LEETheme startTheme:DAY];
    }
}

- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;//右下角的返回键
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    
    
    //为textField添加北京颜色 字体颜色的设置 还有block设置，在block中改变它的键盘样式 （当然背景颜色和字体颜色也恶意直接在block中写）
    _textField.lee_theme
    .LeeAddBackgroundColor(DAY,[UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT,[UIColor blackColor])
    .LeeAddTextColor(DAY,[UIColor blackColor])
    .LeeAddTextColor(NIGHT,[UIColor grayColor])
    .LeeAddCustomConfig(DAY, ^(UITextField *item){
        item.keyboardAppearance = UIKeyboardTypeDefault;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    }).LeeAddCustomConfig(NIGHT, ^(UITextField *item){
        item.keyboardAppearance = UIKeyboardAppearanceDark;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    });
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     ];
    NSArray *namesArray = @[@"FQZ_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"
                            ];
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
        
        //模拟"随机图片"
        int random = arc4random_uniform(6);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
        //模拟随机评论数据
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            QZTimeLineCellCommentItemModel *commentItemModel = [QZTimeLineCellCommentItemModel new];
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
        
        //模拟随机点赞数据
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            QZTimeLineCellLikeItemModel *model = [QZTimeLineCellLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        model.likeItemsArray = [tempLikes copy];
        
        [resArr addObject: model];
    }
    return resArr;
}

- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}


- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h ) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

@end
