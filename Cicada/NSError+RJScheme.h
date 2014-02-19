//
//  NSError+RJScheme.h
//  Cicada
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ENUM(NSInteger, RJSchemeErrorCode) {
    RJSchemeParseError = -1,
    RJSchemeEvalError = -2,
};

extern NSString *const RJSchemeErrorStringKey;
extern NSString *const RJSchemeSymbolKey;

@interface NSError (RJScheme)

+ (id)rjlispParseErrorWithString:(NSString *)string;
+ (id)rjlispUnexpectedSymbolError:(NSString *)symbol;

+ (id)rjlispEvalErrorWithString:(NSString *)string;
+ (id)rjlispUnboundSymbolError:(NSString *)symbol;
+ (id)rjlispTooFewArgumentsErrorForSymbol:(NSString *)symbol atLeast:(long)atLeast got:(long)got;
+ (id)rjlispIncorrectNumberOfArgumentsErrorForSymbol:(NSString *)symbol expected:(long)expected got:(long)got;

- (NSString *)rjlispErrorString;

@end
