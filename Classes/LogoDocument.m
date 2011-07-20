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

#define XLogoDocumentType	@"XLogoDocument"

@implementation LogoDocument


//***********************************************************/
// printDocument - Prints the current drawing (TurtleView)
//
- (IBAction)printDocument:(id)sender
{
	[outputView print: sender];		// Send a print command to the View
}


//***********************************************************/
// setSpeed - Set the speed of the turtle's drawing
//
- (IBAction)setSpeed:(id)sender
{
	float			speed;
	NSUserDefaults	*defaults;

	// Get the speed value from the GUI
	speed = [sender floatValue];

	// Initialize user preferences in casethe user wants to save the speed as a preference
	defaults = [NSUserDefaults standardUserDefaults];

	// Store the speed preference (if the user so desires)
	if([defaults integerForKey:@"Turtle Speed Boolean"])
	{
		[defaults setFloat:speed forKey:@"Turtle Speed"];
	}

	// Catch values above 1
	speed = 1.000001 - speed;

	// Catch a zero value
	if(0 == speed)
	{
		speed = 0.000001;
	}

	// Tell the timer the new speed
	[self setFrequency:speed];
}


//***********************************************************/
// awakeFromNib - Standard cocoa method. Run when app loads
//
- (void)awakeFromNib
{
	// Get the user preferences
	NSUserDefaults	*defaults;
	defaults = [NSUserDefaults standardUserDefaults];

	// Set the speed preference, show it in the GUI
	if([defaults integerForKey:@"Turtle Speed Boolean"])
	{
		frequency = 1.000001 - [defaults floatForKey:@"Turtle Speed"];
		[speedSlider setFloatValue: [defaults floatForKey:@"Turtle Speed"]];
	}
	else
	{
		frequency = 0.013;
	}
}


//***************************************************************/
// init - Standard cocoa method. Run when object begins its life
//
- (id)init
{
	[super init];
	if(self)
	{
		timer = NULL;
	}
	return(self);
}


//***************************************************************/
// dealloc - Standard cocoa method. Run when object ends its life
//
- (void)dealloc
{
	[dataFromFile release];
	dataFromFile = NULL;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self timerStop];
	[super dealloc];
}


// Accessor method
- (NSString *)windowNibName
{
	return(@"XLogoDocument");		// This must match the document info in info.plist
}

//*************************************************************************************/
// loadDocumentWithInitialData - As the name sounds, for loading files in a new window
//
- (void)loadDocumentWithInitialData
{
	NSUnarchiver	*unarchiver;
	NSTextStorage	*text;

	// Open the file, load the data into memory
	unarchiver = [[[NSUnarchiver alloc] initForReadingWithData:dataFromFile] autorelease];

	// Take the file data and turn it back into text
	text = [unarchiver decodeObject];

	// If the text is longer than 0 in length, load it into the view
	if([text length])
	{
		[listingView insertText:text];
	}

	[[self undoManager] removeAllActions];	// remove dirty-flag

	// Clean up
	[dataFromFile release];
	dataFromFile = NULL;
}


// When the window loads, run this
- (void)windowControllerDidLoadNib:(NSWindowController *) controller
{
	// Tell the controller to run it's own loadNib
	[super windowControllerDidLoadNib:controller];

	// Set focus on the text view, where commands are entered
	[[listingView window] makeFirstResponder:listingView]; 

	// If the person is opening a document, and not just a new window, load the data into the GUI
	if(dataFromFile)
	{
		[self loadDocumentWithInitialData];
	}
}


// For saving files
- (NSData *)dataRepresentationOfType:(NSString *)type
{
	NSMutableData	*data;
	NSArchiver		*archiver;

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


// Accessor method
- (void)setFrequency:(float)aFrequency
{
	frequency = aFrequency;
	if(timer)
	{
		[self timerStart];
	}
}


// Accessor method
- (float)frequency
{
	return(frequency);
}


//***********************************************************/
// timerStop - Stops the timer
//
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


//***********************************************************/
// timerStart - Starts the timer
//
- (void)timerStart
{
	// First stop the timer if it has already been started, so we can start over from scratch
	if(timer)
	{
		[self timerStop];
	}

	// Now create the timer.
	timer = [NSTimer scheduledTimerWithTimeInterval:frequency target:self selector:@selector(timerTask:) userInfo:NULL repeats:YES];
	[timer retain];
}


//***********************************************************/
// timerTask - Details what to do each timer interval
//
- (void)timerTask:(NSTimer *)aTimer
{
	long		stat;
	long		count;
	BOOL		refresh;

#ifdef SEMAPHORE
	static BOOL	semaphore = 1;

	if(semaphore)
	{
		semaphore = 0;
#endif

	count = 6;					// we're cheating here. :)
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

#ifdef SEMAPHORE
		semaphore = 1;
	}
	else
	{
DEBUGMSG("Yeh, yeh, I'm already at work!!\n");
	}
#endif

#if 0
	switch([parser doCommand])
	{
	  case kParserStop:			// stop interpreting the program
		[self timerStop];
		// FallThru...
	  case kParserUpdateDisplay:		// not all commands update the display; eg. pen up or if the pen is up and the turtle is moving...
		[outputView setNeedsDisplay:YES];
		// FallThru...
	  case kParserContinue:			// don't need to do anything
		break;
	}
#endif
}

//***********************************************************/
// run - Starts the timer, and hence the turtle's drawing
//
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


// Action method
- (IBAction)run:(id)sender
{
	[self run];
}

// Action method
- (IBAction)stop:(id)sender
{
	[self stop];
}

@end
