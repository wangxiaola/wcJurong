//
//  TBServicePlaceTitleView.h
//  Telecom
//
//  Created by 王小腊 on 2017/5/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 服务场所名称
 */
@interface TBServicePlaceTitleView : UIView
/**
 选中第几个
 
 @param index row
 */
- (void)selectIndex:(NSInteger)index;

/**
 创建titleView

 @param frame frame
 @param ID id
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame templateID:(NSInteger)ID;

@end
