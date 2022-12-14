//
//  PrivateProtocolAlert.m
//  JMBaseProject
//
//  Created by Alerson on 2022/4/23.
//  Copyright © 2022 Alerson. All rights reserved.
//

#import "BCJPrivateProtocolAlert.h"
#import "Masonry.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import <SafariServices/SafariServices.h>

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define BCJPrivateProtocolAlertDefaultsKey @"lsj-PrivateProtocolStandard"


@implementation BJCPrivateProtocolModel

- (instancetype)init{
    self = [super init];
    if(self){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.userAgreementURL = [NSURL URLWithString:@"https://www.jianshu.com"];
        self.privacyPolicyURL = [NSURL URLWithString:@"https://www.juejin.com"];
        self.appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return self;
}

@end

@interface BCJPrivateProtocolAlert()

@property (nonatomic,strong) UIView *maskView;/**< 蒙板 */
@property (nonatomic,strong) UIView *containerView;/**< 弹窗容器 */
@property (nonatomic,strong) UILabel *titleLabel;/**< 弹窗 Title */
@property (nonatomic,strong) YYLabel *descLabel;/**< 详细描述文本 */
@property (nonatomic,strong) UIButton *cancelButton;/**< 取消按钮 */

@end

@implementation BCJPrivateProtocolAlert
+(void)showWithModel:(BJCPrivateProtocolModel * ) model block:(void(^)(void))completionBlock
{
    NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:BCJPrivateProtocolAlertDefaultsKey];
    
    if (status) {
        completionBlock();
    }else{
        BCJPrivateProtocolAlert *alert = [BCJPrivateProtocolAlert new];
        alert.appName = model.appName;
        alert.userAgreementURL = model.userAgreementURL;
        alert.privacyPolicyURL = model.privacyPolicyURL;
        alert.completionBlock = completionBlock ;
        [alert show];
    }
    
}
- (instancetype)init{
    self = [super init];
    if(self){
        self.nomalTextColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        self.highlightColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
        self.userAgreementURL = [NSURL URLWithString:@"https://www.jianshu.com"];
        self.privacyPolicyURL = [NSURL URLWithString:@"https://www.juejin.com"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        self.conformButton.layer.masksToBounds = true;
        self.conformButton.layer.cornerRadius = self.conformButton.frame.size.height/2.0;
        self.conformButton.backgroundColor = [UIColor colorWithRed:83.0/255.0 green:162/255.0 blue:255.0/255.0 alpha:1];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupLayout];
}


// MARK: - Layout


-(void)setupLayout{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Mask View
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Container View
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(310);
    }];
    
    // Title Label
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.containerView.mas_top).offset(24);
    }];
    
    // Desc Label
    [self.containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(20);
        make.right.equalTo(self.containerView.mas_right).offset(-20);
    }];
    
    // Sure Button
    [self.containerView addSubview:self.conformButton];
    [self.conformButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(30.0);
        make.centerX.equalTo(self.containerView);
    }];
    
    // Cancel Button
    [self.containerView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.conformButton);
        make.top.equalTo(self.conformButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.conformButton);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-10);
    }];
    
}


// MARK: - Method

-(void)show{
    NSString *guide = [[NSUserDefaults standardUserDefaults] objectForKey:BCJPrivateProtocolAlertDefaultsKey];
    if(guide){
        if(self.completionBlock){
            self.completionBlock();
        }   
    }else{
        [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
        [UIApplication sharedApplication].delegate.window.rootViewController = self;
    }
}


-(void)cancelButtonClick{
    abort();
}

-(void)confirmButtonClick{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BCJPrivateProtocolAlertDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.completionBlock){
        self.completionBlock();
    }
}


// MARK: - Lazy
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.userInteractionEnabled = true;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.4;
    }
    return _maskView;
}

-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.masksToBounds = true;
    }
    return _containerView;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

-(YYLabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [YYLabel new];
        _descLabel.preferredMaxLayoutWidth = 270;
        _descLabel.numberOfLines = 0;
        
        
        NSString *contentString = [NSString stringWithFormat:@"%@深知个人信息对您的重要性，因此我们将竭尽全力保障用户的隐私信息安全。\n\n您可以阅读完整版《用户协议》《隐私政策》详细了解我们如何保护您的权益。\n\n我们将严格按照政策要求使用和保护您的个人信息，如您同意以上内容，请点击同意，开始使用我们的产品与服务！",self.appName];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSForegroundColorAttributeName value:self.nomalTextColor range:[contentString rangeOfString:contentString]];
        [attrString addAttribute:NSStrokeColorAttributeName value:self.nomalTextColor range:[contentString rangeOfString:contentString]];
        [attrString addAttribute:NSStrokeWidthAttributeName value:@0 range:[contentString rangeOfString:contentString]];

        NSRange range1 = [contentString rangeOfString:@"《用户协议》"];
        NSRange range2 = [contentString rangeOfString:@"《隐私政策》"];
      
        kWeakSelf(self);
        [attrString yy_setTextHighlightRange:range1 color:self.highlightColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            kStrongSelf(self);
            if(self.userAgreementClickBlock){
                self.userAgreementClickBlock();
            }else{
                SFSafariViewController * safariVC = [[SFSafariViewController alloc]initWithURL:self.userAgreementURL];
                [self presentViewController:safariVC animated:NO completion:nil];
            }
        }];
        
        [attrString yy_setTextHighlightRange:range2 color:self.highlightColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            kStrongSelf(self);
            if(self.privacyPolicyClickBlock){
                self.privacyPolicyClickBlock();
            }else{
                SFSafariViewController * safariVC = [[SFSafariViewController alloc]initWithURL:self.privacyPolicyURL];
                [self presentViewController:safariVC animated:NO completion:nil];
            }
        }];
        [attrString yy_setLineSpacing:5 range:NSMakeRange(0, contentString.length)];
        
        _descLabel.attributedText = attrString;
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descLabel;
}

-(UIButton *)conformButton{
    if(!_conformButton){
        CGSize size = CGSizeMake(270, 40);
        _conformButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                
        [_conformButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
        }];
        
        [_conformButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_conformButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _conformButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_conformButton setTitle:@"同意，继续使用" forState:UIControlStateNormal];
    }
    return _conformButton;
}



-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"不同意，退出" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:.7] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

@end

//### 给按钮设置渐变色
//```
//CGSize size = alert.conformButton.frame.size;
//CAGradientLayer *gl = [CAGradientLayer layer];
//gl.frame = CGRectMake(0,0,size.width,size.height);
//gl.startPoint = CGPointMake(0, 0.5);
//gl.endPoint = CGPointMake(1, 0.5);
//gl.colors = @[(__bridge id)[UIColor colorWithRed:235/255.0 green:134/255.0 blue:114/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:235/255.0 green:91/255.0 blue:143/255.0 alpha:1.0].CGColor];
//gl.locations = @[@(0), @(1.0f)];
//gl.cornerRadius = size.height/2.0;
//gl.masksToBounds = true;
//
//alert.conformButton.layer.shadowColor = [UIColor colorWithRed:235/255.0 green:93/255.0 blue:143/255.0 alpha:0.3].CGColor;
//alert.conformButton.layer.shadowOffset = CGSizeMake(0,6);
//alert.conformButton.layer.shadowRadius = size.height/2.0;
//alert.conformButton.layer.shadowOpacity = 0;
//[alert.conformButton.layer insertSublayer:gl below:alert.conformButton.titleLabel.layer];
//
//```
