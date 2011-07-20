//
//  Turtle.m
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

#import "Turtle.h"

@implementation Turtle


- (id)init
{
    // Purpse: Initialize the turtle to some base values. This method does not have to
    //         be declared in the header file like the others because it is inherited from its super class (parent)

    if (!(self = [super init])) return nil;   // Call the super init if exists

    location.x = 0.0;  // Turtle always starts at (0,0), also called HOME
    location.y = 0.0;

    heading = 0;       // Turtle starts at a heading of 0 (NORTH)
    
    speed = 1.0;       // This is the default GUI value, which has a range of 0.5 to 1.5 (1 is the middle value)

    return self;
}

- (void)setLocation:(float)x y:(float)y
{
    // Purpose: Set the location of the turtle (xy coordinate system). Because there is a limit
    //          to the size of the drawing area, we must take that into account. Location.X can
    //          be no larger than 410 and Location.Y can be no large than 340. See NIB file for values

    // Make sure the new x value to be assigned is within the window (0 to 410)
    // This code is VERY long/verbose for the job, but it's meant to be simple and instructive
    if (x > 410)
	 {
	 x = 410.0;
	 }
    if (x < 0)
	 {
 	 x = 0.0;
	 }

    // Make sure the new y value to be assigned is within the window (0 to 340)
    // This code is VERY long/verbose for the job, but it's meant to be simple and instructive
    if (y > 340)
	 {
	 y = 340.0;
	 }
    if (y < 0)
	 {
	 y = 0.0;
	 }

    // Now set the turtle's location values to the new ones
    location.x = x;
    location.y = y;
    
    printf("Location set to %f,%f\n", location.x, location.y);
}

- (NSPoint)getLocation
{
    // Purpse: Return the location data which is an (x,y) value
    
    return location;
}

- (void)setSpeed:(float)newSpeed
{
    // Purpose: Set the turtle's speed to a new value. Make sure it is either 0.5, 1.0, or 1.5
    //          If not, set it to the default value of 1.0
    if (newSpeed < 0.5 | (newSpeed > 0.5 & newSpeed < 1.0) | newSpeed > 1.5)
	 {
	newSpeed = 1.0;
	 }
    
    speed = newSpeed;
}

- (float)getSpeed
{
    // Purpse: Return the turtle's speed to the object calling this method

    return speed;
}

- (void) setHeading:(int)newHeading
{
    // Purpse: Set the turtle's heading. If the value passed is not between the values of 0 and 359
    //         we set it to a value most similar to the one passed.

    // If the heading is too large or small, just set it back to 0
    if (newHeading > 359 | newHeading < -361)
	 {
	newHeading = 0;
	 }

    // If a negative heading is passed, convert it to a positive one, but not using abs()
    // Example: A heading of -180 degrees should be 180 (and on the reverse)
    // Example: A heading of -270 degrees should be 90 (and on the reverse)
    // Example: A heading of -315 degrees should be 45 (and on the reverse)
    // So, just add 360 do the value (as long as it is negative), and you'll get the conversion
    if (newHeading < 0 & newHeading > -360)
	 {
	newHeading = 360 + newHeading;
	 }
    
    // Now reset the turtle's heading to the new one
    heading = newHeading;
}

- (void) setHeadingByWord:(NSString *)newHeading
{
    // Purpse: Set the turtle's heading, but using words. Those words are listed below:
    //         NORTH, N, SOUTH, S, EAST, E, WEST, W, NORTHEAST, NE, SOUTHEAST, SE, NORTHWEST, NW, SOUTHWEST, SW
    
    if ([newHeading isEqualToString:@"NORTH"] | [newHeading  isEqualToString:@"N"])
	 {
	heading = 0;
	 }

    if ([newHeading isEqualToString:@"SOUTH"] | [newHeading isEqualToString:@"S"])
	 {
	heading = 180;
	 }

    if ([newHeading isEqualToString:@"EAST"] | [newHeading isEqualToString:@"E"])
	 {
	heading = 90;
	 }

    if ([newHeading isEqualToString:@"WEST"] | [newHeading isEqualToString:@"W"])
	 {
	heading = 270;
	 }

    if ([newHeading isEqualToString:@"NORTHWEST"] | [newHeading isEqualToString:@"NW"])
	 {
	heading = 315;
	 }
    
    if ([newHeading isEqualToString:@"NORTHEAST"] | [newHeading isEqualToString:@"NE"])
	 {
	heading = 45;
	 }
    
    if ([newHeading isEqualToString:@"SOUTHWEST"] | [newHeading isEqualToString:@"SW"])
	 {
	heading = 225;
	 }
    
    if ([newHeading isEqualToString:@"SOUTHEAST"] | [newHeading isEqualToString:@"SE"])
	 {
	heading = 135;
	 }
}

- (int) getHeading
{
    // Purpose: Return the turtle's heading value to the object calling this method

    return heading;
}

@end
