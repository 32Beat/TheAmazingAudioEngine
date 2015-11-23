////////////////////////////////////////////////////////////////////////////////
/*
	RMSResultView.m
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import "RMSResultView.h"
#import "RMSIndexView.h"


@interface RMSResultView ()
{
	// Represented data
	rmsresult_t mLevels;
	
	RMSIndexView *mIndexView;
}
@end

////////////////////////////////////////////////////////////////////////////////
@implementation RMSResultView
////////////////////////////////////////////////////////////////////////////////

- (void) setLevels:(rmsresult_t)levels
{
	mLevels = levels;
	[self setNeedsDisplayInRect:self.bounds];
}

////////////////////////////////////////////////////////////////////////////////

- (NSRect) frameForIndexView
{
	NSRect frame = self.bounds;
	frame.size.height *= 5.0/25.0;
	return frame;
}

////////////////////////////////////////////////////////////////////////////////

- (RMSIndexView *) indexView
{
	if (mIndexView == nil)
	{
		// Compute top half of frame
		NSRect frame = [self frameForIndexView];
		
		// Create levels view with default drawing direction
		mIndexView = [[RMSIndexView alloc] initWithFrame:frame];
		mIndexView.direction = self.direction;
		
		// Add as subview
		[self addSubview:mIndexView];
	}
	
	return mIndexView;
}

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark Drawing
////////////////////////////////////////////////////////////////////////////////

#define HSBCLR(h, s, b) \
[NSColor colorWithHue:h/360.0 saturation:s brightness:b alpha:1.0]

- (NSColor *) bckColor
{
	if (_bckColor == nil)
	{ _bckColor = HSBCLR(0.0, 0.0, 0.5); }
	return _bckColor;
}

- (NSColor *) avgColor
{
	if (_avgColor == nil)
	{ _avgColor = HSBCLR(240.0, 0.6, 0.9); }
	return _avgColor;
}

- (NSColor *) maxColor
{
	if (_maxColor == nil)
	{ _maxColor = HSBCLR(240.0, 0.5, 1.0); }
	return _maxColor;
}

- (NSColor *) hldColor
{
	if (_hldColor == nil)
	{ _hldColor = HSBCLR(0.0, 0.0, 0.25); }
	return _hldColor;
}

- (NSColor *) clpColor
{
	if (_clpColor == nil)
	{ _clpColor = HSBCLR(0.0, 1.0, 1.0); }
	return _clpColor;
}

////////////////////////////////////////////////////////////////////////////////
#if !TARGET_OS_IOS
- (BOOL) isOpaque
{ return !(self.bckColor.alphaComponent < 1.0); }
#endif

- (void)drawRect:(NSRect)rect
{
	// Reverse direction if necessary
	if (self.direction != 0)
	{
		CGContextRef context = NSGraphicsGetCurrentContext();
		CGContextTranslateCTM(context, self.bounds.size.width, 0.0);
		CGContextScaleCTM(context, -1.0, 1.0);
	}
	[self drawHorizontal];
	return;
	[[self bckColor] set];
	NSRectFill(self.bounds);

	rmsresult_t levels = mLevels;

	if (levels.mHld > 0.0)
	{
		if (levels.mHld > 1.0)
			[[self clpColor] set];
		else
			[[self hldColor] set];
		NSRectFill([self boundsWithRatio:levels.mHld]);
		
		[[self maxColor] set];
		NSRectFill([self boundsWithRatio:levels.mMax]);
		
		[[self avgColor] set];
		NSRectFill([self boundsWithRatio:levels.mAvg]);
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) drawHorizontal
{
	// Source = mLevels
	rmsresult_t levels = mLevels;
	// Destination = frame
	NSRect frame = self.bounds;
	
	// scale values to width
	double W = frame.size.width;
	
	// Average
	[[self avgColor] set];
	frame.size.width = round(W * RMS2DISPLAY(levels.mAvg));
	NSRectFill(frame);

	[[self maxColor] set];
	frame.origin.x += frame.size.width;
	frame.size.width = round(W * RMS2DISPLAY(levels.mMax));
	frame.size.width -= frame.origin.x;
	NSRectFill(frame);

	[[self hldColor] set];
	frame.origin.x += frame.size.width;
	frame.size.width = round(W * RMS2DISPLAY(levels.mHld));
	frame.size.width -= frame.origin.x;
	NSRectFill(frame);

	[[self bckColor] set];
	frame.origin.x += frame.size.width;
	frame.size.width = W;
	frame.size.width -= frame.origin.x;
	NSRectFill(frame);
	
}

////////////////////////////////////////////////////////////////////////////////

- (NSRect) boundsWithRatio:(double)ratio
{
	NSRect bounds = self.bounds;

	// Adjust for display scale
	ratio = RMS2DISPLAY(ratio);
	
	if (_direction == 0)
	{ _direction = (bounds.size.width > bounds.size.height) ? 1 : 4; }
	
	if (_direction & 0x01)
	{
		bounds.size.width *= ratio;
		if (_direction & 0x02)
		bounds.origin.x += self.bounds.size.width - bounds.size.width;
	}
	else
	{
		bounds.size.height *= ratio;
		if (_direction & 0x02)
		bounds.origin.y += self.bounds.size.height - bounds.size.height;
	}
	
	return bounds;
}

////////////////////////////////////////////////////////////////////////////////
@end
////////////////////////////////////////////////////////////////////////////////






