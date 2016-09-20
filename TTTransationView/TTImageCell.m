//
//  TTImageCell.m
//  TTTransationView
//
//  Created by 唐韬 on 16/9/20.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "TTImageCell.h"

@interface TTImageCell()

@property (weak, nonatomic) IBOutlet UILabel     *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TTImageCell


-(void)setText:(NSString *)text {


    _text               = text;
    self.textLabel.text = text;
}

-(void)setImageName:(NSString *)imageName {

    _imageName           = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}


@end
