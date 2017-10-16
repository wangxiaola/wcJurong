//
//  TBMainCollectionViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMainCollectionViewCell.h"
#import "HQliquidButton.h"
@implementation TBMainCollectionViewCell
{
    UIImageView    *_imageView;
    UILabel        *_nameLabel;
    HQliquidButton *_redPoint;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUPImageView];
        
    }
    return self;
}

- (void)setUPImageView
{
    self.userInteractionEnabled = YES;
    UIView *centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeDefault"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [centerView addSubview:_imageView];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.text = @"？？？";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [centerView addSubview:_nameLabel];


    
    TBWeakSelf

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(centerView);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView);
        make.centerX.equalTo(_imageView.mas_centerX);
        make.top.equalTo(_imageView.mas_bottom).offset(12);
    }];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];

}
- (void)setBackImageData:(NSDictionary *)data;
{
    _imageView.image = [UIImage imageNamed:[data valueForKey:@"image"]];
    _nameLabel.text  = [data valueForKey:@"name"];
}

/**
 设置红点数量
 
 @param number 数量
 @param section 区
 */
- (void)setTheRedDotNumber:(NSInteger)number cellSection:(NSInteger)section;
{
    if (number == 0)
    {
        [self removeRedDot];
        return;
    }
    if (_redPoint ==  nil)
    {
        CGFloat cellWidth = 0.0f;
        cellWidth = section == 0 ?(_SCREEN_WIDTH/3):(_SCREEN_WIDTH/4);
        _redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(cellWidth/2+16, 20) bagdeNumber:(int)number];
        [self addSubview:_redPoint];
    }
    else
    {
        [_redPoint updateBagdeNumber:(int)number];
    }
 
}
/**
 清除红点
 */
- (void)removeRedDot;
{
    [_redPoint removeFromSuperview];
    _redPoint = nil;
}
@end
