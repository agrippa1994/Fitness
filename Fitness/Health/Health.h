//
//  Health.h
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface Health : NSObject

+ (id)health;

- (void)isAllowedToUse:(void (^)(BOOL success))completion;

// Add calories to HealthKit
- (void)addCalories:(double)calories;
- (void)addCalories:(double)calories forDate:(NSDate *)date;
- (void)addCalories:(double)calories forDate:(NSDate *)date withCompletion:(void (^)(BOOL success))completion;

// Add a training
- (void)addTraining:(NSDate *)start end:(NSDate *)end calories:(double)calories distance:(double)distance trainingInfo:(NSDictionary *)trainingInfo completion:(void (^)(BOOL success))completion;

@end
