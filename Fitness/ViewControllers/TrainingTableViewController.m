//
//  TrainingTableViewController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "TrainingTableViewController.h"
#import "EditTrainingTableViewController.h"
#import "../CoreData/CoreData.h"
#import "../CoreData/CDTraining.h"

@interface TrainingTableViewController () <NSFetchedResultsControllerDelegate, EditTrainingTableViewControllerDelegate>
{
    NSFetchedResultsController *_fetchController;
}

@end

@implementation TrainingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    NSManagedObjectContext *context = [[CoreData coreData] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CDTraining"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchController.delegate = self;
    
    [_fetchController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_fetchController fetchedObjects] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingTableViewCell" forIndexPath:indexPath];
    
    CDTraining *training = ((CDTraining *)[[_fetchController fetchedObjects] objectAtIndex:indexPath.row]);
    cell.textLabel.text = training.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Übungen", training.exercises.count];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete)
        return;
    
    // Delete object from context
    NSManagedObjectContext *context = [[CoreData coreData] managedObjectContext];
    [context deleteObject:[[_fetchController fetchedObjects] objectAtIndex:indexPath.row]];
    
    // Refetch data
    [_fetchController performFetch:nil];
    
    // Reorder indices
    NSArray *array = [_fetchController fetchedObjects];
    for(int i = 0; i < array.count; i++)
        ((CDTraining *)[array objectAtIndex:i]).index = [NSNumber numberWithInt:i];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *array = [[_fetchController fetchedObjects] mutableCopy];
    
    id movee = [array objectAtIndex:fromIndexPath.row];
    
    [array removeObjectAtIndex:fromIndexPath.row];
    [array insertObject:movee atIndex:toIndexPath.row];
    
    for(int i = 0; i < array.count; i++)
        ((CDTraining *)[array objectAtIndex:i]).index = [NSNumber numberWithInt:i];
    
    [_fetchController performFetch:nil];
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
            
            if([sender isKindOfClass:[UITableViewCell class]]) {
                NSInteger index = [self.tableView indexPathForCell:(UITableViewCell *)sender].row;
                controller.training = (CDTraining *)[[_fetchController fetchedObjects] objectAtIndex:index];
            }
            else {
                NSManagedObjectContext *context = [[CoreData coreData] managedObjectContext];
                NSEntityDescription *description = [NSEntityDescription entityForName:@"CDTraining" inManagedObjectContext:context];
                
                controller.training = [[CDTraining alloc] initWithEntity:description insertIntoManagedObjectContext:nil];
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
        [self.tableView reloadData];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)controller.sender] animated:YES];
    } else {
        // Store the new training and appent it at the end
        controller.training.index = [NSNumber numberWithInt:(int)[_fetchController fetchedObjects].count];
        [[[CoreData coreData] managedObjectContext] insertObject:controller.training];
        
        // Store all exercises
        for(NSManagedObject *exercise in controller.training.exercises) {
            [[[CoreData coreData] managedObjectContext] insertObject:exercise];
        }
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    [_fetchController performFetch:nil];
    [self.tableView reloadData];
}

@end
