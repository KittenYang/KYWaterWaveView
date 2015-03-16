# KYWaterWaveView

###一个内置波浪动画的UIView。
####A view with water wave animation inside.

![](water.gif)


##Usage

 You can use code or xib to create;
 Then set the properties;
 
 ```
@property (nonatomic,assign)CGFloat waveSpeed;     // 控制波浪的快慢 the speed of the wave
@property (nonatomic,assign)CGFloat waveAmplitude; // 波浪的震荡幅度 the amplitude  of the wave
 ```
 
 Most importantly, do not forget to call `[waterView wave]`; 
 
 When you need to stop the wave,just call `[waterView stop]`;
 
 
