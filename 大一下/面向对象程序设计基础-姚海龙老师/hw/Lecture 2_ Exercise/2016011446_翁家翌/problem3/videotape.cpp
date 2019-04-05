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
#include "videotape.h"

Video::Video(std::string name)
{
	this->name = name;
	is_out = 0;
}

void Video::rent(std::string customer)
{
	if (is_out == 1)
	{
		std::cout << "This Video has been rent by " << this->customer << ", sorry!" << std::endl;
		return;
	}
	is_out = 1;
	this->customer = customer;
	std::cout << customer << " has successfully rent \"" << this->name << "\"!" << std::endl;
}

void Video::back(std::string customer)
{
	if(is_out == 0)
	{
		std::cout << "You don't need to return this video because it hasn't been rent yet!" << std::endl;
		return;
	}
	if(this->customer != customer)
	{
		std::cout << "You don't need to return this video because it has been rent by " << this->customer << "." << std::endl;
		return;
	}
	is_out = 0;
	std::cout << customer <<" has successfully send it back!" << std::endl;
}

void Stack::add(std::string name)
{
	Video d = Video(name);
	v.push_back(d);
}
void Stack::print()
{
	std::cout << std::endl;
	int cnt = 1;
	for (std::vector<Video>::iterator i = v.begin(); i != v.end(); ++i, ++cnt)
	{
		std::cout << "ID: " << cnt << "\tVideo name: \"" << (*i).name << "\",\t";
		if((*i).is_out)
			std::cout << "has been rent by " << (*i).customer << "." << std::endl;
		else
			std::cout << "hasn't been rent." << std::endl;
	}
	std::cout << std::endl;
}
void Stack::require(std::string name, std::string customer)
{
	for (std::vector<Video>::iterator i = v.begin(); i != v.end(); ++i)
		if ((*i).name == name && (*i).is_out == 0)
		{
			(*i).rent(customer);
			return;
		}
	std::cout << "Sorry, we don't have this video." << std::endl;
}
void Stack::sendback(std::string name, std::string customer)
{
	for (std::vector<Video>::iterator i = v.begin(); i != v.end(); ++i)
		if ((*i).name == name && (*i).is_out == 1 && (*i).customer == customer)
		{
			(*i).back(customer);
			return;
		}
	std::cout << "There must be something wrong." << std::endl;
}
