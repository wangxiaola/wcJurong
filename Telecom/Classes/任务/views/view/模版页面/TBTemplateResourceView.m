//
//  TBTemplateResourceView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/13.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateResourceView.h"
#import "TBBusinessIntelligencePhotoTableViewCell.h"
#import "TBNoteTableViewCell.h"
#import "TBResourceLabelTableViewCell.h"

@interface TBTemplateResourceView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) ResourceImageType viewType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TBBusinessIntelligencePhotoTableViewCell *photoCell;

@property (nonatomic, strong) TBNoteTableViewCell *infoTextCell;

@property (nonatomic, strong) TBResourceLabelTableViewCell *labelCell;

@property (nonatomic, strong) NSArray <TBDescriDicData *>*labes;
// 记录标签id
@property (nonatomic, strong) NSArray *recordArray;

@property (nonatomic, strong) TBBasicDataTool *dataTool;

@property (nonatomic, strong) NSString *defaultImageName;
@end

@implementation TBTemplateResourceView

static NSString*const  reuseIdentifier_photo = @"cell_photo";
static NSString*const  reuseIdentifier_info = @"cell_info";
static NSString*const  reuseIdentifier_label = @"cell_label";

- (TBBasicDataTool *)dataTool
{
    if (!_dataTool)
    {
        _dataTool = [[TBBasicDataTool alloc] init];
    }
    return _dataTool;
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"TBNoteTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_info];
        [_tableView registerNib:[UINib nibWithNibName:@"TBResourceLabelTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_label];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessIntelligencePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_photo];
    }
    return _tableView;
}
- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        [self initTableView];
    }
    return self;
}
#pragma mark ---setView---
- (void)initTableView
{
    [self.contenView addSubview:self.tableView];
    
    self.photoCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_photo];
    self.photoCell.maxRow = 6;
    
    self.infoTextCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_info];
    [self.infoTextCell.promptButton setTitle:@" 描述" forState:UIControlStateNormal];
    self.infoTextCell.textView.placeholder = @"简单描述您上传的图片,不超过25个字";
    self.labelCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_label];
    
    TBWeakSelf
    [self.photoCell setUpdataTableView:^{
        
        [weakSelf reloadTableView];
    }];
    [self.labelCell setUpdataTableView:^{
        [weakSelf reloadTableView];
    }];
    
    [self.labelCell.tagsView setCompletionOriginal:^(NSArray *originalArray) {
        // 选中
        weakSelf.recordArray = originalArray;
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contenView);
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?1:2;
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
    if (indexPath.section == 0)
    {
        cell = self.photoCell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            cell = self.infoTextCell;
        }
        else
        {
            cell = self.labelCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark --- 类型设置----
- (void)createLayoutViewType:(ResourceImageType)type;
{
    self.viewType = type;
}
#pragma mark ----

- (void)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    NSString *labels = @"";
    NSString *info = @"";
    NSMutableArray *array;
    
    switch (self.viewType) {
        case ResourceImageTypeAppearance:
            info = makingList.appearanceText;
            labels = makingList.appearanceLabel;
            array = makingList.appearancePhotos;
            self.defaultImageName = @"default_appearance";
            break;
        case ResourceImageTypeFood:
            info = makingList.foofText;
            labels = makingList.foofLabel;
            array = makingList.foodPhotos;
            self.defaultImageName = @"default_food";
            break;
        case ResourceImageTypeEnvironment:
            info = makingList.environmentText;
            labels = makingList.environmentLabel;
            array = makingList.environmentPhotos;
            self.defaultImageName = @"default_environment";
            
            break;
            
        default:
            break;
    }
    
    self.photoCell.defaultName = self.defaultImageName;
    
    if (info.length >0)
    {
        self.infoTextCell.textView.text = info;
    }
    if (labels.length>0)
    {
        self.recordArray = [labels componentsSeparatedByString:@","];
    }
    [self postLabels];
    TBWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSString class]])
            {
                NSString *data = obj;
                if (data.length >200)
                {
                    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                    if (_decodedImage)
                    {
                        [array replaceObjectAtIndex:idx withObject:_decodedImage];
                    }
                    else
                    {
                        [array removeObjectAtIndex:idx];
                    }
                }
            }
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
            weakSelf.photoCell.imageArray = array;
            [weakSelf.photoCell updataCollectionView];
            [weakSelf reloadTableView];
        });
    });
    
}
// 请求标签
- (void)postLabels
{
    TBWeakSelf
    [TBBasicDataTool initializeTypeData:^(TBBasicDataTool *tool) {
        
        weakSelf.labes = [tool.describle objectAtIndex:self.viewType].data;
        [self.labelCell updataTags:self.recordArray allArray:self.labes];
        [weakSelf reloadTableView];
    }];
    
}
- (void)updataMaking;
{
    NSString *labels = [self.recordArray componentsJoinedByString:@","];
    
    if (self.labes.count == 0)
    {
        [self postLabels];
    }
    switch (self.viewType) {
        case ResourceImageTypeAppearance:
            
            self.makingList.appearancePhotos = self.photoCell.imageArray;
            self.makingList.appearanceText = self.infoTextCell.textView.text;
            self.makingList.appearanceLabel = labels;
            break;
        case ResourceImageTypeFood:
            
            self.makingList.foodPhotos = self.photoCell.imageArray;
            self.makingList.foofText = self.infoTextCell.textView.text;
            self.makingList.foofLabel = labels;
            break;
        case ResourceImageTypeEnvironment:
            
            self.makingList.environmentPhotos = self.photoCell.imageArray;
            self.makingList.environmentText = self.infoTextCell.textView.text;
            self.makingList.environmentLabel = labels;
            
            break;
            
        default:
            break;
    }
    
}


@end
