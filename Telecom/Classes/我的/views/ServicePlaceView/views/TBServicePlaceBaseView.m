//
//  TBServicePlaceBaseView.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBServicePlaceBaseView.h"


@implementation TBServicePlaceBaseView

- (instancetype)init

{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self createAview];
    }
    return self;
}
- (void)createAview
{

}
- (void)updataData:(TBMakingListMode *)makingList;
{

}
- (void)updataMaking;
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
