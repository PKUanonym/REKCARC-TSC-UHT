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

#ifndef __VIDEO_H__
#define __VIDEO_H__

#include <string>

class Video
{
public:
	std::string name;
	bool is_out;
	std::string customer;
	Video(std::string name);
	void rent(std::string customer);
	void back(std::string customer);
};

class Stack
{
	std::vector<Video> v;
public:
	void add(std::string name);
	void print();
	void require(std::string name, std::string customer);
	void sendback(std::string name, std::string customer);
};

#endif //__VIDEO_H__

