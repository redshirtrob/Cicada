//
//  NSError+RJLisp.m
//  Lisp
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "NSError+RJLisp.h"

NSString *const RJLispErrorDomain = @"com.robertjones.rjlisp";

NSString *const RJLispErrorStringKey = @"errorString";
NSString *const RJLispSymbolKey = @"symbol";

@implementation NSError (RJLisp)

#pragma mark Parse Errors

+ (id)rjlispParseErrorWithString:(NSString *)string
{
    return [NSError errorWithDomain:RJLispErrorDomain
                               code:RJLispParseError
                           userInfo:@{RJLispErrorStringKey : string}];
}

+ (id)rjlispUnexpectedSymbolError:(NSString *)symbol
{
    return [NSError rjlispParseErrorWithString:[NSString stringWithFormat:@"Error: unexpected symbol: '%@'", symbol]];
}

#pragma mark Eval Errors

+ (id)rjlispEvalErrorWithString:(NSString *)string
{
    return [NSError errorWithDomain:RJLispErrorDomain
                               code:RJLispEvalError
                           userInfo:@{RJLispErrorStringKey : string}];
}

+ (id)rjlispUnboundSymbolError:(NSString *)symbol
{
    return [NSError rjlispEvalErrorWithString:[NSString stringWithFormat:@"Error: unbound symbol: '%@'", symbol]];
}

+ (id)rjlispTooFewArgumentsErrorForSymbol:(NSString *)symbol atLeast:(long)atLeast got:(long)got
{
    return [NSError rjlispEvalErrorWithString:[NSString stringWithFormat:@"Error %@: too few arguments (at least: %ld got: %ld)", symbol, atLeast, got]];
}

+ (id)rjlispIncorrectNumberOfArgumentsErrorForSymbol:(NSString *)symbol expected:(long)expected got:(long)got
{
    return [NSError rjlispEvalErrorWithString:[NSString stringWithFormat:@"Error %@: incorrect number of arguments (expected: %ld got: %ld)", symbol, expected, got]];
}

#pragma mark Instance Methods

- (NSString *)rjlispErrorString
{
    return self.userInfo[RJLispErrorStringKey];
}

@end
