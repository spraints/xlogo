//
//  TurtleView.m
//  Software: XLogo
//
//  Created by Jens Bauer & Jeff Skrysak on Thu Jun 26 2003.
//
//  Copyright (c) 2003 Jens Bauer & Jeff Skrysak
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//   THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
//   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//   ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
//   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
//   OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
//   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
//   SUCH DAMAGE.
//

#import "TurtleView.h"
#import "DrawCommand.h"
#import "Turtle.h"
#import "LogoParser.h"

@implementation TurtleView

- (id)init	// never invoked (!)
{
	self = [super init];
	if(self)
	{
		path = NULL;
		drawCommands = NULL;
		paperColor = 0;
	}
	return(self);
}

- (void)dealloc
{
	[path release];
	[drawCommands release];
	[super dealloc];
}

- (void)setup
{
	initializeFlag = YES;
	[self setPaperColor:7];
}


// Added by Jeff Skrysak
- (BOOL)isOpaque
{
    // According to Apple (the DotView example), this is good for NSViews that
    // fill themselves totally, and re-draw themselves totally. It is supposed to
    // help performance. Check the NSView documentation to verify.
    return YES;
}


- (void)drawRect:(NSRect)rect
{
	DrawCommand	*drawCommand;
	unsigned	i;
	unsigned	count;
	NSPoint		pt;
	NSArray		*turtles;
	float		hOffset;
	float		vOffset;
	NSColor		*theColor;
	NSColor         *borderColor;  // Added by Jeff Skrysak
	int			rgb[] = { 0x000000, 0x0000ff, 0xff0000, 0xff00ff, 0x00ff00, 0x00ffff, 0xffff00, 0xffffff };
	int			col;
	float		r;
	float		g;
	float		b;

	if(!initializeFlag)
	{
		[self setup];
	}

	col = rgb[7 & ((int) [self paperColor])];
	r = (1.0 / 256.0) * ((float) (0xff & (col >> 16)));
	g = (1.0 / 256.0) * ((float) (0xff & (col >> 8)));
	b = (1.0 / 256.0) * ((float) (0xff & col));
	theColor = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];

	if(!path)
	{
		path = [[[NSBezierPath alloc] init] retain];
		[path setLineWidth:1.0];
		[path setLineCapStyle:NSRoundLineCapStyle];
		[path setLineJoinStyle:NSRoundLineJoinStyle];
		[path setMiterLimit:4.0];
	}

//	[[NSColor whiteColor] set];
	[theColor set];
	NSRectFill(rect);
	
	// Draw a border (default: black, 1 pixel wide) around the view [Added by Jeff Skrysak]
	borderColor = [NSColor blackColor];
	[borderColor set];
	NSFrameRect(rect);             

	hOffset = [self frame].size.width / 2;
	vOffset = [self frame].size.height / 2;

	pt.x = hOffset;
	pt.y = vOffset;
	count = [drawCommands count];
	for(i = 0; i < count; i++)
	{
		drawCommand = [drawCommands objectAtIndex:i];
		[[drawCommand color] set];
		pt = [drawCommand fromPoint];
		pt.x += hOffset;
		pt.y += vOffset;
		[path moveToPoint:pt];
		pt = [drawCommand toPoint];
		pt.x += hOffset;
		pt.y += vOffset;
		[path lineToPoint:pt];
		[path stroke];
		[path removeAllPoints];
	}

	pt.x = hOffset;
	pt.y = vOffset;
	turtles = [parser turtles];
	count = [turtles count];
	for(i = 0; i < count; i++)
	{
		[[turtles objectAtIndex:i] drawAtOffset:pt];
	}
}

- (void)addCommand:(DrawCommand *)drawCommand
{
	if(!initializeFlag)
	{
		[self setup];
	}
	if(!drawCommands)
	{
		drawCommands = [[NSMutableArray array] retain];
	}
	[drawCommands addObject:drawCommand];
}

- (BOOL)clear
{
	if(!initializeFlag)
	{
		[self setup];
	}
	if(drawCommands)
	{
		[drawCommands release];
		drawCommands = NULL;
		return(YES);
	}
	return(NO);
}

- (BOOL)setPaperColor:(float)aPaperColor
{
	if(paperColor != aPaperColor)
	{
		paperColor = aPaperColor;
		return(YES);
	}
	return(NO);
}

- (float)paperColor
{
	return(paperColor);
}

@end
