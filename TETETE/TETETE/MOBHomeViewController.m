//
//  MOBHomeViewController.m
//  TETETE
//
//  Created by 崔林豪 on 2018/11/19.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import "MOBHomeViewController.h"
#import "MOBCollectionViewCell.h"
#import "MOBRoomViewController.h"
#import "MOBAccessoryViewController.h"



@interface MOBHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HMAccessoryBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) HMAccessoryBrowser *browser;

@property (nonatomic, strong) HMCharacteristic *cc ;

@property (nonatomic, strong) NSMutableArray *accessoryArray;

@end

@implementation MOBHomeViewController

#pragma mark -  生命周期 Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initConfigure];
    
    
    
    //---
    //self.browser = [[HMAccessoryBrowser alloc] init];
    //self.browser.delegate = self;
    
    //[self _configureAccessoryValue];
    //self.accessoryArray = [NSMutableArray array];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.browser stopSearchingForNewAccessories];
}

#pragma mark - 初始化
- (void)_initConfigure
{
    self.homeKitManager = [[MOBHomeKitManager alloc] init];
    
    [self.homeKitManager initHomeKitManager];
    
    self.homeArray = [NSArray array];
    self.roomArray = [NSMutableArray array];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //注册 已经获取到全部home 信息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_getHomesNotify) name:@"getHomes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateRoom:) name:@"removeRoom" object:nil];
    
    //-----
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomes:) name:@"UpdateHomesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrimaryHome:) name:@"UpdatePrimaryHomeNotification"  object:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.browser startSearchingForNewAccessories];
    //[self _configureAccessoryValue];
    [self _addHomeUser];
    
    
}


//MARK:-添加删除用户
- (void)_addHomeUser
{
    [self.currentHome manageUsersWithCompletionHandler:^(NSError * _Nullable error) {
        
        if (error == nil)
        {
            // Successfully added a user
            NSLog(@"---Successfully added a user");
        }
        else
        {
            // Unable to add a user
            NSLog(@"---Unable to add a user---%@", error);
        }
        
    }];
    
    NSLog(@"----users----%@", self.currentHome.users);
    NSLog(@"---current-users----%@", self.currentHome.currentUser.name);
    
}

//MARK:- 更新home
- (void)updateHomes:(id)info
{
    NSLog(@"-----更新了home");
}

- (void)updatePrimaryHome:(id)info
{
    NSLog(@"-----更新了home--PrimaryHome");
}

- (void)_updateRoom:(NSNotification *)info
{
    NSLog(@"----%@", info.userInfo[@"home"]);
    
    HMHome *home = info.userInfo[@"home"];
    self.roomArray = home.rooms;
    
    [self. collectionView reloadData];
    
}

- (void)_getHomesNotify
{
    self.currentHome = self.homeKitManager.homeManager.primaryHome;
    NSLog(@"-----当前home的名字---%@", self.homeKitManager.homeManager.primaryHome.name);
    
    [self _updateCurrentHome];
    [self _updateCurrentHomesRooms:self.currentHome];
}

- (void)_updateCurrentHome
{
    self.currentRoomLabel.text = [NSString stringWithFormat:@"当前的房间：%@", self.currentHome.name];
}

- (void)_updateCurrentHomesRooms:(HMHome *)home
{
    NSLog(@"------开始更新rooms数据----%lu", (unsigned long)home.rooms.count);
    
//    [self.roomArray removeAllObjects];
//    [home.rooms enumerateObjectsUsingBlock:^(HMRoom * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.roomArray addObject:obj];
//    }];
    if (home.rooms.count)
    {
        self.roomArray = home.rooms;
        for (NSInteger i = 0; i < self.roomArray.count; i++) {
            HMRoom *room = self.roomArray[i];
            NSLog(@"++++++%@", room.name);
        }
    }
    else
    {
        self.roomArray = home.rooms;
    }
    
    [self.collectionView reloadData];
    
}



