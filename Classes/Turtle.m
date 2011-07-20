//
//  Turtle.h
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
#include "Utilities.h"

#import "Turtle.h"
#import "DrawCommand.h"
#import "TurtleView.h"

const float	defaultTurtleShape[] = {
	0, 9.8,						// starting distance from drawing point
	90, 0.49,
	45, 2,
	45, 3,
	-45, 4,
	-105, 2,
	0, -2,
	150, 5,
	-25, 2,
	0, -2,
	70, 3,
	45, 5,
	45, 3,
	-105, 2,
	0, -2,
	150, 5,
	-25, 2,
	0, -2,
	70, 4,
	-45, 3,
	45, 2,
//	45, 0.52,	// This is not necessary, as the code closes the polygon
	360.0
};

const float	triangleTurtleShape[] = {
	
};

@implementation Turtle

- (id)init
{
	return([self initWithName:@"Bob" andColor:[NSColor greenColor]]);
//	[parser addTurtle:[[Turtle alloc] initWithName:@"Frank" andColor:[NSColor brownColor]]];
}

- (id)initWithName:(NSString *)aName andColor:(NSColor *)aColor
{
	self = [super init];
	if(self)
	{
		path = NULL;
		[self setTurtleName:aName];
		[self setTurtleColor:aColor];
		[self setTurtleSize:1.0];
		[self setTurtleShape:defaultTurtleShape];
		[self home];
		[self north];
		[self show];
		[self penDown];
	}
	return(self);
}

- (void)dealloc
{
	[self setTurtleName:NULL];
	[self setTurtleColor:NULL];
	[super dealloc];
}

- (void)setTurtleName:(NSString *)aName
{
	if(turtleName)
	{
		[turtleName release];
	}
	turtleName = [aName retain];
}

- (NSString *)turtleName
{
	return(turtleName);
}

- (void)setTurtleColor:(NSColor *)aColor
{
	if(turtleColor)
	{
		[turtleColor release];
	}
	turtleColor = [aColor retain];
}

- (NSColor *)turtleColor
{
	return(turtleColor);
}

- (void)setTurtleSize:(float)aTurtleSize
{
	turtleSize = aTurtleSize;
}

- (float)turtleSize
{
	return(turtleSize);
}

- (void)setTurtleShape:(const float *)aShape
{
	turtleShape = aShape;
}

- (void)setOutputView:(id)aOutputView
{
	[outputView release];
	outputView = [aOutputView retain];
}

- outputView
{
	return(outputView);
}

- (void)setErrorView:(id)aErrorView
{
	[errorView release];
	errorView = [aErrorView retain];
}

- errorView
{
	return(errorView);
}

- (NSPoint)location
{
	return(location);
}

- (BOOL)setLocation:(NSPoint)aLocation
{
	NSPoint	oldLocation;

	oldLocation = location;
	location = aLocation;
	return(oldLocation.x != location.x && oldLocation.y != oldLocation.y);
}

- (float)direction
{
	return(direction);
}

- (BOOL)setDirection:(float)aDirection
{
	float	oldDirection;

	oldDirection = direction;
	direction = my_fmod(aDirection, 360.0);
	return(oldDirection != direction);
}

- (BOOL)visible
{
	return(visible);
}

- (BOOL)setVisible:(BOOL)aVisible
{
	BOOL	oldVisible;

	oldVisible = visible;
	visible = aVisible;
	return(oldVisible != visible);
}

- (BOOL)setPenColor:(float)aPenColor
{
	penColor = aPenColor;
	return(NO);
}

- (float)penColor
{
	return(penColor);
}

- (void)initPath
{
	if(!path)
	{
		path = [[[NSBezierPath alloc] init] retain];
		[path setLineWidth:1.0];
		[path setLineCapStyle:NSRoundLineCapStyle];
		[path setLineJoinStyle:NSRoundLineJoinStyle];
		[path setMiterLimit:4.0];
	}
}

- (void)drawTriangleAt:(NSPoint)aPoint heading:(float)aDirection withColor:(NSColor *)aColor
{
	NSPoint		pt[3];
	float		steps;

	if(!path)
	{
		[self initPath];
	}
	steps = 10.0 * turtleSize;

	pt[0] = aPoint;
	pt[1] = aPoint;
	pt[2] = aPoint;

	pt[0].x += sin(aDirection * 2.0 * PI / 360.0) * steps;
	pt[0].y += cos(aDirection * 2.0 * PI / 360.0) * steps;

	aDirection += 120.0;
	if(aDirection >= 360.0)
	{
		aDirection -= 360.0;
	}

	pt[1].x += sin(aDirection * 2.0 * PI / 360.0) * steps;
	pt[1].y += cos(aDirection * 2.0 * PI / 360.0) * steps;

	aDirection += 120.0;
	if(aDirection >= 360.0)
	{
		aDirection -= 360.0;
	}

	pt[2].x += sin(aDirection * 2.0 * PI / 360.0) * steps;
	pt[2].y += cos(aDirection * 2.0 * PI / 360.0) * steps;


	[aColor set];
	[path moveToPoint:pt[0]];
	[path lineToPoint:pt[1]];
	[path stroke];
	[path removeAllPoints];

	[path moveToPoint:pt[1]];
	[path lineToPoint:pt[2]];
	[path stroke];
	[path removeAllPoints];

	[path moveToPoint:pt[2]];
	[path lineToPoint:pt[0]];
	[path stroke];
	[path removeAllPoints];
}

