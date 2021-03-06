//
//  TBSigningContractInformationView.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBSigningContractInformationView.h"
#import "TBBusinessIntelligencePhotoTableViewCell.h"
#import "TBSigningPromptTableViewCell.h"
#import "TBSigningPromptTableViewCell.h"

static NSString*const  reuseIdentifier_photo = @"cell_photo";
static NSString*const  reuseIdentifier_card = @"cell_card";
static NSString*const  reuseIdentifier_info = @"cell_info";

@interface TBSigningContractInformationView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TBBusinessIntelligencePhotoTableViewCell *cardCell;

@property (nonatomic, strong) TBBusinessIntelligencePhotoTableViewCell *photoCell;

@property (nonatomic, strong) NSArray *promptArray;
@end
@implementation TBSigningContractInformationView

- (NSArray *)promptArray
{
    if (!_promptArray)
    {
        _promptArray = [NSArray arrayWithObjects:@"    老板身分证双面照作为开通天府银行云金融账户的必要条件，请上传清晰的照片，此影响到商户审核是否通过，请重视，谢谢合作。",@"    合同资料，包含套餐内容、付费金额、签署日期、签署人页面照片为必传，此影响到商家审核是否通过，请重视，谢谢合作。", nil];
    }
    return _promptArray;
}
- (UITableView *)tableView
{
    
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TBSigningPromptTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_info];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessIntelligencePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_photo];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessIntelligencePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_card];
    }
    return _tableView;
}

- (void)createAview;
{
    [self addSubview:self.tableView];
    self.photoCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_photo];
    self.cardCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_card];
    
    self.cardCell.maxRow = 2;
    self.cardCell.defaultRow = 2;
    self.photoCell.maxRow = 9;
    
    TBWeakSelf
    [self.photoCell setUpdataTableView:^{
        
        [weakSelf reloadTableView];
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
}
#pragma mark ---tableViewDelegate---
- (void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0)
    {
        if (indexPath.section == 0)
        {
            self.cardCell.defaultName = @"task-shangchuan-small";
            [self.cardCell.promptButton setTitle:@" 老板身份证（双面照）" forState:UIControlStateNormal];
            cell = self.cardCell;
        }
        else
        {
            self.photoCell.defaultName = @"contractPhotos";
            [self.photoCell.promptButton setTitle:@" 上传签约合同资料图片" forState:UIControlStateNormal];
            cell = self.photoCell;
        }
    }
    else
    {
        TBSigningPromptTableViewCell *signingCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier_info];
        [signingCell assignmentText:self.promptArray[indexPath.section]];
        cell = signingCell
        ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark  --数据处理---
- (void)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    [self.photoCell.imageArray removeAllObjects];
    
    id positiveImage;
    id reverseImage;
    if (makingList.positivePhotoUrl.length >0)
    {
        positiveImage = makingList.positivePhotoUrl;
    }
    else if (makingList.positivePhotoData)
    {
        UIImage *_decodedImage      = [UIImage imageWithData:makingList.positivePhotoData];
        positiveImage = _decodedImage;
    }
    
    if (makingList.reversePhotoUrl.length >0)
    {
        reverseImage = makingList.reversePhotoUrl;
    }
    else if (makingList.reversePhotoData)
    {
        UIImage *_decodedImage      = [UIImage imageWithData:makingList.reversePhotoData];
        reverseImage = _decodedImage;
    }

    if (positiveImage)
    {
        [self.cardCell.imageArray addObject:positiveImage];
    }
    if (reverseImage)
    {
        [self.cardCell.imageArray addObject:reverseImage];
    }
    [self.cardCell updataCollectionView];

}
- (void)updataMaking;
{
 
    id positiveImage;
    id reverseImage;
    
    if (self.cardCell.imageArray.count == 2)
    {
        positiveImage = self.cardCell.imageArray.firstObject;
        reverseImage = self.cardCell.imageArray.lastObject;
    }
    else if (self.cardCell.imageArray.count == 1)
    {
        positiveImage = self.cardCell.imageArray.firstObject;
    }
    
    
    if ([positiveImage isKindOfClass:[NSString class]])
    {
        self.makingList.positivePhotoUrl = positiveImage;
        self.makingList.positivePhotoData = nil;
    }
    else if ([positiveImage isKindOfClass:[UIImage class]])
    {
        NSData *data = UIImageJPEGRepresentation(positiveImage, 1.0);
        self.makingList.positivePhotoData = data;
        self.makingList.positivePhotoUrl = nil;
    }
    else
    {
        self.makingList.positivePhotoData = nil;
        self.makingList.positivePhotoUrl = nil;
    }
    
    if ([reverseImage isKindOfClass:[NSString class]])
    {
        self.makingList.reversePhotoUrl = reverseImage;
        self.makingList.reversePhotoData = nil;
    }
    else if ([reverseImage isKindOfClass:[UIImage class]])
    {
        NSData *data = UIImageJPEGRepresentation(reverseImage, 1.0);
        self.makingList.reversePhotoData = data;
        self.makingList.reversePhotoUrl = nil;
    }
    else
    {
        self.makingList.reversePhotoData = nil;
        self.makingList.reversePhotoUrl = nil;
    }
}

@end
