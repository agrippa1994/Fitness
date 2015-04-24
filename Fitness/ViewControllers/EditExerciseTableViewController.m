//
//  EditExerciseTableViewController.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "EditExerciseTableViewController.h"

@interface EditExerciseTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    // Initial data
    enum ExerciseType _initialExerciseType;
    NSTimeInterval _initialWarmup;
    NSTimeInterval _initialInterval;
}

@property (strong, nonatomic) IBOutlet UIPickerView *exercisePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *warmUpPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *intervalPickerView;

@end

@implementation EditExerciseTableViewController

- (IBAction)onSave:(id)sender {
    
    enum ExerciseType type = (enum ExerciseType)[self.exercisePickerView selectedRowInComponent:0];
    NSTimeInterval warmup = (NSTimeInterval)([self.warmUpPickerView selectedRowInComponent:0] + 5);
    NSTimeInterval interval = (NSTimeInterval)([self.intervalPickerView selectedRowInComponent:0] * 60 + [self.intervalPickerView selectedRowInComponent:1]);
    
    if(_delegate != nil)
        [_delegate editExerciseTableViewController:self didFinishedWithExerciseType:type withWarmupInterval:warmup withTimeInterval:interval];
}


- (IBAction)onCancel:(id)sender {
    if(_delegate != nil)
        [_delegate editExerciseTableViewControllerDidCancel:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _initialExerciseType = 0;
    _initialWarmup = 5;
    _initialInterval = 60;
    
    self.exercisePickerView.delegate = self;
    self.warmUpPickerView.delegate = self;
    self.intervalPickerView.delegate = self;
    
    self.exercisePickerView.dataSource = self;
    self.warmUpPickerView.dataSource = self;
    self.intervalPickerView.dataSource = self;
    
    [self.exercisePickerView selectRow:_initialExerciseType inComponent:0 animated:NO];
    [self.warmUpPickerView selectRow:_initialWarmup - 5 inComponent:0 animated:NO];
    [self.intervalPickerView selectRow:(NSInteger)((NSInteger)(_initialInterval) / 60) inComponent:0 animated:NO];
    [self.intervalPickerView selectRow:(NSInteger)((NSInteger)(_initialInterval) % 60) inComponent:1 animated:NO];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // The interval picker also supports minutes, so we need two components
    return (pickerView == self.intervalPickerView) ? 2 : 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(pickerView == self.exercisePickerView)
        return (NSInteger)ExerciseTypeCount;
    
    if(pickerView == self.warmUpPickerView)
        return 16;
    
    if(pickerView == self.intervalPickerView) {
        if(component == 0) return 120; // 120 minutes
        else return 60; // 60 seconds
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView == self.exercisePickerView)
        return [CDExercise exerciseTypeToString:(enum ExerciseType)row];
    
    if(pickerView == self.warmUpPickerView)
        return [NSString stringWithFormat:@"%ld Sekunden", row + 5];
    
    if(pickerView == self.intervalPickerView) {
        if(component == 0)  // minutes
            return [NSString stringWithFormat:@"%ld Minuten", row];
        else // seconds
            return [NSString stringWithFormat:@"%ld Sekunden", row];
    }
    
    return @"";
}

- (BOOL)setInitialData:(enum ExerciseType)type warmupTime:(NSTimeInterval)warmup timeInterval:(NSTimeInterval)interval {
    _initialExerciseType = type;
    _initialWarmup = warmup;
    _initialInterval = interval;
    
    return YES;
}

@end