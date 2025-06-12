#pragma once
#include <iostream>
#include <vector>
using namespace std;

template<class T, int N> class MultiArray {
public:
	T* _data;
	vector<int> _dims;

	MultiArray(){
		_data = new T[0];
		_dims = vector<int>(N, 0);
	}
	
	~MultiArray(){
		delete[] _data;
	}

	MultiArray(const MultiArray& other){
		vector<int> dims = other._dims;
		vector<T> data;
		int len = 1;
		for(int i=0;i<N;++i){
			len *= dims[i];
		}
		for(int i=0;i<len;++i){
			data.push_back(other._data[i]);
		}

		if(data.empty()){
			_dims = dims;
			int len = 1;
			for(int i=0;i<dims.size();++i){
				len *= dims[i];
			}

			_data = new T[len];
			for(int i=0;i<len;++i){
				_data[i] = T();
			}
		} else if(dims.empty()){
			_dims = vector<int>(N, 0);
			_dims[0] = data.size();
			for(int i=0;i<data.size();++i){
				_data[i] = data[i];
			}
		} else {
			_dims = dims;
			_data = new T[data.size()];
		
			for(int i=0;i<data.size();++i){
				_data[i] = data[i];
			}
		}
	}
	
	MultiArray(const vector<int> &dims, const vector<T> &data = vector<T>()){
		if(data.empty()){	
			_dims = dims;		
			int len = 1;
			for(int i=0;i<dims.size();++i){
				len *= dims[i];
			}

			_data = new T[len];
			for(int i=0;i<len;++i){
				_data[i] = T();
			}
		} else if(dims.empty()){
			_dims = vector<int>(N, 0);
			_dims[0] = data.size();
			for(int i=0;i<data.size();++i){
				_data[i] = data[i];
			}
		} else {
			_dims = dims;
			_data = new T[data.size()];
		
			for(int i=0;i<data.size();++i){
				_data[i] = data[i];
			}
		}
	}
	
	int get_idx(const vector<int>& idx) const {
		int _idx = 0;
		int temp = 1;
		for(int i=0;i<N;++i){
			_idx += idx[N-i-1]*temp;
			temp *= _dims[N-i-1];
		} return _idx;
	}

	vector<int> get_idx_vec(const int& idx) const {
		vector<int> _idx(N, 0);
		int rem = idx;
		for(int i=0;i<N;++i) {
			int dim = _dims[N-i-1];
			_idx[N-i-1] = rem % dim;
			rem /= dim;
		}
		return _idx;
	}

	void set(const vector<int> &idx, const T &val){
		int _idx = get_idx(idx);
		_data[_idx] = val;
	}
	
	T& get(const vector<int> &idx){
		int _idx = get_idx(idx);
		return _data[_idx];
	}
	
	vector<int>& get_dims(){
		return _dims;
	}

	template<int M> bool operator ==(const MultiArray<T,M> &other) const{
		if(M!=N){
			return false;
		}

		for(int i=0;i<N;++i){
			if(_dims[i] != other._dims[i]){
				return false;
			}
		}

		int len = 1;
		for(int i=0;i<N;++i){
			len *= _dims[i];
		}

		for(int i=0;i<len;++i){
			if(_data[i] != other._data[i]){
				return false;
			}
		}

		return true;
	}
	
	template<int M> bool operator !=(const MultiArray<T,M> &other) const{
		if(M!=N){
			return true;
		}

		for(int i=0;i<N;++i){
			if(_dims[i] != other._dims[i]){
				return true;
			}
		}

		int len = 1;
		for(int i=0;i<N;++i){
			len *= _dims[i];
		}

		for(int i=0;i<len;++i){
			if(_data[i] != other._data[i]){
				return true;
			}
		}

		return false;
	}
	
	MultiArray& operator=(const MultiArray<T, N> &other){
		if(this!=&other){
			_dims = other._dims;
			delete[] _data;
			
			int len = 1;
			for(int i=0;i<N;++i){
				len *= _dims[i];
			}

			_data = new T[len];

			for(int i=0;i<len;++i){
				_data[i] = other._data[i];	
			}
		}

		return *this;
	}

	class Iterator {
	public:
		const MultiArray* _arr;
		int _idx;

		Iterator(const MultiArray* arr, int idx){
			_arr = arr;
			_idx = idx;
		}

		~Iterator(){}
		
		T operator*() const{
			return _arr->_data[_idx];
		}
		
		Iterator& operator++(){
			++_idx;
			return *this;
		}
		
		Iterator operator++(int){
			Iterator new_ite(_arr, _idx);
			++_idx;
			return new_ite;
		}
		
		bool operator!=(const Iterator& other) const{
			return (_idx!=other._idx) || (_arr!=other._arr);
		}
		
		bool operator==(const Iterator& other) const{
			return (_idx==other._idx) && (_arr==other._arr);
		}
		
		Iterator& operator=(const Iterator& other){
			_arr = other.	_arr;
			_idx = other._idx;
			return *this;
		}
	};
	
	Iterator begin() const{
		return Iterator(this, 0);
	}
	
	Iterator end() const{
		int len = 1;
		for(int i=0;i<N;++i){
			len *= _dims[i];
		} return Iterator(this, len);
	}

	auto operator[] (const int &idx);
	auto operator[] (const int &idx) const;

	void reshape(const vector<int> &dims2);
	void resize(const vector<int> &dims2);
};

template<class T, int N>
std::ostream& operator <<(std::ostream& out, const MultiArray<T, N>& a){
	int len = 1;
	
	for(int i=0;i<N;++i){
		len *= a._dims[i];
	}

	for(int i=0;i<len;++i){
		std::vector<int> _index = a.get_idx_vec(i);
		for(int j=0;j<N;++j){
			out<<"["<<_index[j]<<"]";
		} out<<" = "<<a._data[i];
		if(i!=len-1){
			out<<"\n";
		}
	}

	return out;
}