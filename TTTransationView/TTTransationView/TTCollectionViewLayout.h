//
//  TTCollectionViewLayout.h
//  HH
//
//  Created by 唐韬 on 16/9/7.
//  Copyright © 2016年 TT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTCollectionViewLayoutDataSourse <NSObject>

-(CGSize)contenSize;

@end

@interface TTCollectionViewLayout : UICollectionViewLayout


@property(nonatomic, assign) CGSize itemSize;
@property(nonatomic, weak)   id <TTCollectionViewLayoutDataSourse> dataSourse;


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index;

@end
