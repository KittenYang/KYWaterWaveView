//
//  KYWaterWaveView.h
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MB_STRONG
#if __has_feature(objc_arc)
    #define MB_STRONG strong
#else
    #define MB_STRONG retain
#endif
#endif

@interface KYWaterWaveView : UIView

@property (nonatomic, assign) CGFloat waveSpeed;     // Default as 6
@property (nonatomic, assign) CGFloat waveAmplitude; // Default as 6
@property (nonatomic, MB_STRONG) UIColor   *waveColor; // Default as [UIColor blueColor]

- (void)wave;
- (void)stop;

@end
