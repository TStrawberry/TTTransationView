//
//  ViewController.m
//  TTTransationView
//
//  Created by 唐韬 on 16/9/20.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "ViewController.h"
#import "TTTransationView.h"
#import "TTImageCell.h"
#import "TTTextCell.h"


static NSString * identifier = @"cell";

@interface ViewController () <TTTransationViewDataSourse>

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    TTTransationView * transationView = [[TTTransationView alloc] initWithFrame:self.view.bounds];
    transationView.dataSourse = self;

    [transationView registerNib:[UINib nibWithNibName:NSStringFromClass([TTImageCell class]) bundle:nil] forCellType:TTTransationViewCellTypeTop WithReuseIdentifier:identifier];

    [transationView registerNib:[UINib nibWithNibName:NSStringFromClass([TTTextCell class]) bundle:nil] forCellType:TTTransationViewCellTypeBottom WithReuseIdentifier:identifier];

    [self.view addSubview:transationView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TTTransationViewDataSourse

-(NSUInteger)numberOfItems {

    return 30;
}

-(UICollectionViewCell *) transationView:(TTTransationView *)transtionView type:(TTTransationViewCellType)type itemForIndex:(NSUInteger)index {


    UICollectionViewCell * cell = [transtionView dequeueReusableCellWithReuseIdentifier:identifier type:type forIndex:index];

    if (type == TTTransationViewCellTypeTop) {

        TTImageCell * imageCell = (TTImageCell *)cell;
        imageCell.text = [NSString stringWithFormat:@"%ld", (unsigned long)index];
        imageCell.imageName = [NSString stringWithFormat:@"image_%ld", (unsigned long)index];

        return imageCell;

    } else {

        TTTextCell * textCell = (TTTextCell *)cell;
        cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        textCell.text = [NSString stringWithFormat:@"第%d个cell", index];
        return cell;
    }

    return nil;

}





@end
