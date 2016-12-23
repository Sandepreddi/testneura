//
//  ViewController.m
//  testneura
//
//  Created by  on 23/12/16.
//  Copyright © 2016 sandep. All rights reserved.
//

#import "ViewController.h"
#import <NeuraSDK/NeuraSDK.h>
#import "UIView+AppAddon.h"
#define kIsUserLogin @"Is_user_login"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *neuraSymbolTopmImageView;
@property (strong, nonatomic) IBOutlet UIImageView *neuraSymbolBottomImageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kIsUserLogin]) {
        [self neuraConnectSymbolAnimate];
    }
    //[self loginToNeura];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - login To Neura
- (void)loginToNeura {
    
    [self.view addDarkLayerWithAlpha:0.5];
    [[NeuraSDK sharedInstance] getAppPermissionsWithHandler:^(NSArray *permissionsArray, NSString *error) {
        
        NSMutableArray *permissions = nil;
        if (!error) {
            permissions = [NSMutableArray new];
            for (NSDictionary* dict in permissionsArray) {
                NSString *event = [dict objectForKey:@"name"];
                if(event) {
                    [permissions addObject:event];
                }
            }
        } else {
            permissions = [NSMutableArray arrayWithObjects:@"userStartedWalking",
                           @"userArrivedHome",
                           @"userArrivedHomeFromWork",
                           @"userLeftHome",
                           @"userArrivedHomeByWalking",
                           @"userArrivedHomeByRunning",
                           @"userIsOnTheWayHome",
                           @"userIsIdleAtHome", nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addDarkLayerWithAlpha:0.0];
        });
        
        [[NeuraSDK sharedInstance] authenticateWithPermissions:permissions
                                                  onController:self
                                                   withHandler:^(NSString *token, NSString *error) {
                                                       if (token) {
                                                           NSLog(@"token = %@ ", token);
                                                           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLogin];
                                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                                           [self neuraConnectSymbolAnimate];
                                                       }  else {
                                                           NSLog(@"login error = %@", error);
                                                       }
                                                   }];
    }];
    
}


#pragma mark - Neura Symbol Animation
- (void)neuraConnectSymbolAnimate{
    [UIView animateWithDuration:1 animations:^{
        self.neuraSymbolTopmImageView.frame = CGRectMake( self.view.center.x - (self.neuraSymbolTopmImageView.frame.size.width/2), self.neuraSymbolTopmImageView.frame.origin.y, self.neuraSymbolTopmImageView.frame.size.width, self.neuraSymbolTopmImageView.frame.size.height);
        self.neuraSymbolBottomImageView.frame = CGRectMake(self.view.center.x - (self.neuraSymbolTopmImageView.frame.size.width/2), self.neuraSymbolBottomImageView.frame.origin.y, self.neuraSymbolBottomImageView.frame.size.width, self.neuraSymbolBottomImageView.frame.size.height);
        self.neuraSymbolTopmImageView.alpha = 1;
        self.neuraSymbolBottomImageView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserLogin]) {
        [self logoutFromeNeura];
    } else {
        [self loginToNeura];
    }
}



#pragma mark - logout Frome Neura
- (void)logoutFromeNeura {
    [[NeuraSDK sharedInstance] logout];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsUserLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self neuraDisconnecSymbolAnimate];
}


- (void)neuraDisconnecSymbolAnimate{
    [UIView animateWithDuration:1 animations:^{
        self.neuraSymbolTopmImageView.frame = CGRectMake(self.neuraSymbolTopmImageView.frame.origin.x - self.neuraSymbolTopmImageView.frame.size.width/3, self.neuraSymbolTopmImageView.frame.origin.y, self.neuraSymbolTopmImageView.frame.size.width, self.neuraSymbolTopmImageView.frame.size.height);
        self.neuraSymbolBottomImageView.frame = CGRectMake(self.neuraSymbolBottomImageView.frame.origin.x + self.neuraSymbolBottomImageView.frame.size.width/3, self.neuraSymbolBottomImageView.frame.origin.y, self.neuraSymbolBottomImageView.frame.size.width, self.neuraSymbolBottomImageView.frame.size.height);
        self.neuraSymbolTopmImageView.alpha = 0.2;
        self.neuraSymbolBottomImageView.alpha = 0.2;
    } completion:^(BOOL finished) {
    }];
}


@end
