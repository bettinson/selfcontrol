//
//  SCDaemonXPC.m
//  selfcontrold
//
//  Created by Charlie Stigler on 5/30/20.
//

#import "SCDaemonXPC.h"
#import "version-header.h"
#import "SCDaemonBlockMethods.h"
#import "SCXPCAuthorization.h"

@implementation SCDaemonXPC

- (void)startBlockWithControllingUID:(uid_t)controllingUID blocklist:(NSArray<NSString*>*)blocklist isAllowlist:(BOOL)isAllowlist endDate:(NSDate*)endDate blockSettings:(NSDictionary*)blockSettings authorization:(NSData *)authData reply:(void(^)(NSError* error))reply {
    NSLog(@"XPC method called: startBlockWithControllingUID");
    
    NSError* error = [SCXPCAuthorization checkAuthorization: authData command: _cmd];
    if (error != nil) {
        NSLog(@"ERROR: XPC authorization failed due to error %@", error);
        reply(error);
        return;
    } else {
        NSLog(@"AUTHORIZATION ACCEPTED for startBlock with authData %@ and command %s", authData, sel_getName(_cmd));
    }

    [SCDaemonBlockMethods startBlockWithControllingUID: controllingUID blocklist: blocklist isAllowlist:isAllowlist endDate: endDate blockSettings:blockSettings authorization: authData reply: reply];
}

- (void)updateBlocklistWithControllingUID:(uid_t)controllingUID newBlocklist:(NSArray<NSString*>*)newBlocklist authorization:(NSData *)authData reply:(void(^)(NSError* error))reply {
    NSLog(@"XPC method called: updateBlocklistWithControllingUID");
    
    NSError* error = [SCXPCAuthorization checkAuthorization: authData command: _cmd];
    if (error != nil) {
        NSLog(@"ERROR: XPC authorization failed due to error %@", error);
        reply(error);
        return;
    } else {
        NSLog(@"AUTHORIZATION ACCEPTED for updateBlocklist with authData %@ and command %s", authData, sel_getName(_cmd));
    }
    
    [SCDaemonBlockMethods updateBlocklist: controllingUID newBlocklist: newBlocklist authorization: authData reply: reply];
}

- (void)updateBlockEndDateWithControllingUID:(uid_t)controllingUID newEndDate:(NSDate*)newEndDate authorization:(NSData *)authData reply:(void(^)(NSError* error))reply {
    NSLog(@"XPC method called: updateBlockEndDateWithControllingUID");
    
    NSError* error = [SCXPCAuthorization checkAuthorization: authData command: _cmd];
    if (error != nil) {
        NSLog(@"ERROR: XPC authorization failed due to error %@", error);
        reply(error);
        return;
    } else {
        NSLog(@"AUTHORIZATION ACCEPTED for updateBlockENdDate with authData %@ and command %s", authData, sel_getName(_cmd));
    }
    
    [SCDaemonBlockMethods updateBlockEndDate:controllingUID newEndDate: newEndDate authorization: authData reply: reply];
}

- (BOOL) checkup {
    NSLog(@"XPC method called: checkup");

    // no authorization needed to run a checkup

    return YES;
}

// Part of the HelperToolProtocol.  Returns the version number of the tool.  Note that never
// requires authorization.
- (void)getVersionWithReply:(void(^)(NSString * version))reply {
    NSLog(@"XPC method called: getVersionWithReply");
    // We specifically don't check for authorization here.  Everyone is always allowed to get
    // the version of the helper tool.
    reply(SELFCONTROL_VERSION_STRING);
}

@end