- (void)drawSquareAt:(NSPoint)aPoint heading:(float)aDirection withColor:(NSColor *)aColor length:(float)sideLength
{
}

- (void)drawTurtleAt:(NSPoint)aPoint heading:(float)aDirection withColor:(NSColor *)aColor
{
	NSPoint		pt0;	// first point
	NSPoint		pt1;	// from
	NSPoint		pt2;	// to
	float		d;
	float		steps;
	float		dir;
	const float	*s;
	BOOL		more;

	s = turtleShape;
	if(s)
	{
		if(!path)
		{
			[self initPath];
		}

		[aColor set];

		d = *s++;
		steps = *s++ * turtleSize;
		dir = my_fmod(aDirection + d, 360.0);
		pt0.x = aPoint.x + sin(dir * 2.0 * PI / 360.0) * steps;
		pt0.y = aPoint.y + cos(dir * 2.0 * PI / 360.0) * steps;

		pt1 = pt0;
		more = YES;
		while(more)
		{
			d = *s++;
			if(d < 360.0)
			{
				steps = *s++ * turtleSize;
				dir = my_fmod(dir + d, 360.0);
				pt2.x = pt1.x + sin(dir * 2.0 * PI / 360.0) * steps;
				pt2.y = pt1.y + cos(dir * 2.0 * PI / 360.0) * steps;
			}
			else
			{
				pt2 = pt0;
				more = NO;
			}
			[path moveToPoint:pt1];
			[path lineToPoint:pt2];
			[path stroke];
			[path removeAllPoints];
			pt1 = pt2;
		}
	}
}

- (void)drawAtOffset:(NSPoint)aPoint
{
	if([self visible])
	{
		aPoint.x += [self location].x;
		aPoint.y += [self location].y;
		[self drawTurtleAt:aPoint heading:[self direction] withColor:[self turtleColor]];
	}
}

- (BOOL)moveTo:(NSPoint)aPoint
{
	DrawCommand	*drawCommand;
	NSPoint	fromPt;
	NSPoint	toPt;
	NSColor	*theColor;
	int		rgb[] = { 0x000000, 0x0000ff, 0xff0000, 0xff00ff, 0x00ff00, 0x00ffff, 0xffff00, 0xffffff };
	int		col;
	float	r;
	float	g;
	float	b;

	col = rgb[7 & ((int) [self penColor])];
	r = (1.0 / 256.0) * ((float) (0xff & (col >> 16)));
	g = (1.0 / 256.0) * ((float) (0xff & (col >> 8)));
	b = (1.0 / 256.0) * ((float) (0xff & col));

	theColor = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];

	if(draw)
	{
		fromPt = location;
		toPt = aPoint;
		drawCommand = [[DrawCommand alloc] initWithColor:theColor fromPoint:fromPt toPoint:toPt];
		[outputView addCommand:drawCommand];
	}
	if([self setLocation:aPoint])	// if location changed
	{
		if(draw || visible)			// if we're drawing or the turtle is visible
		{
			return(YES);			// then we need to update the display!
		}
	}
	return(NO);						// nothing changed, don't update display
}

- (BOOL)move:(float)aSteps stepsInDirection:(float)aDirection
{
	NSPoint	pt;

	pt = location;
	pt.x += sin(aDirection * 2 * PI / 360.0) * aSteps;
	pt.y += cos(aDirection * 2 * PI / 360.0) * aSteps;
	return([self moveTo:pt]);
}

- (BOOL)clearGraphics
{
	return([outputView clear]);
}

- (BOOL)home
{
	NSPoint	pt;

	pt.x = 0.0;
	pt.y = 0.0;
	return([self moveTo:pt]);
}

- (BOOL)north
{
	return([self setDirection:0.0] && visible);
}

- (BOOL)northWest
{
	return([self setDirection:45.0] && visible);
}

- (BOOL)west
{
	return([self setDirection:90.0] && visible);
}

- (BOOL)southWest
{
	return([self setDirection:135.0] && visible);
}

- (BOOL)south
{
	return([self setDirection:180.0] && visible);
}

- (BOOL)southEast
{
	return([self setDirection:225.0] && visible);
}

- (BOOL)east
{
	return([self setDirection:270.0] && visible);
}

- (BOOL)northEast
{
	return([self setDirection:315.0] && visible);
}

- (BOOL)back:(float)aSteps
{
	return([self move:aSteps stepsInDirection:direction + 180.0]);
}

- (BOOL)forward:(float)aSteps
{
	return([self move:aSteps stepsInDirection:direction]);
}

- (BOOL)turnLeft:(float)aDegrees
{
	return([self setDirection:direction - aDegrees] && visible);
}

- (BOOL)turnRight:(float)aDegrees
{
	return([self setDirection:direction + aDegrees] && visible);
}

- (BOOL)penUp
{
	draw = NO;
	return(NO);
}

- (BOOL)penDown
{
	draw = YES;
//	[self moveTo:location];		// make a pixel, pen is down! (not a good idea, as the turtle starts with the pen down!)
//	return(YES);
	draw = YES;
	return(NO);
}

- (BOOL)hide
{
	return([self setVisible:NO]);
}

- (BOOL)show
{
	return([self setVisible:YES]);
}

- (BOOL)repeat:(float)aCount
{
	return(NO);
}

@end
