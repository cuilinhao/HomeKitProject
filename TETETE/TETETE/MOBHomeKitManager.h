//
//  MOBHomeKitManager.h
//  Test
//
//  Created by 崔林豪 on 2018/11/19.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MOBHomeKitManager : NSObject<HMHomeManagerDelegate, HMHomeDelegate>

@property (nonatomic, strong) HMHomeManager *homeManager;

/** 初始化*/
- (void)initHomeKitManager;

/** 添加Home*/
- (void)addHome:(NSString *)homeName;

/** 删除Home*/
- (void)removeHome:(HMHome *)home;

/** 删除room*/
- (void)romoveRoom:(HMHome *)home;

@end

NS_ASSUME_NONNULL_END
