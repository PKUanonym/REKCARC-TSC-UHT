/*
* Copyright (c) 2017 Trinkle
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

#ifndef __C5N8_H__
#define __C5N8_H__

class C5N8
{
	int private_i32;
	long long private_i64;
	char private_i8;
	float private_f32;
	double private_f64;
protected:
	int protected_i32;
	long long protected_i64;
	char protected_i8;
	float protected_f32;
	double protected_f64;
public:
	int public_i32;
	long long public_i64;
	char public_i8;
	float public_f32;
	double public_f64;
	void showMap();
};

#endif //__C5N8_H__

