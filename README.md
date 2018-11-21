# HomeKitProject
智能家居在线
核心代码

示例代码：

```
HMAccessory *accessory;

for(accessory in room.accessories)

{ 
 //获取到room中的所有 accessory对象
 
}

HMAccessory *accessory;

for(accessory in hoom.accessories)

{
  //获取到hoom中的所有accessory对象
  
 }


```

一旦我们获取到accessory对象，我们就可以展示一个个accessory的相关信息或者访问它的服务和对象这样就可以允许用户控制它，可设置accessory的代理方法并实现这个代理方法

#####获取room中的Accessories

Accessories 数组属于home，但是被指定给了home中的room。假如用户没有给一个accessory指定room，那么这个accessories被指定一个默认的room，这个room是roomForEntireHome方法的返回值。用room的accessores属性可以枚举room中所有的accessory

```
HMAccessory *accessory;

 for(accessory in room.accessories){

 …

 }
```
  如果你要展示一个个accessory的相关信息或者允许用户控制它，可设置accessory的代理方法并实现这个代理方法， 如果一旦获取到一个accessory对象，你就可以访问它的服务的对象
  具体内容可参考
  [Observing Changes to Accessories](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW1) 
  [Accessing Services and Characteristics](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1)
 
  
#####  获取Home 中的Accessories属性
 
  使用HMHome类中的accessories的方法，可以直接从Home对象中获取所有的accessory对象，而不用枚举home中的所有room对象，详情见[Getting the Accessories in a Room](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW5)
  
#####   创建Homes和添加Accessories

--
我们所添加或者移除的这些homeKit对象都是会保存在一个共享的homeKit数据库中的。我们在自己写的homeKitAPP中添加和移除的home，room等homekit对象，在系统自带的家庭APP中的数据都是同步的。

HomeKit对象被保存在一个可以共享的HomeKit数据库里，它可以通过HomeKit框架被多个应用程序访问，所以HomeKit调用的方法都是异步写入的，并且这些方法都包含一个完成处理后的参数。如果这个方法处理成功了，你的应用将会在完成处理函数里更新本地对象。应用程序启动时，HomeKit对象发生改变的并不能收到代理回调，只能接受处理完成后的回调函数。

想要观察其他应用程序启动的HomeKit对象的变化请参阅：[Observing HomeKit Database Changes](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW2)。查阅异步消息完成处理后传过来的错误码的信息，请参阅：[HomeKit Constants Reference.](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW2)

#####  对象命名规则
 HomeKit对象的名字，例如home，room和zone对象都可以被Siri识别，这一点已经在文档中指出。
以下几点是HomeKit对象的命名规则：

* 对象名字在其命名空间内必须是唯一的。
* 属于用户所有的home名字都在一个命名空间内。
* 一个home对象及其所包含的对象在另一个命名空间内。
* 名字只能包含数字、字母、空格以及省略号字符。
* 名字必须以数字或者字母字符开始。
* 在名字比较的时候,空格或者省略号是忽略的（例如home1和home 1 同一个名字）。
* 名字没有大小写之分。
关于那些语言可以与Siri进行交互，请参阅[HomeKit User Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/homekit/overview/introduction/)文档中的"Siri Integration"

创建Homes
在HMHomeManager类中使用addHomeWithName:completionHandler: 异步方法可以添加一个home。作为参数传到那个方法中的home的名字，必须是唯一独特的，并且是Siri   可以识别的home名字。

```

[self.homeManager addHomeWithName:@"My Home"

completionHandler:^(HMHome *home, NSError *error) {

if (error != nil) {

// Failed to add a home

} else {

// Successfully added a home

} }];

```
在else语句中，写入代码以更新应用程序的视图。为了获取home manager对象，请参阅 [Getting the Home Manager Object.](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW2)

##### 在Home中添加一个Room
--
每个Home一般有多个room，并且每个room一般会有多个智能配件。在home中，每个房间是独立的room
使用addRoomWithName:completionHandler: 异步方法可以在一个home中添加一个room对象。作为参数传到那个方法中的room的名字，必须是唯一独特的，并且是Siri可识别的room的名字。

```
NSString *roomName = @"Living Room";

[home addRoomWithName:roomName completionHandler:^(HMRoom

*room, NSError *error) {

if (error != nil) {

// Failed to add a room to a home

} else {

// Successfully added a room to a home

} }];

```
在else语句中，写入代码更新应用程序的视图。

