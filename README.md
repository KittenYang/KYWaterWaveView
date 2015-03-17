# KYWaterWaveView

### 一个内置波浪动画的UIView。
#### A view with water wave animation inside.

![](water.gif)


## Usage

 You can use code or xib to create;
 Then set the properties;
 
 ```
@property (nonatomic, assign) CGFloat waveSpeed;     // Default as 6
@property (nonatomic, assign) CGFloat waveAmplitude; // Default as 6
@property (nonatomic, strong) UIColor   *waveColor; // Default as [UIColor blueColor]
 ```
 
 Most importantly, do not forget to call `[waterView wave]`; 
 
 When you need to stop the wave,just call `[waterView stop]`;
 
 
