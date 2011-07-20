//
//  Commands.c
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

#include "Commands.h"
#include "Utilities.h"

Command	*g_commands = NULL;

void InitCommands()
{
	typedef struct CommandList CommandList;
	struct CommandList
	{
		const unsigned char	*name;
		long				commandNumber;
	};

	static CommandList	commandList[]= {
		{ "bk", kCommandBack },						/* implemented */
		{ "fd", kCommandForward },					/* implemented */
		{ "lt", kCommandLeftTurn },					/* implemented */
		{ "rt", kCommandRightTurn },				/* implemented */
		{ "pd", kCommandPenDown },					/* implemented */
		{ "pu", kCommandPenUp },					/* implemented */
		{ "if", kCommandIf },
		{ "n", kCommandNorth },						/* implemented */
		{ "nw", kCommandNorthWest },				/* implemented */
		{ "w", kCommandWest },						/* implemented */
		{ "sw", kCommandSouthWest },				/* implemented */
		{ "s", kCommandSouth },						/* implemented */
		{ "se", kCommandSouthEast },				/* implemented */
		{ "e", kCommandEast },						/* implemented */
		{ "ne", kCommandNorthEast },				/* implemented */
		{ "ht", kCommandHideTurtle },				/* implemented */
		{ "st", kCommandShowTurtle },				/* implemented */
		{ "cg", kCommandClearGraphics },			/* implemented */
		{ "cc", kCommandClearCommands },
		{ "to", kCommandTo },
		{ "tto", kCommandTalkTo },					/* implemented */
		{ "end", kCommandEnd },
		{ "ifelse", kCommandIfElse },
		{ "fill", kCommandFloodFill },
		{ "seth", kCommandSetHeading },				/* implemented */
		{ "setc", kCommandSetColor },
		{ "setbg", kCommandSetBackground },
		{ "setxy", kCommandSetXY },
		{ "setpos", kCommandSetPosition },
		{ "newturtle", kCommandNewTurtle },			/* implemented */
		{ "remove", kCommandRemoveTurtle },			/* implemented */
		{ "repeat", kCommandRepeat },				/* implemented */
		{ "make", kCommandMake },					/* implemented */

		{ "back", kCommandBack },					/* implemented */
		{ "forward", kCommandForward },				/* implemented */
		{ "left", kCommandLeftTurn },				/* implemented */
		{ "right", kCommandRightTurn },				/* implemented */
		{ "pendown", kCommandPenDown },				/* implemented */
		{ "penup", kCommandPenUp },					/* implemented */
		{ "north", kCommandNorth },					/* implemented */
		{ "northwest", kCommandNorthWest },			/* implemented */
		{ "west", kCommandWest },					/* implemented */
		{ "southwest", kCommandSouthWest },			/* implemented */
		{ "south", kCommandSouth },					/* implemented */
		{ "southeast", kCommandSouthEast },			/* implemented */
		{ "east", kCommandEast },					/* implemented */
		{ "northeast", kCommandNorthEast },			/* implemented */
		{ "hideturtle", kCommandHideTurtle },		/* implemented */
		{ "showturtle", kCommandShowTurtle },		/* implemented */
		{ "home", kCommandHome },					/* implemented */
		{ "clear", kCommandClearGraphics },			/* implemented */
		{ "talkto", kCommandTalkTo },				/* implemented */
		{ "cleargraphics", kCommandClearGraphics },
		{ "clearcommands", kCommandClearCommands },
		{ "setheading", kCommandSetHeading },		/* implemented */
		{ "setcolor", kCommandSetColor },
		{ "setbackground", kCommandSetBackground },
		{ "floodfill", kCommandFloodFill },
		{ "setposition", kCommandSetPosition },
		{ "removeturtle", kCommandRemoveTurtle },	/* implemented */

		{ NULL, kCommandUnknown }
	};
	int					i;
	int					size;
	const unsigned char	*s;
	unichar				*d;
	unichar				c;

	if(!g_commands)
	{
		size = sizeof(commandList) / sizeof(*commandList);
		g_commands = (Command *) malloc(size * sizeof(*g_commands));
		for(i = 0; i < size; i++)
		{
			s = commandList[i].name;
			d = s ? (unichar *) malloc(sizeof(unichar) * (strlen(s) + 1)) : NULL;
			g_commands[i].name = d;
			if(s && d)
			{
				c = *s++;
				while(c)
				{
					*d++ = c;
					c = *s++;
				}
				*d++ = c;
			}
			g_commands[i].commandNumber = commandList[i].commandNumber;
		}
	}
}

long LookupCommand(const unichar *aCommand, unsigned long length)
{
	Command	*p;

	p = g_commands;
	if(!p)
	{
		InitCommands();
		p = g_commands;
	}
	while(p->name)
	{
		if(unimatchin(p->name, aCommand, length))
		{
			break;
		}
		p++;
	}
	return(p->commandNumber);
}

