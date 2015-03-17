//
//  KYWaterWaveView.h
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYWaterWaveView : UIView

@property (nonatomic,assign)CGFloat waveSpeed;     // Default as 6
@property (nonatomic,assign)CGFloat waveAmplitude; // Default as 6

@property (nonatomic, strong) UIColor   *waveColor; // Default as [UIColor blueColor]

- (void)wave;
- (void)stop;

@end
