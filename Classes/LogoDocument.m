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
#import "Preferences.h"

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
// speedToFrequency - a shared method for converting the speed to frequency
// (so we only need to change the converter-code in one place)
// Input: aSpeed: a float between 0.45 and 1.0 (from the slider).
// Output: The number of seconds between each step of execution (for the timer).
- (float)speedToInterval:(float)aSpeed
{
    if(aSpeed < 0.45) aSpeed = 0.45;
    if(aSpeed > 1.00) aSpeed = 1.00;
    
    // Convert so it spans 1.0 .. 10.0
    aSpeed -= 0.45;
    aSpeed *= 9.0 / 0.55;
    aSpeed += 1.0;

    return 1.0 / aSpeed / aSpeed;
}

//***********************************************************/
// setSpeed - Set the speed of the turtle's drawing
//
- (IBAction)setSpeed:(id)sender
{
	float			speed;

	// Get the speed value from the GUI
	speed = [sender floatValue];
    NSLog(@"New speed: %f", speed);

	[[Preferences sharedInstance] setTurtleSpeed:speed];

	// Tell the timer the new speed
	[self setInterval:[self speedToInterval:speed]];
}


//***********************************************************/
// awakeFromNib - Standard cocoa method. Run when app loads
//
- (void)awakeFromNib
{
	interval = [self speedToInterval:[[Preferences sharedInstance] turtleSpeed]];
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
// windowWillClose - Standard cocoa method. Run when window started closing
//
- (void)windowWillClose:(NSNotification *)aNotification
{
	[self timerStop];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

//***************************************************************/
// dealloc - Standard cocoa method. Run when object ends its life
//
- (void)dealloc
{
	[dataFromFile release];
	dataFromFile = NULL;
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
- (void)setInterval:(float)anInterval
{
	interval = anInterval;
	if(timer)
	{
		[self timerStart];
	}
}


// Accessor method
- (float)interval
{
	return(interval);
}


//***********************************************************/
// timerStop - Stops the timer
//
- (void)timerStop
{
	if(timer)
	{
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
    NSLog(@"Start timer with interval %f", interval);
	timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerTask:) userInfo:NULL repeats:YES];
	[timer retain];
}


//***********************************************************/
// timerTask - Details what to do each timer interval
//
- (void)timerTask:(NSTimer *)aTimer
{
    NSLog(@"TICK");
    long stat = [parser doCommand];
    if(kParserStop == stat) [self timerStop];
    [outputView setNeedsDisplay:YES];
}

//***********************************************************/
// run - Starts the timer, and hence the turtle's drawing
//
- (void)run
{
	[self timerStop];				// stop processing commands, so that variables are not changed after re-initializing them
#if (defined(DEBUGFLAG) && DEBUGFLAG)
//	DUMP_OBCOUNT();
#endif
	[parser reset];					// re-initialize variables
	[parser setListing:[[listingView textStorage] string]];
	[self timerStart];				// start processing
}


//***********************************************************/
// stop - Stops the timer, and hence the turtle's drawing
//
- (void)stop
{
	[self timerStop];	// stop processing commands
#if (defined(DEBUGFLAG) && DEBUGFLAG)
//	[parser forgetAll];	// clear memory used by parser (for debugging only, as the user should be able to print the output, AND if we need to redraw, we won't have the drawing commands, if we use forgetAll!)
//	DUMP_OBCOUNT();
#endif
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
