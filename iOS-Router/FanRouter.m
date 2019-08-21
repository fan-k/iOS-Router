//
//  FanRouter.m
//  iOS-Router
//
//  Created by 樊康鹏 on 2019/8/21.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanRouter.h"
#import <objc/runtime.h>

@implementation FanRouter

+ (instancetype)shareInstance{
    static FanRouter *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[FanRouter alloc] init];
    });
    return tools;
}
+ (UIViewController *)currentViewController{
    return [FanRouter topViewController];
}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [FanRouter _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [FanRouter _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
- (void)pushViewControllerWithUrl:(NSString *)url transferData:(id)transferData hander:(void (^ _Nullable)(id, int))hander{
    if(url.length == 0) return;
    if ([url hasPrefix:@"http"]) {
        //区分下网页
        UIViewController *webVc = (UIViewController *)[NSClassFromString(@"WebController") new];
        webVc.transferData = url;
        webVc.customActionBlock = ^(id obj, int idx) {
            if(hander){
                hander(obj ,idx);
            }
        };
        webVc.hidesBottomBarWhenPushed = YES;
        [[FanRouter currentViewController].navigationController pushViewController:webVc animated:YES];
        return;
    }
    if ([url rangeOfString:@"://"].location == NSNotFound) {
        url = [@"ticket://" stringByAppendingString:url];
    }
    //取链接内的参数
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSString *host = urlComponents.host;
    NSString *path = urlComponents.path;
    NSDictionary *params = [url urlToParamDict];
    host = [host toClassController];
    id urlClass = [NSClassFromString(host) new];
    if([urlClass isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)urlClass;
        vc.transferData = transferData;
        vc.urlParams = params;
        vc.path = path;
        vc.customActionBlock = ^(id obj, int idx) {
            if(hander){
                hander(obj ,idx);
            }
        };
        vc.hidesBottomBarWhenPushed = YES;
        [[FanRouter currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)presentViewControllerWithUrl:(NSString *)url transferData:(id)transferData hander:(void (^ _Nullable)(id, int))hander{
    if(url.length == 0) return;
    if ([url hasPrefix:@"http"]) {
        //区分下网页
        UIViewController *webVc = (UIViewController *)[NSClassFromString(@"WebController") new];
        webVc.transferData = url;
        webVc.customActionBlock = ^(id obj, int idx) {
            if(hander){
                hander(obj ,idx);
            }
        };
        webVc.hidesBottomBarWhenPushed = YES;
        [[FanRouter currentViewController] presentViewController:webVc animated:YES completion:nil];
        return;
    }
    if ([url rangeOfString:@"://"].location == NSNotFound) {
        url = [@"ticket://" stringByAppendingString:url];
    }
    //取链接内的参数
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSString *host = urlComponents.host;
    NSString *path = urlComponents.path;
    NSDictionary *params = [url urlToParamDict];
    host = [host toClassController];
    id urlClass = [NSClassFromString(host) new];
    if([urlClass isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)urlClass;
        vc.transferData = transferData;
        vc.urlParams = params;
        vc.path = path;
        vc.customActionBlock = ^(id obj, int idx) {
            if(hander){
                hander(obj ,idx);
            }
        };
        vc.hidesBottomBarWhenPushed = YES;
        //特殊页面 示例
        if ([host isEqualToString:@"LoginController"]) {
            //登陆页添加导航
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [[FanRouter currentViewController] presentViewController:nav animated:YES completion:nil];
        }else
            [[FanRouter currentViewController] presentViewController:vc animated:YES completion:nil];
    }
}
@end

static const char *FanCustomActionBlock = "FanCustomActionBlock";
static const char *FanResultActionBlock = "FanResultActionBlock";

@implementation UIViewController (block)

- (void)setCustomActionBlock:(void (^)(id, int))customActionBlock{
    objc_setAssociatedObject(self, FanCustomActionBlock, customActionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setResultActionBlock:(void (^)(id, int))resultActionBlock{
    objc_setAssociatedObject(self, FanResultActionBlock, resultActionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(id, int))customActionBlock{
    return objc_getAssociatedObject(self,FanCustomActionBlock);
}
- (void (^)(id, int))resultActionBlock{
    return objc_getAssociatedObject(self,FanResultActionBlock);
}


@end

static const char *FanVCPassValue = "FanVCPassValue";
static const char *FanVCPassUrlParams = "FanVCPassUrlParams";
static const char *FanVCPath = "FanVCPath";
@implementation UIViewController (passValue)

- (void)setTransferData:(id)transferData{
    objc_setAssociatedObject(self, FanVCPassValue, transferData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)transferData{
    return objc_getAssociatedObject(self,FanVCPassValue);
}
- (void)setUrlParams:(NSDictionary *)urlParams{
    objc_setAssociatedObject(self, FanVCPassUrlParams, urlParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary *)urlParams{
    return objc_getAssociatedObject(self,FanVCPassUrlParams);
}
- (void)setPath:(NSString *)path{
    objc_setAssociatedObject(self, FanVCPath, path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)path{
    return objc_getAssociatedObject(self,FanVCPath);
}

/**
 pushVc
 * 传参可通过url 和 transferData进行传参
 @param url url
 @param transferData 需要传递的参数
 @param hander 回调
 */
- (void)pushViewControllerWithUrl:(NSString *)url
                     transferData:(id)transferData
                           hander:(void (^ __nullable)(id obj,int idx))hander{
    [[FanRouter shareInstance] pushViewControllerWithUrl:url transferData:transferData hander:hander];
}

/**presentVc*/
- (void)presentViewControllerWithUrl:(NSString *)url
                        transferData:(id)transferData
                              hander:(void (^ __nullable)(id obj,int idx))hander{
    [[FanRouter shareInstance] presentViewControllerWithUrl:url transferData:transferData hander:hander];
}
@end




@implementation NSString(router)


- (NSString *)toClassController{
    NSString *className = [self.classTable objectForKey:self];
    if (className.length <= 0) {//如果映射表中 不存在 返回原有的值
        className = self;
    }
    return className;
}
- (NSDictionary *)classTable{
    return @{
             @"pushVc":@"PushViewController",
             };
}

- (NSMutableDictionary *)urlToParamDict{
    //先转编码
    NSString *url  = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    __block NSMutableDictionary *parm = [NSMutableDictionary new];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //把pbj.value 转编码回来
        if (obj.value && obj.name) {
            [parm setObject:[obj.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:obj.name];
        }
    }];
    
    return parm;
}
@end
