//
//  RJEval.h
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJInPort;
@class RJEnv;

@interface RJEval : NSObject

- (void)replWithPrompt:(NSString *)prompt inPort:(RJInPort *)inPort output:(NSFileHandle *)output;

- (id)eval:(id)sexp environment:(RJEnv *)environment error:(NSError **)error;

@end
