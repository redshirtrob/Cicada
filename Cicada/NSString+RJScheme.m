//
//  NSString+RJScheme.m
//  Cicada
//
//  Created by Robert Jones on 1/20/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "NSString+RJScheme.h"

@implementation NSString (RJScheme)

- (NSString *)encodeBackslash
{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
}

- (NSString *)decodeBackslash
{
    return [self stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
}

@end
