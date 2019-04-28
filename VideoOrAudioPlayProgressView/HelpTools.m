//
//  HelpTools.m
//  VideoOrAudioPlayProgressView
//
//  Created by 李海群 on 2019/4/28.
//  Copyright © 2019 hsrd-hq. All rights reserved.
//

#import "HelpTools.h"

@implementation HelpTools

+ (CGFloat)adaptiveWithPx:(CGFloat)px
{
    CGFloat temp = 0;
    if (KScreenHeight < 330) {
        temp = 0.56;
    }
    else if (KScreenHeight > 330 && KScreenHeight < 400)
    {
        temp = 0.66;
    }
    else
    {
        temp = 0.73;
    }
    return temp*kPxChange(px);
}

@end
