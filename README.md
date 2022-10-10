# BJCPrivateProtocolAlert
#### 隐私协议-模块化
| ![image](https://github.com/Alerson-Z/BJCPrivateProtocolAlert/raw/main/BCJPrivateProtocolAlert/Assets/image.gif) | ![image](https://github.com/Alerson-Z/BJCPrivateProtocolAlert/raw/main/BCJPrivateProtocolAlert/Assets/image) |
|---|--:|
### 只有两个类： 
BCJPrivateProtocolAlert ： 控制类 

BJCPrivateProtocolModel  ：  保存协议跳转地址和应用名称

使用方式：
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 用户点击过同意，会直接执行 completionBlock
    [BCJPrivateProtocolAlert showWithModel:[BJCPrivateProtocolModel new ] block:^{
            [self startApplication:application didFinishLaunchingWithOptions:launchOptions];
        }];
    // Override point for customization after application launch.
   
    return YES;
}
-(void)startApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [ViewController new];
}
```
###  model 内部
只有三个属性
```
@property (nonatomic,strong) NSURL *userAgreementURL;/* 用户协议地址 */
@property (nonatomic,strong) NSURL *privacyPolicyURL;/* 隐私政策地址 */
@property (nonatomic,strong) NSString *appName;/*设置应用名称 */ 
```