//
//  LayerShow.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "LayerShow.h"
#import "MainScreenBound.h"

@implementation LayerShow

{
    UIImageView *rocketImageView;
    UIImageView *earthImageView;
    UIImageView *bgImageView;
    UIButton *buttom;
    UIView *view;
    
}

- (void)appear {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [window addSubview:bgImageView];
    [window addSubview:earthImageView];
    [window addSubview:rocketImageView];
    [window addSubview:buttom];
    
    
    [UIView animateWithDuration:0.01 animations:^{
        [self startAnimationForRocket];
        [self startAnimationForEarth];
    } completion:^(BOOL finished) {
    }];
    
}
- (void)disappear {
    [UIView animateKeyframesWithDuration:1.8 delay:0 options:(UIViewKeyframeAnimationOptionBeginFromCurrentState) animations:^{
        earthImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        bgImageView.alpha = 0;
        earthImageView.alpha = 0;
        rocketImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self cancelGuideAnimation];
    }];
}

- (void)cancelGuideAnimation {
    [buttom removeFromSuperview];
    [bgImageView removeFromSuperview];
    [earthImageView removeFromSuperview];
    [rocketImageView removeFromSuperview];
    [view removeFromSuperview];
}

- (void)guideShow {
    
    view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor clearColor];
    
    buttom = [UIButton buttonWithType:(UIButtonTypeSystem)];
    buttom.frame = CGRectMake(kWidth - 50, kHeight/20, kWidth/10, kHeight/20);
    [buttom setTitle:@"跳过" forState:(UIControlStateNormal)];
    [buttom addTarget:self action:@selector(cancelGuideAnimation) forControlEvents:(UIControlEventTouchUpInside)];
    [buttom setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImageView.image = [UIImage imageNamed:@"bg_guide"];
    
    earthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/10, kHeight/4, kWidth * 4/5, kWidth * 4/5)];
    earthImageView.image = [UIImage imageNamed:@"earth@3x"];
    
    float w = earthImageView.frame.origin.x;
    rocketImageView = [[UIImageView alloc] initWithFrame:CGRectMake(earthImageView.center.x - w/2, earthImageView.center.y - w, w, w*2)];
    rocketImageView.image = [UIImage imageNamed:@"fire1@3X(1)"];
    
    [self appear];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self disappear];
    });
    
    
    
}

static int i = 1;
- (void)startAnimationForRocket {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        if (i > 3) {
            i = 1;
        }
        NSString *imageName = [NSString stringWithFormat:@"fire%d@3X(1)",i];
        rocketImageView.image = [UIImage imageNamed:imageName];
        i++;
        rocketImageView.transform = CGAffineTransformRotate(rocketImageView.transform, M_PI_4/5);
        rocketImageView.layer.anchorPoint = CGPointMake(4.8, 0.5);
        
    } completion:^(BOOL finished) {
        
        [self startAnimationForRocket];
        
    }];
}

- (void)startAnimationForEarth {
    
    [UIView animateWithDuration:0.1 animations:^{
        earthImageView.transform = CGAffineTransformRotate(earthImageView.transform, M_PI / -40);
    } completion:^(BOOL finished) {
        [self startAnimationForEarth];
    }];
}

#pragma mark -------------- weather --------------

+ (void)fallStarShowWithFallStar:(UIImageView *)fallStar {
    [UIView animateWithDuration:2 animations:^{
        if (fallStar.frame.origin.x >  - fallStar.frame.size.width) {
            fallStar.hidden = NO;
            fallStar.transform = CGAffineTransformMakeTranslation(-fallStar.frame.origin.x - fallStar.frame.size.width, fallStar.frame.origin.x * 1.5);
        }
    } completion:^(BOOL finished) {
        fallStar.hidden = YES;
        fallStar.transform = CGAffineTransformMakeTranslation(arc4random() % 50, - fallStar.frame.size.height);
    }];
}


+ (void)cloudShowWithCloud:(UIImageView *)cloud {
    [UIView animateWithDuration:0.1 animations:^{
        
        if (cloud.frame.origin.x >= kWidth) {
            cloud.hidden = YES;
            cloud.alpha = 0;
            cloud.transform = CGAffineTransformMakeTranslation(- cloud.frame.size.width, arc4random() % 150);
        } else {
            cloud.hidden = NO;
            cloud.alpha = 1;
            cloud.transform = CGAffineTransformMakeTranslation(cloud.frame.origin.x + 0.5, 0);
        }
    } completion:nil];
    
}

+ (void)lightningShowWithLigtning:(UIImageView *)lightning {
    [UIView animateWithDuration:arc4random() % 2 animations:^{
        lightning.hidden = NO;
        lightning.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        lightning.hidden = NO;
        lightning.transform = CGAffineTransformMakeScale(1.003, 1.003);
        [LayerShow hidden:lightning];
    }];
}

+ (void)hidden:(UIImageView *)light {
    [UIView animateWithDuration:arc4random() % 2 animations:^{
        light.hidden = YES;
    } completion:^(BOOL finished) {
        light.hidden = NO;
    }];
    
}



static int count;
+ (void)sunshineShowWithSunshine:(UIImageView *)sunshine {
    count++;
    [UIView animateWithDuration:0.1 animations:^{
        if (count <= 20) {
            sunshine.transform = CGAffineTransformRotate(sunshine.transform, M_PI/360.0);
        } else if (count < 170) {
            sunshine.transform = CGAffineTransformRotate(sunshine.transform, -M_PI/360.0);
        } else {
            count = -130;
        }
        
    } completion:nil];
 
}



#pragma mark -------------- view change --------------

+ (void)waterDropCATransitionWithView:(UIView *)view dration:(CGFloat)dration {
    
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromLeft;
    transition.duration = dration;
    [view.superview.layer addAnimation:transition forKey:@"水滴效果"];
}


@end
