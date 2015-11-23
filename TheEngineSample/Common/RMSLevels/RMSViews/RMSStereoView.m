////////////////////////////////////////////////////////////////////////////////
/*
	RMSStereoView.m
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import "RMSStereoView.h"


@interface RMSStereoView ()
{
	RMSResultView *mViewL;
	RMSResultView *mViewR;
}
@end


////////////////////////////////////////////////////////////////////////////////
@implementation RMSStereoView
////////////////////////////////////////////////////////////////////////////////

- (NSRect) frameForResultViewL
{
	NSRect frame = self.bounds;
	frame.size.height *= 0.5;
	frame.origin.y += frame.size.height;
	return frame;
}

////////////////////////////////////////////////////////////////////////////////

- (NSRect) frameForResultViewR
{
	NSRect frame = self.bounds;
	frame.size.height *= 0.5;
	return frame;
}

////////////////////////////////////////////////////////////////////////////////

- (RMSResultView *) resultViewL
{
	if (mViewL == nil)
	{
		// Compute top half of frame
		NSRect frame = [self frameForResultViewL];
		
		// Create levels view with default drawing direction
		mViewL = [[RMSResultView alloc] initWithFrame:frame];
		
		// Add as subview
		[self addSubview:mViewL];
	}
	
	return mViewL;
}

////////////////////////////////////////////////////////////////////////////////

- (RMSResultView *) resultViewR
{
	if (mViewR == nil)
	{
		// Compute bottom half of frame
		NSRect frame = [self frameForResultViewR];
		
		// Create levels view with default drawing direction
		mViewR = [[RMSResultView alloc] initWithFrame:frame];
		
		// Add as subview
		[self addSubview:mViewR];
	}
	
	return mViewR;
}

////////////////////////////////////////////////////////////////////////////////

- (void) timerDidFire:(NSTimer *)timer
{
	[self updateLevels];
}

////////////////////////////////////////////////////////////////////////////////

- (void) updateLevels
{
	rmsresult_t L = RMSEngineFetchResult(self.enginePtrL);
	rmsresult_t R = RMSEngineFetchResult(self.enginePtrR);
	
	[self.resultViewL setLevels:L];
	[self.resultViewR setLevels:R];
}

////////////////////////////////////////////////////////////////////////////////

- (void) drawRect:(NSRect)rect
{
	[[NSColor blackColor] set];
	NSRectFill(rect);
}

////////////////////////////////////////////////////////////////////////////////
@end
////////////////////////////////////////////////////////////////////////////////
