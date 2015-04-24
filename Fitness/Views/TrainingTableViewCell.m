//
//  TrainingTableViewCell.m
//  Fitness
//
//  Created by Mani on 23.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#import "TrainingTableViewCell.h"

@interface TrainingTableViewCell() <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TrainingTableViewCell

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.textField.delegate = self;
}

- (NSString *)inputText {
    return self.textField.text;
}

- (void)setInputText:(NSString *)text {
    self.textField.text = text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
