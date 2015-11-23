////////////////////////////////////////////////////////////////////////////////
/*
	RMSTimerView.h
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#if !TARGET_OS_IOS
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
// Remap Cocoa to UIKit equivalents
#define NSView 		UIView
#define NSColor 	UIColor
#define NSRect 		CGRect
#define NSRectFill 	UIRectFill
#endif

////////////////////////////////////////////////////////////////////////////////

@interface RMSTimerView : NSView

- (void) startUpdating;
- (void) stopUpdating;
- (void) timerDidFire:(NSTimer *)timer;

@end




