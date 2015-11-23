////////////////////////////////////////////////////////////////////////////////
/*
	RMSTimerView.m
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import "RMSTimerView.h"


@interface RMSTimerView ()
{
	// Update timer
	NSTimer *mTimer;
}
@end

////////////////////////////////////////////////////////////////////////////////
@implementation RMSTimerView
////////////////////////////////////////////////////////////////////////////////

- (void) startUpdating
{
/*
	dispatch_queue_t globalQueue = dispatch_get_global_queue \
	(QOS_CLASS_USER_INTERACTIVE, DISPATCH_QUEUE_PRIORITY_HIGH);

	dispatch_after(dispatch_time(0.0, 100000000), globalQueue,
	^{
		dispatch_async(dispatch_get_main_queue(),
		^{ [self timerDidFire:nil]; });
	});
	
	return;
*/	
	if (mTimer == nil)
	{
		// set timer to appr 25 updates per second
		mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/25.0
		target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
		
		// add tolerance down to appr 20 updates per second
		[mTimer setTolerance:(1.0/20.0)-(1.0/25.0)];
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) stopUpdating
{
	if (mTimer != nil)
	{
		[mTimer invalidate];
		mTimer = nil;
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) timerDidFire:(NSTimer *)timer
{
	NSLog(@"%@", @"timerDidFire not implemented");
	[self stopUpdating];
}

////////////////////////////////////////////////////////////////////////////////
@end
////////////////////////////////////////////////////////////////////////////////






