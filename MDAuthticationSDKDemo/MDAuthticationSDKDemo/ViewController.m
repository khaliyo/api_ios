//
//  ViewController.m
//  MDAuthticationSDKDemo
//
//  Created by Wee Tom on 14-1-15.
//  Copyright (c) 2014年 Mingdao. All rights reserved.
//

#import "ViewController.h"
#import "MDAuthenticator.h"
#import "MDAuthView.h"

#warning keys
#define AppKey @"E122D74997594DF274C41722732D25C"
#define AppSecret @"C879A5862377DAF66F7FABFBB69D84CE"
#define RedirectURL @"http://www.mingdao.com"

@interface ViewController () <MDAuthViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation ViewController
#pragma mark -
#pragma mark - ViewLifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MDAPIManagerNewTokenSetNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTokenSet:) name:MDAPIManagerNewTokenSetNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button2Pressed:(UIButton *)sender {
    [self authorizeByMingdaoMobilePage];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    // 尝试使用明道App获取认证信息
    [self authorizeByMingdaoApp];
}

#pragma mark -
#pragma mark - AuthMethod
- (void)authorizeByMingdaoApp
{
    if (![MDAuthenticator authorizeByMingdaoAppWithAppKey:AppKey appSecret:AppSecret]) {
        // 未安装明道App
        [self authorizeByMingdaoMobilePage];
    }
}

- (void)authorizeByMingdaoMobilePage
{
    // 使用 @MDAuthView 来获取认证信息
    MDAuthView *view = [[MDAuthView alloc] initWithFrame:self.view.bounds];
    view.appKey = AppKey;
    view.appSecret = AppSecret;
    view.redirectURL = RedirectURL;
    view.delegate = self;
    [view showInView:self.view];
}

#pragma mark -
#pragma mark - MDAuthViewDelegate
- (void)mingdaoAuthView:(MDAuthView *)view didFinishAuthorizeWithResult:(NSDictionary *)result
{
    // @MDAuthView 的回调方法
    
    [view hide];
    NSString *errorStirng= result[MDAuthErrorKey];
    if (errorStirng) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed!" message:errorStirng delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alertView show];
    } else {
        NSString *accessToken = result[MDAuthAccessTokenKey];
        //    NSString *refeshToken = result[MDAuthRefreshTokenKey];
        //    NSString *expireTime = result[MDAuthExpiresTimeKeyl];
        [MDAPIManager sharedManager].accessToken = accessToken;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Succeed!" message:[NSString stringWithFormat:@"token = %@", accessToken] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark - Notification
- (void)newTokenSet:(NSNotification *)notification
{
    self.tokenLabel.text = notification.object;
    
    // 开始获取用户信息并展示
    [self.indicator startAnimating];
    __weak __block typeof(self) weakSelf = self;
    
    [[[MDAPIManager sharedManager] loadCurrentUserDetailWithHandler:^(MDUser *user, NSError *error){
        [weakSelf.indicator stopAnimating];
        if (error) {
            weakSelf.nameLabel.text = error.userInfo[NSLocalizedDescriptionKey];
            return ;
        }
        weakSelf.nameLabel.text = user.objectName;
        weakSelf.titleLabel.text = user.job;
        weakSelf.birthLabel.text = user.birth;
    }] start];
}
@end
