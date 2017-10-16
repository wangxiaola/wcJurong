//
//  TBTaskMakeViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTaskMakeViewController.h"
#import "TBTemplateCompleteViewController.h"

#import "TBTaskListMode.h"
#import "TBMakingListMode.h"
#import "TBTaskMakeViewMode.h"

#import "TBTemplateInfoView.h"
#import "TBTemplateBossHeadBaseView.h"
#import "TBTemplateBackgroundView.h"
#import "TBTemplateResourceView.h"
#import "TBStrategyViewController.h"
#import "TBPreferentialInformationView.h"
#import "TBDiscountCardView.h"
#import "TBSigningContractInformationView.h"

#import "CDPMonitorKeyboard.h"
#import "UIBarButtonItem+Custom.h"
#import "TBMoreReminderView.h"
#import "TBTaskMakeFootView.h"
#import "TBTaskMakeTitleView.h"
#import "AFNetworkReachabilityManager.h"
#import "TBSaveSuccessTipsView.h"
#import "AppDelegate.h"
@interface TBTaskMakeViewController ()<UIScrollViewDelegate,TBTaskMakeViewModeDelegate,TBTaskMakeFootViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//业务处理模型
@property (nonatomic, strong) TBTaskMakeViewMode *viewMode;
//基本信息
@property (nonatomic, strong) TBTemplateInfoView *inforView;
//老板
@property (nonatomic, strong) TBTemplateBossHeadBaseView *bossHeadView;
//外观
@property (nonatomic, strong) TBTemplateResourceView *hallView;
//美食
@property (nonatomic, strong) TBTemplateResourceView *foodView;
//环境
@property (nonatomic, strong) TBTemplateResourceView *environmentView;
//背景
@property (nonatomic, strong) TBTemplateBackgroundView *backgroundView;
//老板优惠
@property (nonatomic, strong) TBPreferentialInformationView *preferentialView;
// 老板折扣
@property (nonatomic, strong) TBDiscountCardView *discountCardView;
// 商家账户信息 && 签约合同信息
@property (nonatomic, strong) TBSigningContractInformationView *signingContractInformationView;

//尾部视图
@property (nonatomic, strong) TBTaskMakeFootView *footTool;

@property (nonatomic, strong) TBTaskMakeTitleView *titleView;

@property (nonatomic) AFNetworkReachabilityStatus workStatus;//网络状态

@end

@implementation TBTaskMakeViewController
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, _SCREEN_WIDTH, _SCREEN_HEIGHT-64)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}

