//
//  TurtleController.m
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

#import <AppKit/NSOpenPanel.h>
#import "TurtleController.h"
#import "TurtleView.h"
#import "CommandMaster.h"
#import "Turtle.h"

@implementation TurtleController

- (void) awakeFromNib
{
    // Purpose: This is run upon startup

    [self updateUI];
}

- (void) updateUI
{
    // Purpose: Refresh the GUI when needed

    //[turtleView foregroundColor];   // Set the foreground color
    //[turtleView backgroundColor];   // Set the background color
}

- (IBAction) activateTurtle:(id)sender
{
    // Purpose: Start the drawing process by setting a boolean value to true
    //           then start interpreting and sending commands to the view

    // compileCommands(); -- Tell CommandMaster to translate LOGO to Obj-C
    //                       understandable by TurtleView
    // setDrawTrue();     -- Access boolean in TurtleView, set it to true
    // updateUI();

    // For now, just display a message
    // NSRunAlertPanel(@"Draw",@"Draw not yet implemented",@"OK",NULL,NULL);

}

- (IBAction) changeSpeed:(id)sender
{
    // Purpose: Call the accessor method in Turtle to update the speed level
    float newSpeed;

    newSpeed = [sender floatValue];
    [turtle setSpeed: newSpeed];
}

- (IBAction) newCommand:(id)sender
{
    // Purpose: to receive a new command from the GUI textfield and
    //          add it to the list in the GUI as well as internally

    NSString *cmd;  // Use this to store the new command locally in a variable

    cmd = [[commandField stringValue] uppercaseString];  // Capture the new command from the NSTextfield

    if ([commandMaster checkValidity: cmd])  // If it is a valid command, continue
	 {
	[commandList setEditable:TRUE];    // Set the NSTextView to editable so we can add the command
	[commandList insertText:cmd];      // Add the new command to the NSTextview (Command List)
	[commandList insertNewlineIgnoringFieldEditor:sender];       // append the carriage return!
	[commandList setEditable:FALSE];   // Set the NSTextView back to uneditable

	[commandMaster addCommand: cmd];     // Store the new command internally
	 }
    
}

- (IBAction) saveCommands:(id)sender
{
    // Purpose: To save the commands to a text file 

    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSString *actualFileNameToSave = [fileName stringByResolvingSymlinksInPath];	
    //NSDictionary *curAttributes = [fileManager fileAttributesAtPath:actualFileNameToSave traverseLink:YES];
    //NSMutableDictionary *newAttributes;
    //BOOL fileIsWritable = [fileManager isWritableFileAtPath:actualFileNameToSave];

    // If the file exists, but is writeable, continue with the save
    //if (fileIsWritable)
	// {
	// }
}

- (IBAction) loadCommands:(id)sender
{
    // Purpose: To load commands from a text file
    
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    NSString *fileName;
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSDictionary *docAttrs;
    NSTextStorage *text = [self textStorage];
    NSURL *url = [NSURL fileURLWithPath:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [openDialog setTitle:@"Load a LOGO commands file"];
    [openDialog setAllowsMultipleSelection:FALSE];       // Make sure they just choose one file
    
    SEL sel = @selector(openPanelDidEnd:returnCode:contextInfo:);
    [openDialog beginSheetForDirectory:@"/Users/jeff/Projects/xlogo/"
                                 file:nil
                                types:nil
                       modalForWindow:[turtleView window]
                        modalDelegate:self
                       didEndSelector:sel
                          contextInfo:nil];

    fileName = [openDialog URLs];   // Get the path and name of the file chosen

    // Set up the options dictionary with desired parameters
    [options setObject:url forKey:@"BaseURL"];
    [options setObject:NSPlainTextDocumentType forKey:@"DocumentType"]; // Force plain text


    // [fileLoader fileHandleForReadingAtPath: chosenFile];   // Open the file
    
    // loadedFile = [fileLoader readDataToEndOfFile];       // Read the data from the file

    // [fileLoader closeFile];         // Close the file

    NSRunAlertPanel(@"File Loaded",[fileName objectAtIndex:0],@"OK",NULL,NULL);
    
    [commandList setEditable:TRUE];
    [commandList insertText:[fileName objectAtIndex:0]];
}

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    if(returnCode == NSOKButton)
	 {
        dataString = [[NSString alloc] initWithContentsOfFile:[sheet filename]];
	 }
}

- (IBAction) printView:(id)sender
{
    // Purpose: To print the current drawing. Send a print command to the View

    [turtleView print: sender];
}


@end
