//
//  StringCrypto.m
//  AcnSDK
//
//  Created by Alexey Chechetkin on 07/02/2018.
//  Copyright © 2018 Arrow. All rights reserved.
//

#import "NSString+Crypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString(Crypto)

- (NSString *) sha256
{
    static unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    memset(hash, 0, sizeof(hash));
   
    // data.bytes is const void *
    CC_SHA256(data.bytes, (CC_LONG)data.length, hash);
    
    return [NSString hexStringForChars:hash length:sizeof(hash)];
}

+ (NSString *)hexStringForChars:(unsigned char *)chars length:(NSUInteger)length
{
    NSMutableString *res = [NSMutableString string];
    
    for( NSUInteger i = 0; i < length; i++ ) {
        [res appendFormat:@"%02x", chars[i]];
    }
    
    return res;
}

- (NSString *)hmacForKey:(NSString *)key
{
    static unsigned char result[CC_SHA256_DIGEST_LENGTH];
    
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long len = strlen(str);
    
    const char *strKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long keyLen = strlen(strKey);

    CCHmac(kCCHmacAlgSHA256, strKey, keyLen, str, len, result);
 
    return [NSString hexStringForChars:result length:sizeof(result)];
}

- (NSString *)hmacForKeyData:(NSData *)dataKey
{
    static unsigned char result[CC_SHA256_DIGEST_LENGTH];
    
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long len = strlen(str);
    
    CCHmac(kCCHmacAlgSHA256, dataKey.bytes, dataKey.length, str, len, result);
    
    NSData *data = [NSData dataWithBytes:result length:sizeof(result)];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    return [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
}

@end
