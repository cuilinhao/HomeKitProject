//
//  MOBRoomViewController.h
//  TETETE
//
//  Created by 崔林豪 on 2018/11/19.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MOBHomeKitManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOBRoomViewController : UIViewController

@property (nonatomic,strong)HMRoom *currentRoom;

@property (nonatomic, strong) HMHome *currentHome;

@end

NS_ASSUME_NONNULL_END
