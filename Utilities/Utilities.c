//
//  Utilities.c
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

#include "Utilities.h"

float my_fmod(float value, float maxvalue)	/* this mod is for floats, but also allows (positive) mod on negative values */
{
	register float	tmp;
	register int	i;
	register float	half;

	tmp = maxvalue;
	if(tmp - 1.0 == tmp)	/* infinite */
	{
		value = 0.0;
	}
	else
	{
		i = 0;
		if(value < 0.0)					/* if too small */
		{
			while((value + tmp) < 0.0)	/* add something; notice: this will end up being way too much, because I'm lazy! */
			{
				tmp += tmp;
			}
			value += tmp;
			tmp = maxvalue;
		}
		if(value > 0.0)					/* The rest of this routine is pretty well written. */
		{
			half = 0.5;
			while(value >= tmp && i < 128)
			{
				tmp += tmp;
				i++;
			}
			while(i--)
			{
				tmp *= half;
				if(value >= tmp)
				{
					value -= tmp;
				}
			}
		}
	}
	return(value);
}

int unimatchin(const unichar *string1, const unichar *string2, unsigned long length)
{
	register const unichar	*s1;
	register const unichar	*s2;
	register unichar		c1;
	register unichar		c2;
	const unichar			empty[] = { 0, 0 };

	s1 = string1;
	s2 = string2;

	if(NULL == s1)
	{
		s1 = empty;
	}
	if(NULL == s2)
	{
		s2 = empty;
	}
	if(s1 == s2)
	{
		return(1);
	}
	while(length--)
	{
		c1 = *s1++;
		c2 = *s2++;
		if(c1 != c2)
		{
			if('a' <= c1 && 'z' >= c1)
			{
				if((c2 | 0x20) != c1)
				{
					return(0);
				}
			}
			else if('a' <= c2 && 'z' >= c2)
			{
				if((c1 | 0x20) != c2)
				{
					return(0);
				}
			}
			else
			{
				return(0);
			}
		}
	}
	if('\0' == *s1)
	{
		return(1);
	}
	return(0);
}

