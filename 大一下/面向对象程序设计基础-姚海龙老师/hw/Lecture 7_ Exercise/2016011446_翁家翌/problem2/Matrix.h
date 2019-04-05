#ifndef __MATRIX_H__
#define __MATRIX_H__

#include <fstream>
class Matrix
{
	int n, m;
	int**mat;
	void shape();
	void show_in(std::ostream&output, int cas = 0)const;
public:
	Matrix();
	Matrix(int _n, int _m);
	Matrix(const char*filename);
	~Matrix();
	void load(const char*filename);
	void display()const;
	void display_product()const;
	void save_product(const char*filename)const;
	Matrix multiply(Matrix&b);
};

#endif //__MATRIX_H__