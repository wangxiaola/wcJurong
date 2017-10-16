//
//  TBTemplateBaseView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateBaseView.h"
#import "UIButton+ImageTitleStyle.h"

@implementation TBTemplateBaseView


- (instancetype)init;
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        TBWeakSelf
        self.contenView = [[UIView alloc] init];
        self.contenView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.contenView];
        
        [weakSelf.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-1);//55
        }];

    }
    
    return self;
    
}

- (void)updataData:(TBMakingListMode *)makingList;
{}
- (void)updataMaking;
{}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
