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
#import "../CoreData/CoreData.h"

@interface EditTrainingTableViewController () <EditExerciseTableViewControllerDelegate, NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchController;
}

- (NSArray *)sortedExercises;

@end

@implementation EditTrainingTableViewController

- (IBAction)onCancel:(id)sender {
    if(_delegate != nil)
        [_delegate editTrainingTableViewControllerDidCancelled:self];
}

- (IBAction)onSave:(id)sender {
    
    TrainingTableViewCell *cell = (TrainingTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    if([cell inputText].length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Name ist leer!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if(self.training.exercises.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Keine Übungen!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    self.training.name = [cell inputText];
    
    if(_delegate != nil)
        [_delegate editTrainingTableViewControllerDidFinished:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSManagedObjectContext *context = [[CoreData coreData] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CDExercise"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchController.delegate = self;
    
    [_fetchController performFetch:nil];
}

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

    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1; // Move only exercises;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *underlayingController = ((UINavigationController *)segue.destinationViewController).topViewController;
        
        if([underlayingController isKindOfClass:[EditExerciseTableViewController class]]) {
            EditExerciseTableViewController *controller = (EditExerciseTableViewController *)underlayingController;
            controller.delegate = self;
            controller.sender = sender;
            
            if([sender isKindOfClass:[UITableViewCell class]]) {
                //Exercise *exercise = [self.training.exercises objectAtIndex:<#(NSUInteger)#>]
                //controller setInitialData:<#(enum ExerciseType)#> warmupTime:<#(NSTimeInterval)#> timeInterval:<#(NSTimeInterval)#>
            }
        }
    }
}

- (void)editExerciseTableViewController:(EditExerciseTableViewController *)controller didFinishedWithExerciseType:(enum ExerciseType)type withWarmupInterval:(NSTimeInterval)warmup withTimeInterval:(NSTimeInterval)interval {
    
    if(controller.sender == nil)
        return;
    
    NSManagedObjectContext *context = [[CoreData coreData] managedObjectContext];
    
    // Edit the object only
    if([controller.sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)controller.sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        
        // Disable the highlighting of the table's cell
        [self.tableView deselectRowAtIndexPath:path animated:YES];
    } else {
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CDExercise" inManagedObjectContext:context];
        CDExercise *exercise = [[CDExercise alloc] initWithEntity:description insertIntoManagedObjectContext:nil];
        
        
        exercise.type = type;
        exercise.warmup = [NSNumber numberWithInteger:warmup];
        exercise.interval = [NSNumber numberWithInteger:interval];
        exercise.index = [NSNumber numberWithInt:(int)[self sortedExercises].count];
        
        [self.training addExercisesObject:exercise];
    }
    
    [self.tableView reloadData];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)editExerciseTableViewControllerDidCancel:(EditExerciseTableViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)sortedExercises {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [self.training.exercises sortedArrayUsingDescriptors:@[descriptor]];
}

@end
