//
//  TBTaskMakeTitelView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTaskMakeTitleView.h"

@implementation TBTaskMakeTitleView
{
    
    UIView *_centerView;
    UILabel *_lefLabel;
    UILabel *_ritLebel;
    NSArray *_lefTextArray;
    NSArray *_ritTextArray;
    NSString *_type;
    
}
- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        _lefTextArray = @[[self assembleName:@"基本信息"],
                          [self assembleName:@"老板头像"],
                          [self assembleName:@"外观图片"],
                          [self assembleName:@"美食图片"],
                          [self assembleName:@"环境图片"],
                          [self assembleName:@"发布优惠"],
                          [self assembleName:@"打折卡优惠"],
                          [self assembleName:@"商家资质"],
                          [self assembleName:@"封面图片"],
                          ];
        _ritTextArray = @[@"(必填)",
                          @"",
                          @"(必填)",
                          @"",
                          @"(必填)",
                          @"",
                          @"",
                          @"",
                          @""];
        
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
- (NSString *)assembleName:(NSString *)name
{
    NSString *nameString = name;
    
    if (_type)
    {
        NSString *typeName = @"";
        if ([_type isEqualToString:@"farmstay"])
        {
            typeName = @"农家乐";
        }
        else if ([_type isEqualToString:@"recreation"])
        {
            typeName = @"休闲娱乐";
        }
        else if ([_type isEqualToString:@"food"])
        {
            typeName = @"特色美食";
        }
        else if ([_type isEqualToString:@"hotel"])
        {
            typeName = @"酒店客栈";
        }
        else if ([_type isEqualToString:@"view"])
        {
            typeName = @"景区景点";
        }
        
        nameString = [NSString stringWithFormat:@"%@-%@",typeName,name];
    }
    return nameString;
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
