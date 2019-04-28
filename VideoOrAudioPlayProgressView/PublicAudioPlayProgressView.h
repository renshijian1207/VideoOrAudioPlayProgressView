//
//  PublicAudioPlayProgressView.h
//  ProjectFramework
//
//  Created by 李海群 on 2019/4/24.
//  Copyright © 2019 hsrd-hq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PublicAudioPlayProgressViewDelegate <NSObject>

- (void) changePlayTimeByPublicAudioPlayProgressView : (int) playCount;

@end

@interface PublicAudioPlayProgressView : UIView

+ (instancetype) publicAudioPlayProgressView : (CGRect) frame;

@property (nonatomic, weak) id<PublicAudioPlayProgressViewDelegate> delegate;

- (void)changeCanPlayAbleProgress:(int)progressFloat totalLength:(int)totalCount;

- (void) changePlayProgress : (int) progressFloat totalLength : (int) totalCount;

@end

NS_ASSUME_NONNULL_END
