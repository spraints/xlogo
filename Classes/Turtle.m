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
	360.0
};


@implementation Turtle


//***********************************************/
// init - Create the new turtle
//
- (id)init
{
	return([self initWithName:@"Bob" andColor:[NSColor greenColor]]);
}


//***********************************************/
// initWithName - Create a new, named, turtle
//
- (id)initWithName:(NSString *)aName andColor:(NSColor *)aColor
{
    // Create the object data
    self = [super init];

    // If the creation was successful, then continue with the rest...
    if(self)
	{
	    path = NULL;
	    [self setTurtleName:aName];
	    [self setTurtleColor:aColor];
	    [self setTurtleSize:1.0];
	    [self setTurtleShape:defaultTurtleShape];
	    [self home];           //
	    [self north];          // Put him at (0,0), face him north, show him, and put the pen down
	    [self show];           //
	    [self penDown];        //
	}

    // Send the new turtle back to the caller (probably to place it into an array)
    return(self);
}


//***********************************************/
// dealloc - Destroy the turtle object
//
- (void)dealloc
{
	[self setTurtleName:NULL];
	[self setTurtleColor:NULL];
	[super dealloc];
}


//***********************************************/
// setTurtleName - Give the turtle a name
//
- (void)setTurtleName:(NSString *)aName
{
    if(turtleName)
	{
	[turtleName release];
	}
    turtleName = [aName retain];
}


// Accessor method
- (NSString *)turtleName
{
    return(turtleName);
}


//***********************************************/
// setTurtleColor - Give the turtle a color
//
- (void)setTurtleColor:(NSColor *)aColor
{
	if(turtleColor)
		{
		[turtleColor release];
		}
    turtleColor = [aColor retain];
}


// Accessor method
- (NSColor *)turtleColor
{
	return(turtleColor);
}


//***********************************************/
// setTurtleSize - Give the turtle a size (1.0 is normal)
//
- (void)setTurtleSize:(float)aTurtleSize
{
	turtleSize = aTurtleSize;
}


// Accessor method
- (float)turtleSize
{
	return(turtleSize);
}


//***********************************************/
// setTurtleShape - Give the turtle a shape
//
- (void)setTurtleShape:(const float *)aShape
{
	turtleShape = aShape;
}


//***********************************************/
// setOutputView - Tell the turtle where to draw
//
- (void)setOutputView:(id)aOutputView
{
	[outputView release];
	outputView = [aOutputView retain];
}


// Accessor method
- outputView
{
	return(outputView);
}


//*****************************************************/
// setErrorView - Tell the turtle where to list errors
//
- (void)setErrorView:(id)aErrorView
{
	[errorView release];
	errorView = [aErrorView retain];
}


// Accessor method
- errorView
{
	return(errorView);
}


// Accessor method
- (NSPoint)location
{
	return(location);
}


//*****************************************************/
// setLocation - Puts the turtle somewhere (x,y)
//
- (BOOL)setLocation:(NSPoint)aLocation
{
	NSPoint	oldLocation;   // NSPoint is a struct of two values, x and y.

	oldLocation = location;
	location = aLocation;

	// If the new location is equal to the old, return FALSE
	return(oldLocation.x != location.x && oldLocation.y != oldLocation.y);
}


// Accessor method
- (float)direction
{
	return(direction);
}


//*********************************************************/
// setDirection - Tell the turtle which direction to face
//
- (BOOL)setDirection:(float)aDirection
{
	float	oldDirection;

	oldDirection = direction;

	// Catch some nasty value
	direction = my_fmod(aDirection, 360.0);

	// If the new direction is equal to the old, return FALSE (NO)
	return(oldDirection != direction);
}


// Accessor method
- (BOOL)visible
{
	return(visible);
}


//*********************************************************/
// setVisible - Make the turtle visible on the screen
//
- (BOOL)setVisible:(BOOL)aVisible
{
    BOOL oldVisible;

    oldVisible = visible;
    visible = aVisible;

    // If the new value is equal to the old, return FALSE (NO)
    return(oldVisible != visible);
}


