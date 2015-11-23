////////////////////////////////////////////////////////////////////////////////
/*
	RMSBalanceView.m
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import "RMSBalanceView.h"


@interface RMSBalanceView ()
{
	NSView *mIndicator;
}
@end


////////////////////////////////////////////////////////////////////////////////
@implementation RMSBalanceView
////////////////////////////////////////////////////////////////////////////////

- (NSRect) frameForResultViewL
{
	// Compute left side of bounds
	NSRect frame = self.bounds;
	frame.size.width *= 0.5;
	frame.size.width -= 1.0;

	return frame;
}

////////////////////////////////////////////////////////////////////////////////

- (NSRect) frameForResultViewR
{
	// Compute right side of bounds
	NSRect frame = self.bounds;
	frame.size.width *= 0.5;
	frame.size.width -= 1.0;
	frame.origin.x += frame.size.width+2.0;

	return frame;
}

////////////////////////////////////////////////////////////////////////////////

- (RMSResultView *) resultViewL
{
	RMSResultView *view = [super resultViewL];
	view.direction = eRMSViewDirectionW;
	return view;
}

////////////////////////////////////////////////////////////////////////////////

- (void) setBalance:(double)balance
{
	NSRect frame = self.bounds;
	frame.origin.x += 0.5*frame.size.width;
	frame.origin.x += 0.5*frame.size.width * balance;
	frame.origin.x -= 1.0;
	frame.size.width = 2.0;
	self.balanceIndicator.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark Drawing
////////////////////////////////////////////////////////////////////////////////

- (void) drawRect:(NSRect)rect
{
	[[NSColor blackColor] set];
	NSRectFill(rect);
}

////////////////////////////////////////////////////////////////////////////////

- (NSView *) balanceIndicator
{
	if (mIndicator == nil)
	{
		// Create one point wide view
		NSRect frame = self.bounds;
		frame.origin.x += 0.5*frame.size.width;
		frame.origin.x -= 1.0;
		frame.size.width = 2.0;
		
		// Abuse background layer for coloring (OSX)
		mIndicator = [[NSView alloc] initWithFrame:frame];
		
		#if !TARGET_OS_IOS
		mIndicator.wantsLayer = YES;
		#endif
		mIndicator.layer.backgroundColor = [NSColor redColor].CGColor;

		// Add as subview
		[self addSubview:mIndicator];
	}
	
	return mIndicator;
}

////////////////////////////////////////////////////////////////////////////////
@end
////////////////////////////////////////////////////////////////////////////////
