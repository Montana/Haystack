//
//  UIColor+Create.m
//

#import "UIColor+Create.h"

@implementation UIColor (Create)

+ (UIColor *)hay_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [UIColor hay_colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)hay_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:alpha];
}

+ (UIColor *)hay_colorWithHex:(NSString *)hex
{
    //
    // Test for hash on start, remove it if necessary
    //
    
    if ([hex characterAtIndex:0] == '#')
    {
        hex = [hex substringFromIndex:1];
    }
    
    unsigned alphaInt = 0;
    
    if ([hex length] == 8)
    {
        NSString *alphaHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
        
        NSScanner *rScanner = [NSScanner scannerWithString:alphaHex];
        [rScanner scanHexInt:&alphaInt];
        
        hex = [hex substringFromIndex:2];
    }
    else if ([hex length] == 6)
    {
        alphaInt = 255;
    }
    else
    {
        return nil;
    }
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(0, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(2, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(4, 2)]];
    
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor hay_colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alphaInt / 255.0];
}

+ (UIColor *)hay_colorWithObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        UIColor* color = [self hay_colorWithName:object];
        
        if (color)
        {
            return color;
        }
        
        return [self hay_colorWithHex:object];
    }
    else if ([object isKindOfClass:[UIColor class]])
    {
        return object;
    }
    
    return nil;
}

+ (UIColor *)hay_colorWithName:(NSString *)name
{
    id color = [self hay_colorObjectWithName:name];
    
    if ([color isKindOfClass:[NSArray class]])
    {
        return [color firstObject];
    }
    else if ([color isKindOfClass:[UIColor class]])
    {
        return color;
    }
    
    return nil;
}

+ (NSArray *)hay_colorsWithName:(NSString *)name
{
    id color = [self hay_colorObjectWithName:name];
    
    if ([color isKindOfClass:[NSArray class]])
    {
        return color;
    }
    
    return nil;
}

+ (id)hay_colorObjectWithName:(NSString *)name
{
    NSString* string = name;
    
    //
    // If there is a color in the string, we make sure it is correct
    //
    
    if ([string rangeOfString:@"Color" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        string = [string stringByReplacingOccurrencesOfString:@"Colors" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
        
        string = [string stringByReplacingOccurrencesOfString:@"Color" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    }
    
    //
    // Append color again in correct capitals
    //
    
    NSString* selectorString = [NSString stringWithFormat:@"%@Color", string];
    
    //
    // Try if UIColor responds to hay_name
    //
    
    SEL selector = NSSelectorFromString(selectorString);
    
    if ([UIColor respondsToSelector:selector])
    {
        id color = [UIColor performSelector:selector];
        
        if (color == nil)
        {
            selectorString = [NSString stringWithFormat:@"%@Colors", string];
            
            //
            // Try if UIColor responds to hay_name
            //
            
            selector = NSSelectorFromString(selectorString);
            
            color = [UIColor performSelector:selector];
        }
        
        return color;
    }
    
    return nil;
}

@end