#pragma mark ----initView----
- (void)initNacItemView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"教程" itemWithIcon:nil target:self action:@selector(strategyClick)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(goBackClick)];
}
// 视图布局
- (void)initSupViews;
{
    TBWeakSelf
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.top.right.equalTo(weakSelf.view);
     }];
    self.footTool = [[TBTaskMakeFootView alloc] init];
    self.footTool.backgroundColor = [UIColor whiteColor];
    self.footTool.maxPage = 8;//设置页数
    self.footTool.delegate = self;
    [self.footTool updateFootViewStyle:0];
    [self.view addSubview:self.footTool];
    
    self.titleView = [[TBTaskMakeTitleView alloc] initWithFrame:CGRectMake(0, 24, _SCREEN_WIDTH-100, 40) type:self.type];
    [self.titleView selectIndex:0];
    [self.navigationItem setTitleView:self.titleView];
    
    [self.footTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.scrollView.mas_bottom);
        make.height.equalTo(@44);
    }];
    
}
// 加载内容
- (void)setScrollViewContent
{
    NSMutableArray *viewArray = [NSMutableArray array];
    
    self.inforView = [[TBTemplateInfoView alloc] init];
    [self.scrollView addSubview:self.inforView];
    [viewArray addObject:self.inforView];
    
    self.bossHeadView = [[TBTemplateBossHeadBaseView alloc] init];
    [self.scrollView addSubview:self.bossHeadView];
    [viewArray addObject:self.bossHeadView];
    
    self.hallView = [[TBTemplateResourceView alloc] init];
    [self.hallView createLayoutViewType:ResourceImageTypeAppearance];
    
    [self.scrollView addSubview:self.hallView];
    [viewArray addObject:self.hallView];
    
    self.foodView = [[TBTemplateResourceView alloc] init];
    [self.foodView createLayoutViewType:ResourceImageTypeFood];
    [self.scrollView addSubview:self.foodView];
    [viewArray addObject:self.foodView];
    
    self.environmentView = [[TBTemplateResourceView alloc] init];
    [self.environmentView createLayoutViewType:ResourceImageTypeEnvironment];
    [self.scrollView addSubview:self.environmentView];
    [viewArray addObject:self.environmentView];
    
    self.preferentialView = [[TBPreferentialInformationView alloc] init];
    [self.scrollView addSubview:self.preferentialView];
    [viewArray addObject:self.preferentialView];
    
    self.discountCardView = [[TBDiscountCardView alloc] init];
    [self.scrollView addSubview:self.discountCardView];
    [viewArray addObject:self.discountCardView];
    
    self.signingContractInformationView = [[TBSigningContractInformationView alloc] init];
    [self.scrollView addSubview:self.signingContractInformationView];
    [viewArray addObject:self.signingContractInformationView];
    
    self.backgroundView = [[TBTemplateBackgroundView alloc] init];
    [self.scrollView addSubview:self.backgroundView];
    [viewArray addObject:self.backgroundView];
    
    // 布局
    
    self.scrollView.contentSize = CGSizeMake(_SCREEN_WIDTH*viewArray.count, _SCREEN_HEIGHT-64-44);
    [viewArray enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.frame = CGRectMake(_SCREEN_WIDTH*idx, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT-64-44);
    }];
    //此模式输入视图在scrollView上或其子view中,即其下级体系中,superView传该scrollView
    [[CDPMonitorKeyboard defaultMonitorKeyboard] sendValueWithSuperView:self.scrollView higherThanKeyboard:34 andMode:CDPMonitorKeyboardScrollViewMode];
}
#pragma mark --- 监听网络状态---
/**
 监听网络状态
 */
- (void)workReachability
{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         self.workStatus = status;
     }];
    
    //开始监听
    [manager startMonitoring];
    
}

