//
//  TTCollectionViewLayout.m
//  HH
//
//  Created by 唐韬 on 16/9/7.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "TTCollectionViewLayout.h"

@interface TTCollectionViewLayout()

@property(nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> * attributes;

@end

@implementation TTCollectionViewLayout

-(NSMutableArray<UICollectionViewLayoutAttributes *> *)attributes {

    if (_attributes == nil) {

        _attributes = [NSMutableArray array];

        CGSize contentSize  = [self collectionViewContentSize];
        NSInteger itemNum   = [self.collectionView numberOfItemsInSection:0];
        CGFloat distanceW   = contentSize.width - self.itemSize.width;
        CGFloat distanceH  = contentSize.height - self.itemSize.height;

        for (NSInteger i = 0; i < itemNum; i++) {

            UICollectionViewLayoutAttributes * att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];

            att.zIndex = i;
            CGFloat x  = distanceW / (itemNum - 1) * i;
            CGFloat y  = distanceH / (itemNum - 1) * i;
            att.frame  = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);

            [_attributes addObject:att];
        }

    }
    
    return _attributes;
}

-(void)setItemSize:(CGSize)itemSize {

    _itemSize = itemSize;

    if (_attributes != nil) {

        [self updateAttributes];
    }
}

-(void) updateAttributes {

    CGSize contentSize  = [self collectionViewContentSize];
    NSInteger itemNum    = [self.collectionView numberOfItemsInSection:0];
    CGFloat distanceW   = contentSize.width - self.itemSize.width;
    CGFloat distanceH  = contentSize.height - self.itemSize.height;

    for (int i = 0; i < self.attributes.count; i++) {

        UICollectionViewLayoutAttributes * att = self.attributes[i];

        CGFloat x = distanceW / (itemNum - 1) * i;
        CGFloat y = distanceH / (itemNum - 1) * i;
        att.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    }


}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    return self.attributes;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_attributes.count == 0) {
        return nil;
    }
    return self.attributes[indexPath.item];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index {

    if (_attributes.count == 0) {
        return nil;
    }

    return self.attributes[index];
}


-(CGSize)collectionViewContentSize {

    return [self.dataSourse contenSize];
}

@end
