//
//  CommandMaster.m
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

#import "CommandMaster.h"

@implementation CommandMaster


- (id) init;
{
    // Purpse: Initialize the CommandMaster to some base values. This method does not have to
    //         be declared in the header file like the others because it is inherited from its super class (parent)

    self = [super init];

    commandStorage = [[NSMutableArray alloc] init];   // Initialize the command storage array 
	
    return self;
}

- (BOOL) checkValidity:(NSString *) newCommand
{
    // Purpose: To verify that a command entered by the user is a legitimate command
    //          A variety of checks are performed in order to validate the command
    //          starting from the larger 

    // Variable declarations
    BOOL isValid;
    char firstChar;
    NSCharacterSet *charSet;
    NSString *customSetString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789[]";
    //NSRange charCheck;

    // First we set the boolean value to TRUE and if the command fails
    // any of the tests that follow we will set it to FALSE
    isValid = TRUE;
    
    // Create a custom character set using the string above. This should be good
    // enough for the LOGO language, which only uses letters, numbers, and brackets
    charSet = [NSCharacterSet characterSetWithCharactersInString: customSetString];

    // Check to see if the string has any characters other than [A-Z], [0-9], or "[]"
    // using the character set created above.
    // If so, it's not valid. Subsequent checks will then be skipped.
    
    // Check to see if the string starts out with any numbers, if so, it's not valid.
    // Because the first 4 characters of any logo command are always some combination
    // of letters, this is a valid thing to do. Though, it may not be very elegant
    // as far as algorithms go but we're trying to be thorough and teach programming
    // ideas, albeit slow and simple ones, and not shortcuts or speedy ones.
    if (isValid != FALSE)
    firstChar = [newCommand characterAtIndex:0];

    isValid = TRUE;

    return isValid;
}

- (BOOL) addCommand:(NSString *) newCommand
{
    // Purpose: To add a new command (String) to the command storage (Array) and return
    //          a value of success (true) or failure (false)

    // Use this to store the success or failure message
    BOOL addSuccess;

    // Attempt to add the new command to the Array. It goes in the last spot.
    [commandStorage addObject:newCommand];

    // Make sure to find out if it was successful or not and return that value
    addSuccess = [commandStorage containsObject:newCommand];
    
    return addSuccess;
}


- (BOOL) deleteLastCommand
{
    // Purpose: To delete the last command in the command storage. We're going to check for success
    //          by first noting the size of the array, and after the attempted deletion check if it is 1 less

    BOOL deleteSuccess;
    short arraySize;

    // Find out the current size of the array, before any attempts at deletion
    arraySize = [commandStorage count];

    // Attempt a deletion of the last object in the array
    [commandStorage removeLastObject];

    // Now compare the size of the array before and after to see if it has changed
    // We use that change to decide if the deletion was successful
    if (arraySize > [commandStorage count])
	 {
	deleteSuccess = TRUE;
	 }
    else
	 {
	deleteSuccess = FALSE;
	 }

    return deleteSuccess;
}


- (BOOL) deleteAllCommands
{
    // Purpose: To delete the all of the commands in the command storage. To check for success
    //          or failure we will see if the array size is zero.

    BOOL deleteSuccess;

    // Attempt to delete all of the commands in the array
    [commandStorage removeAllObjects];

    // We check for success by seeing if the array is empty (count is zero)
    if ([commandStorage count] == 0)
	 {
	deleteSuccess = TRUE;
	 }
    else
	 {
	deleteSuccess = FALSE;
	 }
    
    return deleteSuccess;
}


- (int) commandCount
{
    // Purpose: To return the number of items in the array

    return [commandStorage count];
}


- (void) dealloc
{
    // Purpse: Clean up. This is called when the object is being freed. This method
    //         should free any memory allocated by the subclass (in this case, TurtleView)
    //         and then call super to get the superclass to do any additional cleanup.

    [commandStorage release];    // Release the memory used to store the commands
    [super dealloc];
}


@end
