//
//  Helpers.h
//  Fitness
//
//  Created by Mani on 25.04.15.
//  Copyright (c) 2015 Mani. All rights reserved.
//

#pragma mark Util Helpers
#define STRINGIFY(x) #x

#pragma mark NSCoding Helpers
#define ENCODE_OBJ(x, c) [c encodeObject: x forKey:@STRINGIFY(x)]
#define DECODE_OBJ(x, c) x = [c decodeObjectForKey:@STRINGIFY(x)]

#define ENCODE_ENUM(x, c) [c encodeInt: (int)x forKey:@STRINGIFY(x)]
#define DECODE_ENUM(x, c) x = [c decodeIntForKey:@STRINGIFY(x)]