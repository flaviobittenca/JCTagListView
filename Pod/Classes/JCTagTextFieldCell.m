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
        _textField .textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont fontWithName:@"Avenir-Book" size:15.0f];
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

@end
