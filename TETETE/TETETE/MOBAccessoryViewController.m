//
//  MOBAccessoryViewController.m
//  TETETE
//
//  Created by 崔林豪 on 2018/11/20.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import "MOBAccessoryViewController.h"
#import <HomeKit/HMHome.h>


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
    [self _getService];
    
    [self _getBridgeAccessory];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

#pragma mark - 获取服务
- (void)_getService
{
    //----获取服务
    //To get the services of an accessory, use the services property in the HMAccessory class.
    HMAccessory * accessory = self.currentRoom.accessories.firstObject;
    NSArray *services = accessory.services;
    
    /*
     2018-11-22 10:29:27.396185+0800 TETETE[13578:2141671] ----services--(
     "HMService 03AC1582-F6A9-5C6F-A51D-87F2215A39A7: Accessory Information Service(0000003E-0000-1000-8000-0026BB765291)",
     "HMService 403FA84F-CC05-5FE6-A576-3C1BD0F8F3F0: Lightbulb(00000043-0000-1000-8000-0026BB765291)"
     )
     */
    NSLog(@"----services--%@------", services );
    
    [services enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"-----------------services--------------------------");
        
        HMService *service = (HMService *)obj;
        //To get the name of a service, use the name property in the HMService class.
        NSString *name = service.name;
        
        //To get the characteristics of a service, use the characteristics property.
        NSArray *characteristics = service.characteristics;
        
        //To get the type of service, use the serviceType property.
        NSString *serviceType = service.serviceType;
        
        /*
         ----
         name: aTest
         characteristics: 5个
         "<HMCharacteristic: 0x281184150>",
         "<HMCharacteristic: 0x281185570>",
         "<HMCharacteristic: 0x281184620>",
         "<HMCharacteristic: 0x2811845b0>",
         "<HMCharacteristic: 0x2811844d0>"
         
         serviceType:0000003E-0000-1000-8000-0026BB765291
         
         ---
         name: Lightbulb
         characteristics:
         "<HMCharacteristic: 0x281187250>",
         "<HMCharacteristic: 0x281186f40>",
         "<HMCharacteristic: 0x281186fb0>",
         "<HMCharacteristic: 0x2811851f0>",
         "<HMCharacteristic: 0x281185340>"
         serviceType: 00000043-0000-1000-8000-0026BB76529
         
         */
        
        NSLog(@"--service-name---%@", name);//
        NSLog(@"--characteristics----%@", characteristics);
        NSLog(@"--serviceType-name---%@", serviceType);
    }];
    
}

//MARK:-获取某一个设备，可以获取bridge桥接中的任意一个
- (void)_getBridgeAccessory
{
    NSLog(@"-----------%@", self.currentHome.accessories);
    /*
     2018-11-22 11:25:38.162750+0800 TETETE[13697:2159660] -----------(
     "<HMAccessory, Name = aTest, Identifier = 778923CC-C4C2-521F-9EB4-B5977C677993, Reachable = YES>",
     "<HMAccessory, Name = testBridge, Identifier = 26E2303C-37B6-554D-9C65-A326D97C56AA, Reachable = YES>",
     "<HMAccessory, Name = Accessory1, Identifier = 474FF8E8-8CF3-58AD-9EB5-6E724F280F96, Reachable = YES>",
     "<HMAccessory, Name = accessory2, Identifier = F31003A6-1B14-580D-8C79-77B63CB17DD8, Reachable = YES>"
     )
     */
    [self.currentHome.accessories enumerateObjectsUsingBlock:^(HMAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"Accessory1"]) {
            NSLog(@"这是桥接下面的一个设备，获取到，就可以进行读写啦啦啦啦😄😄");
        }
    }];
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
    
    [self _configureAccessoryValue];
    return;
    
    //拿到只能硬件 首先 获取硬件开启的所有服务
    HMAccessory *acc = self.currentRoom.accessories[indexPath.row];
    NSArray *serviceArray = acc.services;
    acc.delegate = self;
    
    NSLog(@">>>>>这个外设中有%lu个服务>>>", serviceArray.count);
    NSLog(@">>>>>服务>>>>>>>>>>>>>>>>>>第%ld个>>>>>>>>>>>>>>>>>>>>>", (long)indexPath.row);
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



//MARK:- 更新一个已经添加到home中的accessory对象
- (void)_updateAccessoryName:(HMAccessory *)accessory
{
    
    __weak typeof(self) weakSelf = self;
    [accessory updateName:@"测试Home" completionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"-----更改名字失败---");
        }
        else
        {
            NSLog(@"-----更改名字成功---");
        }
        [weakSelf.tableView reloadData];
    }];
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
