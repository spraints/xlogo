//
//  NSTextViewOutputExtensions.m
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

#import "NSTextViewOutputExtensions.h"


@implementation NSTextView (NSTextViewOutputExtensions)

- (void)appendString:(NSString *)aString ofColor:(NSColor *)textColor
{
	NSAttributedString	*attrStr;
	NSDictionary		*dict;

	dict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, [NSFont userFixedPitchFontOfSize:0.0], NSFontAttributeName, nil];
	attrStr = [[NSAttributedString alloc] initWithString:aString attributes:dict];
	[[self textStorage] appendAttributedString:attrStr];
}

- (void)appendLine:(NSString *)aString ofColor:(NSColor *)textColor
{
	NSAttributedString	*attrStr;
	NSDictionary		*dict;
	NSString			*str;

	str = [aString stringByAppendingString:@"\n"];
	dict = [NSDictionary dictionaryWithObjectsAndKeys:textColor, NSForegroundColorAttributeName, [NSFont userFixedPitchFontOfSize:0.0], NSFontAttributeName, nil];
	attrStr = [[NSAttributedString alloc] initWithString:str attributes:dict];
	[[self textStorage] appendAttributedString:attrStr];
}


//***********************************************************/
// ClearAllText - Clears all of the text in the textview
//
- (void)clearAllText
{
    NSRange allChars;

    // The NSRange allChars is a struct of two parts, location (where to start)
    // and length (where to end). Since we want to delete all of the TextView
    // we start at 0 and then make the length equal to the amount of text currently
    // in the view - if we didnt do that, we would get an error.
    allChars.location = 0;
    allChars.length = [[self textStorage] length];

    // Since NSTextStorage is a semi-subclass of NSMutableAttributedString, we can
    // use its function "deleteCharactersInRange" to clear it all
    [[self textStorage] deleteCharactersInRange:allChars];
}

@end
