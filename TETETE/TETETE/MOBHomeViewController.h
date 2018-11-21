//
//  MOBHomeViewController.h
//  TETETE
//
//  Created by 崔林豪 on 2018/11/19.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#import "MOBHomeKitManager.h"



NS_ASSUME_NONNULL_BEGIN

@interface MOBHomeViewController : UIViewController

@property (nonatomic, strong) MOBHomeKitManager *homeKitManager;
@property (nonatomic, strong) NSArray *homeArray;
@property (nonatomic, strong) NSArray *roomArray;
@property (nonatomic, strong) HMHome *currentHome;

@property (weak, nonatomic) IBOutlet UILabel *currentRoomLabel;



@end

NS_ASSUME_NONNULL_END