//更加类型来获取数据
- (void)initDataConfiguration
{
    self.viewMode = [[TBTaskMakeViewMode alloc] init];
    if (self.makingList)
    {
        self.typeID = [[self.makingList.infoDic valueForKey:@"type"] integerValue];
        self.merchantsID = self.makingList.merchantsID;
        self.modelsID = self.makingList.modelsID;
        [self assignmentData:self.makingList];
    }
    else
    {
        self.viewMode.delegate = self;
        
        if (self.templateType == TBMakingProductionNewAdded)
        {
            TBMakingListMode *mode = [[TBMakingListMode alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithInteger:self.typeID] forKey:@"type"];
            mode.modelsID = self.modelsID;
            mode.infoDic = dic;
            [self assignmentData:mode];
            
        }
        else if (self.templateType == TBMakingProductionMaking)
        {
            [self.viewMode postMakingDataID:self.merchantsID];
        }
        else if (self.templateType == TBMakingProductionModifyThe)
        {
            [self.viewMode postEditDataID:self.merchantsID];
        }
    }
}
#pragma mark  ---- 逻辑处理 ---
- (void)valuesViewTabelIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self.inforView updataDic];
        // 非新增都要验证是否修改名称
        if (self.templateType != TBMakingProductionNewAdded)
        {
            self.viewMode.nameState = [self.inforView isNameEditor];
        }
    }
    else if (index == 1)
    {
        [self.bossHeadView updataMaking];
        
    }
    else if (index == 2)
    {
        [self.hallView updataMaking];
        
    }
    else if (index == 3)
    {
        [self.foodView updataMaking];
    }
    else if (index == 4)
    {
        [self.environmentView updataMaking];
    }
    else if (index == 5)
    {
        [self.preferentialView updataMaking];
    }
    else if (index == 6)
    {
        [self.discountCardView updataMaking];
    }
    else if (index == 7)
    {
        [self.signingContractInformationView updataMaking];
    }
    else if (index == 8)
    {
        [self.backgroundView updataMaking];
    }

    self.viewMode.makingMode = self.makingList;
    
}
- (void)valuesViewTableViewAll
{
    [self.inforView updataDic];
    if (self.templateType != TBMakingProductionNewAdded)
    {
        self.viewMode.nameState = [self.inforView isNameEditor];
    }
    [self.bossHeadView updataMaking];
    [self.hallView updataMaking];
    [self.foodView updataMaking];
    [self.environmentView updataMaking];
    [self.backgroundView updataMaking];
    [self.preferentialView updataMaking];
    [self.discountCardView updataMaking];
    [self.signingContractInformationView updataMaking];
    
    self.makingList.merchantsID = self.merchantsID;
    self.makingList.modelsID = self.modelsID;
    self.viewMode.makingMode = self.makingList;
}
#pragma mark --- 导航栏点击事件 -----
- (void)strategyClick
{
    TBStrategyViewController *strategyView = [[TBStrategyViewController alloc] init];
    [self.navigationController pushViewController:strategyView animated:YES];
}
- (void)goBackClick
{
    [self.view endEditing:YES];
    [self valuesViewTableViewAll];
    if (self.makingList.msg.length == 0 ||self.makingList.appearancePhotos.count>0 )
    {
        [self showPrompt];
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)showPrompt
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAlert = [UIAlertAction actionWithTitle:@"保存本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self footViewTouchUpInsideSave];
    }];
    
    UIAlertAction *exitAler = [UIAlertAction actionWithTitle:@"退出制作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self backLevelController];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alert addAction:saveAlert];
    [alert addAction:exitAler];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark ----TBTaskMakeViewModeDelegate---
/**
 开始请求
 */
- (void)postDataStart;
{
    hudShowLoading(@"数据加载中...");
}
/**
 制作数据获取
 
 @param data data
 */
- (void)makingTemplateData:(TBMakingListMode *)data;
{
    data.modelsID = self.modelsID;
    [self assignmentData:data];
    hudDismiss();
}
/**
 编辑数据获取
 
 @param data data
 */
- (void)editTemplateData:(TBMakingListMode *)data;
{
    [self assignmentData:data];
    hudDismiss();
}
/**
 数据请求失败
 
 @param err string
 */
- (void)dataPostError:(NSString *)err;
{
    hudShowError(err);
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 赋值
 
 @param mode 模型
 */
- (void)assignmentData:(TBMakingListMode *)mode
{
    self.modelsID = mode.modelsID;
    self.merchantsID = mode.merchantsID;
    self.makingList = mode;
    self.makingList.type = self.type;
    
    [self.inforView updataData:self.makingList];
    [self.bossHeadView updataData:self.makingList];
    [self.hallView updataData:self.makingList];
    [self.foodView updataData:self.makingList];
    [self.environmentView updataData:self.makingList];
    [self.backgroundView updataData:self.makingList];
    [self.discountCardView updataData:self.makingList];
    [self.preferentialView updataData:self.makingList];
    [self.signingContractInformationView updataData:self.makingList];
}

#pragma mark ---TBTaskMakeFootViewDelegate--
/**
 尾部视图点击代理
 
 @param type 左右点击类型 yes左点击
 */
- (void)footViewTouchUpInsideType:(BOOL)type
{
    NSInteger offset =  self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    if (offset == 1||offset == self.footTool.maxPage)
    {
        [self sendVoiceStopNotice];
    }
    if (type == YES)
    {
        //  上一步
        [self scrollViewOffsetIndex:offset-1 animateDuration:0.2];
    }
    else
    {   // 提交
        if (offset == self.footTool.maxPage)
        {
            [self touchUpInsideSubmit];
        }
        else
        {
            [self valuesViewTabelIndex:offset];
            TBWeakSelf
            [self.viewMode isNextStepIndex:offset state:^(BOOL successful) {
                
                if (successful)
                {         // 下一步
                    [weakSelf scrollViewOffsetIndex:offset+1 animateDuration:0.2];
                    
                }
            }];
        }
    }
}
#pragma mark  一些业务处理--
//偏移界面
- (void)scrollViewOffsetIndex:(NSInteger)row animateDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(_SCREEN_WIDTH*row, 0);
        [self.footTool updateFootViewStyle:row];
        [self.titleView selectIndex:row];
    }];
}

