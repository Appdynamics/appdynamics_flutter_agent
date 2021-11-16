#import "ObjcExceptionCatch.h"

@implementation ObjcExceptionCatch

+ (BOOL)tryExecute:(nonnull void(NS_NOESCAPE^)(void))tryBlock error:(__autoreleasing NSError * _Nullable * _Nullable)error {
  @try {
    tryBlock();
    return YES;
  }
  @catch (NSException *exception) {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    if (exception.userInfo != NULL) {
      userInfo = [[NSMutableDictionary alloc] initWithDictionary:exception.userInfo];
    }
    if (exception.reason != nil) {
      if (![userInfo.allKeys containsObject:NSLocalizedFailureReasonErrorKey]) {
        [userInfo setObject:exception.reason forKey:NSLocalizedFailureReasonErrorKey];
      }
    }
    *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:userInfo];
    return NO;
  }
}

@end
