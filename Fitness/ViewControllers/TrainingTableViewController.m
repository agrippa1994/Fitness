//
//  TrainingTableViewController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "TrainingTableViewController.h"
#import "EditTrainingTableViewController.h"
#import "../Resources/Training.h"
#import "../Resources/Exercise.h"
#import "../Resources/Storage.h"

@interface TrainingTableViewController () <EditTrainingTableViewControllerDelegate>
@property(strong) NSMutableArray *trainings;
@end

@implementation TrainingTableViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trainings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingTableViewCell" forIndexPath:indexPath];
    
    Training *training = [self.trainings objectAtIndex:indexPath.row];
    cell.textLabel.text = training.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Übung%@", training.exercises.count, training.exercises.count == 1 ? @"" : @"en"];
    
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
    if(fromIndexPath.section != 1 || toIndexPath.section != 1)
        return;
    
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
        
    }
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

@end
