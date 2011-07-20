//
//  NSStringParserExtensions.h
//  Software: XLogo
//
//  Created by Jens Bauer on Wed Jun 25 2003.
//
//  Copyright (c) 2003 Jens Bauer
//  All rights reserved.
//

#include "Debugging.h"

#import <Foundation/Foundation.h>


@interface NSString (NSStringParserExtensionMethods)
- (NSString *)stringWithoutUnwantedTabsAndSpaces;
- (BOOL)getFloat:(float *)aFloat;
@end