//*********************************************************/
// setPenColor - Set the drawing color
//
- (BOOL)setPenColor:(float)aPenColor
{
    penColor = aPenColor;

    // For now, just return FALSE (v0.3)
    return(NO);
}


// Accessor method
- (float)penColor
{
	return(penColor);
}


//*********************************************************/
// initPath - Intialize the turtle's path
//
- (void)initPath
{
    // Only initialize if the path hasn't been initialized already
    if(!path)
	{
	path = [[[NSBezierPath alloc] init] retain];
	[path setLineWidth:1.0];
	[path setLineCapStyle:NSRoundLineCapStyle];
	[path setLineJoinStyle:NSRoundLineJoinStyle];
	[path setMiterLimit:4.0];
	}
}


//******************************************************************/
// drawTriangleAt - Draw a triangle at the point and heading given
//
- (void)drawTriangleAt:(NSPoint)aPoint heading:(float)aDirection withColor:(NSColor *)aColor
{
    NSPoint		pt[3];
    float		steps;

    // If the path hasn't be initialized, do so now (rare case)
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

    // Set the drawing color
    [aColor set];
    
    // Now we can start the drawing....
    [path moveToPoint:pt[0]];
    [path lineToPoint:pt[1]];
    [path stroke];
    [path removeAllPoints];

    // Side two of the triangle
    [path moveToPoint:pt[1]];
    [path lineToPoint:pt[2]];
    [path stroke];
    [path removeAllPoints];

    // Side three of the triangle
    [path moveToPoint:pt[2]];
    [path lineToPoint:pt[0]];
    [path stroke];
    [path removeAllPoints];
}


//******************************************************************/
// drawSquareAtt - Draw a square at the point and heading given
//
- (void)drawSquareAt:(NSPoint)aPoint heading:(float)aDirection withColor:(NSColor *)aColor length:(float)sideLength
{
}


//***********************************************/
// drawTurtleAt - Draws the shape of the turtle 
//
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

    // If the shape is defined, continue...
    if(s)
	{
	// If there is no path defined, make one.
	if(!path)
	    {
	    [self initPath];
	    }

	// Set the turtle's color to the current color, for drawing
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

	    // Draw the side
	    [path moveToPoint:pt1];
	    [path lineToPoint:pt2];
	    [path stroke];
	    [path removeAllPoints];

	    // Change the starting point to the end of the last side
	    pt1 = pt2;
	    }
	}
}


//***********************************************/
// drawAtOffset - Offset draw the turtle
//
- (void)drawAtOffset:(NSPoint)aPoint
{
    if([self visible])
	{
	aPoint.x += [self location].x;
	aPoint.y += [self location].y;
	[self drawTurtleAt:aPoint heading:[self direction] withColor:[self turtleColor]];
	}
}


//*********************************************************************/
// moveTo - Move the turtle to a new place, drawing the move if needed
//
- (BOOL)moveTo:(NSPoint)aPoint
{
    DrawCommand	*drawCommand;
    NSPoint	fromPt;
    NSPoint	toPt;
    NSColor	*theColor;

    // Colors:             black      blue      red      purple    green   lightblue   yellow     white
    int		rgb[] = { 0x000000, 0x0000ff, 0xff0000, 0xff00ff, 0x00ff00, 0x00ffff, 0xffff00, 0xffffff };
    int		col;

    // To store each part of the color RGB spectrum
    float	r;
    float	g;
    float	b;

    // Get the current color and dissect it
    col = rgb[7 & ((int) [self penColor])];
    r = (1.0 / 256.0) * ((float) (0xff & (col >> 16)));
    g = (1.0 / 256.0) * ((float) (0xff & (col >> 8)));
    b = (1.0 / 256.0) * ((float) (0xff & col));

    // Now turn the color into a Cocoa NSColor
    theColor = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];

    // If we are to draw, do so..
    if(draw)
	{
	fromPt = location;
	toPt = aPoint;
	drawCommand = [[DrawCommand alloc] initWithColor:theColor fromPoint:fromPt toPoint:toPt];
	[outputView addCommand:drawCommand];
	}

	
    if([self setLocation:aPoint])	// if location changed
	{
	    if(draw || visible)		// if we're drawing or the turtle is visible
		{
		return(YES);		// then we need to update the display!
		}
	}
    return(NO);				// nothing changed, don't update display
}


