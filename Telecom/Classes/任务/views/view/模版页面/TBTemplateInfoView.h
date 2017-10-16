//
//  TBTemplateInfoView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateBaseView.h"
@class TBMakingListMode;

/**
 基础信息填写
 */
@interface TBTemplateInfoView : TBTemplateBaseView
// 验证名称是否修改过
- (BOOL)isNameEditor;

- (void )updataDic;

@end
