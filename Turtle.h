//
//  Turtle.h
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

#import <Cocoa/Cocoa.h>

@interface Turtle : NSObject
{
    // Variable declarations
    NSPoint location;   // Holds the turtle's location in an (x,y) coordinate value
    float speed;        // The turtle's drawing speed (0.5, 1, or 1.5)
    int heading;      // Holds the turtle's heading in degree format (0 to 359). 0 is North, 90 East, 180 South, 270 West
}

// Method declarations (mostly accessor methods)
- (void) setLocation:(float)x y:(float)y;
- (NSPoint) getLocation;

- (void) setSpeed:(float)newSpeed;
- (float) getSpeed;

- (void) setHeading:(int)newHeading;
- (void) setHeadingByWord:(NSString *)newHeading;
- (int) getHeading;

@end
