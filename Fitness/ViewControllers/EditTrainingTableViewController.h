//
//  EditTrainingTableViewController.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EditTrainingTableViewController;
@class CDTraining;

@protocol EditTrainingTableViewControllerDelegate
- (void)editTrainingTableViewControllerDidCancelled:(EditTrainingTableViewController *)controller;
- (void)editTrainingTableViewControllerDidFinished:(EditTrainingTableViewController *)controller;
@end

@interface EditTrainingTableViewController : UITableViewController

@property(weak) id<EditTrainingTableViewControllerDelegate> delegate;
@property(weak) NSObject *sender;

@property(strong) CDTraining *training;

@end
