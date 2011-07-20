//
//  Commands.h
//  Software: XLogo
//
//  Created by Jens Bauer on Fri Jun 27 2003.
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

#include "Debugging.h"

#import <Foundation/Foundation.h>	// need typedef unsigned short unichar; from NSString.h

#ifndef _Commands_h_
#define _Commands_h_

#ifdef __cplusplus
extern "C" {
#endif

enum
{
	kCommandUnknown		= 0,
	kCommandHome,
	kCommandNorth,
	kCommandNorthWest,
	kCommandWest,
	kCommandSouthWest,
	kCommandSouth,
	kCommandSouthEast,
	kCommandEast,
	kCommandNorthEast,
	kCommandHideTurtle,
	kCommandShowTurtle,
	kCommandClearGraphics,
	kCommandClearCommands,
	kCommandBack,
	kCommandForward,
	kCommandLeftTurn,
	kCommandRightTurn,
	kCommandPenDown,
	kCommandPenUp,
	kCommandRepeat,
	kCommandTo,
	kCommandEnd,
	kCommandIf,
	kCommandIfElse,
	kCommandSetHeading,
	kCommandNewTurtle,
	kCommandRemoveTurtle,
	kCommandSetColor,
	kCommandSetBackground,
	kCommandFloodFill,
	kCommandSetPosition,
	kCommandSetXY,
	kCommandTalkTo,
	kCommandMake,

	kCommandCount
};


typedef struct Command Command;
struct Command
{
	unichar		*name;
	long		commandNumber;
};

#if 0	// no longer needed
extern Command	*g_commands;
#endif

void InitCommands();
long LookupCommand(const unichar *aCommand, unsigned long length);

#ifdef __cplusplus
}
#endif

#endif	/* _Commands_h_ */
