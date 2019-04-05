#include "Matrix.h"

#include <iostream>

/**
 * [Matrix::shape description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * create int[n][m] into int**mat
 */
void Matrix::shape()
{
	mat = new int*[n];
	for (int i = 0; i < n; i++)
		mat[i] = new int[m];
}
Matrix::Matrix(): n(0), m(0) {}
/**
 * [Matrix::shape description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * create int[_n][_m] into int**mat and set all elements to 0
 */
Matrix::Matrix(int _n, int _m): n(_n), m(_m)
{
	shape();
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			mat[i][j] = 0;
}
/**
 * [Matrix::load description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * @param    filename   [load data from this file]
 */
void Matrix::load(const char*filename)
{
	std::ifstream input(filename);
	input >> n >> m;
	shape();
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			input >> mat[i][j];
}
Matrix::Matrix(const char*filename)
{
	load(filename);
}
Matrix::~Matrix()
{
	for (int i = 0; i < n; i++)
		delete[] mat[i];
	delete[] mat;
	n = m = 0;
}
/**
 * [Matrix::show_in description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * @param    output     [can be std::cout or one filename]
 * @param    cas        [0: output into screen; 1: output into file]
 */
void Matrix::show_in(std::ostream&output, int cas)const
{
	if (cas)
		output << n << " " << m << std::endl;
	else
		output << "n = " << n << ", m = " << m << std::endl;
	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < m; j++)
			output << mat[i][j] << "\t";
		output << std::endl;
	}
}
void Matrix::display()const
{
	show_in(std::cout);
	std::cout << "----------------------------------------------------------" << std::endl;
}
void Matrix::display_product()const//same as display()
{
	display();
}
void Matrix::save_product(const char*filename)const
{
	std::ofstream output(filename);
	show_in(output, 1);
}
/**
 * [Matrix::multiply description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * @return              [Matrix a multiply b]
 * c_{ij}=\sum_{k=0}^{a_m} a_{ik}\times b_{kj}
 * In this function, (*this) means matrix a above, and (*c) means matrix c above.
 */
Matrix Matrix::multiply(Matrix&b)
{
	if (m != b.n)
	{
		std::cerr << "Can not execute multiply operation!" << std::endl;
		return *this;
	}
	Matrix *c = new Matrix(n, b.m);
	for (int i = 0; i < n; i++)
		for (int k = 0; k < m; k++)
			for (int j = 0; j < b.m; j++)
				c->mat[i][j] += mat[i][k] * b.mat[k][j];
	return *c;
}
