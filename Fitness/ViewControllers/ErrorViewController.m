//
//  ErrorViewController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()

@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@end


@implementation ErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *message = @"";
    if(self.errorMessage != nil)
        message = self.errorMessage;
    
    self.errorLabel.text = message;
}

@end
