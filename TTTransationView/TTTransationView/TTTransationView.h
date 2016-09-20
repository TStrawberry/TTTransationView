//
//  TTTransationView.h
//  HH
//
//  Created by 唐韬 on 16/9/7.
//  Copyright © 2016年 TT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTransationView;

typedef NS_OPTIONS(NSUInteger, TTTransationViewCellType) {

    TTTransationViewCellTypeTop,
    TTTransationViewCellTypeBottom
};

@protocol TTTransationViewDelegate <NSObject>

-(void) transationView:(TTTransationView *)transationView didSelectedIndex:(NSUInteger)index type:(TTTransationViewCellType)type;

@end

@protocol TTTransationViewDataSourse <NSObject>

-(NSUInteger)numberOfItems;
-(UICollectionViewCell *) transationView:(TTTransationView *)transtionView type:(TTTransationViewCellType)type itemForIndex:(NSUInteger)index;
@end

@interface TTTransationView : UIView

@property(nonatomic, weak) id <TTTransationViewDelegate> delegate;
@property(nonatomic, weak) id <TTTransationViewDataSourse> dataSourse;

- (void)registerClass:(Class)itemClass forCellType:(TTTransationViewCellType)type WithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellType:(TTTransationViewCellType)type WithReuseIdentifier:(NSString *)identifier;

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier type:(TTTransationViewCellType)type forIndex:(NSUInteger)index;


@end