//*********************************************************************/
// move - Move the turtle using steps
//
- (BOOL)move:(float)aSteps stepsInDirection:(float)aDirection
{
    NSPoint	pt;

    pt = location;
    pt.x += sin(aDirection * 2 * PI / 360.0) * aSteps;
    pt.y += cos(aDirection * 2 * PI / 360.0) * aSteps;
    return([self moveTo:pt]);
}


//*********************************************************************/
// clearGraphics - Clear the screen
//
- (BOOL)clearGraphics
{
    return([outputView clear]);
}


//*********************************************************************/
// home - Send the turtle home
//
- (BOOL)home
{
    NSPoint	pt;
    
    pt.x = 0.0;
    pt.y = 0.0;
    return([self moveTo:pt]);
}


//*********************************************************************/
// north - Face the turtle North
//
- (BOOL)north
{
    return([self setDirection:0.0] && visible);
}


//*********************************************************************/
// northWest - Face the turtle NorthWest
//
- (BOOL)northWest
{
    return([self setDirection:45.0] && visible);
}


//*********************************************************************/
// west - Face the turtle West
//
- (BOOL)west
{
    return([self setDirection:90.0] && visible);
}


//*********************************************************************/
// southWest - Face the turtle SouthWest
//
- (BOOL)southWest
{
    return([self setDirection:135.0] && visible);
}


//*********************************************************************/
// south - Face the turtle South
//
- (BOOL)south
{
    return([self setDirection:180.0] && visible);
}


//*********************************************************************/
// southEast - Face the turtle SouthEast
//
- (BOOL)southEast
{
    return([self setDirection:225.0] && visible);
}


//*********************************************************************/
// east - Face the turtle East
//
- (BOOL)east
{
    return([self setDirection:270.0] && visible);
}


//*********************************************************************/
// northEast - Face the turtle NorthEast
//
- (BOOL)northEast
{
    return([self setDirection:315.0] && visible);
}


//*********************************************************************/
// back - Send the turtle walking backwards 
//
- (BOOL)back:(float)aSteps
{
    return([self move:aSteps stepsInDirection:direction + 180.0]);
}


//*********************************************************************/
// forward - Send the turtle walking forwards
//
- (BOOL)forward:(float)aSteps
{
    return([self move:aSteps stepsInDirection:direction]);
}


//*********************************************************************/
// turnLeft - Turn the turtle toward the left
//
- (BOOL)turnLeft:(float)aDegrees
{
    return([self setDirection:direction - aDegrees] && visible);
}


//*********************************************************************/
// turnRight - Turn the turtle toward the right
//
- (BOOL)turnRight:(float)aDegrees
{
    return([self setDirection:direction + aDegrees] && visible);
}


//*********************************************************************/
// penUp - Stop drawing by setting the pen to up (off the page)
//
- (BOOL)penUp
{
    draw = NO;
    return(draw);
}


//*********************************************************************/
// penDown - Start drawing by setting the pen to down (on the page)
//
- (BOOL)penDown
{
    draw = YES;
    return(draw);
}


// Accessor method
- (BOOL)hide
{
    return([self setVisible:NO]);
}


// Accessor method
- (BOOL)show
{
    return([self setVisible:YES]);
}


// Accessor method
- (BOOL)repeat:(float)aCount
{
    return(NO);
}

@end