##### 发现配件
Accessories封装了物理配件的状态，因此它不能被用户创建。想要允许用户给家添加新的配件，我们可以使HMAccessoryBrowser对象找到一个与home没有关联的配件。HMAccessoryBrower对象在后台搜寻配件，当它找到配件的时候，使用委托来通知你的应用程序。只有在startSearchingForNewAccessories方法调用之后或者stopSearchingForNewAccessories方法调用之前，HMAccessoryBrowserDelegate消息才被发送给代理对象。

##### 发现home中的配件

 一个accessory代表一个家庭中的自动化设备，例如一个智能插座，一个智能灯具等
 
* 在类接口中天啊及配件浏览器委托协议，并且添加一个配件浏览器属性。代码如下：

```
@interface EditHomeViewController ()

@property HMAccessoryBrowser *accessoryBrowser;

@end

```
用自己的类名代替EditHomeViewController

* 创建配件浏览器对象，并设置它的代理

```
self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];

self.accessoryBrowser.delegate = self;

```

* 开始搜寻配件

```
[self.accessoryBrowser startSearchingForNewAccessories];

```

* 将找到的配件添加到你的收藏里

```

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser

didFindNewAccessory:(HMAccessory *)accessory {

// Update the UI per the new accessory; for example,

reload a picker

view.

[self.accessoryPicker reloadAllComponents];

}

```
用你自己的代码实现上面的accessoryBrowser:didFindNewAccessory:方法。 当然也可以实现accessoryBrowser:didRemoveNewAccessory: 这个方法来移除配件，这个配件对你的视图或者收藏来说不再是新的。

* 停止搜寻配件
如果一个视图控制器正在开始搜寻配件，那么可以重写viewWillDisappear:方法来停止搜寻配件

