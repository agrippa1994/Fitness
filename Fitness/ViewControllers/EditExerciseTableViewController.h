//
//  EditExerciseTableViewController.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Resources/Exercise.h"

@class EditExerciseTableViewController;

@protocol EditExerciseTableViewControllerDelegate
- (void)editExerciseTableViewControllerDidCancel:(EditExerciseTableViewController *)controller;
- (void)editExerciseTableViewController:(EditExerciseTableViewController *)controller didFinishedWithExerciseType:(enum ExerciseType)type withWarmupInterval:(NSTimeInterval)warmup withTimeInterval:(NSTimeInterval)interval;
@end

@interface EditExerciseTableViewController : UITableViewController

@property(weak) id<EditExerciseTableViewControllerDelegate> delegate;
@property(weak) NSObject *sender;

// This method is used to set the display data
- (BOOL)setInitialData:(enum ExerciseType)type warmupTime:(NSTimeInterval)warmup timeInterval:(NSTimeInterval)interval;

@end
