//
//  Health.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "Health.h"

@interface Health()
{
    HKHealthStore *_store;
}

@end

@implementation Health

- (id)init {
    self = [super init];
    
    _store = [[HKHealthStore alloc] init];
    
    return self;
}

+ (id)health {
    static Health *h = nil;
    if(h == nil)
        h = [[Health alloc] init];
    
    return h;
}

- (void)isAllowedToUse:(void (^)(BOOL success))completion {
    if(![HKHealthStore isHealthDataAvailable])
        completion(NO);
    
    NSSet *writeTypes = [NSSet setWithObjects:
                         [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                         [HKSampleType workoutType],
                         nil
                         ];
    
    NSSet *readTypes = [NSSet setWithObjects:
                        [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                        [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                        nil];
    
    [_store requestAuthorizationToShareTypes:writeTypes readTypes:readTypes completion:^(BOOL success, NSError *error) {
        completion(success);
    }];
}

- (void)addCalories:(double)calories {
    [self addCalories:calories forDate:nil withCompletion:nil];
}

- (void)addCalories:(double)calories forDate:(NSDate *)date {
    [self addCalories:calories forDate:date withCompletion:nil];
}

- (void)addCalories:(double)calories forDate:(NSDate *)date withCompletion:(void (^)(BOOL success))completion {
    HKQuantity *cal = [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:calories];
    
    if(date == nil)
        date = [NSDate date];

    HKQuantityType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:cal startDate:date endDate:date];
    
    [_store saveObject:sample withCompletion:^(BOOL success, NSError *p) {
        if(completion)
            completion(success);
    }];
}

- (void)addTraining:(NSDate *)start end:(NSDate *)end calories:(double)calories distance:(double)distance trainingInfo:(NSDictionary *)trainingInfo completion:(void (^)(BOOL success))completion {
    HKQuantity *dist = [HKQuantity quantityWithUnit:[HKUnit meterUnit] doubleValue:distance * 1000.0];
    HKQuantity *cal = [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:calories];
    
    HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeCrossTraining startDate:start endDate:end duration:0 totalEnergyBurned:cal totalDistance:dist metadata:trainingInfo];
    
    [_store saveObject:workout withCompletion:^(BOOL success, NSError *error) {
        if(error)
            NSLog(@"Error while saving workout: %@", error.localizedDescription);
        
        if(completion)
            completion(success);
    }];
}

- (void)addTraining:(NSDate *)start end:(NSDate *)end completion:(void (^)(BOOL success))completion {
    HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeCrossTraining startDate:start endDate:end duration:0 totalEnergyBurned:nil totalDistance:nil metadata:nil];
    
    [_store saveObject:workout withCompletion:^(BOOL success, NSError *error) {
        if(error)
            NSLog(@"Error while saving workout: %@", error.localizedDescription);
        
        if(completion)
            completion(success);
    }];
}

- (void)numberOfStepsFrom:(NSDate *)start toEnd:(NSDate *)end withCompletion:(void (^)(BOOL success, NSInteger steps))completionHandler {
    [self isAllowedToUse:^(BOOL success) {
        if(!success)
            return completionHandler(NO, 0);
        
        HKQuantityType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start endDate:end options:HKQueryOptionNone];
        
        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            if(error != nil)
                return completionHandler(NO, 0);
            
            HKQuantity *quantity = [result sumQuantity];
            if(quantity == nil)
                return completionHandler(NO, 0);
            
            return completionHandler(YES, (NSInteger)[quantity doubleValueForUnit:[HKUnit countUnit]]);
        }];
        
        [_store executeQuery:query];
    }];
}

- (void)numberOfKilometersFrom:(NSDate *)start toEnd:(NSDate *)end withCompletion:(void (^)(BOOL success, double track))completionHandler {
    [self isAllowedToUse:^(BOOL success) {
        if(!success)
            return completionHandler(NO, 0);
        
        HKQuantityType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start endDate:end options:HKQueryOptionNone];
        
        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            if(error != nil)
                return completionHandler(NO, 0);
            
            HKQuantity *quantity = [result sumQuantity];
            if(quantity == nil)
                return completionHandler(NO, 0);
            
            return completionHandler(YES, (NSInteger)[quantity doubleValueForUnit:[HKUnit unitFromString:@"km"]]);
        }];
        
        [_store executeQuery:query];
    }];
}

@end
