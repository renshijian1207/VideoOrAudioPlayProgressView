//
//  HelpTools.h
//  VideoOrAudioPlayProgressView
//
//  Created by 李海群 on 2019/4/28.
//  Copyright © 2019 hsrd-hq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MARK:   ----------获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight ([[UIScreen mainScreen] bounds].size.height)

//MARK:        -------------px转换
#define kPxChange(pxSize) ((pxSize)*(72.f)/(96.f))

//MARK:        -------------字体字号
#define FontSemibold(a) [UIFont fontWithName:@"PingFangSC-Semibold" size:a]

@interface HelpTools : NSObject

/**
 适配屏幕
 
 @param px px
 @return dx
 */
+ (CGFloat) adaptiveWithPx : (CGFloat) px;

@end

NS_ASSUME_NONNULL_END
