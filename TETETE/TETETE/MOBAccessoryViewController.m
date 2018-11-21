//
//  MOBAccessoryViewController.m
//  TETETE
//
//  Created by 崔林豪 on 2018/11/20.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import "MOBAccessoryViewController.h"


@interface MOBAccessoryViewController ()<UITableViewDelegate, UITableViewDataSource, HMAccessoryDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) HMCharacteristic *charaRead;

@property (nonatomic, strong) HMCharacteristic *charaWrite;


@end

@implementation MOBAccessoryViewController

#pragma mark -  生命周期 Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    
}

- (void)_initUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.dataArray = [NSMutableArray array];
    
    [self.currentRoom.accessories enumerateObjectsUsingBlock:^(HMAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray addObject:obj.name];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //拿到只能硬件 首先 获取硬件开启的所有服务
    HMAccessory *acc = self.currentRoom.accessories[indexPath.row];
    NSArray *serviceArray = acc.services;
    acc.delegate = self;
    NSLog(@">>>>>这个外设中有%lu个服务>>>", serviceArray.count);
    //遍历所有的服务， 获取每个服务的特征
    for (HMService *service in serviceArray) {
        NSLog(@">>>>服务的名字>>%@", service.name);
        /*
         获取该服务中所有的特性
         判断遍历到的特征的读写属性 然后赋值
         通过打印可看到HMCharacteristic是可读可写的
         */
        NSArray *arr = service.characteristics;
        for (HMCharacteristic *chara in arr) {
            NSLog(@"-0000000000000-特征为:%@", chara.properties);
            if ([chara.properties isEqual:HMCharacteristicPropertyReadable])
            {
                 self.charaWrite = chara;
            }
            else
            {
                 self.charaRead = chara;
                //接收外设的notifiy，类似于Ble开发中的通知
                [self.charaRead enableNotification:YES completionHandler:^(NSError * _Nullable error) {
                    
                }];
                
            }
        }
        
        if (self.charaRead)
        {//判断一下如果有这个读写特性的话 就读取它的值
            [self.charaRead readValueWithCompletionHandler:^(NSError * _Nullable error) {
                if (!error)
                {
                    /*
                     如果读取成功那么打印该值，根据当前值来改变外设状态
                     如果服务是开关，则读取到的值是0(关闭) 1(打开)
                     */
                    id value = self.charaRead.value;
                    NSLog(@"--读取到了值%@", value);
                    if ([value intValue] == 0)
                    {//q读取到的值如果是0 那么当前状态为关闭， 那么就写入1
                        [self.charaRead writeValue:@(1) completionHandler:^(NSError * _Nullable error) {
                            if (!error)
                            {
                                NSLog(@"---写入成功");
                            }
                            else
                            {
                               NSLog(@"---写入失败");
                            }
                       }];
                        
                        
                    }
                    else
                    {//读取到的为1， 写入0
                        [self.charaRead writeValue:@(0) completionHandler:^(NSError * _Nullable error) {
                            if (!error)
                            {
                                NSLog(@"---写入成功");
                            }
                            else
                            {
                                NSLog(@"---写入失败");
                            }
                        }];
                    }
                }
                else
                {
                    NSLog(@"---读取失败---");
                }
            }];
        }
    }
    
}

#pragma mark - HMAccessoryDelegate delegate

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
    NSLog(@">>>>>>>>特征的值已经改变 %@", characteristic.value);
    
}

- (void)accessory:(HMAccessory *)accessory didUpdateNameForService:(HMService *)service
{
    
}



@end
