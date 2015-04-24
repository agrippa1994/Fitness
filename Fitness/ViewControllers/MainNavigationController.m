//
//  MainTabBarController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "MainNavigationController.h"
#import "ErrorViewController.h"
#import "../Health/Health.h"

@interface MainNavigationController ()

- (void)validateHealthKit;
- (void)applicationDidEnterForeground;

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self validateHealthKit];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier compare:@"ErrorViewController"] == NSOrderedSame) {
        NSString *msg = @"Fehler beim Initialisieren von HealthKit\n"
        "Möglicherweise wird es von deinem Gerät nicht unterstützt oder es wird der Zugriff auf die Gesundheitsdaten nicht gewährt!";
        
        ((ErrorViewController *)segue.destinationViewController).errorMessage = msg;
    }
}

- (void)validateHealthKit {
    [[Health health] isAllowedToUse:^(BOOL success) {
       if(!success)
           [self performSegueWithIdentifier:@"ErrorViewController" sender:self];
    }];
}

- (void)applicationDidEnterForeground {
    [self validateHealthKit];
}

@end
