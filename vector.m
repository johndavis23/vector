//
//  VectorMath.m
//  RedFez
//
//  Created by johndavis on 12/29/15.
//  Copyright © 2015 Good Lamb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vector.h"

SCNVector3 transform( const float (*m)[3], const SCNVector3 v )
{
    SCNVector3 o;
    o.x = v.x * m[0][0] + v.y * m[0][1] + v.z * m[0][2];
    o.y = v.x * m[1][0] + v.y * m[1][1] + v.z * m[1][2];
    o.z = v.x * m[2][0] + v.y * m[2][1] + v.z * m[2][2];
    return o;
}

float dot( const SCNVector3 v, const SCNVector3 w )
{
    return v.x*w.x+v.y*w.y+v.z*w.z;
}

float reciprocalSquared( float f )
{
    return 1.0f / sqrtf(f);
}

#pragma error REFACTOR TO SIMD?
SCNVector3 scale(float scalar, SCNVector3 vec)
{
    SCNVector3 v = SCNVector3Make(vec.x,vec.y,vec.z);
    v.x *= scalar;
    v.y *= scalar;
    v.z *= scalar;
    return v;
}

SCNVector3 normalized( const SCNVector3 v )
{
    return scale(reciprocalSquared(dot(v, v)), v) ;
}

SCNVector3 add( SCNVector3 a, SCNVector3 b)
{
    SCNVector3 c = SCNVector3Make(0.0f, 0.0f, 0.0f);
    c.x = a.x + b.x;
    c.y = a.y + b.y;
    c.z = a.z + b.z;
    return c;
}

SCNVector3 inverseTransform( const float (*m)[3], const SCNVector3 v )
{
    SCNVector3 o = SCNVector3Make(0.0f, 0.0f, 0.0f);
    o.x = v.x * m[0][0] + v.y * m[1][0] + v.z * m[2][0];
    o.y = v.x * m[0][1] + v.y * m[1][1] + v.z * m[2][1];
    o.z = v.x * m[0][2] + v.y * m[1][2] + v.z * m[2][2];
    return o;
}


void MatriceMultiply( float out[3][3], const float a[3][3], const float b[3][3] )
{
    float temp[3][3];
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            temp[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
        }
    }
    memcpy( out, temp, sizeof(temp) );
}

SCNVector3 cross( const SCNVector3 v, const SCNVector3 w )
{
    return SCNVector3Make( v.y*w.z - w.y*v.z, w.x*v.z - v.x*w.z, v.x*w.y - w.x*v.y );
}

void transpose( float out[3][3], const float in[3][3] )
{
    float temp[3][3];
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            temp[i][j] = in[j][i];
        }
    }
    memcpy( out, temp, sizeof(temp) );
}

void matriceToQuat( float destQuat[ 4 ], const float srcMatrix[ 3 ][ 3 ] )

{
    double      trace, s;
    int         i, j, k;
    static int  next[3] = {1, 2, 0};
    
    trace = srcMatrix[0][0] + srcMatrix[1][1]+ srcMatrix[2][2];
    
    if (trace > 0.0) {
        s = sqrt(trace + 1.0);
        destQuat[3] = s * 0.5;
        s = 0.5 / s;
        
        destQuat[0] = (srcMatrix[2][1] - srcMatrix[1][2]) * s;
        destQuat[1] = (srcMatrix[0][2] - srcMatrix[2][0]) * s;
        destQuat[2] = (srcMatrix[1][0] - srcMatrix[0][1]) * s;
    } else { //well this is expensive
        i = 0;
        if (srcMatrix[1][1] > srcMatrix[0][0])
            i = 1;
        if (srcMatrix[2][2] > srcMatrix[i][i])
            i = 2;
        j = next[i];
        k = next[j];
        
        s = sqrt( (srcMatrix[i][i] - (srcMatrix[j][j]+srcMatrix[k][k])) + 1.0 );
        destQuat[i] = s * 0.5;
        
        s = 0.5 / s;
        
        destQuat[3] = (srcMatrix[k][j] - srcMatrix[j][k]) * s;
        destQuat[j] = (srcMatrix[j][i] + srcMatrix[i][j]) * s;
        destQuat[k] = (srcMatrix[k][i] + srcMatrix[i][k]) * s;
    }
}

