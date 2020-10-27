// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>

/// "UINavigation+FDFullscreenPopGesture" extends UINavigationController's swipe-
/// to-pop behavior in iOS 7+ by supporting fullscreen pan gesture. Instead of
/// screen edge, you can now swipe from any place on the screen and the onboard
/// interactive pop transition works seamlessly.
///
/// 译：“UINavigation+FDFullscreenPopGesture”扩展了UINavigationController在iOS 7+中的话滑屏弹出行为，以支持全屏平移手势取代了屏幕边缘，现在可以从屏幕上的任何地方滑动，以pop的交互式过渡无缝工作。
///
/// Adding the implementation file of this category to your target will
/// automatically patch UINavigationController with this feature.

/// 译：将此类别的实现文件添加到目标将自动使用此功能修补UINavigationController。

@interface UINavigationController (FDFullscreenPopGesture)

/// The gesture recognizer that actually handles interactive pop.

/// 译：实际处理交互式pop的手势识别器。
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *fd_fullscreenPopGestureRecognizer;

/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "fd_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.

/// 译：视图控制器可以自己控制导航栏的外观，而不是全局方式，检查“fd_prefersNavigationBarHidden”属性。默认为YES，如果不想禁用它。
@property (nonatomic, assign) BOOL fd_viewControllerBasedNavigationBarAppearanceEnabled;

@end

/// Allows any view controller to disable interactive pop gesture, which might
/// be necessary when the view controller itself handles pan gesture in some
/// cases.

/// 译：允许任何视图控制器禁用交互式pop手势，在某些情况下，当视图控制器本身处理平移手势时，这可能是必需的。
@interface UIViewController (FDFullscreenPopGesture)

/// Whether the interactive pop gesture is disabled when contained in a navigation
/// stack.

/// 译：当包含在导航堆栈中时，交互式pop手势是否被禁用。
@property (nonatomic, assign) BOOL fd_interactivePopDisabled;

/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.

/// 译：指示此视图控制器是否希望其导航栏处于隐藏状态，在启用基于视图控制器的导航栏外观时选中此选项。默认为NO，导航栏可能显示。
@property (nonatomic, assign) BOOL fd_prefersNavigationBarHidden;

/// Max allowed initial distance to left edge when you begin the interactive pop
/// gesture. 0 by default, which means it will ignore this limit.

/// 译：开始交互式pop手势时允许的最大左边缘初始距离。默认为0，这意味着它将忽略此限制。
@property (nonatomic, assign) CGFloat fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
