//
//  KYWaterWaveView.h
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYWaterWaveView : UIView

@property (nonatomic,assign)CGFloat waveSpeed;     // 控制波浪的快慢
@property (nonatomic,assign)CGFloat waveAmplitude; // 波浪的震荡幅度

-(void) wave;
-(void) stop;

@end
