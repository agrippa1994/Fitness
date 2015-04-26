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

#pragma mark Actions
- (void)textFieldDidChange:(UITextField *)textField {
    if(_delegate)
        [_delegate trainingTableViewCell:self didChangedText:textField.text];
}

#pragma mark Overrided Base Methods
-(void) awakeFromNib {
    [super awakeFromNib];
    
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
}

#pragma mark UITextField Delegation
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Methods
- (NSString *)inputText {
    return self.textField.text;
}

- (void)setInputText:(NSString *)text {
    self.textField.text = text;
}

@end
