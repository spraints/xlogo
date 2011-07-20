//
//  LogoParser.m
//  Software: XLogo
//
//  Created by Jens Bauer on Wed Jun 25 2003.
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

#import "LogoParser.h"
#import "NSStringParserExtensions.h"
#import "NSTextViewOutputExtensions.h"
#import "Turtle.h"
#import "TurtleView.h"
#import "Expression.h"
#import "StackObject.h"
#import "LogoParserExpression.h"
#import "Variable.h"

#include "Commands.h"

@implementation LogoParser

- (void)reset
{
	Turtle	*turtle;

	listing = NULL;
	[variables release];
	variables = [[NSMutableArray array] retain];
	[turtles release];
	turtles = [[NSMutableArray array] retain];
	[listeningTurtles release];
	listeningTurtles = [[NSMutableArray array] retain];
	[stack release];
	stack = [[NSMutableArray array] retain];
	stackIndex = 0;

	// Clear the drawing area (TurtleView, subclass of NSView)
	[outputView clear];

	// Create the turtle
	turtle = [[Turtle alloc] init];

	// Tell the turtle where he needs to draw and spit out command errors
	[turtle setOutputView:[self outputView]];
	[turtle setErrorView:[self errorView]];

	// Clear the Error TextView
	[errorView clearAllText];
	
	[self addTurtle:turtle];
	[self activateTurtle:turtle];
}

- (id)initWithOutputView:(id)aOutputView errorView:(id)aErrorView
{
	self = [super init];
	if(self)
	{
		turtles = NULL;
		listeningTurtles = NULL;
		stack = NULL;
		[self setOutputView:aOutputView];
		[self setErrorView:aErrorView];
		[self reset];
	}
	return(self);
}

- (void)dealloc
{
	[stack release];
	stack = NULL;
	[turtles release];
	turtles = NULL;
	[listeningTurtles release];
	turtles = NULL;
	[variables release];
	variables = NULL;
	[self setOutputView:NULL];
	[self setErrorView:NULL];
	[self setListing:NULL];
	[super dealloc];
}

- (void)addTurtle:(Turtle *)aTurtle
{
	[turtles addObject:aTurtle];
}

- (void)removeTurtle:(Turtle *)aTurtle
{
	[turtles removeObject:aTurtle];
}

- (void)activateTurtle:(Turtle *)aTurtle
{
	[listeningTurtles addObject:aTurtle];
// speech-bubbles:
// "Bob here!"
// "Yes?"
// "I'll be there in a minute..."
// "I still feel sleepy!"
// "Couldn't you pick someone else?"
// "I'm Frank, and I'm eager to go!"
}

- (void)deactivateTurtle:(Turtle *)aTurtle
{
	[listeningTurtles removeObject:aTurtle];
}

- (void)deactivateAllTurtles
{
	[listeningTurtles removeAllObjects];
}

