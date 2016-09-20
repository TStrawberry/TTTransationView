
//
//  TTTextCell.m
//  TTTransationView
//
//  Created by 唐韬 on 16/9/20.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "TTTextCell.h"

@interface TTTextCell()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end

@implementation TTTextCell

-(void)setText:(NSString *)text {


    _text               = text;
    self.textLabel.text = text;
}


@end
