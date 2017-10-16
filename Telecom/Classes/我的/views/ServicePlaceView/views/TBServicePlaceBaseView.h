//
//  TBServicePlaceBaseView.h
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBMakingListMode.h"


//基础
@interface TBServicePlaceBaseView : UIView


/**
 子视图开始添加
 */
- (void)createAview;

@property (nonatomic, strong) TBMakingListMode *makingList;

- (void)updataData:(TBMakingListMode *)makingList;

- (void)updataMaking;

@end
