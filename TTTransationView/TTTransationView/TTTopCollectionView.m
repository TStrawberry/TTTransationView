//
//  TTTopCollectionView.m
//  HH
//
//  Created by 唐韬 on 16/9/8.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "TTTopCollectionView.h"
#import "TTCollectionViewLayout.h"

static NSInteger UnableIndexValue = -1;

@interface TTTopCollectionView() <TTCollectionViewLayoutDataSourse>

@property(nonatomic, weak) TTCollectionViewLayout *     layout;
@property(nonatomic, strong) CADisplayLink *            displayLink;

@property(nonatomic, assign) CGRect                     originalFrame;
@property(nonatomic, assign) CGRect                     toFrame;

// 绝对高度 : cell距离collection顶部的高度, 这是用户感知变化的量

/*
 * index标记的cell的初始绝对高度
 */
@property(nonatomic, assign) CGFloat                    abHeightOriginal;

/*
 * index标记的cell的目标绝对高度
 */
@property(nonatomic, assign) CGFloat                    abHeightTo;

/*
 * 用于标记动画过程中始终处于屏幕中间的cell
 */
@property(nonatomic, assign) NSInteger                  index;

@property(nonatomic, assign) CGFloat                    progress;
@property(nonatomic, assign) NSTimeInterval             duration;
@property(nonatomic, assign) NSInteger                  timeCounter;

@end

@implementation TTTopCollectionView

-(void)layoutSubviews {

    [super layoutSubviews];
    
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {

    if (self == [super initWithFrame:frame collectionViewLayout:layout]) {

        self.layout              = (TTCollectionViewLayout *)layout;
        self.layout.dataSourse  = self;

        self.index              = UnableIndexValue;
        self.displayLink        = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame:)];
        self.displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }

    return self;
}

-(void)setContentOffset:(CGPoint)contentOffset {

    if (self.ignoreBottom) {
        return;
    }

    [super setContentOffset:contentOffset];

}

-(void)setFrame:(CGRect)frame {

    [super setFrame: frame];

    CGFloat selfHeight   = self.frame.size.height;
    CGFloat superHeight  = self.superview.frame.size.height;
    // 计算动画的进度
    CGFloat progress     = (selfHeight - TTTopCollectionViewCellHeightStateOriginal) / (superHeight - TTTopCollectionViewCellHeightStateOriginal);
    progress            = sinf(M_PI_2 * progress);

    // 调整cell的大小
    self.layout.itemSize = CGSizeMake(self.layout.itemSize.width, TTTopCollectionViewCellHeightStateOriginal - (TTTopCollectionViewCellHeightStateOriginal - TTTopCollectionViewCellHeightStatePlain) * progress);

    // 保证目标cell一直停留在屏幕中央
    if (self.index != UnableIndexValue) {

        UICollectionViewLayoutAttributes * indexAtt = [self.layout layoutAttributesForItemAtIndex:self.index];

        CGFloat contentX   = indexAtt.frame.origin.x;
        CGFloat contentY   = self.contentOffset.y;

        CGFloat h          = self.abHeightOriginal + (self.abHeightTo - self.abHeightOriginal) * progress;
        contentY          = indexAtt.frame.origin.y - h;

        self.contentOffset   = CGPointMake(contentX, contentY);
    }

    [self.layout invalidateLayout];
}

+(CGFloat)originalCellHeight {

    return TTTopCollectionViewCellHeightStateOriginal;
}

-(void) updateFrame:(CADisplayLink *)displayLink {

    self.timeCounter++;

    if (self.timeCounter > self.duration * 60) {

        self.timeCounter        = 0;
        self.index            = UnableIndexValue;
        self.abHeightOriginal = 0;
        self.abHeightTo       = 0;
        displayLink.paused    = YES;

        return;
    }

    CGFloat progress = self.timeCounter / (self.duration * 60);
    CGFloat height   = self.originalFrame.size.height + (self.toFrame.size.height - self.originalFrame.size.height) * progress;
    self.frame       = CGRectMake(0, 0, self.superview.frame.size.width, height);
}

//在动画开始前更新目标cell的index
-(void) updateIndex {

    self.index             = [self indexPathsForVisibleItems].firstObject.item;
    self.abHeightOriginal = 0;
    self.abHeightTo       = self.superview.frame.size.height * 0.5 - TTTopCollectionViewCellHeightStatePlain * 0.5;

    CGFloat maxHeight = self.index * TTTopCollectionViewCellHeightStatePlain;
    if (self.abHeightTo > maxHeight) {
        self.abHeightTo = maxHeight;
    }

    CGFloat minHeight = self.index * TTTopCollectionViewCellHeightStatePlain - ([self numberOfItemsInSection:0] * TTTopCollectionViewCellHeightStatePlain - self.superview.frame.size.height);
    if (self.abHeightTo < minHeight) {
        self.abHeightTo = minHeight;
    }
}

-(void)animationToState:(TTTopCollectionViewCellHeightState)state duration:(NSTimeInterval)duration forIndex:(NSUInteger)index{

    // 初始化动画状态
    CGFloat height      = state == TTTopCollectionViewCellHeightStatePlain ? self.superview.frame.size.height : state;

    self.originalFrame   = self.frame;
    self.toFrame        = CGRectMake(0, 0, self.frame.size.width, height);
    self.duration       = duration;
    _cellState          = state;
    self.pagingEnabled = state != TTTopCollectionViewCellHeightStatePlain;

    if (self.index == UnableIndexValue) {

        self.index = index;
        UICollectionViewLayoutAttributes * att = [self.layout layoutAttributesForItemAtIndex:index];

        if (state == TTTopCollectionViewCellHeightStateOriginal) {

            self.abHeightTo        = att.frame.origin.y - self.contentOffset.y;
            self.abHeightOriginal   = 0;
        } else {
            self.abHeightTo        = self.superview.frame.size.height * 0.5 - TTTopCollectionViewCellHeightStatePlain * 0.5;
            self.abHeightOriginal   = att.frame.origin.y - self.contentOffset.y;
        }
    }

    // 开始动画
    self.displayLink.paused = NO;
}

#pragma mark - TTCollectionViewLayoutDataSourse
-(CGSize)contenSize {

    CGFloat w            = self.contentSize.width;
    CGFloat h           = self.contentSize.height;
    CGFloat selfHeight   = self.frame.size.height;
    CGFloat superHeight = self.superview.frame.size.height;
    CGSize itemSize     = self.layout.itemSize;
    NSInteger numbers   = [self numberOfItemsInSection:0];

    if (selfHeight < TTTopCollectionViewCellHeightStateOriginal) {

        w = itemSize.width * numbers;
        h = itemSize.height;

    } else if (selfHeight <= superHeight) {

        CGFloat progress  = (selfHeight - TTTopCollectionViewCellHeightStateOriginal) / (superHeight - TTTopCollectionViewCellHeightStateOriginal);
        w = itemSize.width * (numbers - 1) * (1 - progress) + itemSize.width;
        h = itemSize.height * (numbers - 1) * progress + itemSize.height;
    }

    self.contentSize = CGSizeMake(w, h);
    return self.contentSize;

}

@end