- (NSArray *)turtles		// invoked by LogoDocument's drawRect method
{
	return(turtles);
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

- (void)errorMessage:(NSString *)aMessage
{
	unsigned long			lineCount;
	register const unichar	*s;
	register unichar		c;
	unsigned long			l;

	lineCount = 1;
	s = listing;
	l = programCounter - s;

	while(l--)
	{
		c = *s++;
		if(10 == c && 13 == s[0])			// incorrect line ending style (LF/CR)
		{
			lineCount++;
			s++;
		}
		else if(13 == c && 10 == s[0])		// DOS style line endings (CR/LF)
		{
			lineCount++;
			s++;
		}
		else if(10 == c || 13 == c)			// Unix, Linux (LF) or Mac OS (CR) style line endings
		{
			lineCount++;
		}
	}

	[errorView appendLine:[NSString stringWithFormat:@"Error in line %d:\n%@", lineCount, aMessage] ofColor:[NSColor redColor]];
}

- (void)setListing:(NSString *)aListing
{
	unichar			*buffer;
	unsigned long	length;

	if(listing)
	{
		free((void *) listing);
		listing = NULL;
	}
	[stack removeAllObjects];
	programCounter = NULL;
	if(aListing)
	{
		length = [aListing length];
		buffer = (unichar *) malloc(sizeof(unichar) * (length + 1));
		if(buffer)
		{
			[aListing getCharacters:buffer];
			buffer[length] = 0;
			listing = buffer;
			programCounter = buffer;
		}
	}
}

- (void)pushProgramCounter:(const unichar *)aProgramCounter withRepeat:(unsigned long)aRepeatCount
{
	StackObject	*obj;

	obj = [[StackObject alloc] initWithProgramCounter:aProgramCounter andRepeat:aRepeatCount];
	[stack addObject:obj];
}

- (void)pop
{
	StackObject	*obj;

	if([stack count])
	{
		obj = [stack lastObject];
		if(obj)
		{
			if([obj count])
			{
				programCounter = [obj programCounter];
				[obj decCount];
			}
			else
			{
				[stack removeLastObject];
			}
		}
	}
}

- (BOOL)getChar:(unichar *)p_char	// get next character and update character position
{
	register unichar	c;

	c = *programCounter;
	if(c)
	{
		programCounter++;
		if(p_char)
		{
			*p_char = c;
		}
		return(YES);
	}
	return(NO);
}

- (unsigned long)skipWhiteIn:(const unichar **)p_aBuffer length:(unsigned long)aLength			// skip over spaces, tabs, linefeeds, formfeeds and carriage returns
{
	register unichar		c;
	register const unichar	*s;
	unsigned long			length;

	length = 0;
	if(p_aBuffer)
	{
		s = *p_aBuffer;
		while(aLength--)
		{
			c = *s;
			if(32 != c && (9 > c || 13 < c))
			{
				break;
			}
			s++;
		}
		length = s - *p_aBuffer;
		*p_aBuffer = s;
	}
	return(length);
}

- (unsigned long)getListElementSize:(const unichar *)aList length:(unsigned long)aListLength
{
	register const unichar	*s;
	register unichar		c;
	unsigned long			length;

	s = aList;
	length = 0;
	c = *s++;
	while(aListLength-- && c && (32 != c && (9 > c || 13 < c)))
	{
		c = *s++;
	}
	length = (s - 1) - aList;
	return(length);
}

- (void)skipWhite			// skip over spaces, tabs, linefeeds, formfeeds and carriage returns
{
	register unichar		c;
	register const unichar	*s;

	s = programCounter;
	c = *s++;
	while(32 == c || (9 <= c && 13 >= c))
	{
		c = *s++;
	}
	s--;
	programCounter = s;
}

- (long)doCommand
{
	BOOL			refresh;
	const unichar	*unitemp;
	const unichar	*command;
	unsigned long	length;
	unsigned long	l;
	NSColor			*col;
	NSString		*temp;
	Expression		*expression;
	unsigned long	i;
	unsigned long	count;
	Turtle			*turtle;
	NSString		*name;
	Variable		*variable;
	BOOL			found;

	refresh = NO;

	[self skipWhite];
#if 1
	if(']' == *programCounter)
	{
		programCounter++;
		[self pop];
		return(kParserContinue);
	}
	else if('[' == *programCounter)
	{
		programCounter++;
		[self pushProgramCounter:programCounter withRepeat:0];
		return(kParserContinue);
	}
	else
#endif
	if([self getWord:&command andLength:&length])
	{
		expression = [[Expression alloc] init];
		[self skipWhite];
		count = [listeningTurtles count];
		switch(LookupCommand(command, length))
		{
		  case kCommandSetHeading:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					for(i = 0; i < count; i++)
					{
						refresh |= [[listeningTurtles objectAtIndex:i] setDirection:[expression floatValue]];
					}
				}
				else
				{
					[self errorMessage:@"SetHeading: nummeric expression expected"];
				}
			}
			break;
		  case kCommandPenUp:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] penUp];
			}
			break;
		  case kCommandPenDown:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] penDown];
			}
			break;
		  case kCommandHideTurtle:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] hide];
			}
			break;
		  case kCommandShowTurtle:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] show];
			}
			break;
		  case kCommandSetColor:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					for(i = 0; i < count; i++)
					{
						refresh |= [[listeningTurtles objectAtIndex:i] setPenColor:[expression floatValue]];
					}
				}
			}
			break;
		  case kCommandSetBackground:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
