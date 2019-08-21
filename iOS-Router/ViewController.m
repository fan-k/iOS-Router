//
//  ViewController.m
//  iOS-Router
//
//  Created by 樊康鹏 on 2019/8/21.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ViewController.h"
#import "FanRouter.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *routerList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Router 跳转演示";
    
    self.routerList = @[
                        @{@"router":@"PushViewController",@"title":@"push方式页面跳转并传值cell的dict",@"type":@"push"},
                        @{@"router":@"PushViewController?title=b",@"title":@"push方式页面跳转携带参数",@"type":@"push"},
                        @{@"router":@"PushViewController?title=b&id=1",@"title":@"push方式页面跳转携带多个参数",@"type":@"push"},
                        @{@"router":@"PushViewController?title=中文标题&id=1",@"title":@"push方式页面跳转携带中文参数",@"type":@"push"},
                        @{@"router":@"PushViewController",@"title":@"push方式页面跳转反向传值",@"type":@"push"},
                        @{@"router":@"http://www.baidu.com",@"title":@"push方式页面跳转网页",@"type":@"push"},
                        @{@"router":@"pushVc",@"title":@"push方式页面跳转映射表",@"type":@"push"},
                        @{@"router":@"PushViewController",@"title":@"present方式页面跳转并传值cell的dict",@"type":@"present"},
                        @{@"router":@"PushViewController?title=b",@"title":@"present方式页面跳转携带参数",@"type":@"present"},
                        @{@"router":@"PushViewController?title=b&id=1",@"title":@"present方式页面跳转携带多个参数",@"type":@"present"},
                        @{@"router":@"PushViewController?title=中文标题&id=1",@"title":@"present方式页面跳转携带中文参数",@"type":@"present"},
                        @{@"router":@"PushViewController",@"title":@"present方式页面跳转反向传值",@"type":@"present"},
                        ].mutableCopy;
    
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}



#pragma mark -- tableView delegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.routerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.routerList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [dict objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.routerList[indexPath.row];
    NSString *router = [dict objectForKey:@"router"];
    NSString *type = [dict objectForKey:@"type"];
    __weak ViewController *weakSelf = self;
    if ([type isEqualToString:@"push"]) {
        
        //跳转页面 并把dict  当做一个参数传递   其中router 内也可能存在参数  hander为回调block
        [self pushViewControllerWithUrl:router transferData:dict hander:^(id  _Nonnull obj, int idx) {
            [weakSelf showAlertWithObj:obj];
        }];
        //或者直接使用FanRouter单例调用
        //    [[FanRouter shareInstance] pushViewControllerWithUrl:router transferData:dict hander:nil];
    }else{
        //跳转页面 并把dict  当做一个参数传递   其中router 内也可能存在参数  hander为回调block
        [self presentViewControllerWithUrl:router transferData:dict hander:^(id  _Nonnull obj, int idx) {
            [weakSelf showAlertWithObj:obj];
        }];
        //或者直接使用FanRouter单例调用
        //    [[FanRouter shareInstance] presentViewControllerWithUrl:router transferData:dict hander:nil];
    }
 
}

- (void)showAlertWithObj:(NSString *)obj{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"反向传值" message:obj delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark --tableView

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat top =  FaniPhoneX()?88.0f : 64.0f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - top) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [self.view addSubview:_tableView];
    }return _tableView;
}


/**是否为iPhoneX系列*/
static inline BOOL FaniPhoneX() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

@end
