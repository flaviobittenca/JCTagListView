//
//  JCTagTextFieldCell.m
//  Pods
//
//  Created by Flavio Kruger Bittencourt on 5/4/16.
//
//

#import "JCTagTextFieldCell.h"

@implementation JCTagTextFieldCell 

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        
        _textField = [[UITextField alloc] initWithFrame:self.bounds];
        _textField.delegate = self;
        _textField .textAlignment = NSTextAlignmentCenter;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.font = [UIFont fontWithName:@"Avenir-Book" size:16.0f];
        _textField.textColor = [UIColor lightGrayColor];
        _textField.placeholder = @"add a new tag";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.layer.borderColor = [UIColor clearColor].CGColor;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.layer.cornerRadius = 4.0f;
        
        [self.contentView addSubview:_textField];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textField.frame = self.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textField.text = @"";
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate didPressEnterInTextField:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string lowercaseString]];
        return NO;
    }
    
    return YES;
}


@end
