//
//  AppDelegate.m
//  DemoApp
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIColor *globalTintColor = [UIColor colorWithRed:239./255. green:30./255. blue:19./255. alpha:1.0];
    [[UINavigationBar appearance] setTintColor:globalTintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: globalTintColor,
                                                           }];
    
    [[UIBarButtonItem appearance] setTintColor:globalTintColor];
    [[UITextView appearance] setTintColor:globalTintColor];
    [[UIToolbar appearance] setTintColor:globalTintColor];
    [[UITextField appearance] setTintColor:globalTintColor];

    return YES;
}

@end