/**
 保存
 */
- (void)footViewTouchUpInsideSave;
{ 
    hudShowSuccess(@"正在保存");
    self.makingList.type = self.type;
    [self valuesViewTableViewAll];
    self.makingList.complete = [self.viewMode isComplete];
    if (self.makingList.saveID.length == 0)
    {
        self.makingList.saveID = [ZKUtil timeStamp];
    }
    self.viewMode.makingMode.type = self.type;
    TBWeakSelf
    [self.viewMode saveState:^(BOOL state) {
        hudDismiss();
        if (state == YES)
        {
            [weakSelf showSavePromptViewState:weakSelf.makingList.complete == 0];
        }
    }];
    
}
- (void)showSavePromptViewState:(BOOL)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *msg = state == YES?@"草稿箱":@"待提交任务";
        TBSaveSuccessTipsView *tipsView = [[TBSaveSuccessTipsView alloc] initShowPrompt:msg];
        [tipsView showHandler:^{
            
            [self disappearHUD];
        }];
    });
}
// 返回上一级
- (void)disappearHUD
{
    if (self.dataStatusChange)
    {
        self.dataStatusChange();
    }
    [self backLevelController];
}
/**
 提交最后的判断
 */
- (void)touchUpInsideSubmit;
{
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否开始提交任务信息?"];
    [more showHandler:^{
        
        if (weakSelf.workStatus == AFNetworkReachabilityStatusUnknown)
        {
            hudShowError(@"网络连接异常!");
        }
        else if (weakSelf.workStatus == AFNetworkReachabilityStatusNotReachable)
        {
            // 不可达的网络(未连接)
            hudShowError(@"网络异常!");
        }
        else if (weakSelf.workStatus == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            // 2G,3G,4G...的网络
            [weakSelf showPrompt:@"当前网络非WiFi连接,是否继续上传资源信息?"];
        }
        else if (weakSelf.workStatus == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            // wifi的网络
            [weakSelf uploadingResources];
        }
        
    }];
    
}
/**
 上传
 */
- (void)uploadingResources
{
    [self sendVoiceStopNotice];
    [self valuesViewTableViewAll];
    
    if ([self.viewMode isComplete])
    {
        TBWeakSelf
        [self.viewMode submitDataSuccessful:^(TBMakingListMode *mode) {
            
            weakSelf.makingList = mode;
            [weakSelf pushCompleteController];
        } failure:^{
            
        }];
    }
    else
    {
        hudShowError(@"有数据遗漏?");
    }
    
}
// 调到结果页
- (void)pushCompleteController
{
    TBWeakSelf
    [self.viewMode deleteMode:self.makingList state:^(BOOL successful) {
        
        if (weakSelf.dataStatusChange)
        {
            weakSelf.dataStatusChange();
        }
    }];
    
    [self scrollViewOffsetIndex:0 animateDuration:0.0];
    self.templateType = TBMakingProductionModifyThe;
    TBTemplateCompleteViewController *vc = [[TBTemplateCompleteViewController alloc] init];
    vc.makingModel = self.makingList;
    [self.navigationController pushViewController:vc animated:YES];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:TaskToInform object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}
// 发送停止声音通知
- (void)sendVoiceStopNotice
{
    NSNotification * notice = [NSNotification notificationWithName:@"VoiceStopNotice" object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}
- (void)showPrompt:(NSString *)stateInfo
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:stateInfo preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"任性上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self uploadingResources];
        
    }]];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)backLevelController
{
    [self sendVoiceStopNotice];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger offset =  self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self.footTool updateFootViewStyle:offset];
}

#pragma mark ---self---
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [(AppDelegate *)APPDELEGATE setIsProcessingNotice:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIView dismissMJNotifier];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    [(AppDelegate *)APPDELEGATE setIsProcessingNotice:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNacItemView];
    [self initSupViews];
    [self setScrollViewContent];
    [self initDataConfiguration];
    [self workReachability];
}
- (void)dealloc
{
    [self.bossHeadView stopBossAudio];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
