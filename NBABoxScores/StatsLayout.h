//
//  StatsLayout.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/9/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsLayout : UICollectionViewLayout

- (void)prepareLayout;
- (CGSize)collectionViewContentSize;
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
- (CGSize)sizeForItemWithColumnIndex:(NSUInteger)columnIndex;
- (void)calculateItemsSize;





@end
