//
//  RJScheme.h
//  Cicada
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^lambda)(NSArray *, NSError **);

@class RJInPort;
@class RJEnv;

@interface RJScheme : NSObject

+ (NSString *)toString:(id)exp;

- (void)replWithPrompt:(NSString *)prompt inPort:(RJInPort *)inPort output:(NSFileHandle *)output;
- (id)eval:(id)sexp environment:(RJEnv *)environment error:(NSError **)error;
- (void)loadFile:(NSString *)filename;
- (id)evalString:(NSString *)string error:(NSError **)error;

// Test harness: calls through to evalString:error: and then stringifies the result
- (NSString *)testEvalWithString:(NSString *)string error:(NSError **)error;

@end
