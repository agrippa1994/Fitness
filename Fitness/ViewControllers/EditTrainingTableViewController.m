//
//  EditTrainingTableViewController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "EditTrainingTableViewController.h"
#import "EditExerciseTableViewController.h"
#import "../Views/TrainingTableViewCell.h"
#import "../Resources/Training.h"
#import "../Resources/Exercise.h"

@interface EditTrainingTableViewController () <EditExerciseTableViewControllerDelegate, TrainingTableViewCellDelegate>

@end

@implementation EditTrainingTableViewController

#pragma mark Storyboard Actions
- (IBAction)onCancel:(id)sender {
    if(_delegate != nil)
        [_delegate editTrainingTableViewControllerDidCancelled:self];
}

- (IBAction)onSave:(id)sender {
    if(self.training.name.length == 0)
        return [[[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Name ist leer!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    if(self.training.exercises.count == 0)
        return [[[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Keine Übungen!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    if(_delegate != nil)
        [_delegate editTrainingTableViewControllerDidFinished:self];
}

#pragma mark Overloaded Base Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.editing = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *underlayingController = ((UINavigationController *)segue.destinationViewController).topViewController;
        
        if([underlayingController isKindOfClass:[EditExerciseTableViewController class]]) {
            EditExerciseTableViewController *controller = (EditExerciseTableViewController *)underlayingController;
            controller.delegate = self;
            controller.sender = sender;
            
            if([sender isKindOfClass:[UITableViewCell class]]) {
                NSUInteger index = [self.tableView indexPathForCell:(UITableViewCell *)sender].row;
                
                Exercise *exercise = [self.training.exercises objectAtIndex:index];
                [controller setInitialData:exercise.type warmupTime:[exercise.warmup integerValue] timeInterval:[exercise.interval integerValue]];
            }
        }
    }
}

#pragma mark UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return 1;
        case 1:
            return self.training.exercises.count;
        case 2:
            return 1;
    }
    
    return 0;
}

#pragma mark UITableView Delegation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"";
    switch(indexPath.section) {
        case 0:
            reuseIdentifier = @"TrainingNameCell";
            break;
        case 1:
            reuseIdentifier = @"TrainingDetailCell";
            break;
        case 2:
            reuseIdentifier = @"AddTrainingCell";
            break;
    };
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
   
    if(indexPath.section == 0) {
        TrainingTableViewCell *ptr = (TrainingTableViewCell *)cell;
        
        [ptr setInputText:self.training.name];
        ptr.delegate = self;
    }
    
    if(indexPath.section == 1) {
        Exercise *exercise = [self.training.exercises objectAtIndex:indexPath.row];
        
        NSInteger minutes = [exercise.interval integerValue] / 60;
        NSInteger seconds = [exercise.interval integerValue] % 60;
        
        cell.textLabel.text = [Exercise exerciseTypeToString:exercise.type];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Minute%@ %ld Sekunde%@", minutes, minutes == 1 ? @"" : @"n", seconds, seconds == 1 ? @"" : @"n"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section != 1)
        return;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"EditExerciseTableViewController" sender:cell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1; // Edit only exercises
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete)
        return;

    [self.training.exercises removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id movee = [self.training.exercises objectAtIndex:fromIndexPath.row];
    [self.training.exercises removeObject:movee];
    [self.training.exercises insertObject:movee atIndex:toIndexPath.row];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1; // Move only exercises;
}

#pragma mark EditExerciseTableViewController Delegation
- (void)editExerciseTableViewController:(EditExerciseTableViewController *)controller didFinishedWithExerciseType:(enum ExerciseType)type withWarmupInterval:(NSTimeInterval)warmup withTimeInterval:(NSTimeInterval)interval {
    
    if(controller.sender == nil)
        return;

    // Edit the object only
    if([controller.sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)controller.sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        NSUInteger index = path.row;
        
        Exercise *exercise = [self.training.exercises objectAtIndex:index];
        exercise.type = type;
        exercise.warmup = [NSNumber numberWithInteger:warmup];
        exercise.interval = [NSNumber numberWithInteger:interval];
        
        // Disable the highlighting of the table's cell
        [self.tableView deselectRowAtIndexPath:path animated:YES];
    } else {
        Exercise *exercise = [[Exercise alloc] init];
        
        exercise.type = type;
        exercise.warmup = [NSNumber numberWithInteger:warmup];
        exercise.interval = [NSNumber numberWithInteger:interval];
        
        [self.training.exercises addObject:exercise];
    }
    
    [self.tableView reloadData];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)editExerciseTableViewControllerDidCancel:(EditExerciseTableViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TrainingTableViewCell Delegation
- (void)trainingTableViewCell:(TrainingTableViewCell *)cell didChangedText:(NSString *)text {
    self.training.name = text;
}

@end
