//
//  LogoDocument.m
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

#import "LogoDocument.h"
#import "LogoParser.h"
#import "NSTextViewOutputExtensions.h"
#import "Turtle.h"

#define XLogoDocumentType  @"XLogoDocument"

@implementation LogoDocument

- (IBAction)run:(id)sender
{
    [self run];
}

- (IBAction)stop:(id)sender
{
    [self stop];
}


//***********************************************************/
// printDocument - Prints the current drawing (TurtleView)
//
- (IBAction)printDocument:(id)sender
{
    [outputView print: sender];   // Send a print command to the View
}


- (IBAction)setSpeed:(id)sender
{
	float	speed;

	speed = [sender floatValue];
	speed = 1.000001 - speed;

	if(0 == speed)
	{
		speed = 0.000001;
	}
	[self setFrequency:speed];
}

- (id)init
{
    [super init];
    if(self)
	{
		frequency = 0.013;
		timer = NULL;
    }
    return(self);
}

- (void)dealloc
{
    [dataFromFile release];
    dataFromFile = NULL;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [self timerStop];
    [super dealloc];
}

- (NSString *)windowNibName
{
    return(@"XLogoDocument");
}



- (void)loadDocumentWithInitialData
{
    NSUnarchiver *unarchiver;
    NSTextStorage *text;

    unarchiver = [[[NSUnarchiver alloc] initForReadingWithData:dataFromFile] autorelease];

    text = [unarchiver decodeObject];

    if([text length])
	 {
	[listingView insertText:text];
	 }

    [[self undoManager] removeAllActions];  // remove dirty-flag

    [dataFromFile release];
    dataFromFile = NULL;
}


- (void)windowControllerDidLoadNib:(NSWindowController *) controller
{
    [super windowControllerDidLoadNib:controller];
    [[listingView window] makeFirstResponder:listingView]; 

    if(dataFromFile)
	 {
	[self loadDocumentWithInitialData];
	 }
}


// For saving files
- (NSData *)dataRepresentationOfType:(NSString *)type
{
    NSMutableData *data;
    NSArchiver *archiver;

    data = NULL;
    archiver = NULL;

    if([type isEqualToString:XLogoDocumentType])
	 {
	archiver = [[[NSArchiver alloc] initForWritingWithMutableData:[NSMutableData data]] autorelease];
	[archiver encodeObject:[listingView textStorage]];
	data = [archiver archiverData];
	 }
    return(data);
}


// For loading files
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type
{
    if([type isEqualToString:XLogoDocumentType])
	 {
	dataFromFile = [data retain];
	return(YES);
	}
    else
	 {
	return(NO);
	 }
}

- (void)setFrequency:(float)aFrequency
{
	frequency = aFrequency;
	if(timer)
	{
		[self timerStart];
	}
}

- (float)frequency
{
	return(frequency);
}

- (void)timerStop
{
	if(timer)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[timer invalidate];
		[timer release];
		timer = NULL;
	}
}

- (void)timerStart
{
	if(timer)
	{
		[self timerStop];
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:frequency target:self selector:@selector(timerTask:) userInfo:NULL repeats:YES];
	[timer retain];
}

- (void)timerTask:(NSTimer *)aTimer
{
	long	stat;
	long	count;
	BOOL	refresh;

	count = 2;					// we're cheating here. :)
	while(count--)
	{
		stat = [parser doCommand];
		if(kParserUpdateDisplay == stat)
		{
			refresh = YES;
		}
		else if(kParserStop == stat)
		{
			refresh = YES;
			[self timerStop];
			break;
		}
	}
	if(refresh)
	{
		[outputView setNeedsDisplay:YES];
	}

#if 0
	switch([parser doCommand])
	{
	  case kParserStop:				// stop interpreting the program
		[self timerStop];
		// FallThru...
	  case kParserUpdateDisplay:	// not all commands update the display; eg. pen up or if the pen is up and the turtle is moving...
		[outputView setNeedsDisplay:YES];
		// FallThru...
	  case kParserContinue:			// don't need to do anything
		break;
	}
#endif
}

- (void)run
{
	[self timerStop];				// stop processing commands, so that variables are not changed after re-initializing them
	[parser reset];					// re-initialize variables
	[parser setListing:[[listingView textStorage] string]];
//	[parser setLines:[self linesFromString:[[listingView textStorage] string]]];
	[self timerStart];				// start processing
}


//***********************************************************/
// stop - Stops the timer, and hence the turtle's drawing
//
- (void)stop
{
    [self timerStop];	// stop processing commands
}




@end