//					for(i = 0; i < count; i++)
//					{
//						refresh |= [[listeningTurtles objectAtIndex:i] setPaperColor:[expression floatValue]];
//					}
					refresh |= [outputView setPaperColor:[expression floatValue]];
				}
			}
			break;
		  case kCommandForward:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					for(i = 0; i < count; i++)
					{
						refresh |= [[listeningTurtles objectAtIndex:i] forward:[expression floatValue]];
					}
				}
				else
				{
					[self errorMessage:@"Forward: nummeric expression expected"];
				}
			}
			break;
		  case kCommandBack:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					for(i = 0; i < count; i++)
					{
						refresh |= [[listeningTurtles objectAtIndex:i] back:[expression floatValue]];
					}
				}
				else
				{
					[self errorMessage:@"Back: nummeric expression expected"];
				}
			}
			break;
		  case kCommandLeftTurn:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					for(i = 0; i < count; i++)
					{
						refresh |= [[listeningTurtles objectAtIndex:i] turnLeft:[expression floatValue]];
					}
				}
				else
				{
					[self errorMessage:@"LeftTurn: nummeric expression expected"];
				}
			}
			break;
		  case kCommandRightTurn:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					for(i = 0; i < count; i++)
					{
						refresh |= [[listeningTurtles objectAtIndex:i] turnRight:[expression floatValue]];
					}
				}
				else
				{
					[self errorMessage:@"RightTurn: nummeric expression expected"];
				}
			}
			break;
		  case kCommandHome:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] home];
			}
			break;
		  case kCommandNorth:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] north];
			}
			break;
		  case kCommandNorthWest:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] northWest];
			}
			break;
		  case kCommandWest:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] west];
			}
			break;
		  case kCommandSouthWest:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] southWest];
			}
			break;
		  case kCommandSouth:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] south];
			}
			break;
		  case kCommandSouthEast:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] southEast];
			}
			break;
		  case kCommandEast:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] east];
			}
			break;
		  case kCommandNorthEast:
			for(i = 0; i < count; i++)
			{
				refresh |= [[listeningTurtles objectAtIndex:i] northEast];
			}
			break;

		  case kCommandNewTurtle:
			if([self getExpression:expression])
			{
				switch([expression type])
				{
				  case kExpressionKindListValue:
				  case kExpressionKindStringValue:
					if(kExpressionKindListValue == [expression type])
					{
						unitemp = [expression listValue];
					}
					else
					{
						unitemp = [expression stringValue];
					}
					l = [expression length];
					while(l)
					{
						length = [self getListElementSize:unitemp length:l];
						if(length)
						{
							temp = [NSString stringWithCharacters:unitemp length:length];
							count = [turtles count];
							found = NO;
							for(i = 0; i < count; i++)
							{
								turtle = [turtles objectAtIndex:i];
								if([[turtle turtleName] isEqualToString:temp])
								{
									found = YES;
									break;
								}
							}
							if(found)
							{
								[self errorMessage:[NSString stringWithFormat:@"Already got a turtle named %@!", temp]];
							}
							else
							{
								col = [NSColor brownColor];
								turtle = [[Turtle alloc] initWithName:temp andColor:col];
								[turtle setOutputView:[self outputView]];
								[turtle setErrorView:[self errorView]];
								[self addTurtle:turtle];
							}
							l -= length;
							unitemp += length;
							l -= [self skipWhiteIn:&unitemp length:l];
						}
					}
				}
			}
			break;
		  case kCommandRemoveTurtle:
			if([self getExpression:expression])
			{
				switch([expression type])
				{
				  case kExpressionKindListValue:
				  case kExpressionKindStringValue:
					if(kExpressionKindListValue == [expression type])
					{
						unitemp = [expression listValue];
					}
					else
					{
						unitemp = [expression stringValue];
					}
					l = [expression length];
					while(l)
					{
						length = [self getListElementSize:unitemp length:l];
						if(length)
						{
							temp = [NSString stringWithCharacters:unitemp length:length];
							count = [turtles count];
							found = NO;
							for(i = 0; i < count; i++)
							{
								turtle = [turtles objectAtIndex:i];
								if([[turtle turtleName] isEqualToString:temp])
								{
									[self deactivateTurtle:turtle];
									[self removeTurtle:turtle];
									found = YES;
									break;
								}
							}
							if(!found)
							{
								[self errorMessage:[NSString stringWithFormat:@"%@ is not here", temp]];
							}
							l -= length;
							unitemp += length;
							l -= [self skipWhiteIn:&unitemp length:l];
						}
					}
				}
			}
			break;
		  case kCommandTalkTo:
			if([self getExpression:expression])
			{
				switch([expression type])
				{
				  case kExpressionKindListValue:
				  case kExpressionKindStringValue:
					if(kExpressionKindListValue == [expression type])
					{
						unitemp = [expression listValue];
					}
					else
					{
						unitemp = [expression stringValue];
					}
					l = [expression length];
					[self deactivateAllTurtles];
					while(l)
					{
						length = [self getListElementSize:unitemp length:l];
						if(length)
						{
							temp = [NSString stringWithCharacters:unitemp length:length];
							count = [turtles count];
							found = NO;
							for(i = 0; i < count; i++)
							{
								turtle = [turtles objectAtIndex:i];
								if([[turtle turtleName] isEqualToString:temp])
								{
									[self activateTurtle:turtle];
									found = YES;
								}
							}
							if(!found)
							{
								[self errorMessage:[NSString stringWithFormat:@"%@ is not here", temp]];
							}
							l -= length;
							unitemp += length;
							l -= [self skipWhiteIn:&unitemp length:l];
						}
					}
				}
			}
			break;

		  case kCommandMake:	// create a new variable
			// parameter: name-or-list name-or-list-or-value
			// If a list, each name in this list will be assigned the value that follows
			if([self getExpression:expression])
			{
				switch([expression type])
				{
				  case kExpressionKindListValue:
				  case kExpressionKindStringValue:
					if(kExpressionKindListValue == [expression type])
					{
						unitemp = [expression listValue];
					}
					else
					{
						unitemp = [expression stringValue];
					}
					l = [expression length];
					while(l)
					{
						length = [self getListElementSize:unitemp length:l];
						if(length)
						{
							temp = [NSString stringWithCharacters:[expression stringValue] length:[expression length]];
							[self skipWhite];
							if([self getExpression:expression])
							{
								count = [variables count];
								for(i = 0; i < count; i++)
								{
									variable = [variables objectAtIndex:i];
									name = [variable name];
									if(NSOrderedSame == [temp caseInsensitiveCompare:name])
									{
										[variables removeObject:variable];
									}
								}
								[variables addObject:[[Variable alloc] initWithName:temp andExpression:expression]];
							}
							l -= length;
							unitemp += length;
							l -= [self skipWhiteIn:&unitemp length:l];
						}
					}
				}
			}
			break;

			// program flow control...
		  case kCommandRepeat:
			if([self getExpression:expression])
			{
				if(kExpressionKindNumber & [expression type])
				{
					count = (long) [expression floatValue];
					[self skipWhite];
					if([self getExpression:expression])
					{
						if(kExpressionKindListValue == [expression type])
						{
							unitemp = [expression listValue];
							length = [expression length];
							[self pushProgramCounter:unitemp withRepeat:count];
							[self pop];
						}
					}
				}
			}
			break;

			// display commands...
		  case kCommandClearGraphics:
			refresh |= [outputView clear];
			break;
		  case kCommandUnknown:
			temp = [NSString stringWithCharacters:command length:length];
			unitemp = programCounter;
			programCounter = command;
			[self errorMessage:[NSString stringWithFormat:@"I don't know how to %@", temp]];
			programCounter = unitemp;
			break;
		  default:
			break;
		}
		return(refresh ? kParserUpdateDisplay : kParserContinue);
	}

#if 0
	if(currentLine < [lines count])
	{
				switch([self commandNumberFromString:parameter[0]])
				{
				  case kCommandSetXY:	// may be incorrect. setpos [x y] is supported more often
					if([parameter[1] getFloat:&number[1]])
					{
						if([parameter[2] getFloat:&number[2]])
						{
							pt.x = number[1];
							pt.y = number[2];
//							[turtle setLocation:pt];
							refresh = [turtle moveTo:pt];		// this is better, it allows for absolute-point-drawing. :) (remember that penUp and penDown are still in effect!)
						}
					}
					break;
				  case kCommandRepeat:
					break;
				  case kCommandNone:
					[errorView appendLine:[NSString stringWithFormat:@"I don't know how to %@", parameter[0]] ofColor:[NSColor redColor]];
					break;
				}
		return(refresh ? kParserUpdateDisplay : kParserContinue);
	}
#endif
	return(kParserStop);
}

@end
