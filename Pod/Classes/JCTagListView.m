//
//  JCTagListView.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagListView.h"
#import "JCTagCell.h"
#import "JCTagTextFieldCell.h"
#import "JCCollectionViewTagFlowLayout.h"

@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource, JCTagTextFieldCellProtocol>

@property (nonatomic, copy) JCTagListViewBlock selectedBlock;

@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";
static NSString * const reuseTextFieldIdentifier = @"tagListViewTextFieldItemId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup
{
    _selectedTags = [NSMutableArray array];
    _tags = [NSMutableArray array];
    
    _tagStrokeColor = [UIColor lightGrayColor];
    _tagBackgroundColor = [UIColor clearColor];
    _tagTextColor = [UIColor darkGrayColor];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
    
    _tagCornerRadius = 10.0f;
    
    JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_collectionView registerClass:[JCTagTextFieldCell class] forCellWithReuseIdentifier:reuseTextFieldIdentifier];
    [self addSubview:_collectionView];
}

- (void)setCompletionBlockWithSelected:(JCTagListViewBlock)completionBlock
{
    self.selectedBlock = completionBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.textFieldEnabled) {
        if (self.tags.count == 0) {
            return  1;
        } else {
            return self.tags.count + 1;
        }
    } else {
        return self.tags.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.textFieldEnabled && (self.tags.count == 0 || (indexPath.row == self.tags.count))) {
        JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
        CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        
        return CGSizeMake(130.0f, layout.itemSize.height);
    } else {
        JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
        CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        
        CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        
        return CGSizeMake(frame.size.width + 30.0f, layout.itemSize.height);
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.textFieldEnabled && (self.tags.count == 0 || (indexPath.row == self.tags.count))) {
        JCTagTextFieldCell *textFieldCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseTextFieldIdentifier forIndexPath:indexPath];
        textFieldCell.delegate = self;
        textFieldCell.backgroundColor = self.tagBackgroundColor;
        textFieldCell.layer.borderColor = self.tagStrokeColor.CGColor;
        textFieldCell.layer.cornerRadius = self.tagCornerRadius;
        
        return textFieldCell;
    } else {
        JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.backgroundColor = self.tagBackgroundColor;
        cell.layer.borderColor = self.tagStrokeColor.CGColor;
        cell.layer.cornerRadius = self.tagCornerRadius;
        cell.titleLabel.text = self.tags[indexPath.item];
        cell.titleLabel.textColor = self.tagTextColor;
        
        if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
            cell.backgroundColor = self.tagSelectedBackgroundColor;
        }
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canSelectTags) {
        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
            cell.backgroundColor = self.tagBackgroundColor;
            
            [self.selectedTags removeObject:self.tags[indexPath.item]];
        }
        else {
            cell.backgroundColor = self.tagSelectedBackgroundColor;
            
            [self.selectedTags addObject:self.tags[indexPath.item]];
        }
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.item);
    }
}

#pragma mark - JCTagTextFieldCellDelegate

- (void)didPressEnterInTextField:(NSString *)text {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![text isEqualToString:@""]) {
        
        [self.tags addObject:text];
        [self.collectionView reloadData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPressEnterInTextFieldNotification" object:self];
}

@end
