/*
 *  Debugging.h
 *  Software: XLogo
 *
 *  Created by Jens Bauer on Wed Jun 25 2003.
 *  Copyright (c) 2003 Jens Bauer. All rights reserved.
 *
 */

#include <Carbon/Carbon.h>

#ifndef _Debugging_h_
#define _Debugging_h_

#ifdef __cplusplus
extern "C" {
#endif

#if (defined(DEBUGFLAG) && DEBUGFLAG)
#define DEBUGMSG(a...)	fprintf(stderr, a);	fflush(stderr)
#else
#define DEBUGMSG(a...)
#endif

#ifdef __cplusplus
}
#endif

#endif	/* _Debugging_h_ */
