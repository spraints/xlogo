//
//  DrawCommand.m
//  Software: XLogo
//
//  Created by Jens Bauer on Thu Jun 26 2003.
//
//  Copyright (c) 2003 Jens Bauer
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

#import "DrawCommand.h"


@implementation DrawCommand

+ (id)drawCommandWithColor:(NSColor *)aColor fromPoint:(NSPoint)aFromPoint toPoint:(NSPoint)aToPoint
{
    return([[DrawCommand alloc] initWithColor:aColor fromPoint:aFromPoint toPoint:aToPoint]);
}

- (id)initWithColor:(NSColor *)aColor fromPoint:(NSPoint)aFromPoint toPoint:(NSPoint)aToPoint
{
    self = [super init];
    if(self)
	{
	color = [aColor retain];
	fromPoint = aFromPoint;
	toPoint = aToPoint;
	}
    return(self);
}

- (id)init
{
    self = [super init];
    if(self)
	{
	color = [[NSColor blackColor] retain];
	fromPoint.x = 0;
	fromPoint.y = 0;
	toPoint.x = 0;
	toPoint.y = 0;
	}
    return(self);
}

- (void)dealloc
{
    [color release];
    [super dealloc];
}

- (NSColor *)color
{
    return(color);
}

- (NSPoint)fromPoint
{
    return(fromPoint);
}

- (NSPoint)toPoint
{
    return(toPoint);
}

@end
