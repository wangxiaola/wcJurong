//
//  TBServicePlaceViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBServicePlaceViewController.h"
#import "TBStrategyViewController.h"
#import "TBTemplateCompleteViewController.h"

#import "TBMakingListMode.h"
#import "TBTaskMakeViewMode.h"

#import "TBServicePlaceTitleView.h"
#import "TBTaskMakeFootView.h"
#import "TBBasicInformationView.h"
#import "TBSigningContractInformationView.h"

#import "AFNetworkReachabilityManager.h"
#import "TBSaveSuccessTipsView.h"
#import "CDPMonitorKeyboard.h"
#import "TBMoreReminderView.h"
#import "UIBarButtonItem+Custom.h"

@interface TBServicePlaceViewController ()<UIScrollViewDelegate,TBTaskMakeViewModeDelegate,TBTaskMakeFootViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//业务处理模型
@property (nonatomic, strong) TBTaskMakeViewMode *viewMode;

// 服务场所基础信息
@property (nonatomic, strong) TBBasicInformationView *basicInformationView;

// 商家账户信息 && 签约合同信息
@property (nonatomic, strong) TBSigningContractInformationView *signingContractInformationView;


//尾部视图
@property (nonatomic, strong) TBTaskMakeFootView *footTool;

@property (nonatomic, strong) TBServicePlaceTitleView *titleView;

@property (nonatomic) AFNetworkReachabilityStatus workStatus;//网络状态

@end

@implementation TBServicePlaceViewController
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
- (TBTaskMakeViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[TBTaskMakeViewMode alloc] init];
        _viewMode.delegate = self;
    }
    return _viewMode;
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
    self.footTool.delegate = self;
    self.footTool.maxPage = 1;
    [self.footTool updateFootViewStyle:0];
    [self.view addSubview:self.footTool];
    
    self.titleView = [[TBServicePlaceTitleView alloc] initWithFrame:CGRectMake(0, 24, _SCREEN_WIDTH-100, 40) templateID:self.makingList.modelsID];
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
    
    self.basicInformationView = [[TBBasicInformationView alloc] init];
    [self.scrollView addSubview:self.basicInformationView];
    [viewArray addObject:self.basicInformationView];
    
    self.signingContractInformationView = [[TBSigningContractInformationView alloc] init];
    [self.scrollView addSubview:self.signingContractInformationView];
    [viewArray addObject:self.signingContractInformationView];
    
    
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
#pragma mark --- 导航栏点击事件 -----
- (void)strategyClick
{
    TBStrategyViewController *strategyView = [[TBStrategyViewController alloc] init];
    [self.navigationController pushViewController:strategyView animated:YES];
}
- (void)goBackClick
{
    [self.view endEditing:YES];
    if (self.makingList.images.count >0 )
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
#pragma mark ---根据类型来获取数据--
- (void)initDataConfiguration
{
    self.viewMode = [[TBTaskMakeViewMode alloc] init];
    if (self.makingList)
    {
        [self assignmentData:self.makingList];
    }
    else
    {
        if (self.servicePlaceType == TBServicePlaceTypeEditor)
        {
            self.viewMode.delegate = self;
            [self.viewMode postEditDataID:self.merchantsID];
        }
        else if (self.servicePlaceType == TBServicePlaceTypeMaking)
        {
            self.viewMode.delegate = self;
            [self.viewMode postMakingDataID:self.merchantsID];
        }
        else
        {
            self.makingList = [[TBMakingListMode alloc] init];
            self.makingList.modelsID = self.modelsID;
            [self assignmentData:self.makingList];
        }
    }
    
}
#pragma mark ---TBTaskMakeViewModeDelegate--
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
    hudDismiss();
    [self assignmentData:data];
}
/**
 编辑数据获取
 
 @param data data
 */
- (void)editTemplateData:(TBMakingListMode *)data;
{
    hudDismiss();
    [self assignmentData:data];
}
/**
 数据请求失败
 
 @param err string
 */
- (void)dataPostError:(NSString *)err;
{
    hudShowError(err);
    [self backLevelController];
}
/**
 赋值
 
 @param mode 模型
 */
- (void)assignmentData:(TBMakingListMode *)mode
{
    self.makingList = mode;
    self.makingList.type = @"service";
    [self.basicInformationView updataData:self.makingList];
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
    
    if (type == YES)
    {
        //  上一步
        [self scrollViewOffsetIndex:offset-1 animateDuration:0.2];
    }
    else
    {
        // 提交
        if (offset == self.footTool.maxPage)
        {
            
            [self touchUpInsideSubmit];
        }
        else
        {
            [self valuesViewTabelIndex:offset];
            TBWeakSelf
            [self.viewMode isServiceNextStepIndex:offset templateID:self.makingList.modelsID  state:^(BOOL successful) {
                if (successful)
                {         // 下一步
                    [weakSelf scrollViewOffsetIndex:offset+1 animateDuration:0.2];
                }
            }];
        }
        
    }
}

#pragma mark  ---- 逻辑处理 ---
- (void)valuesViewTabelIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self.basicInformationView updataMaking];
    }
    else if (index == 1)
    {
        
        [self.signingContractInformationView updataMaking];
    }
    
    self.viewMode.makingMode = self.makingList;
}
- (void)valuesViewTableViewAll
{
    [self.basicInformationView updataMaking];
    [self.signingContractInformationView updataMaking];
    self.viewMode.makingMode = self.makingList;
}
#pragma mark --- 保存&&提交---

/**
 保存
 */
- (void)footViewTouchUpInsideSave;
{
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"是否保存到本地"];
    [more showHandler:^{
        [weakSelf saveTask];
    }];
}

/**
 提交最后的判断
 */
- (void)touchUpInsideSubmit;
{
    TBWeakSelf
    [self valuesViewTableViewAll];
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
- (void)saveTask
{
    hudShowLoading(@"保存中");
    [self valuesViewTableViewAll];
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

/**
 上传
 */
- (void)uploadingResources
{
    TBWeakSelf
    [self.viewMode isServiceNextStepIndex:self.footTool.maxPage templateID:self.makingList.modelsID  state:^(BOOL successful) {
        if (successful)
        {
            [self.viewMode submitServiceSuccessful:^(TBMakingListMode *mode)
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     weakSelf.makingList = mode;
                     [weakSelf pushCompleteController];
                 }];
             } failure:^{
             }];
        }
    }];

}
// 调到结果页
- (void)pushCompleteController
{
    hudShowSuccess(@"上传成功");
    if (self.dataStatusChange)
    {
        self.dataStatusChange();
    }
    [self.viewMode deleteMode:self.makingList state:^(BOOL successful) {
    }];
    [self scrollViewOffsetIndex:0 animateDuration:0.0];
     self.servicePlaceType = TBServicePlaceTypeEditor;
    TBTemplateCompleteViewController *completeView = [[TBTemplateCompleteViewController alloc] init];
    completeView.makingModel = self.makingList;
    [self.navigationController pushViewController:completeView animated:YES];
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:TaskToInform object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];

}
- (void)backLevelController
{
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNacItemView];
    [self setScrollViewContent];
    [self workReachability];
    [self initDataConfiguration];
    [self initSupViews];
}
- (void)dealloc
{
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
