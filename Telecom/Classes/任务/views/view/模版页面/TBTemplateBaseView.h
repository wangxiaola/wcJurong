//
//  TBTemplateBaseView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TBMakingListMode.h"


@interface TBTemplateBaseView : UIView

/**
 内容view
 */
@property (nonatomic, strong) UIView *contenView;

@property (nonatomic, strong) TBMakingListMode *makingList;

- (void)updataData:(TBMakingListMode *)makingList;

- (void)updataMaking;

@end
