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

+ (id)rjschemeParseErrorWithString:(NSString *)string;
+ (id)rjschemeUnexpectedSymbolError:(NSString *)symbol;

+ (id)rjschemeEvalErrorWithString:(NSString *)string;
+ (id)rjschemeUnboundSymbolError:(NSString *)symbol;
+ (id)rjschemeTooFewArgumentsErrorForSymbol:(NSString *)symbol atLeast:(long)atLeast got:(long)got;
+ (id)rjschemeIncorrectNumberOfArgumentsErrorForSymbol:(NSString *)symbol expected:(long)expected got:(long)got;

- (NSString *)rjschemeErrorString;

@end
