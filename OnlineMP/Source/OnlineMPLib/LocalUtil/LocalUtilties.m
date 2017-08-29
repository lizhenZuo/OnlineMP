//
//  LocalUtilties.m
//  HiPandaParentLib
//
//  Created by MAC20151009A on 16/9/14.
//  Copyright © 2016年 HiPandaParent. All rights reserved.
//

#import "LocalUtilties.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <MobClick.h>
#import "zlib.h"

@implementation LocalUtilties
+ (NSString *)dicToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData)
    {
        jsonString = @"";
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSDictionary *)jsonStringToDict:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSArray *)jsonStringToArray:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

+ (NSString *)arrayToJsonString:(NSArray *)array
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData)
    {
        jsonString = @"";
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;

}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)stringFromTime:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSDate *)timeFromString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)base64EncodeWithString:(NSString *)originStr
{
    NSString *encodeStr = nil;
    if(originStr)
    {
        NSData *originData = [originStr dataUsingEncoding:NSUTF8StringEncoding];
        encodeStr = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    return encodeStr;
}

+ (NSString *)base64DecodeWithString:(NSString *)encodeStr
{
    NSString *decodeStr = nil;
    if (encodeStr)
    {
        NSData  *decodeData = [[NSData alloc] initWithBase64EncodedString:encodeStr options:0];
        decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    }
    return decodeStr;
}

+ (NSString *)sha1CodeWith:(NSString *)password passwordSeed:(NSString *)passwordSeed
{
    password = [passwordSeed stringByAppendingString:password];
    //    NSString *newPassword = [NSString stringWithFormat:@"%@%@", passwordSeed,password];
    //    newPassword = @"DkS911QpsAkS0J1tU1234567";
    const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:password.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *password_1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i ++)
    {
        [password_1 appendFormat:@"%02x", digest[i]];
    }
    
    return password_1;
}

+ (NSString *)encodeUseDES3:(NSString *)plainText key:(NSString *)key
{
    //    uint8_t * bufferPtr = NULL;
    //    size_t bufferPtrSize = 0;
    //    bufferPtrSize = (dataLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    //    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    //    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t movedBytes = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySize3DES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &movedBytes);
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes];
        ciphertext = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    //  if (bufferPtr) free(bufferPtr);
    
    return ciphertext;
}

+ (NSString *)getDeviceOpenUDID
{
    NSString *deviceID = nil;
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return deviceID;
}

// 日期获取星期
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects:NSLocalizedString(@"星期天", nil), NSLocalizedString(@"星期一", nil), NSLocalizedString(@"星期二", nil), NSLocalizedString(@"星期三", nil), NSLocalizedString(@"星期四", nil), NSLocalizedString(@"星期五", nil), NSLocalizedString(@"星期六", nil), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];;
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    NSString *weekString = [weekdays objectAtIndex:theComponents.weekday - 1];
    return weekString;
}

+ (NSData *)uncompressGZippedData:(NSData *)compressedData
{
    
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
        {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END)
        {
            done = YES;
        }
        else if (status != Z_OK)
        {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else
    {
        return nil;
    }
}

@end
