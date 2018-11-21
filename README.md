# HomeKitProject
智能家居在线
核心代码

++++++++++++++++++++++++++++++++++++++++++++++++++++++

### 代码示例

##### 获取homes

初始化之后我们在其回调方法中可以获取到manager.homes，这是一个数组，里边是用户的全部HMhome对象，我们可以遍历这个数组获取到全部的home，通过home.name得到home的名字。代码如下：

```
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

```

##### 添加删除home
使用homeManager对象来调用。这两个方法同样有两个回调方法来告诉我们是否操作成功

```
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


```
##### 获取room
获取到HMhome对象之后可以通过home.rooms获取到该home的全部room。同样通过遍历这个数组获取到全部的HMroom对象，然后通过room.name获取到room的名字


```
- (void)_updateCurrentHomesRooms:(HMHome *)home
{
    NSLog(@"------开始更新rooms数据");
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


```
##### 添加和移除room
同添加和移除home，不过是使用HMhome对象来调用


```
//删除room
- (void)romoveRoom:(HMHome *)home
{
    if (home.rooms.count > 0)
    {
        [home removeRoom:home.rooms.firstObject completionHandler:^(NSError * _Nullable error) {
            NSLog(@"-----删除了Room---%@----%@", home, home.rooms);
        }];
    }
    
}

//添加room
[self.currentHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
                if (!error) {
                    [weakSelf _updateCurrentHomesRooms:weakSelf.currentHome];
                }
 }];
            
```

### Accessories

##### 寻找一个新的accessory

Accessories封装了物理配件的状态，因此它不能被用户创建，也就是说我们不能去创建智能硬件对象，只能通过去搜寻它，然后添加。想要允许用户给家添加新的配件，我们可以使HMAccessoryBrowser对象在后台搜寻一个与home没有关联的配件，当它找到配件的时候，系统会调用委托方法来通知你的应用程序。
具体步骤如下：

* 设置 HMAccessoryBrowserDelegate的代理
* 添加一个HMAccessoryBrowser对象属性

```
- (void)_initConfigure
{
    self.browser = [[HMAccessoryBrowser alloc] init];
    self.browser.delegate = self;
    self.accessoryArray = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

```

* 创建一个搜索按钮，在按钮的点击方法里开始搜索硬件，需要实现代理方法

```
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


```

* 点击按钮开始搜索新的智能硬件，如果搜索到硬件系统会通过didFindNewAccessory这个回调方法来通知我们发现了硬件，每次发现一个智能硬件这个方法都会调用一次

搜索结果如下：

```
2018-11-20 15:50:05.846864+0800 TETETE[14430:2872234] -------开始搜索设备----
2018-11-20 15:50:06.326251+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.330283+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.330490+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.330645+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.330839+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.331000+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.331163+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 15:50:06.331322+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<
2018-11-20 16:02:06.950860+0800 TETETE[14430:2872234] >>>>>>>>>>>已经发现了一个新的硬件<<<<<<<<<<<

```
对应的设备信息
![image.png](https://upload-images.jianshu.io/upload_images/2121032-bccc2d1b978eb294.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 为新的Accessory对象，指定一个room


```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选取目标 进行配置
    //获取当前选择的外设对象
    HMAccessory *acc = self.accessoryArray[indexPath.row];
    __block HMHome *home = self.currentHome;
    
    __weak typeof(self) weakSelf = self;
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

```

添加外设和指定room的方法都是由HMHome对象调用的。如果我们只是向home中添加了设备，没有指定room那么它就会被放入到一个默认的room中
![image.png](https://upload-images.jianshu.io/upload_images/2121032-aa5bc5009de99bea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/2121032-406485de30d174fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/2121032-188b62e593f8a102.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 移除一个已经添加到home中的accessory对象


```
//MARK:- 移除一个已经添加到home中的accessory对象
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

```

##### 查看当前的设备

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"-----w进入了我的房间-------");
    [self.currentRoom.accessories enumerateObjectsUsingBlock:^(HMAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"----当前的设备----%@", obj.name);
    }];
}

```

*** 注意事项 ***
*** 使用真机调试，连接时要先打开手机蓝牙
 1. 电脑使用WiFI 一定要和手机使用的WIFI同一个，电脑的蓝牙也打开
 2. 连接会不稳当，时而可以连接，时而又会不弹出添加设备的界面
 3. 建议可以先使用手机自带的家庭App进行连接，如果手机自带的App可以连接成功，再去测试你自己写的Demo 
 4. 一旦设备添加到Room中，再次搜素就不会再出现
 ***
 
#####  使用APP实现对硬件对象的基本控制
我是这样处理的，如果有设备了则给一个展示设备的页面，如果没有设备的，跳转到搜索设备的界面，当然你也可以都用一个，只是测试Demo
在展示设备的页面中
![image.png](https://upload-images.jianshu.io/upload_images/2121032-9d67a58b4dbe3082.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在tableView的cell点击方法中，设置设备的代理，进行对设备的值进行读写操作，代码如下：

```

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

```
  打印结果：
  
```
2018-11-21 16:57:51.869010+0800 TETETE[12656:1982261] >>>>服务的名字>>Switch 466044934
2018-11-21 16:57:51.869178+0800 TETETE[12656:1982261] -0000000000000-特征为:(
    HMCharacteristicPropertyReadable
)
2018-11-21 16:57:51.869399+0800 TETETE[12656:1982261] -0000000000000-特征为:(
    HMCharacteristicPropertyWritable,
    HMCharacteristicPropertyReadable,
    HMCharacteristicPropertySupportsEventNotification
)
2018-11-21 16:57:51.902866+0800 TETETE[12656:1982261] --读取到了值0
2018-11-21 16:57:51.908635+0800 TETETE[12656:1982261] --读取到了值0
2018-11-21 16:57:51.918117+0800 TETETE[12656:1982261] ---写入成功
2018-11-21 16:57:51.919101+0800 TETETE[12656:1982261] ---写入成功

```

当你点击cell的时候，进行读写设备的数据，可以通过HomeKit Accessory Simulator 模拟器看到界面上的控件（比如开关在变化）
![image.png](https://upload-images.jianshu.io/upload_images/2121032-8ee07c63ec9362e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
