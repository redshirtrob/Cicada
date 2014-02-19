//
//  NSError+RJScheme.m
//  Cicada
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "NSError+RJScheme.h"

NSString *const RJSchemeErrorDomain = @"com.robertjones.rjscheme";

NSString *const RJSchemeErrorStringKey = @"errorString";
NSString *const RJSchemeSymbolKey = @"symbol";

@implementation NSError (RJScheme)

#pragma mark Parse Errors

+ (id)rjschemeParseErrorWithString:(NSString *)string
{
    return [NSError errorWithDomain:RJSchemeErrorDomain
                               code:RJSchemeParseError
                           userInfo:@{RJSchemeErrorStringKey : string}];
}

+ (id)rjschemeUnexpectedSymbolError:(NSString *)symbol
{
    return [NSError rjschemeParseErrorWithString:[NSString stringWithFormat:@"Error: unexpected symbol: '%@'", symbol]];
}

#pragma mark Eval Errors

+ (id)rjschemeEvalErrorWithString:(NSString *)string
{
    return [NSError errorWithDomain:RJSchemeErrorDomain
                               code:RJSchemeEvalError
                           userInfo:@{RJSchemeErrorStringKey : string}];
}

+ (id)rjschemeUnboundSymbolError:(NSString *)symbol
{
    return [NSError rjschemeEvalErrorWithString:[NSString stringWithFormat:@"Error: unbound symbol: '%@'", symbol]];
}

+ (id)rjschemeTooFewArgumentsErrorForSymbol:(NSString *)symbol atLeast:(long)atLeast got:(long)got
{
    return [NSError rjschemeEvalErrorWithString:[NSString stringWithFormat:@"Error %@: too few arguments (at least: %ld got: %ld)", symbol, atLeast, got]];
}

+ (id)rjschemeIncorrectNumberOfArgumentsErrorForSymbol:(NSString *)symbol expected:(long)expected got:(long)got
{
    return [NSError rjschemeEvalErrorWithString:[NSString stringWithFormat:@"Error %@: incorrect number of arguments (expected: %ld got: %ld)", symbol, expected, got]];
}

#pragma mark Instance Methods

- (NSString *)rjschemeErrorString
{
    return self.userInfo[RJSchemeErrorStringKey];
}

@end
