//
//  FanRouter.h
//  iOS-Router
//
//  Created by 樊康鹏 on 2019/8/21.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 * 通过urlScheme页面跳转的处理类
 * 通过类名映射的方法 获取VC
 * 通过分类属性的方法 传值赋值
 */
@interface FanRouter : NSObject


/**单例*/
+ (instancetype)shareInstance;
/**当前的viewController*/
+ (UIViewController *)currentViewController;

/**
 pushVc
 * 传参可通过url 和 transferData进行传参
 @param url url
 @param transferData 需要传递的参数
 @param hander 回调
 */
- (void)pushViewControllerWithUrl:(NSString *)url
                     transferData:(id)transferData
                           hander:(void (^ __nullable)(id obj,int idx))hander;

/**presentVc*/
- (void)presentViewControllerWithUrl:(NSString *)url
                        transferData:(id)transferData
                              hander:(void (^ __nullable)(id obj,int idx))hander;
@end


/**页面传参的block 扩展*/
@interface UIViewController (block)
#pragma mark -- 扩展事件传递block
/**事件外传递block*/
@property (nonatomic, copy) void (^customActionBlock)(id obj, int idx);
/**事件接收block*/
@property (nonatomic ,copy) void (^resultActionBlock)(id obj, int idx);
@end

/**页面传递参数以及扩展页面跳转方法*/
@interface UIViewController (passValue)
/**
 页面push 或presnt时 需要传递的参数 -- 多个参数 可使用字典 或model 或array 或other
 */
@property (nonatomic ,strong) id transferData;

/**
 页面push 或presnt时 URL中包含的参数-- 固定字典，
 * 若URL中不包含 “=” 或& ，字典键值为key:url
 */
@property (nonatomic ,strong) NSDictionary * urlParams;

/**
 页面push 或presnt时 的path参数，
 * path 指向页面内的一种action
 */
@property (nonatomic ,copy) NSString * path;

/**
 pushVc
 * 传参可通过url 和 transferData进行传参
 @param url url
 @param transferData 需要传递的参数
 @param hander 回调
 */
- (void)pushViewControllerWithUrl:(NSString *)url
                     transferData:(id)transferData
                           hander:(void (^ __nullable)(id obj,int idx))hander;

/**presentVc*/
- (void)presentViewControllerWithUrl:(NSString *)url
                        transferData:(id)transferData
                              hander:(void (^ __nullable)(id obj,int idx))hander;

@end

@interface NSString (router)
/**
 URL链接 转化为字典参数
 
 @return 字典
 */
- (NSMutableDictionary *)urlToParamDict;


/*
 * 映射表
 */
- (NSString *)toClassController;
@property (nonatomic ,strong) NSDictionary *classTable;
@end

NS_ASSUME_NONNULL_END
