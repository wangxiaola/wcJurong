//
//  TBServicePlaceViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/5/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 模板编辑状态
 
 - TBServicePlaceTypeNewAdded: 新添加
 - TBServicePlaceTypeMaking: 制作
 - TBServicePlaceTypeEditor: 编辑
 */
typedef NS_ENUM(NSInteger ,TBServicePlaceType) {
    
    TBServicePlaceTypeNewAdded = 0,
    
    TBServicePlaceTypeMaking,
    
    TBServicePlaceTypeEditor,
    
};

#import "TBBaseViewController.h"
@class TBMakingListMode;
/**
 服务场所
 */
@interface TBServicePlaceViewController : TBBaseViewController

@property (strong, nonatomic) TBMakingListMode *makingList;

// 商户ID
@property (nonatomic, assign) NSInteger merchantsID;
// 模板ID
@property (nonatomic, assign) NSInteger modelsID;

@property (nonatomic) TBServicePlaceType servicePlaceType;

/**
 数据状态发生更改
 */
@property (nonatomic, copy) void(^dataStatusChange)(void);

@end
