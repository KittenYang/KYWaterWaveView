<p align="left" >
  <img src="logo_.png" alt="KYWaterWaveView" title="KYWaterWaveView">
</p>


![CocoaPods Version](https://img.shields.io/badge/pod-v1.1.0-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-iOS-red.svg)


### 一个内置波浪动画的UIView。
#### A view with water wave animation inside.

![](water.gif)


##Installation

`pod 'KYWaterWaveView', '~> 1.1.0'`

## Usage

 You can use code or xib to create;
 Then set the properties;
 
 ```objective-c
@property (nonatomic, assign) CGFloat waveSpeed;     // Default as 6
@property (nonatomic, assign) CGFloat waveAmplitude; // Default as 6
 ```
 
 Most importantly, do not forget to call `[waterView wave]`; 
 
 When you need to stop the wave,just call `[waterView stop]`;
 
 

##License
The MIT License (MIT)

Copyright (c) 2015 KittenYang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
