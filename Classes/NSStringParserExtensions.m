//
//  NSStringParserExtensions.m
//  Software: XLogo
//
//  Created by Jens Bauer on Wed Jun 25 2003.
//
//  Copyright (c) 2003 Jens Bauer
//  All rights reserved.
//

#import "NSStringParserExtensions.h"


@implementation NSString (NSStringParserExtensionMethods)
- (NSString *)stringWithoutUnwantedTabsAndSpaces
{
	NSString	*string;
	int			i;

	string = self;
	string = [[string componentsSeparatedByString:@"\t"] componentsJoinedByString:@" "];	// find one tab, replace by one space
	for(i = 0; i < 8; i++)
	{
		string = [[string componentsSeparatedByString:@"        "] componentsJoinedByString:@" "];	// find 8 spaces, replace by one space
	}
	for(i = 0; i < 4; i++)
	{
		string = [[string componentsSeparatedByString:@"  "] componentsJoinedByString:@" "];	// find 2 spaces, replace by one space
	}
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return(string);
}

- (BOOL)getFloat:(float *)p_float
{
	unichar		firstChar;
	unichar		secondChar;
	unichar		thirdChar;

	if([self length])
	{
		firstChar = [self characterAtIndex:0];
		secondChar = 0;
		thirdChar = 0;
		if([self length] > 1)
		{
			secondChar = [self characterAtIndex:1];
			if([self length] > 2)
			{
				thirdChar = [self characterAtIndex:2];
			}
		}
		if('-' == firstChar)
		{
			firstChar = secondChar;
			secondChar = thirdChar;
			thirdChar = 0;
		}
		if('.' == firstChar)
		{
			firstChar = secondChar;
			secondChar = thirdChar;
			thirdChar = 0;
		}
		if('0' <= firstChar && '9' >= firstChar)
		{
			if(p_float)
			{
				*p_float = [self floatValue];
			}
			// Note: I'm not checking if garbage is following the float; I allow for this, but this is not the right way to do it!
			// I don't check, because Cocoa is a bit clumsy, and I don't feel like going non-unicode now. A parser should really be pointer-based, rather than using string classes, etc..
			return(YES);
		}
	}

	return(NO);
}

- (BOOL)getExpression:(float *)p_float
{
	if(p_float)
	{
		*p_float = 0.0;
	}
	return(NO);
}

@end
