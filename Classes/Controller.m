//
//  Controller.m
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

#import "Controller.h"

@implementation Controller


//***********************************************************/
// preferences - Get the preferences values from the OS and show the window
//
- (IBAction)preferences:(id)sender
{
    NSUserDefaults *defaults;
    NSString *lineWidthValue;
    int maximumTurtlesValue, saveSpeedValue;

    // Initialze the defaults variable for the program
    defaults = [NSUserDefaults standardUserDefaults];

    // Assign each part of the default to the corresponding string variable
    lineWidthValue = [defaults objectForKey:@"Line Width"];
    maximumTurtlesValue = [defaults integerForKey:@"Maximum Turtles"];
    saveSpeedValue = [defaults integerForKey:@"Turtle Speed Boolean"];

    // Now we set the parts of the preferences panel GUI to reflect those values
    if (maximumTurtlesValue)
	{
	[maximumTurtles setIntValue:maximumTurtlesValue];
	}

    if (saveSpeedValue)
	{
	[saveSpeed setState:saveSpeedValue];
	}

    if (lineWidthValue)
	{
	[lineWidth selectItemWithTitle:lineWidthValue];
	}
    
    // Now show the panel (preferences window) to the user
    [preferencesPanel makeKeyAndOrderFront:nil];
}


//***********************************************************/
// cancelPreferences - Quit the window, without saving
//
- (IBAction)cancelPreferences:(id)sender
{
    [preferencesPanel close];
}


//***************************************************************/
// savePreferences - Save the users preferences and exit window
//
- (IBAction)savePreferences:(id)sender
{
    NSUserDefaults *defaults;

    // Initialize the defaults for the program
    defaults = [NSUserDefaults standardUserDefaults];

    // Store the value for the maximum number of turtles
    [defaults setInteger:[maximumTurtles intValue] forKey:@"Maximum Turtles"];

    // Store the value of the turtle speed boolean
    [defaults setInteger:[saveSpeed state] forKey:@"Turtle Speed Boolean"];

    // Store the value of the line width
    [defaults setObject:[[lineWidth selectedItem] title] forKey:@"Line Width"];
    
    // Now close the window
    [preferencesPanel close];
}

@end
