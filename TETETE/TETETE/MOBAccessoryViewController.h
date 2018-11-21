//
//  MOBAccessoryViewController.h
//  TETETE
//
//  Created by 崔林豪 on 2018/11/20.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MOBAccessoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HMHome *currentHome;

@property (nonatomic, strong) HMRoom *currentRoom;


@end

NS_ASSUME_NONNULL_END
