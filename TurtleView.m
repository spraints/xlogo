//
//  TurtleView.m
//  Software: XLogo
//
//  Created by Jeffrey M Skrysak on Thu Jun 12 2003.
//
//  Copyright (c) 2003 Jeffrey M Skrysak
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

@implementation TurtleView

- (id)initWithFrame:(NSRect)frameRect
{
    // Purpose: Every NSView subclass needs this method (initWithFrame)
    //          It does just that, initializes the NSView, just as an init method
    //          does for regular objects.
    
    if (self = [super initWithFrame:frameRect])
	 {
	backgroundColor = [NSColor whiteColor];  // Set the bg color to White.
	foregroundColor = [NSColor blackColor];  // Set the foreground color to Black
	lineWidth = 5.0;
	 }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    // Purpose: Every NSView subclass needs this method (drawRect)
    //          Its name may convey a different functionality. Maybe it should be
    //          called "thisIsWhereEverythingIsDrawn" because that's what it's far. It will
    //          be called to draw any or all of the view area, and it's parts (images,
    //          shapes, backgrounds, etc...). It will also be called during printing.

    [backgroundColor set]; 	   // Set the background color (White, see initWithFrame method)
    [NSBezierPath fillRect:rect];  // Fill in the background (White)
    [foregroundColor set];         // Set the foreground color (Black, see initWithFrame method)
    NSFrameRect(rect);             // Draw a border (default: black, 1 wide) around the view


    // This is where we are going to draw the coordinates
    // When the user says "Go"
    // PseudoCode:
    // If (turtle.Draw==TRUE) {            -- Boolean toggled by TurtleController activateTurtle() action
    //    delayByTurtleSpeed();            -- Timed delay to simulate speed
    //    getNextCommandFromController();  -- Could be entire BezierPath, or just addition
    //    If (nextCommand == HALT) {
    //       stopDrawing();                -- Boolean back to FALSE
    //       setTurtleLocation();          -- Direct access to Turtle?
    //       }
    //    If (nextCommand == CLEAR) {
    //       fill the background white;    -- call Clear() method in TurtleView
    //       }
    //    draw();
    // }
}


// According to Apple (the DotView example), this is good for NSViews that
// fill themselves totally, and re-draw themselves totally. It is supposed to
// help performance. Check the NSView documentation to verify.
- (BOOL)isOpaque
{
    return YES;
}


// The following methods are your basic accessor methods
// They do nothing more than modify variables or return their values
- (void) setFrame: (NSRect) frameRect { [super setFrame:frameRect]; }
- (void) setBoundsSize: (NSSize) newSize { [super setBoundsSize:newSize]; }

- (NSColor *) foregroundColor { return foregroundColor; }
- (void) setForegroundColor: (NSColor *) aColor { foregroundColor = aColor; [self setNeedsDisplay:YES]; }

- (NSColor *) backgroundColor { return backgroundColor; }
- (void) setBackgroundColor: (NSColor *) aColor { backgroundColor = aColor; [self setNeedsDisplay:YES]; }


- (void) dealloc
{
    // Purpse: Clean up. This is called when the object is being freed. This method
    //         should free any memory allocated by the subclass (in this case, TurtleView)
    //         and then call super to get the superclass to do any additional cleanup.
    
    [foregroundColor release];   // Release the memory used to store the foreground color
    [backgroundColor release];   // Release the memory used to store the background color
    [super dealloc];
}

@end
