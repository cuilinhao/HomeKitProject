//
//  MOBHomeKitManager.m
//  Test
//
//  Created by 崔林豪 on 2018/11/19.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import "MOBHomeKitManager.h"

@implementation MOBHomeKitManager

- (void)initHomeKitManager
{
    self.homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;
}

#pragma mark - Home 添加删除操作
- (void)addHome:(NSString *)homeName
{
    [self.homeManager addHomeWithName:homeName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        NSLog(@"----添加了home----%@----%@", home, home.name);
    }];
}

- (void)removeHome:(HMHome *)home
{
    [self.homeManager removeHome:home completionHandler:^(NSError * _Nullable error) {
        NSLog(@"-----删除了home---%@----%@", home, home.name);
    }];
    
}

- (void)romoveRoom:(HMHome *)home
{
    if (home.rooms.count > 0)
    {
        [home removeRoom:home.rooms.firstObject completionHandler:^(NSError * _Nullable error) {
            NSLog(@"-----删除了Room---%@----%@", home, home.rooms);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeRoom" object:nil userInfo:@{@"home": home}];
        }];
    }
    
}

#pragma mark - HMHomeManager delegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager
{
    NSLog(@"---primaryHome 主房间只有一个--");
    NSLog(@"----已经获取到homes数据,primary：是不是主房间---%@", manager.homes);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gethomes" object:nil];
    
    for (HMHome *home in manager.homes) {
        NSLog(@"------查看home---%@", home);
        NSLog(@"------查看home---%@", @(home.primary).stringValue);
    }
    
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager
{
    NSLog(@"--已经更新了primaryhome： %@", manager.primaryHome);
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home
{
    NSLog(@"---已经添加了home：%@",home);
}

- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home
{
    NSLog(@"---已经移除了home：%@",home);
}




#pragma mark -
#pragma mark home代理方法
- (void)homeDidUpdateName:(HMHome *)home
{
    NSLog(@"已经更换了home的名字");
}
- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory{
    NSLog(@"已经添加了，智能设备");
}
- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessor{
    
    NSLog(@"已经移除了智能设备");
}



- (void)home:(HMHome *)home didAddUser:(HMUser *)user{
    
    NSLog(@"已经添加用户");
    
}
- (void)home:(HMHome *)home didRemoveUser:(HMUser *)user{
    NSLog(@"已经移除了用户");
    
    
}
- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory{
    
    NSLog(@"一个新房间，添加了一个智能设备");
    
}

- (void)home:(HMHome *)home didAddRoom:(HMRoom *)room{
    
    NSLog(@"已经添加了房间 ");
    
    
}
- (void)home:(HMHome *)home didRemoveRoom:(HMRoom *)room{
    
    
    NSLog(@"已经移除了房间");
    
}

- (void)home:(HMHome *)home didUpdateNameForRoom:(HMRoom *)room{
    
    NSLog(@"已经为一个房间更新了名字");
}
- (void)home:(HMHome *)home didAddZone:(HMZone *)zone{
    
    NSLog(@"已经添加了一个空间");
    
}
- (void)home:(HMHome *)home didRemoveZone:(HMZone *)zone{
    
    NSLog(@"已经移除了一个空间");
}
- (void)home:(HMHome *)home didUpdateNameForZone:(HMZone *)zone{
    
    NSLog(@"已经为一个空间更改了名字");
    
    
}
- (void)home:(HMHome *)home didAddRoom:(HMRoom *)room toZone:(HMZone *)zone{
    
    NSLog(@"已经添加了一个房间到一个空间");
    
}
- (void)home:(HMHome *)home didRemoveRoom:(HMRoom *)room fromZone:(HMZone *)zone{
    
    NSLog(@"已经从一个空间移除了一个房间");
}
- (void)home:(HMHome *)home didAddServiceGroup:(HMServiceGroup *)group{
    
    NSLog(@"已经添加了一个服务组");
    
}
- (void)home:(HMHome *)home didRemoveServiceGroup:(HMServiceGroup *)group{
    
    NSLog(@"已经移除了一个服务组");
}
- (void)home:(HMHome *)home didUpdateNameForServiceGroup:(HMServiceGroup *)group{
    NSLog(@"已经为一个服务组更改了名字");
    
    
}
- (void)home:(HMHome *)home didAddService:(HMService *)service toServiceGroup:(HMServiceGroup *)group{
    
    NSLog(@"已经为一个服务组添加了一个服务");
    
    
}
- (void)home:(HMHome *)home didRemoveService:(HMService *)service fromServiceGroup:(HMServiceGroup *)group{
    
    NSLog(@"已经为一个服务组移除了一个服务");
    
}

- (void)home:(HMHome *)home didAddActionSet:(HMActionSet *)actionSet{
    
    NSLog(@"已经添加了一个动作组");
    
    
}
- (void)home:(HMHome *)home didRemoveActionSet:(HMActionSet *)actionSet{
    
    NSLog(@"已经移除了一个动作组");
    
}
- (void)home:(HMHome *)home didUpdateNameForActionSet:(HMActionSet *)actionSet{
    
    NSLog(@"已经为一个设置组添加了名字");
    
}
- (void)home:(HMHome *)home didUpdateActionsForActionSet:(HMActionSet *)actionSet{
    
    NSLog(@"已经为一个设置组更新了一个设置动作");
}
- (void)home:(HMHome *)home didAddTrigger:(HMTrigger *)trigger{
    
    
    NSLog(@"已经添加了一个触发器");
    
}
- (void)home:(HMHome *)home didRemoveTrigger:(HMTrigger *)trigger{
    
    NSLog(@"已经移除了一个触发器");
    
}

- (void)home:(HMHome *)home didUpdateNameForTrigger:(HMTrigger *)trigg{
    
    
    NSLog(@"已经移除了一个触发器");
    
}
- (void)home:(HMHome *)home didUpdateTrigger:(HMTrigger *)trigger{
    
    
    NSLog(@"已经更新了触发器");
    
    
}
- (void)home:(HMHome *)home didUnblockAccessory:(HMAccessory *)accessor{
    
    
    NSLog(@"已经接通了智能设备");
    
    
    
}
- (void)home:(HMHome *)home didEncounterError:(NSError*)error forAccessory:(HMAccessory *)accessory{
    
    NSLog(@"已经遇到错误");
    
}


@end
