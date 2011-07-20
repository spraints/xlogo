//
//  Expression.m
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

#import "Expression.h"


@implementation Expression

- (id)init
{
	self = [super init];
	if(self)
	{
		type = 0;
	}
	return(self);
}

- (void)reset
{
	if(kExpressionKindPointer & type)
	{
//		free(value.ptr);	// nope, we're not going to copy strings, it's much faster and better just to point directly to them!
		type = 0;
	}
}

- (void)setFloatValue:(float)aFloat
{
	[self reset];
	type = kExpressionKindFloatValue;
	value.number = aFloat;
}

- (float)floatValue
{
	if(kExpressionKindNumber & type)
	{
		return(value.number);
	}
	return(0.0);
}

- (void)setStringValue:(const unichar *)aString ofLength:(unsigned long)aLength
{
	[self reset];
	type = kExpressionKindStringValue;
	value.ptr = (void *) aString;
	length = aLength;
}

- (unichar *)stringValue
{
	if(kExpressionKindStringValue == type)
	{
		return(value.ptr);
	}
	return(NULL);
}

- (void)setListValue:(const unichar *)aList ofLength:(unsigned long)aLength
{
	[self reset];
	type = kExpressionKindListValue;
	value.ptr = (void *) aList;
	length = aLength;
}

- (unichar *)listValue
{
	if(kExpressionKindListValue == type)
	{
		return(value.ptr);
	}
	return(NULL);
}

- (unsigned long)length
{
	if(kExpressionKindPointer & type)
	{
		return(length);
	}
	return(0);
}

- (long)type
{
	return(type);
}

- (void)dealloc
{
	[self reset];
	[super dealloc];
}

@end
