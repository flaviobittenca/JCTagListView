//
//  JCTagTextFieldCell.h
//  Pods
//
//  Created by Flavio Kruger Bittencourt on 5/4/16.
//
//

#import <UIKit/UIKit.h>

@protocol JCTagTextFieldCellProtocol <NSObject>

- (void)didPressEnterInTextField:(NSString *)text;

@end

@interface JCTagTextFieldCell : UICollectionViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id<JCTagTextFieldCellProtocol> delegate;
@property (nonatomic, strong) UITextField *textField;

@end
