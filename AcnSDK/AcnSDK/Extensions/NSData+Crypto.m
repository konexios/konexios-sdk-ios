//
//  NSData+Extension.m
//  AcnSDK
//
//  Created by Alexey Chechetkin on 28.03.2018.
//  Copyright © 2018 Arrow. All rights reserved.
//

#import "NSData+Crypto.h"
#import "NSString+Crypto.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSData(AcnSDK)

- (NSString *)md5
{
    static unsigned char hash[CC_MD5_DIGEST_LENGTH];
    memset(hash, 0, sizeof(hash));
    
    CC_MD5(self.bytes, (CC_LONG)self.length, hash);
    
    return [NSString hexStringForChars:hash length:sizeof(hash)];
}

@end
