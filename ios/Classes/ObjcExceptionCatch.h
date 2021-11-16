#import <Foundation/Foundation.h>

/// Swift doesn't have any mechanism to catch raised Obj-C NSExceptions.
/// This object will allow intercepting them, because we do have API that throws
/// this kind of exceptions.
///
/// https://stackoverflow.com/questions/32758811/catching-nsexception-in-swift
@interface ObjcExceptionCatch : NSObject

+ (BOOL)tryExecute:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
