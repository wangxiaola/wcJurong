//
//  TBServicePlaceTitleView.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBServicePlaceTitleView.h"

@implementation TBServicePlaceTitleView
{
    
    UIView *_centerView;
    UILabel *_lefLabel;
    UILabel *_ritLebel;
    NSArray *_lefTextArray;
    NSArray *_ritTextArray;
    
}
- (instancetype)initWithFrame:(CGRect)frame templateID:(NSInteger)ID;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lefTextArray = @[@"服务场所-基本信息",@"服务场所-商家资质"];
        _ritTextArray = @[@"(必填)",@""];
        
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_centerView];
        
        _lefLabel = [[UILabel alloc] init];
        _lefLabel.textColor = [UIColor whiteColor];
        _lefLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        [_centerView addSubview:_lefLabel];
        
        _ritLebel = [[UILabel alloc] init];
        _ritLebel.textColor = [UIColor whiteColor];
        _ritLebel.font = [UIFont systemFontOfSize:13 weight:0.2];
        [_centerView addSubview:_ritLebel];
        TBWeakSelf
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf.mas_centerX);
        }];
        
        [_lefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerView);
            make.centerY.equalTo(_centerView.mas_centerY);
        }];
        
        [_ritLebel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_centerView);
            make.left.equalTo(_lefLabel.mas_right).offset(4);
            make.bottom.equalTo(_lefLabel.mas_bottom);
        }];
    }
    
    return self;
    
}
/**
 选中第几个
 
 @param index row
 */
- (void)selectIndex:(NSInteger)index;
{
    if (index>_lefTextArray.count||index>_ritTextArray.count)
    {
        _lefLabel.text = @"数据出错了";
        _ritLebel.text = @"";
        return;
    }
    _lefLabel.text = _lefTextArray[index];
    _ritLebel.text = _ritTextArray[index];
    
}

@end
