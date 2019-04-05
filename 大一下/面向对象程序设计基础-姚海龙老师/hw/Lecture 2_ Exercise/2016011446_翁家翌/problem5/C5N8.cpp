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

#include <bits/stdc++.h>
#include "C5N8.h"

#define PR(a) std::cout << "Type name: " << #a << "    \tAddress: " << (int*)&a << std::endl;

void C5N8::showMap()
{
	PR(private_i32);
	PR(private_i64);
	PR(private_i8);
	PR(private_f32);
	PR(private_f64);
	PR(protected_i32);
	PR(protected_i64);
	PR(protected_i8);
	PR(protected_f32);
	PR(protected_f64);
	PR(public_i32);
	PR(public_i64);
	PR(public_i8);
	PR(public_f32);
	PR(public_f64);
}