#pragma mark - 添加删除房间
- (IBAction)allHomeBtn:(id)sender {
    //查看我的所有房间
    if (self.homeKitManager.homeManager.homes.count)
    {
        self.homeArray = self.homeKitManager.homeManager.homes;
        //展示home
        UIAlertController *homeListAlert = [UIAlertController alertControllerWithTitle:@"" message:@"我的所有home" preferredStyle:0];
        
        for (NSInteger i = 0; i < self.homeArray.count; i++) {
            HMHome *home = self.homeArray[i];
            
            NSString *name = home.name;
            if (home.primary == YES)
            {
                name = [NSString stringWithFormat:@"%@primary", home.name];
            }
            UIAlertAction *action = [UIAlertAction actionWithTitle:name style:0 handler:^(UIAlertAction * _Nonnull action) {
                self.currentHome = home;
                [self _updateCurrentHome];
                [self _updateCurrentHomesRooms:home];
            }];
            [homeListAlert addAction:action];
        }
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [homeListAlert addAction:action1];
        [self presentViewController:homeListAlert animated:YES completion:nil];
        
    }
}

- (IBAction)addHomeBtn:(id)sender {
    
    UIAlertController *inputNameAlert = [UIAlertController alertControllerWithTitle:@"请输入新的home名字" message:@"请确保这个名字的唯一性" preferredStyle:1];
    [inputNameAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入新的Hoom名字";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *newName = inputNameAlert.textFields.firstObject.text;
        [self.homeKitManager addHome:newName];
    }];
    
    [inputNameAlert addAction:action1];
    [inputNameAlert addAction:action2];
    [self presentViewController:inputNameAlert animated:YES completion:nil];
}


- (IBAction)removeHom:(id)sender {
    [self.homeKitManager removeHome:self.currentHome];
    [self _getHomesNotify];
}


#pragma mark - HMAccessoryBrowser delegate
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory
{
    NSLog(@">>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<%@", accessory);
    [self.accessoryArray addObject:accessory];
    //[self.tableView reloadData];
    
    [self.currentHome addAccessory:accessory completionHandler:^(NSError * _Nullable error) {
        NSLog(@"---home添加了accessory--%@", accessory.name);
        
    }];
    [self _configureAccessoryValue];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory
{
    NSLog(@"-----一个硬件已经移除了------");
}


#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.roomArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MOBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < self.roomArray.count)
    {
        HMHome *room = self.roomArray[indexPath.row];
        NSString *name = room.name;
        cell.roomLabel.text = name;
    }
    else
    {
        cell.roomLabel.text = @"+++";
    }
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row < self.roomArray.count)
    {
        
        __weak typeof(self) weakSelf = self;
        UIAlertController *inputNameAlert = [UIAlertController alertControllerWithTitle:@"room" message:@"show room" preferredStyle:UIAlertControllerStyleAlert];
        //MARK:-删除房间
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除Room" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.homeKitManager romoveRoom:weakSelf.currentHome];
            [weakSelf _updateCurrentHomesRooms:weakSelf.currentHome];
            
        }];
        
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (indexPath.row < self.roomArray.count)
            {//跳转到对应的房间
                HMRoom *room = self.roomArray[indexPath.row];
                NSLog(@"--房间名字----%@", room.name);
                
                //MOBRoomViewController *rVC = [[MOBRoomViewController alloc] init];
                //rVC.currentRoom = room;
                //rVC.view.backgroundColor = [UIColor greenColor];
                //[self.navigationController pushViewController:rVC animated:YES];
                
                //-----
                [self _segueToAccessory:room];
            }
        }];
        
        [inputNameAlert addAction:action3];
        [inputNameAlert addAction:action4];
        
        [self presentViewController:inputNameAlert animated:YES completion:nil];
        
    }
    else
    {
        UIAlertController *inputNameAlert = [UIAlertController alertControllerWithTitle:@"请输入新room的名字" message:@"请确保这个名字的唯一性" preferredStyle:1];
        [inputNameAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入room的名字";
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {

        }];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {

            NSString *newName = inputNameAlert.textFields.firstObject.text;

            NSLog(@"添加了房间%@", newName);
            [self.currentHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
                if (!error) {
                    [weakSelf _updateCurrentHomesRooms:weakSelf.currentHome];
                }
            }];
        }];
        
        [inputNameAlert addAction:action];
        [inputNameAlert addAction:action2];

        [self presentViewController:inputNameAlert animated:YES completion:nil];
    }
}

