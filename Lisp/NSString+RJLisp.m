//
//  NSString+RJLisp.m
//  Lisp
//
//  Created by Robert Jones on 1/20/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "NSString+RJLisp.h"

@implementation NSString (RJLisp)

- (NSString *)encodeBackslash
{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
}

- (NSString *)decodeBackslash
{
    return [self stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
}

@end
