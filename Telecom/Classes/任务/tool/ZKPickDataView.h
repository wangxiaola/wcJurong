//
//  ZKPickDateView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBBasicDataShoptypes,TBBasicDataArea;

@protocol ZKPickDataViewDelegate <NSObject>
@optional

- (void)selectedData:(TBBasicDataShoptypes*)shop;

- (void)selectedAreaData:(TBBasicDataArea*)area;

@end
/**
 商家类型选择工具
 */
@interface ZKPickDataView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic)id<ZKPickDataViewDelegate>delegate;

- (instancetype)initData:(NSArray<TBBasicDataShoptypes*>*)cellArray;

- (instancetype)initAreaData:(NSArray<TBBasicDataArea *>*)cellArray;

- (void)showSelectedData:(NSInteger )data;

- (void)showSelectedAreaData:(NSString *)data;

@end
