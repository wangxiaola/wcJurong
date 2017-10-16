//
//  TBMakingListMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBMakingListMode : NSObject
// 判断当前商户模版是否已经激活过云金融
@property (nonatomic, strong) NSString *isbind;
// 数据ID
@property (nonatomic, strong) NSString *saveID;
// 商户ID
@property (nonatomic, assign) NSInteger merchantsID;
// 模板ID
@property (nonatomic, assign) NSInteger modelsID;
// 数据是否完整 0不完整
@property (nonatomic, assign) NSInteger complete;
/**
 模型类型
 */
@property (nonatomic, strong) NSString *type;

/**
 基本信息
 */
@property (nonatomic, strong) NSDictionary *infoDic;// 可串演服务场所基本信息
@property (nonatomic, strong) NSString *msg;

/**
 老板信息
 */
@property (nonatomic, strong) NSString *bossHeaderImageUrl;
@property (nonatomic, strong) NSData *bossHeaderData;
@property (nonatomic, strong) NSString *bossVoiceUrl;
@property (nonatomic, strong) NSData *bossVoiceData;

/**
 外观信息
 */
@property (nonatomic, strong) NSMutableArray *appearancePhotos;
@property (nonatomic, strong) NSString *appearanceText;
@property (nonatomic, strong) NSString *appearanceLabel;

/**
 美食信息 选填
 */
@property (nonatomic, strong) NSMutableArray *foodPhotos;
@property (nonatomic, strong) NSString *foofText;
@property (nonatomic, strong) NSString *foofLabel;

/**
 环境信息
 */
@property (nonatomic, strong) NSMutableArray *environmentPhotos;
@property (nonatomic, strong) NSString *environmentText;
@property (nonatomic, strong) NSString *environmentLabel;

/**
 优惠信息 m10
 */
@property (nonatomic, strong) NSDictionary *preferentialDic;

/**
 打折卡 m14
 */
@property (nonatomic, strong) NSDictionary *discountCardDic;

/**
 封面
 */
@property (nonatomic, strong) NSString *coverPhotoUrl;
@property (nonatomic, strong) NSData  *coverPhotoData;
@property (nonatomic, strong) NSString *coverMusic;

/**
 服务场所基础信息
 */
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *serviceMsg;


/**
 商家账户信息 0 正面
 */
@property (nonatomic, strong) NSString *positivePhotoUrl;
@property (nonatomic, strong) NSData  *positivePhotoData;

@property (nonatomic, strong) NSString *reversePhotoUrl;
@property (nonatomic, strong) NSData  *reversePhotoData;



@end
