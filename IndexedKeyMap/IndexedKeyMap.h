
@import Foundation;
@import Cocoa;
typedef NSCellStateValue SocketState;

#define  PROTOCOL(X,...)    @protocol  X  <NSObject>   __VA_ARGS__
#define INTERFACE(X)        @interface X : NSObject + (instancetype)
#define    EXTEND(X)        @interface X ()
#define      VOID(X)        - (void) X;
#define TYPEDEF_V(X)        typedef void(^X)

#define IDXKMAP(...) [IndexedKeyMap mapKeysAndObjects:__VA_ARGS__,nil]



/*! @param Z rawSelector to match @param X forwarfing target for that selector */
#define MAP_SEL(X,Z)    [NSStringFromSelector(@selector(Z)) isEqualToString:NSStringFromSelector(sel)] ? X
#define MAP_SELS(X,...) ^id{ static NSArray *sels; return [(sels = sels ?: \
  [[@#__VA_ARGS__ stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]\
                      componentsSeparatedByString:@","]) containsObject:NSStringFromSelector(sel)] ? X : (id)nil; }()

#define FORWARDTO(X) - (id)forwardingTargetForSelector:(SEL)sel{ return (X)?X:[super forwardingTargetForSelector:sel]; }


#define ATMC 0
#define READ 1
#define COPY 2
#define NATM 3
#define WEAK 4
#define ASSN 5

#define PROP_READ property (readonly)
#define PROP_COPY property (copy)
#define PROP_NATM property (nonatomic)
#define PROP_WEAK property (weak)
#define PROP_ASSN property (assign)

#define PROP(X) !#X ? property : X== 1 ? PROP_READ : X==2 PROP_COPY : x==3 ? PROP_NATM : x==4 ? PROP_WEAK : PROP_ASSN



/*! Advertise your subsctriptability with these simple protocols! */

PROTOCOL(KeySubs,@optional)  - (void) setObject:(id)x      forKeyedSubscript:(id<NSCopying>)k;
                             -                  (id) objectForKeyedSubscript:(id)x;             @end

PROTOCOL(IndexSubs,@optional) - (void) setObject:(id)x      atIndexedSubscript:(NSUInteger)i;
                              -                  (id) objectAtIndexedSubscript:(NSUInteger)i;   @end

/*! An NSMutableDictionary, with the personality of an NSMutableArray! */
#define IndexedKeyMapExample IDXKMAP(@"Apple", @2, @"Bottom", NSColor.redColor, @"Jeans", self)

/*! NSLog ->  0 : [Apple]   = 2
              1 : [Bottom]  = NSCalibratedRGBColorSpace 1 0 0 1
              2 : [Jeans]   = <AppDelegate: 0x600000034820>             
*/
@interface IndexedKeyMap : NSObject <KeySubs, IndexSubs>

@PROP_READ NSArray *allKeys, *allValues;
@PROP_READ      id JSONRepresentation;

+ (instancetype) mapKeysAndObjects:(id)x, ... NS_REQUIRES_NIL_TERMINATION; // NO nil needed with IDXKMAP(...)
+ (instancetype) map:(id)d;

-   (id) reduce:(id)z with:(  id(^)(id k, id o, id sum, int x))b;
- (void)         enumerate:(void(^)(id k, id o, BOOL*s, int x))b;
@end


