//
//  NSMutableString+RJLisp.m
//  Lisp
//
//  Created by Robert Jones on 2/14/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "NSMutableString+RJLisp.h"

@implementation NSMutableString (RJLisp)

- (NSString *)readline
{
    NSString *line = nil;
    NSRange range = [self rangeOfString:@"\n"];
    if (range.location != NSNotFound) {
        range = NSMakeRange(0, range.location+range.length);
    }
    else if ([self length]) {
        range = NSMakeRange(0, [self length]);
    }

    if (range.location != NSNotFound) {
        line = [self substringWithRange:range];
        [self deleteCharactersInRange:range];
    }

    return line;
}

@end
