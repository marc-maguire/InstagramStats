//
//  LoginViewController.m
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"
#import <InstagramKit.h>
#import <InstagramEngine.h>
#import "User+CoreDataProperties.h"

@interface LoginViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak) InstagramUser *myUser;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    InstagramKitLoginScope scope = InstagramKitLoginScopeRelationships | InstagramKitLoginScopeComments | InstagramKitLoginScopeLikes | InstagramKitLoginScopePublicContent | InstagramKitLoginScopeFollowerList;
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:scope];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    
    self.webView.delegate = self;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%@", webView.request.URL);
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error]) {
        
        

        NSLog(@"Received access token: %@", [[InstagramEngine sharedEngine] accessToken]);
        
        [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
            DataManager *manager = [DataManager sharedManager];
            [manager saveUser:user];
            
        
            NSLog(@"username: %@", user.username);
            //get media
            [[InstagramEngine sharedEngine] getMediaForUser: manager.currentUser.userID withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
                
                
                [manager savePhotos:media withUser:manager.currentUser];
                
                
                
            } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                NSLog(@"failed getting media call %@", error.localizedDescription);
            }];
            
            
            
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
            return;
            
        }];
        
        
        
        //[self performSegueWithIdentifier:@"toMain" sender:nil];
        
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end
