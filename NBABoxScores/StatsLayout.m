//
//  StatsLayout.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/9/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "StatsLayout.h"
#import "Game.h"

#import "HomeCollectionView.h"
#import "StatsCollectionViewCell.h"

@interface StatsLayout ()
@property (strong, nonatomic) NSMutableArray *itemAttributes;
@property (strong, nonatomic) NSMutableArray *itemsSize;
@property (nonatomic, assign) CGSize contentSize;

@property Game *game;
@property HomeCollectionView *scv;
@property StatsCollectionViewCell *scvc;


@end

@implementation StatsLayout

- (void)prepareLayout
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"game" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];

    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    self.game = [[Game alloc] initWithDictionary:jsonDict];
    
    if (self.collectionView.numberOfSections == 0) {
        return;
    }

    NSUInteger column = 0; // Current column inside row
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    CGFloat contentWidth = 0.0; // To determine the contentSize
    CGFloat contentHeight = 0.0; // To determine the contentSize

    if (self.itemAttributes.count > 0) { // We don't enter in this if statement the first time, we enter the following times
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            for (NSUInteger index = 0; index < numberOfItems; index++) {
                if (section != 0 && index != 0) { // This is a content cell that shouldn't be sticked
                    continue;
                }
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:section]];
                if (section == 0) { // We stick the first row
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;

                }
                if (index == 0) { // We stick the first column
                    CGRect frame = attributes.frame;
                    frame.origin.x = self.collectionView.contentOffset.x;
                    attributes.frame = frame;
                }
            }
        }

        return;
    }

    // The following code is only executed the first time we prepare the layout
    self.itemAttributes = [@[] mutableCopy];
    self.itemsSize = [@[] mutableCopy];

    // Tip: If we don't know the number of columns we can call the following method and use the NSUInteger object instead of the NUMBEROFCOLUMNS macro
    // NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];

    // We calculate the item size of each column
    if (self.itemsSize.count != self.game.statsDictionary.count + 1) {
        [self calculateItemsSize];
    }

    // We loop through all items
    for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSMutableArray *sectionAttributes = [@[] mutableCopy];
        for (NSUInteger index = 0; index < self.game.statsDictionary.count + 1; index++) {
            CGSize itemSize = [self.itemsSize[index] CGSizeValue];

            // We create the UICollectionViewLayoutAttributes object for each item and add it to our array.
            // We will use this later in layoutAttributesForItemAtIndexPath:
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));

            if (section == 0 && index == 0) {
                attributes.zIndex = 1024; // Set this value for the first item (Sec0Row0) in order to make it visible over first column and first row
            } else if (section == 0 || index == 0) {
                attributes.zIndex = 1023; // Set this value for the first row or section in order to set visible over the rest of the items
            }
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame; // Stick to the top
            }
            if (index == 0) {
                CGRect frame = attributes.frame;
                frame.origin.x = self.collectionView.contentOffset.x;
                attributes.frame = frame; // Stick to the left
            }

            [sectionAttributes addObject:attributes];

            xOffset = xOffset+itemSize.width;
            column++;

            // Create a new row if this was the last column
            if (column == self.game.statsDictionary.count + 1) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }

                // Reset values
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }

        [self.itemAttributes addObject:sectionAttributes];
    }

    // Get the last item to calculate the total height of the content
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y+attributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);

}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES; // Set this to YES to call prepareLayout on every scroll
}

- (CGSize)sizeForItemWithColumnIndex:(NSUInteger)columnIndex
{
    NSString *text;
    switch (columnIndex) { // This only makes sense if the size of the items should be different
        case 0:
            text = @"Col 0";
            break;
        case 1:
            text = @"Col 1";
            break;
        case 2:
            text = @"Col 2";
            break;
        case 3:
            text = @"Col 3";
            break;
        case 4:
            text = @"Col 4";
            break;
        case 5:
            text = @"Col 5";
            break;
        case 6:
            text = @"Col 6";
            break;
        case 7:
            text = @"Col 7";
            break;
        case 8:
            text = @"Col 8";
            break;
        case 9:
            text = @"Col 9";
            break;
        case 10:
            text = @"Col 10";
            break;
        case 11:
            text = @"Col 11";
            break;
        case 12:
            text = @"Col 12";
            break;
        case 13:
            text = @"Col 13";
            break;
        case 14:
            text = @"Col 14";
            break;

        default:
            break;
    }
    CGSize size = [text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}];
    if (columnIndex == 0) {
        size.width += 75; // In our design the first column should be the widest one
    }

    return CGSizeMake([@(size.width + 13) floatValue], 20);

}

- (void)calculateItemsSize
{
    for (NSUInteger index = 0; index < self.game.statsDictionary.count + 1; index++) {
        if (self.itemsSize.count <= index) {
            CGSize itemSize = [self sizeForItemWithColumnIndex:index];
            NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
            [self.itemsSize addObject:itemSizeValue];
        }
    }
}

@end