```
- (void)viewWillDisappear:(BOOL)animated {

[self.accessoryBrowser stopSearchingForNewAccessories];

}
```
在WIFI网络环境下，为了安全的获取新的并且能够被HomeKit发现的无线配件，可参阅[External Accessory Framework Reference](https://developer.apple.com/documentation/externalaccessory#//apple_ref/doc/uid/TP40008235)

##### 为home和room添加配件(Accessory)

配件归属于home，并且它可以被随意添加到home中的任意一个room中。使用addAccessory:completionHandler:这个异步方法可以在home中添加配件。这个配件的名字作为一个参数传递到上述异步方法中，并且这个名字在配件所属的home中必须是唯一的。使用assignAccessory:toRoom:completionHandler: 这个异步方法可以给home中的room添加配件。配件默认的room是roomForEntireHome这个方法返回值room，下面的代码演示了如何给home和room添加配件

```
// Add an accesory to a home and a room

// 1. Get the home and room objects for the completion

handlers.

__block HMHome *home = self.home;

__block HMRoom *room = roomInHome;

// 2. Add the accessory to the home

[home addAccessory:accessory completionHandler:^(NSError

*error) {

if (error) {

// Failed to add accessory to home

} else {

if (accessory.room != room) {

// 3. If successfully, add the accessory to

the room

[home assignAccessory:accessory toRoom:room

completionHandler:^(NSError *error) {

if (error) {

// Failed to add accessory to room

} }];

} }

}];

```
配件可提供一项或者多项服务，这些服务的特性是由制造商定义.配件的服务和特性，可参阅[Accessing Services and Characteristics.](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1)

##### 更改配件名称
使用updateName:completionHandler: 异步方法可以改变配件的名称，代码如下：

```
[accessory updateName:@"Kid's Night Light"

completionHandler:^(NSError *error) {

if (error) {

// Failed to change the name

} else {

// Successfully changed the name

}

}];

```

为Homes和Room添加Bridge (桥接口)

桥接口是配件中的一个特殊对象，它允许你和其他配件交流，但是不允许你直接和HomeKit交流，例如一个桥接口可以是控制多个灯的枢纽，它使用的是自己的通信协议，而不是HomeKit配件通信协议。想要给home添加多个桥接口，你可以安装Adding Accessories to Homes and Rooms 中描述的步骤，添加任何类型的配件到home中。当你给home添加一个桥接口时，在桥接口底层的配件也会被添加到home中。正如Observing HomeKit Database Changes 中所描述的那样，每次更改通知设计模型，home的代理不会接受到桥接口的home:didAddAccessory:代理消息，而是接收一个有关于配件的home:didAddAccessory:代理消息。在home中，要把桥接口后的配件和任何类型的配件看成一样的，例如：把他们加入配件列表的配置表中，相反的是，当你给room增添一个桥接口时，这个桥接口底层的配件并不会自动添加到room中，原因是桥接口和它的配件可以位于不同的room中。

创建分区
分区(HMZone)是任意可选的房间rooms分组，例如楼上，楼下，或者卧室。房间可以被天机到一个或者多个区域

![image.png](https://upload-images.jianshu.io/upload_images/2121032-d673263e6f5fed0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可使用addZoneWithName:completionHandler: 异步方法创建分区。所创建的行为参数传递到这个方法中分区的名称，在home中必须是唯一的，并且应该能被Siri识别。代码如下：

```
__block HMHome *home = self.home;

NSString *zoneName = @"Upstairs";

[home addZoneWithName:zoneName completionHandler:^(HMZone

*zone, NSError *error)

{

if (error) {

// Failed to create zone

} else {

// Successfully created zone, now add the rooms

}

}];

```

可使用addRoom:completionHandler:异步方法给分区添加一个room，代码如下：

```

__block HMRoom *room = roomInHome;

[zone addRoom:room completionHandler:^(NSError *error) {

if (error) {

// Failed to add room to zone

} else {

// Successfully added room to zone

} }];

```

#### 观察HomeKit数据库的变化

每个Home都有一个HomeKit数据库。如图，HomeKit数据库会安全地和home授权的用户的iOS设备以及潜在的客人的iOS设备进行同步。为了给用户展示当前最新的数据，你的应用需要观察HomeKit数据库的变化。
![image.png](https://upload-images.jianshu.io/upload_images/2121032-0adcc703f3d3d9dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### HomeKit代理方法

HomeKit使用代理设计模式(delegate design pattern)来通知应用程序HomeKit对象的改变。一般来讲，如果你的应用程序调用了一个带有完成处理参数的HomeKit方法，并且这个方法被成功调用了，那么相关联的代理消息就会被发送给其他HomeKit应用，无论这些应用时安装在同一台iOS设备上还是远程iOS设备上。这些应用甚至可以运行在客人的iOS设备上。如果你的应用发起了数据改变，但是代理消息并没有发送到你的应用，那么添加代码到完成代理方法和相关联的代理方法中来刷新数据和更新视图就成为必须了。如果home布局发生了显著变化，那么就重新加载关于这个home的所有信息。在完成程序处理的情况下，请在更新应用之前检查那个方法是否成功。HomeKit也会调用代理方法来通知你的应用程序home网络状态的改变。

下图演示了 使用代理方法的过程：响应用户的操作，你的应用程序调用了addRoomWithName:completionHandler:方法，并没有错误发生，完成处理程序应当更新home的所有视图。如果成功了，homekit将会发送home:didAddRoom:消息给其他应用中homes的代理。因此，你实现的这个home:didAddRoom:方法也应该更新home的所有视图

![image.png](https://upload-images.jianshu.io/upload_images/2121032-76b821606710ebcd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

应用程序只有在前台运行的时候才能接受代理消息。当你的应用在后台时，homeKit数据库的改变并不会成批处理。也就是说，如果你的应用在后台，当其他的应用成果地添加一个room到home中的时候，你的应用程序并不会接受到home:didAddRoom: 消息。当你的应用程序到前台运行时，你的应用程序将会接受到homeManagerDidUpdateHomes:消息，这个消息是表示你的应用程序要重新加载所有的数据。

##### 观察Homes集合的改变
设置home manager的代理并且实现HMHomeManagerDelegate协议，当primary home或者home集合发生改变时，可以接受代理消息。

所有的应用都需要实现homeManagerDidUpdateHomes:方法，这个方法在完成最初获胜homes之后被调用。对新建的home manager来说，在这个方法被调用之前，primaryHome属性的值是nil，homes数组是空的数组。当应用程序开始在前台运行时也会调用homeManagerDidUpdateHomes: 方法，当其在后台运行时数据发生改变，改homeManagerDidUpdateHomes:方法会重新加载与homes相关联的所有数据。

##### 观察homes的变化

* 在类的接口中添加HMHomeManagerDelegate代理和homeManager属性。代码如下：

```
@interface AppDelegate () @property (strong, nonatomic) HMHomeManager *homeManager;

@end
```

* 创建home manager对象并设置其代理


```
- (BOOL)application:(UIApplication *)application

didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{

self.homeManager = [[HMHomeManager alloc] init];

self.homeManager.delegate = self;

return YES;

}

```

* 实现hoems发生改变时调用的代理方法。例如：如果多个视图控制器展示了hoems相关信息，你可以发布一个更改通知去更新所有视图

```
- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {

// Send a notification to the other objects

[[NSNotificationCenter defaultCenter]

postNotificationName:@"UpdateHomesNotification"

object:self];

}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager

*)manager {

// Send a notification to the other objects

[[NSNotificationCenter defaultCenter]

postNotificationName:@"UpdatePrimaryHomeNotification"

object:self];

}

```

视图控制器注册更改通知并且执行适当的操作


```
[[NSNotificationCenter defaultCenter] addObserver:self

selector:@selector(updateHomes:)

name:@"UpdateHomesNotification"

object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self

selector:@selector(updatePrimaryHome:)

name:@"UpdatePrimaryHomeNotification" object:nil];

```

#####观察个别home的变化

展示home信息的视图控制器应该成为home对象的代理，并且当home发生改变时更新视图控制器的视图。

######观察特定home对象的改变

* 在类的接口中添加home代理协议

```
@interface HomeViewController ()<HMHomeDelegate>
@end

```

* 设置配件代理

```
home.delegate = self;

```

* 实现[HMHomeDelegate](https://developer.apple.com/documentation/homekit/hmhomedelegate#//apple_ref/occ/intf/HMHomeDelegate)协议
 实现home:didAddAccessory:和home:didRemoveAccessory: 方法来更新展示配件的视图。用HMAccessory类的room属性可以获取配件所属的room。对配件来说，默认的room是roomForEntireHome这个方法的返回值
 
 Bridge Note： 当你为home添加桥接口时，桥接口底层的配件会自动被添加到home中。你的代理会接收到桥接口后每个配件的 home:didAddAccessory:消息，但是你的代理不会接收到桥接口的home:didAddAccessory:消息。

观察配件的变化
配件的状态可以在任何时间发生变化。配件可能不能被获得，可以被移除，或者被关闭。请更新用户界面以反映配件状态的更改，尤其是如果你的app允许用户控制配件时。
如果从HomeKit数据库中检索到了配件对象，可以观察个别配件的变化，具体步骤如下：

* 在类接口中添加配件代理协议

```
@interface AccessoryViewController () < HMAccessoryDelegate> 

@end
```

*  设置配件的代理
 
```
accessory.delegate = self;

```

* 实现HMAccessoryDelegate 协议
比如，执行 accessoryDidUpdateReachability: 方法以启用或者禁用配件控制


```
- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {

    if (accessory.reachable == YES) {

       // Can communicate with the accessory

    } else {

       // The accessory is out of range, turned off, etc

    }

}

```
如果你展示了配件的服务状态和特性，那么请执行以下代理方法来相应地更新视图


```
accessoryDidUpdateServices:

accessory:service:didUpdateValueForCharacteristic:

```
配件的服务具体内容，请参阅[Accessing Services and Their Characteristics](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1)

#### 访问服务和特性
服务(HMService)代表了一个配件(accessory)的某个功能和一些具体可读写的特性(HMCharacteristic)。一个配件可以拥有多项服务，一个服务可以有很多特性。比如一个车库开门器可能拥有一个照明和开关的服务。照明服务可能拥有打开/关闭和调节亮度的特性。用户不能制造智能家电配件和他们的服务-配件制造商会制造配件和它们的服务-但是用户可以改变服务的特性。一些拥有可读写属性的特性代表着某种物理状态，比如，一个恒温器中的当前问题就是一个只可读的值，但是目标温度又是可读写的。苹果预先定义了一些服务和特性的名称，以便让Siri能够识别它们。

#####获得配件的服务和属性
在依照Getting the Accessroties in a Room 中描述，你创建了一个配件对象之后，你可以获得配件的服务和特性。当然你也可以直接从home中按照类型获得不同的服务。

通过HMAccessory类对象的services属性，我们可以获得一个配件的服务。

```
NSArray *services = accessroy.services;

```
要获得一个home当中配件提供的特定服务，使用HMHome类对象的servicesWithTypes:方法

```
NSArray *lightServices = [home servicesWithTypes:[HMServicesTypeLightbulb]];

NSArray *thermostatServices = [home servicesWithTypes:[HMServicesTypeThermostat]];

```
使用HMServices类对象的name属性来获得服务的名称

```
NSString *name = services.name;
```
要获得一个服务的特性，可以使用characteristics属性

```
NSArray *characteristics = service.characteristics
```
使用servicesType属性来获得服务的类型

NSString *serviceType = service.serviceType

苹果定义了一些服务类型，并能被Siri识别：

* 门锁(Door locks)
* 车库开门器(Garage door openers)
* 灯光(Lights)
* 插座(Outlets)
* 恒温器(Thermostats)

#####改变服务名称
使用updateName:completionHandler:异步方法来改变服务名称。传入此方法的服务名称参数必须在一个home当中是唯一的，并且服务名可被Siri识别。

```
[service updateName:@"Garage 1 Opener" completionHandler:^(NSError *error) {

    if (error) {

        // Failed to change the name

    } else {

        // Successfully changed the name

    }

}];

```
#####访问特性的值

特性代表了一个服务的一个参数，它可以是只读，只写或者可读写，它提供了这个参数可能的值的信息，比如，一个布尔或者一个范围值。恒温器中的温度就是只读的，而目标温度又是可续写的，一个执行某个任务命令且不要求任何返回，比如播放一段声音或者闪烁一下灯光确认某个配件，可能就是只写的。

苹果定义了一些特性的类型，并能被Siri识别：

* 亮度(Brightness)
* 最近温度(Current temperature)
* 锁的状态(Lock state)
* 电源的状态(Power state)
* 目标状态(Target state)
* 目标温度(Target temperature)

当对于一个车库开门器来说，目标状态就是打开或者关闭。对于一个锁来说，目标状态就是上锁和未上锁。

在你获得了一个HMService对象之后，如 Getting Services and Their Properties所描述的，你可以获得每个服务的特性的值。因为这些值是从配件中获得的，这些读写的方法都是异步的，并可以传入一个完成回调的block

使用readValueWithCompletionHandler:异步方法来读取一个特性的值。

```
[characteristic readValueWithCompletionHandler:^(NSError *error) {

    if (error == nil) {
        //可以加入代码更新app视图
       // Successfully read the value 
       id value = characteristic.value;

    }

    else {

       // Unable to read the value

} }];

```

使用writeValue:completionHandler:异步方法来向一个特性写入值

```
[self.characteristic writeValue:@42 withCompletionHandler:^(NSError *error) {

    if (error == nil) {

       // Successfully wrote the value

    }

    else {

       // Unable to write the value

} }];

```
不要以为函数调用完成就以为这写入成功，实际上只有在当完成回调执行并没有错误产生时才表示写入成功。比如，知道一个开关的特性改变之前都不要改变这个开关的状态。在if语句中，加入你的代码，以更新app的视图

另外，在别的app更新了特性的值时也需要更新视图，在Observing Changes to Accessories中有描述。

##### 创建服务组
一个服务组(HMServiceGroup)提供了控制不同配件的任意数量服务的快捷方式-比如，当用户离开家之后控制家中的某些灯。
![image.png](https://upload-images.jianshu.io/upload_images/2121032-ac360ea1638cc370.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在你创建了一个HMHome对象之后，如Getting the Primary Home and Collection of Homes中描述，你也就在这个家中创建一个服务组。

为了创建一个服务组，我们使用HMHome类对象的addServiceGroupWithName:completionHandler:方法，方法中参数服务组的名称必须在此家中唯一，并可以被Siri识别

```
[self.home addServiceGroupWithName:@"Away Lights" completionHandler:^(HMServiceGroup *serviceGroup, NSError *error) {

    if (error == nil) {

       // Successfully created the service group

} else {

       // Unable to create the service group

    }];
    
```

我们使用HMServiceGroup类对象的addService:completionHandler:方法来向服务组中添加一个服务。服务可以在一个或多个服务组中。


```
[serviceGroup addService:service completionHandler:^(NSError *error) {

    if (error == nil) {

       // Successfully added service to service group

    }

       // Unable to add the service to the service group

    }];

```

通过HMServiceGroup类对象的accessory属性，我们获得服务所对应的智能电器。

```
HMAccessory *accessory = service.accessory;

```
和配件类似，代理方法在别的app改变服务组时也会被调用。如果你的app使用了服务组，请参阅HMHomeDelegate Protocol Reference文档，获悉你应该事先哪些方法以观察这些变化。

#### 测试HomeKitApp
如果你没有智能电器，你可以使用HomeKit Accessroy Simulator来模拟home中的智能电器。每个模拟配件都拥有服务和特性，你可以从你的App当中控制它。你的App在HomeKit数据库中创建对象和关系。它可以创建home布局，可以添加新的配件到模拟的home环境中，最后向home中的每个房间添加只能配件，然后，你的app就能控制这些在HomeKitAccessory Simulator展示的模拟智能配件了。为了使用HomeKit Accessory Simulator，请在iOS模拟器中运行你的应用程序，或者使用Xcode在Ios设备上运行应用程序。

HomeKitAccessory Simulator是一个附加的开发者工具，怎么安装，之前已经讲过。

##### 添加智能电器(配件)
使用HomeKit Accessory Simulator来添加只能电器到模拟网络中。
向网络中添加只能电器配件，请按照下面的步骤添加：

* 在HomeKit Accessory Simulator中，点击底部左边‘+’按钮。
* 从弹出菜单中选择添加智能电器(Add Accessory)
* 输入智能电器的名字和制造商。
* 点击完成

![image.png](https://upload-images.jianshu.io/upload_images/2121032-8ae727e2569467b4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 向智能电器中添加服务
一个智能电器需要一项服务和特性，你可以从app控制它。从预定了服务列表中选择一项服务，并自定义特性。

按照下面步骤向智能电器中添加服务

* 在HomeKit Accessory Simulator中，选择Accessories列中的某个配件。

该配件的服务信息会展示在一个详情界面中。

注意:所有智能电器都有一个Accessory Information，显示在所有其他服务的下方。你可以向这个Accessory Information服务添加特性，但你不能删除默认的特性。

* 点击添加服务(Add Service)，并从弹出视图中选择一个服务类型。
新添加的服务会在右边详细显示。HomeKit Accessory Simulator为每种服务创建通用的特性。比如一个灯光服务的默认特性为色彩(Hue)，饱和度(Saturation)，亮度(Brightness)和开关。(开关特性和电源状态特性是一样的,正如 Accessing Values of Characteristics中描述的那样。）一些特性是强制性的有一些也是可选择的。比如，开关特性就是强制性的，而色彩，饱和度，亮度这些特性都是可选择的
![image.png](https://upload-images.jianshu.io/upload_images/2121032-79bd5159fb7db385.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 向服务中添加特性
你可以向服务中添加预定义的特性，或者自定义的特性。每种特性你都只能添加一个
按照下面的步骤向服务中添加特性

* 在HomeKit Accessory Simulator中，服务详情视图，点击添加特性(Add Characteristic)
* 在特性类型菜单中，选择一个类型或者自定义类型。
* 在其他文本框中输入此特性的其他信息，并点击完成(Finish).新添加的特性会在详细视图展示出来。
* 点击特性右边的减号来删除一个特性。如果特性右边并没有减号显示，这说明这个特性对这个服务来说是必须的。比如，你可以删除电灯服务中的色彩(Hue)，饱和度(Saturation)和亮度(Brightness)，但是你不可以删除开关特性。

![image.png](https://upload-images.jianshu.io/upload_images/2121032-8c76e740d4ba9b05.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 通过你的app向家庭中添加智能电器（配件）

在你通过HomeKit Accessory Simulator创建了一个智能电器后，运行你的App然后添加一个新的智能电器到你的家庭。

#####控制智能电器(配件)
在HomeKit Accessory Simulator中，你可以获得智能电器的服务，并在其他HomeKit App中设置服务的特性值来模拟控制这个智能电器，或者手动地模拟控制智能电器

想要控制一个智能电器你需要:

* 在HomeKit Accessory Simulator中的智能电器列表（Accessories column）中选择一个智能电器。这个智能电器的服务和特性会被展示在详情界面。
* 操作一个特性的控件来改变它的值。

比如，为了改变一个灯泡的颜色（Hue），饱和度（Saturation）和亮度（Brightness），请滑动这个滑块。为了打开这个灯泡请选择On选项

![image.png](https://upload-images.jianshu.io/upload_images/2121032-3f4c94b47627412e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果你的app展示了一个服务的特性，比如灯泡的开关状态，当你在HomeKit Accessory Simulator中改变这些特性的值时，它应当更新视图。

# ++++++++++++++++++++++++++++

观察HomeKit数据库的变化,可参阅[Observing HomeKit Database Changes](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW2)
如果你想从app中通过编写代码来控制一个智能电器，请阅读[Accessing Services and Characteristics](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1)

# ++++++++++++++++++=

#### 添加桥接口

为了模拟哪些不支持HomeKit Accessory Protocol协议的智能电器，需要添加一个虚拟桥接口，然后将智能家电添加到这个虚拟桥接口。配置虚拟桥接口底层的智能电器和配置其他类型的智能电器差不多。

***添加一个虚拟桥接口到网络***
具体步骤如下：

*  在HomeKit Accessory Simulator中，点击智能电器列表底部的“+”按钮。
*   在弹出框中选择Add 虚拟桥接口。
*   输入一个智能电器的名称和制造商
* 点击完成
![image.png](https://upload-images.jianshu.io/upload_images/2121032-d1236065471ad582.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

***向虚拟桥接口添加智能电器配件***
可向一个虚拟桥接口添加一个或多个智能电器。

为了向一个虚拟桥接口添加一个智能电器，需要:

在HomeKit Accessory Simulator左边的列表中，选择虚拟桥接口中的一个虚拟桥接口。
在详情页面选择Add Accessory。
输入一个智能电器名字和制造商。
点击完成
![image.png](https://upload-images.jianshu.io/upload_images/2121032-4192d1ae94228a96.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 在你的app中添加虚拟桥接口到home
将虚拟桥接口和home匹配的过程和讲一个智能电器配置到一个home的过程是一样的，可参考[Adding Accessories to a Home in Your App](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW4) 在虚拟桥接口底层的智能电器配件也一样被加入到了home，可参阅[ Adding Bridges to Homes and Rooms](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/WritingtotheHomeKitDatabase/WritingtotheHomeKitDatabase.html#//apple_ref/doc/uid/TP40015050-CH4-SW9)

#####控制虚拟桥接口底层的智能电器
如何控制虚拟桥接口的智能电器和直接控制智能电器的步骤一致，可参阅[Controlling Accessories in HomeKit Accessory Simulator](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW5)除了你直接选择虚拟桥接口下的智能电器之外。

#####在多设备和多用户环境中测试
在iOS模拟器中你不能测试分享HomeKit数据库到多个iOS设备和用户。你应该安装你的App到多台iOS设备上，在这些设备中输入iCloud证书，然后运行你的App。或者，使用ad hoc授权来在多台注册设备中测试你的app。

为了测试单用户多设备环境，你应该使用同一个iCloud账户在多台设备登陆。
为了测试多用户使用同一家庭的智能电器，你应该在多台设备使用不同的iCloud账户登陆。
你的App应该应该可以允许一个用户邀请客人到你的家中，如Managing Users所述。

#### 创建动作集（Action Sets）和触发器（Triggers）
一个动作集合HMActionSet和触发器HMTimerTrigger允许你同时控制多个智能电器。比如，一个动作集合可能会在用户上床休息之前执行一组动作HMAction。一个写作向一个特性写入了值。动作集合中的动作是以不确定的顺序执行的。一个触发器会在一个特定的时间触发一个动作集并可以重复执行。每一个动作集合在一个家庭中都有唯一的名称并可被Siri识别。
![image.png](https://upload-images.jianshu.io/upload_images/2121032-f56acafe6e61f9ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 创建写入动作
写入动作会想一个服务的特性写入值并被加入到动作集合中去。HMAction类是HMCharacteristicWriteAction具体类的抽象基类。一个动作有一个相关联的特性对象，你可以通过Accessing Services and Characteristics中描述的来获取相关的服务和特性，然后创建这个HMCharacteristicWriteAction

为了创建一个动作，我们使用HMCharacteristicWriteAction类中的initWithCharacteristic:targetValue:方法。


```
HMCharacteristicWriteAction *action = [[HMCharacteristicWriteAction alloc] initWithCharacteristic:characteristic targetValue:value];

```
在你的代码中，你使用对应的特性的期望来替换value参数，并使用对应的HMCharacteristic对象来替换characteristic参数

#####创建并执行动作集

一个动作集就是一个共同执行的动作的集合。比如一个夜间动作集合可能包含关闭电灯，调低恒温水平和锁上房门。

为了创建一个动作集我们使用addActionSetWithName:completionHandler:异步方法


```
[self.home addActionSetWithName:@"NightTime" completionHandler:^(HMActionSet *actionSet, NSError *error) {

    if (error == nil) {

        // 成功添加了一个动作集

    } else {

        // 添加一个动作集失败

    }

}];

```

为了添加一个动作到动作集，我们使用addAction:completionHandler:异步方法


```
[actionSet addAction:action completionHandler:^(NSError *error) {

    if (error == nil) {

        // 成功添加了一个动作到动作集

    } else {

    // 添加一个动作到动作集失败

    }

}];

```
想要移除一个动作，可使用removeAction:completionHandler:方法。
想要执行一个动作集，可使用HMHome类的executeActionSet:completionHandler:方法。比如，用户希望控制所有的节日彩灯。我们就创建一个动作集来打开所有的节日彩灯，另外一个动作集来关闭所有的节日彩灯。为了打开所有的节日彩灯，发送executeActionSet:completionHandler:消息给home对象，并传递"打开节日彩灯"动作集。

##### 创建并开启触发器
触发器会执行一个或多个动作集。iOS会在后台管理和运行你的触发器。HMTrigger类是HMTimerTrigger具体类的抽象类。当你创建一个空时触发器时，你需要指定触发时间和触发的周期，创建并开启一个定时触发器需要多个步骤来完成。

***循环下面几步来创建并启动一个定时触发器***

###### 创建一个定时器触发

* 创建定时触发器

```
self.trigger = [[HMTimerTrigger alloc] initWithName:name

fireDate:fireDate

timeZone:niL

recurrence:nil

recurrenceCalendar:nil];

```
触发时间必须设置在将来的某个时刻，第二参数必须为0，如果你设置了一个周期，周期的最小值是5分钟，最大值是5周。

* 添加一个动作集到触发器

使用HMTrigger 基类方法addActionSet:completionHandler:来添加一个动作集到触发器

* 添加一个触发器到家庭
使用HMHome类中的addTrigger:completionHandler:方法来添加一个触发器到家庭

* 启动触发器
新创建的触发器默认是未启动的，需要使用enable:complationHandler:方法启动触发器
一个定时触发器被启动后，会周期性的运行它的动作集。

#### 用户管理
创建home的用户是该home的管理员，可以执行所有操作，包括添加一个客人用户到home。任何管理员添加到这个home的用户(HMUser)都有一个有限的权限。客人不能更改家庭的布局，但是可以执行下面的动作：

* 识别智能电器
* 读写特性
* 观察特性值变化
* 执行动作集

比如，一个家庭的户主可以创建一个home布局并向其中添加家庭成员。每个家庭成员必须拥有一个iOS设备和Apple ID以及相关的iCloud账户。iCloud需要个人输入的APPle ID和户主提供的APPle ID 相吻合，以便让他们访问这个home。考虑到隐私问题，Apple ID对你的App是不可见的。

管理员需要遵从一下步骤来添加一个客人到home中：

* 管理员调用一个动作将客人添加到home中。
* 你的App调用addUserWithCompletionHandler:异步方法
* HomeKit展示一个对话框，要求输入客人的Apple ID
* 用户输入客人的Apple ID
* 在完成回调中返回一个新的用户
* 你的App展示客人的名字

添加一个客人到home，需要在客人的iOS设备上做一下操作：
用户在iCloud偏好设置中输入iClound凭证(Apple ID 和密码)
用户启动你的App
你的App通过home manager object 获得一个home集合
如果iClound的凭证和管理员输入的Apple ID相同，那么管理员的home将会出现在homes属性中。
客人执行的操作可能会失败。如果一个异步方法中出现HMErrorCodeInsufficientPrivileges错误码的话，这就意味着用户没有足够的权限来执行动作-也许这个用户是客人，而不是管理员。
为了测试你的App是否正确处理了客人用户，可参阅[Testting Multiple iOS Devices and Users](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW12)

##### 添加和移除用户
为了添加一个客人用户到home，使用addUserWithCompletionHandler:异步方法

```
[self.home addUserWithCompletionHandler:^(HMUser *user, NSError *error) {

    if (error == nil) {

        // Successfully added a user

    }

    else {

       // Unable to add a user

} }];

```
想要移除home中的用户，可使用HMHome类的removeUser:completionHandler:方法。

通过实现HMHomeDelegate协议中的home:didAddUser:和home:didRemoveUser:协议方法检查新添加和移除的用户并更新视图。关于如何创建一个delegate，可参阅[Observing Changes to Individual Homes](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW4)

##### 获得用户名
你的app对用户名只有读写权限，并不能读写用户的Apple ID。使用HMHome对象的users属性来获取用户。使用HMUser类的name属性来获取用户名。


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
