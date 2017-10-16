//
//  ZKUtil.m
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKUtil.h"
#import "UIImageView+WebCache.h"
#import <sys/sysctl.h>

@implementation ZKUtil

+ (void)downloadImage:(UIImageView*)imageView imageUrl:(NSString*)url;
{
    if (![url containsString:IMAGE_URL]) {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

+ (void)downloadImage:(UIImageView *)imageView imageUrl:(NSString *)url  duImageName:(NSString*)duImage;
{
    if (![url containsString:IMAGE_URL]) {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:duImage]];
}

+ (void)cacheUserValue:(NSString *)value key:(NSString *)key;
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+ (NSString *)getUserDataForKey:(NSString *)key;
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (key)
    {
        
        NSString *phone=[defaults objectForKey:key];
        return phone;
    }else{
        
        return @"";
    }
    
}
+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];
    });
}

+ (NSData *)getCacheFileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    return [[NSData alloc] initWithContentsOfFile:path];
}

+ (NSUInteger)getAFNSize
{
    NSUInteger size = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+ (NSUInteger)getSize
{
    //获取AFN的缓存大小
    NSUInteger afnSize = [self getAFNSize];
    return afnSize;
}

+ (void)clearAFNCache
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = NAVIGATION_COLOR;
    [[APPDELEGATE window] addSubview:activity];
    activity.frame = CGRectMake(_SCREEN_WIDTH/2-20, _SCREEN_HEIGHT/2-20, 40, 40);

    [activity startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];
            [fm removeItemAtPath:filePath error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [UIView addMJNotifierWithText:@"清理完毕" dismissAutomatically:YES];
            [activity stopAnimating];
            [activity removeFromSuperview];
        });
    });

}

+ (void)clearCache
{
    [self clearAFNCache];
}

+ (BOOL)isExpire:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:path error:nil];
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return ((nowTimestamp-fileModificationTimestamp)>kYBCache_Expire_Time);
}


+ (BOOL)obtainBoolForKey:(NSString *)key;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
}
+ (void)saveBoolForKey:(NSString *)key valueBool:(BOOL)value;
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum;
{
    /**
     * 手机号码
     */
    NSString * MOBIL = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }
    return NO;
    
}
+ (BOOL)character:(NSString*)str;
{
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *k =[str substringToIndex:1];
    return [predicate evaluateWithObject:k];
    
}

//是否是纯数字

+ (BOOL)isNumText:(NSString *)str
{
    
    NSScanner* scan = [NSScanner scannerWithString:str];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}
+ (BOOL)ismoney:(NSString *)str
{
    if (str.length == 0)
    {
        return NO;
    }
    NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    BOOL flag = [phoneTest evaluateWithObject:str];
    
    return flag;
    
}
+ (BOOL)checkNumber:(NSString *)mobileNum
{
    NSString *tel = [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];

    if (tel.length>13 || tel.length <6)
    {
        return NO;
    }
    else if (tel.length == 13)
    {
        return [self isMobileNumber:tel];
    }
    else
    {
     return [self isNumText:tel];
    }
}
+ (CGSize)contentLabelSize:(CGSize)size labelFont:(UIFont*)font labelText:(NSString*)str
{
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;}
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        if (color) {
            
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}
+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
+ (NSString *)timeStamp
{
    NSTimeInterval time= [[NSDate date] timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%lld", (long long)time];
}


+ (NSString*)deviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space
{
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
+ (void)shakeAnimationForView:(UIView *)view
{
    if (view == nil)
    {
        return;
    }
    //获取到当前View的layer
    CALayer *viewLayer = view.layer;
    //获取当前View的位置
    CGPoint position = viewLayer.position;
    //移动的两个终点位置
    CGPoint beginPosition = CGPointMake(position.x + 10, position.y);
    CGPoint endPosition = CGPointMake(position.x - 10, position.y);
    //设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    //设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:beginPosition]];
    //设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:endPosition]];
    //设置自动反转
    [animation setAutoreverses:YES];
    //设置时间
    [animation setDuration:.06];
    //设置次数
    [animation setRepeatCount:3];
    //添加上动画
    [viewLayer addAnimation:animation forKey:@"vibrationAnimation"];
}

@end
