//
//  PushViewController.m
//  iOS-Router
//
//  Created by 樊康鹏 on 2019/8/21.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用 transferData 或 urlParams 需引用FanRouter 可配置全局引用
    //取传递的参数 transferData 可能是任何类型的参数  这里测试使用的字典类型 下面转json默认为字典类型
    id transferData = self.transferData;
    // 取router中的参数 urlParams
    NSDictionary *urlParams = self.urlParams;
    
    UILabel *lb = [UILabel new];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    lb.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 100);
    lb.text = [NSString stringWithFormat:@"transferData:%@\n urlParams:%@",[self JsonWithObj:transferData],[self JsonWithObj:urlParams]];
    lb.numberOfLines = 0;
    [lb sizeToFit];
    [self.view addSubview:lb];
    
    //添加个按钮 测试反向传值 并alert提示
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width - 20, 50);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"反向传值" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}

- (void)buttonClick{
    if (self.customActionBlock) {
        self.customActionBlock([self JsonWithObj:self.transferData], 0);
    }
}

- (NSString *)JsonWithObj:(NSDictionary *)obj{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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


@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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



@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100)];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.transferData]]];
    [self.view addSubview:web];
    
    // Do any additional setup after loading the view.
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


