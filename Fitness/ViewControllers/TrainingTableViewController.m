//
//  TrainingTableViewController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <ResearchKit/ResearchKit.h>
#import "TrainingTableViewController.h"
#import "EditTrainingTableViewController.h"
#import "../Health/Health.h"
#import "../Resources/Training.h"
#import "../Resources/Exercise.h"
#import "../Resources/Storage.h"

@interface TrainingTableViewController () <EditTrainingTableViewControllerDelegate, ORKTaskViewControllerDelegate>
@property(strong) NSMutableArray *trainings;
@property NSDate *trainingStart;
@property NSInteger lastStep;
@property UILocalNotification *currentNotification;

- (void)startLocalNotificationWithInterval:(NSTimeInterval)interval;
- (void)cancelLocalNotification;

@end

@implementation TrainingTableViewController

#pragma mark Overloaded Base Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // Load the trainings
    self.trainings = [Storage trainings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *underlayingController = ((UINavigationController *)segue.destinationViewController).topViewController;
        
        if([underlayingController isKindOfClass:[EditTrainingTableViewController class]]) {
            EditTrainingTableViewController *controller = (EditTrainingTableViewController *)underlayingController;
            
            controller.delegate = self;
            controller.sender = sender;
            
            // Edit training
            if([sender isKindOfClass:[UITableViewCell class]]) {
                NSInteger index = [self.tableView indexPathForCell:(UITableViewCell *)sender].row;
                controller.training = [[self.trainings objectAtIndex:index] mutableCopy];
            }
            else {
                // Insert training
                controller.training = [[Training alloc] init];
            }
        }
    }
}

#pragma mark UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trainings.count;
}

#pragma mark UITableView Delegation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingTableViewCell" forIndexPath:indexPath];
    
    Training *training = [self.trainings objectAtIndex:indexPath.row];
    cell.textLabel.text = training.name;
    
    NSInteger durationMinutes = ((NSInteger)[training exerciseDuration]) / 60;
    NSInteger durationSeconds = ((NSInteger)[training exerciseDuration]) % 60;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Übung%@, Dauer: %ld Minute%@ %ld Sekunde%@",
                                 training.exercises.count, training.exercises.count == 1 ? @"" : @"en",
                                 durationMinutes, durationMinutes == 1 ? @"" : @"n",
                                 durationSeconds, durationSeconds == 1 ? @"" : @"n"
                                 ];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete)
        return;
    
    [self.trainings removeObjectAtIndex:indexPath.row];
    [Storage saveTrainings:self.trainings];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id movee = [self.trainings objectAtIndex:fromIndexPath.row];
    [self.trainings removeObject:movee];
    [self.trainings insertObject:movee atIndex:toIndexPath.row];
    [Storage saveTrainings:self.trainings];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.isEditing) {
        [self performSegueWithIdentifier:@"EditTrainingTableViewController" sender:[tableView cellForRowAtIndexPath:indexPath]];
    } else {
        Training *training = [self.trainings objectAtIndex:indexPath.row];
        ORKTaskViewController *controller = [[ORKTaskViewController alloc] initWithTask:[training trainingTask] taskRunUUID:nil];
        
        controller.delegate = self;
        self.trainingStart = [NSDate date];
        self.lastStep = 0;
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark EditTrainingTableViewController Delegation
- (void)editTrainingTableViewControllerDidCancelled:(EditTrainingTableViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)editTrainingTableViewControllerDidFinished:(EditTrainingTableViewController *)controller {
    if(controller.sender == nil)
        return;
    
    // The controller was opened by a table cell
    if([controller.sender isKindOfClass:[UITableViewCell class]]) {
        NSUInteger index = [self.tableView indexPathForCell:(UITableViewCell *)controller.sender].row;
        [self.trainings setObject:controller.training atIndexedSubscript:index];
                            
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)controller.sender] animated:YES];
    } else {
        // Store the new training and appent it at the end
        [self.trainings addObject:controller.training];
        
    }
                            
    [self.tableView reloadData];
    [controller dismissViewControllerAnimated:YES completion:nil];
    [Storage saveTrainings:self.trainings];
}

#pragma mark ORKTaskViewController Delegation
- (void)taskViewController:(ORKTaskViewController * __nonnull)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)error {
    [taskViewController dismissViewControllerAnimated:YES completion:nil];
    
    // Add data to HealthKit
    if(reason == ORKTaskViewControllerFinishReasonCompleted) {
        [[Health health] addTraining:self.trainingStart end:[NSDate date] completion:nil];
        [self startLocalNotificationWithInterval:0];
    }
    
    self.lastStep = 0;
}

- (void)taskViewController:(ORKTaskViewController * __nonnull)taskViewController stepViewControllerWillAppear:(ORKStepViewController * __nonnull)stepViewController {
    ORKTaskProgress progress = [taskViewController.task progressOfCurrentStep:stepViewController.step withResult:taskViewController.result];
    if(progress.current <= self.lastStep)
        [self cancelLocalNotification];
    
    self.lastStep = progress.current;
    
    if(stepViewController.step != nil) {
        if([stepViewController.step isKindOfClass:[ORKActiveStep class]]) {
            [self startLocalNotificationWithInterval:((ORKActiveStep *)stepViewController.step).stepDuration];
        }
    }
}

#pragma mark Methods
- (void)startLocalNotificationWithInterval:(NSTimeInterval)interval {
    self.currentNotification = [UILocalNotification new];
    self.currentNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    self.currentNotification.alertBody = @"Zeit abgelaufen!";
    self.currentNotification.soundName = UILocalNotificationDefaultSoundName;
    
    if(interval == 0)
        [[UIApplication sharedApplication] presentLocalNotificationNow:self.currentNotification];
    else
        [[UIApplication sharedApplication] scheduleLocalNotification:self.currentNotification];
}

- (void)cancelLocalNotification {
    if(self.currentNotification == nil)
        return;
    
    [[UIApplication sharedApplication] cancelLocalNotification:self.currentNotification];
    self.currentNotification = nil;
}
@end
