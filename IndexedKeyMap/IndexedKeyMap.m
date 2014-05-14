
#if __MAC_OS_X_VERSION_MIN_REQUIRED <= 1070
#warning This shit needs 10.8.  Get with it!
#endif

#import "IndexedKeyMap.h"

typedef   id(^IDX_Each) (id k, id o, id sum, int x);
typedef void(^IDX_Stop) (id k, id o, BOOL*s, int x);

@implementation IndexedKeyMap { NSMutableArray *keys, *objs; }

-           (id)    reduce:(id)r
                      with:(IDX_Each)b { __block __typeof(r) reducer = r;

   return !keys.count ? r : [self enumerate:^(id k, id o, BOOL *s, int x) { reducer = b(k,o, reducer,x); }], reducer;
}
-         (void) enumerate:(IDX_Stop)b { if (!keys.count) return; BOOL *stop = NO;

  for (id j in keys) if(!stop) b(j,objs[[keys indexOfObject:j]],stop,(int)[keys indexOfObject:j]);
}

+ (instancetype) map:(id)d        { IndexedKeyMap *n; return !!d && !!(n = self.class.new) ?

  [d = [d isKindOfClass:NSDictionary.class] ? d : ({
  [NSJSONSerialization isValidJSONObject:d] ? [NSJSONSerialization JSONObjectWithData:

           [d isKindOfClass:NSString.class] ? [(NSString*)d dataUsingEncoding:NSUTF8StringEncoding]
                                            : (id)d options:0|1|2 error:nil] : @{}; })
    enumerateKeysAndObjectsUsingBlock:^(id k,id o,BOOL *p){ [n->keys addObject:k]; [n->objs addObject:o]; }], n : nil;

}

+ (instancetype) mapKeysAndObjects:(id)x, ...   { if (!x) return nil; IndexedKeyMap *n = self.class.new;

  // 1st arg not part of varargs list, handle separately.  Start scan after firstObject.
  id each; va_list args; BOOL doKey = NO; [n->keys addObject:x]; va_start(args, x);

  // As many times as we can get an argument of type "id"
  while ((each = va_arg(args,id))) { [doKey ? n->keys : n->objs addObject:each];  doKey =! doKey; } va_end(args);

  return n;
}

-    (NSString*) description {  NSMutableString* str = @"\n".mutableCopy;

  return [self enumerate:^(id k, id o, BOOL *s, int x) { [str appendFormat:@"%i : [%@] = %@\n", x, k, o]; }], str;
}
-           (id)        init { return self = super.init ? keys = @[].mutableCopy, objs = @[].mutableCopy, self : nil; }


#pragma mark - Subscipting Protocol Implementation / Proxy

-         (void) setObject:(id)x
         forKeyedSubscript:(id<NSCopying>)k     {

  if ([keys containsObject:k]) [objs replaceObjectAtIndex:[keys indexOfObject:k] withObject:k];
  else { [keys addObject:k]; [objs addObject:x]; }
}
- (id) objectForKeyedSubscript:(id)x { return [keys containsObject:x] ? objs[[keys indexOfObject:x]] : nil; }

- (NSArray *)allKeys { return keys; } - (NSArray*) allValues { return objs; }
- (id) JSONRepresentation {

  return [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjects:objs forKeys:keys]
                                         options:NSJSONWritingPrettyPrinted error:nil];
}
// map subscripting getters
// FORWARDTO( MAP_SELS(objs, objectForKeyedSubscript:, objectAtIndexedSubscript:))
FORWARDTO( MAP_SEL(objs, objectAtIndexedSubscript:) : nil)

@end