- (void)_segueToAccessory:(HMRoom *)room
{
    NSLog(@"-----w进入了我的房间-------");
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (room.accessories.count)
    {//房间中有设备,展示设备
        
        NSLog(@"-----设备：%@", self.currentHome.accessories);
        
        MOBAccessoryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MOBAccessoryViewController"];
        vc.currentHome = self.currentHome;
        vc.currentRoom = room;
        
        vc.view.backgroundColor = [UIColor orangeColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {//房间中没有设备，进行搜索
        
        MOBRoomViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MOBRoomViewController"];
        vc.currentRoom = room;
        vc.currentHome = self.currentHome;
        
        vc.view.backgroundColor = [UIColor greenColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//MARK:- 创建动作集
- (void)_configureCharacteristicWriteAction:(HMCharacteristic *)characteristic
{
    //--- 创建动作集
    //---写入动作会向一个服务的特性写入值并被加入到动作集合中去
    //---一个动作有一个相关联的特性对象
    
    //self.HMCharacteristic *cc = [[HMCharacteristic alloc] init];
    HMCharacteristicWriteAction *action = [[HMCharacteristicWriteAction alloc] initWithCharacteristic:self.cc targetValue:@(1)];
    NSLog(@"---actionSets---%@", self.currentHome.actionSets);
    
    
    [self.currentHome.actionSets enumerateObjectsUsingBlock:^(HMActionSet * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HMActionSet *ss = obj;
        
        NSLog(@"-------%@", ss.name);
        NSLog(@"-------%@", ss.actions);
        NSLog(@"-------%@", ss.actionSetType);
    }];
    
    
    [self.currentHome addActionSetWithName:@"NightTime" completionHandler:^(HMActionSet *actionSet, NSError *error) {
        
        if (error == nil) {
            // 成功添加了一个动作集
            NSLog(@"--成功添加了一个动作集");
            
        } else {
            // 添加一个动作集失败
            NSLog(@"---添加一个动作集失败-%@", error);
        }
    }];
    
    
    
    
    [self.currentHome.actionSets.firstObject addAction:action completionHandler:^(NSError *error) {
        
        if (error == nil) {
            
            // 成功添加了一个动作到动作集
            NSLog(@"--成功添加了一个动作到动作集-");
            
        } else {
            
            // 添加一个动作到动作集失败
            NSLog(@"-添加一个动作到动作集失败-%@", error);
        }
    }];
    
    
    NSLog(@"---actionSets--111111-%@", self.currentHome.actionSets);
    
    
}

//MARK:-写入数值
- (void)_configureAccessoryValue
{
    // Get all lights and thermostats in a home
    NSArray *lightServices = [self.currentHome servicesWithTypes:@[HMServiceTypeLightbulb]];
    NSArray * thrmostatServices = [self.currentHome servicesWithTypes:@[HMServiceTypeThermostat]];
    
    NSLog(@"---lightServices--%@", lightServices);
    NSLog(@"---thrmostatServices--%@", thrmostatServices);
    
    HMService *ss =  lightServices.firstObject;
    [ss.characteristics enumerateObjectsUsingBlock:^(HMCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"---characteristics--%@", obj);
        
        HMCharacteristic *cc = obj;
        NSLog(@"----characteristicType-%@", cc.characteristicType);
        NSLog(@"------读写属性--%@--第%lu个",cc.properties, (unsigned long)idx);
        
        if (idx == 0)
        {
            [cc writeValue:@1 completionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    // Successfully wrote the value
                    NSLog(@"----Successfully wrote the value");
                }
                else {
                    // Unable to write the value
                    NSLog(@"----Unable to write the value");
                }
            }];
            self.cc = obj;
            [self _configureCharacteristicWriteAction: self.cc];
        }
        else
        {
            [cc writeValue:@42 completionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    // Successfully wrote the value
                    NSLog(@"----Successfully wrote the value");
                }
                else {
                    // Unable to write the value
                    NSLog(@"----Unable to write the value");
                }
            }];
        }
        
        
    }];
    
    
}




@end
