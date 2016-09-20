//
//  TTTopCollectionView.h
//  HH
//
//  Created by 唐韬 on 16/9/8.
//  Copyright © 2016年 TT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TTTopCollectionViewCellHeightState) {

    TTTopCollectionViewCellHeightStateOriginal  = 200,
    TTTopCollectionViewCellHeightStatePlain     = 100
};

@interface TTTopCollectionView : UICollectionView

@property(nonatomic, assign, readonly) TTTopCollectionViewCellHeightState cellState;


/*
 * 当设置bottomview的offset的时候,不知道为何会影响到topview, 使其进行布局, 不得已增加了一个bool值来表示忽略这种影响
 */
@property(nonatomic, assign) BOOL ignoreBottom;

-(void) animationToState:(TTTopCollectionViewCellHeightState)state duration:(NSTimeInterval)duration forIndex:(NSUInteger)index;

-(void) updateIndex;




@end
