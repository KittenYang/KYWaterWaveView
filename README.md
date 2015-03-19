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
 ```
 
 Most importantly, do not forget to call `[waterView wave]`; 
 
 When you need to stop the wave,just call `[waterView stop]`;
 
 

##License
The MIT License (MIT)

Copyright (c) 2015 0dayZh

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
