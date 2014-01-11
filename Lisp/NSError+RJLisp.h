//
//  NSError+RJLisp.h
//  Lisp
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ENUM(NSInteger, RJLispErrorCode) {
    RJLispParseError = -1,
    RJLispEvalError = -2,
};

extern NSString *const RJLispErrorStringKey;
extern NSString *const RJLispSymbolKey;

@interface NSError (RJLisp)

+ (id)rjlispParseErrorWithString:(NSString *)string;
+ (id)rjlispUnexpectedSymbolError:(NSString *)symbol;

+ (id)rjlispEvalErrorWithString:(NSString *)string;
+ (id)rjlispUnboundSymbolError:(NSString *)symbol;
+ (id)rjlispTooFewArgumentsErrorForSymbol:(NSString *)symbol atLeast:(long)atLeast got:(long)got;
+ (id)rjlispIncorrectNumberOfArgumentsErrorForSymbol:(NSString *)symbol expected:(long)expected got:(long)got;

- (NSString *)rjlispErrorString;

@end
