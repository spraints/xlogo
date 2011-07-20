//
//  TurtleController.h
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

#import <Cocoa/Cocoa.h>

@interface TurtleController : NSObject
{
    // GUI variables and objects
    IBOutlet NSTextField *commandField;
    IBOutlet NSTextView *commandList;
    IBOutlet id turtleView;
    IBOutlet id commandMaster;
    IBOutlet id turtle;
    NSString *dataString;

    // Internal variables
    NSFileManager *fileManager;
}

// Method declarations
- (IBAction) activateTurtle:(id)sender;
- (IBAction) changeSpeed:(id)sender;
- (IBAction) newCommand:(id)sender;
- (IBAction) saveCommands:(id)sender;
- (IBAction) loadCommands:(id)sender;
- (IBAction) printView:(id)sender;
- (void) updateUI;

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end
