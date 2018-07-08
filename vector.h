//
//  VectorMath.h
//  TODO: lets replace this with apples hardware optimmized implementation.
//
//  Created by johndavis on 12/29/15.
//  Copyright © 2015 Good Lamb. All rights reserved.
//

#ifndef VectorMath_h
#define VectorMath_h


#import <SceneKit/SceneKit.h>

#pragma TODO: refactor into referential arguments

SCNVector3 transform( const float (*m)[3], const SCNVector3 v );
float dot( const SCNVector3 v, const SCNVector3 w );
float reciprocalSquared( float f );
SCNVector3 scale(float scalar, SCNVector3 vec);
SCNVector3 normalized( const SCNVector3 v );
SCNVector3 add( SCNVector3 a, SCNVector3 b);
SCNVector3 inverseTransform( const float (*m)[3], const SCNVector3 v );
SCNVector3 cross( const SCNVector3 v, const SCNVector3 w );

void MatriceMultiply( float out[3][3], const float a[3][3], const float b[3][3] );
void transpose( float out[3][3], const float in[3][3] );
void MatriceToQuat( float destQuat[ 4 ], const float srcMatrix[ 3 ][ 3 ] );


#endif /* VectorMath_h */

