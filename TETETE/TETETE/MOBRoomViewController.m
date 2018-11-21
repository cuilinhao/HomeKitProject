//
//  MOBRoomViewController.m
//  TETETE
//
//  Created by 崔林豪 on 2018/11/19.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import "MOBRoomViewController.h"

@interface MOBRoomViewController ()<HMAccessoryBrowserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *seaarchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HMAccessoryBrowser *browser;
@property (nonatomic, strong) NSMutableArray *accessoryArray;

@end

@implementation MOBRoomViewController

#pragma mark -  生命周期 Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = self.currentRoom.name;
    [self _initConfigure];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.browser stopSearchingForNewAccessories];
    
}

- (void)_initConfigure
{
    self.browser = [[HMAccessoryBrowser alloc] init];
    self.browser.delegate = self;
    self.accessoryArray = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)searchBtn:(id)sender {
    NSLog(@"-------开始搜索设备----");
    [self.browser startSearchingForNewAccessories];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"-------停止搜索设备----");
//        [self.browser stopSearchingForNewAccessories];
//    });
}



#pragma mark - HMAccessoryBrowser delegate
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory
{
    NSLog(@">>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<");
    [self.accessoryArray addObject:accessory];
    [self.tableView reloadData];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory
{
    NSLog(@"-----一个硬件已经移除了------");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"-----w进入了我的房间-------");
    [self.currentRoom.accessories enumerateObjectsUsingBlock:^(HMAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"----当前的设备----%@", obj.name);
    }];
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accessoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     //cell.textLabel.text = @"123";
    HMAccessory *acc = self.accessoryArray[indexPath.row];
    cell.textLabel.text = acc.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //选取目标 进行配置
    //获取当前选择的外设对象
    HMAccessory *acc = self.accessoryArray[indexPath.row];
    __block HMHome *home = self.currentHome;
    
    //---
    //[self _updateAccessoryName:acc];
    //[self _removeAccessory:acc];
    //return;
    
    __weak typeof(self) weakSelf = self;
    //MARK:-为新的Accessory对象，指定一个room
    [self.currentHome addAccessory:acc completionHandler:^(NSError * _Nullable error) {
        if (!error)
        {
            //如果添加home成功，将设备指定给某一个room
            if (acc.room != weakSelf.currentRoom)
            {
                [home assignAccessory:acc toRoom:weakSelf.currentRoom completionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@"---已经将设备加入了%@",weakSelf.currentRoom.name);
                    }
                    else
                    {
                        NSLog(@"---指定房间失败");
                        
                    }
                }];
            }
        }
        else
        {
            NSLog(@"--添加硬件到home失败--%@-", error);
        }
    }];
    
    
}


//MARK:- 更新一个已经添加到home中的accessory对象
- (void)_updateAccessoryName:(HMAccessory *)accessory
{
    
    [accessory updateName:@"测试Home" completionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"-----更改名字失败---");
        }
        else
        {
            NSLog(@"-----更改名字成功---");
        }
        
    }];
}

//MARK:- 移除Accessory
- (void)_removeAccessory:(HMAccessory *)accessory
{
    [self.currentHome removeAccessory:accessory completionHandler:^(NSError * _Nullable error) {
    
        if (error)
        {
            NSLog(@"-----移除设备失败---");
        }
        else
        {
            NSLog(@"-----移除设备成功---");
        }
        
    }];
}

@end
