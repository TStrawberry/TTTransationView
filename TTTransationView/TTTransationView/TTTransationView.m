//
//  TTTransationView.m
//  HH
//
//  Created by 唐韬 on 16/9/7.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "TTTransationView.h"

#import "TTCollectionViewLayout.h"
#import "TTTopCollectionView.h"


@interface TTTransationView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak  ) TTTopCollectionView * topCollectionView;
@property (nonatomic, weak  ) UICollectionView    * bottomCollectionView;

// topView开始动画前的frame
@property (nonatomic, assign) CGRect                originalTopFrame;

@end

@implementation TTTransationView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        [self createSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {

        [self createSubViews];
    }
    return self;
}

-(void) createSubViews {

    self.dataSourse = nil;

    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
    [self addGestureRecognizer:pan];

    // 创建顶部的topView
TTCollectionViewLayout * collectionViewLayout = [[TTCollectionViewLayout alloc] init];
    collectionViewLayout.itemSize                 = CGSizeMake(self.frame.size.width, TTTopCollectionViewCellHeightStateOriginal);

    TTTopCollectionView * topCollectionView       = [[TTTopCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TTTopCollectionViewCellHeightStateOriginal) collectionViewLayout:collectionViewLayout];
    topCollectionView.dataSource                  = self;
    topCollectionView.delegate                    = self;
    topCollectionView.pagingEnabled               = YES;
    topCollectionView.backgroundColor             = [UIColor clearColor];
#ifdef __IPHONE_10_0
    topCollectionView.prefetchingEnabled            = NO;
#endif
    [self addSubview:topCollectionView];
    self.topCollectionView                        = topCollectionView;


    // 创建底部的View
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing           = 0;
    flowLayout.minimumInteritemSpacing      = 0;
    flowLayout.sectionInset                 = UIEdgeInsetsZero;
    flowLayout.itemSize                     = CGSizeMake(self.topCollectionView.frame.size.width, self.frame.size.height - topCollectionView.frame.size.height);
    flowLayout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;

    UICollectionView * bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topCollectionView.frame.size.height, flowLayout.itemSize.width, flowLayout.itemSize.height) collectionViewLayout:flowLayout];
    bottomCollectionView.dataSource         = self;
    bottomCollectionView.delegate           = self;
    bottomCollectionView.pagingEnabled        = YES;
    [self addSubview:bottomCollectionView];
    self.bottomCollectionView                   = bottomCollectionView;

}

-(void)layoutSubviews {

    [super layoutSubviews];

    CGFloat topHeight = self.topCollectionView.frame.size.height;
    CGFloat bottomHeight = 0;

    if (topHeight < TTTopCollectionViewCellHeightStateOriginal) {
        bottomHeight = self.frame.size.height - topHeight;
    } else {

        bottomHeight = self.frame.size.height - TTTopCollectionViewCellHeightStateOriginal;
    }
    self.bottomCollectionView.frame = CGRectMake(0, topHeight, self.frame.size.width, bottomHeight);

}

-(void)registerClass:(Class)itemClass forCellType:(TTTransationViewCellType)type WithReuseIdentifier:(NSString *)identifier {

    if (type == TTTransationViewCellTypeTop) {

        [self.topCollectionView registerClass:itemClass forCellWithReuseIdentifier:identifier];
    } else {

        [self.bottomCollectionView registerClass:itemClass forCellWithReuseIdentifier:identifier];
    }

}

- (void)registerNib:(UINib *)nib forCellType:(TTTransationViewCellType)type WithReuseIdentifier:(NSString *)identifier{

    if (type == TTTransationViewCellTypeTop) {
        [self.topCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    } else {
        [self.bottomCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    }

}

-(UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier type:(TTTransationViewCellType)type forIndex:(NSUInteger)index {

    if (type == TTTransationViewCellTypeTop) {
        return [self.topCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    } else {
        return [self.bottomCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }

}

-(void) viewPanned:(UIPanGestureRecognizer *)pan {

    CGPoint transation = [pan translationInView:self];
    switch (pan.state) {

        case UIGestureRecognizerStateBegan:
        {
            [self.topCollectionView updateIndex];
            self.originalTopFrame = self.topCollectionView.frame;
            break;
        }

        case UIGestureRecognizerStateChanged:
        {
            CGFloat targetHeight = self.originalTopFrame.size.height + transation.y;
            if (targetHeight > self.frame.size.height || targetHeight < TTTopCollectionViewCellHeightStateOriginal) {
                return;
            }
            self.topCollectionView.frame = CGRectMake(0, 0, self.originalTopFrame.size.width, self.originalTopFrame.size.height + transation.y);
            break;
        }

        default:
        {

            if (fabs(self.topCollectionView.frame.size.height - TTTopCollectionViewCellHeightStateOriginal) > 100) {

                CGFloat progress  = (self.topCollectionView.frame.size.height - TTTopCollectionViewCellHeightStateOriginal) / (self.frame.size.height - TTTopCollectionViewCellHeightStateOriginal);

                CGFloat duration  = (1 - progress) * 1.0;
                duration         = (int)(duration * 10) * 0.1;

                [self.topCollectionView animationToState:TTTopCollectionViewCellHeightStatePlain duration:duration forIndex:0];


            } else {

                [self.topCollectionView animationToState:TTTopCollectionViewCellHeightStateOriginal duration:0.2 forIndex:0];
            }

            break;
        }
    }

}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.bottomCollectionView) {
        self.topCollectionView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }

}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.dataSourse numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == self.topCollectionView) {

        return [self.dataSourse transationView:self type:TTTransationViewCellTypeTop itemForIndex:indexPath.item];
    } else {

        return [self.dataSourse transationView:self type:TTTransationViewCellTypeBottom itemForIndex:indexPath.item];
    }
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == self.topCollectionView) {

        self.topCollectionView.ignoreBottom          = YES;
        self.bottomCollectionView.contentOffset = CGPointMake(indexPath.item * self.frame.size.width, 0);
        self.topCollectionView.ignoreBottom     = NO;

        [self.topCollectionView animationToState:TTTopCollectionViewCellHeightStateOriginal duration:0.5 forIndex:indexPath.item];
    }

    TTTransationViewCellType type = collectionView == self.topCollectionView ? TTTransationViewCellTypeTop : TTTransationViewCellTypeBottom;
    [self.delegate transationView:self didSelectedIndex:indexPath.item type:type];

}

@end
