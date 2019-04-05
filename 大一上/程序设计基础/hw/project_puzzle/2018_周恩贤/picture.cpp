#include <iostream>
using namespace std;
#include <stdio.h> /* fopen(), fwrite(), fread(), fclose() */

unsigned int W, H;
unsigned int components = 3;
unsigned char*origin_picture;
unsigned char*output_picture;

//BMP header : 
//[0] -->B
//[1] -->M 
//[2]、[3] --> 对齐   
bool read_picture(string path, unsigned char**pic, unsigned int*W, unsigned int*H){
	const char* s = path.c_str(); 
	//读图 
	FILE *fr = fopen(s , "r");
	if (!fr)
		return false;
	unsigned char BMP[14] = {0} ;  //BMP file header , 确保读进来的是BMP文件而没有损坏 
	unsigned char DIB[40] = {0} ;  //DIB header , 图像的详细讯息 
	unsigned char pad[3]; //额外填充字节 , 确保每一行为4的倍数 
	unsigned int w, h, x, y, i, padding;

	unsigned char *temp = NULL;
	fread(BMP, sizeof(BMP), 1, fr);
	fread(DIB, sizeof(DIB), 1, fr);
	
	//DIB header:	
	//[0]~[3] The size of this header
	//[4]~[7] --> w,  [8]~[11] --> h;
	w = (DIB[4] + (DIB[5] * 256) + (DIB[6] * 256 * 256) + (DIB[7] * 256 * 256 * 256));
	h = (DIB[8] + (DIB[9] * 256) + (DIB[10] * 256 * 256) + (DIB[11] * 256));
	if ((w > 0) && (h > 0)){
		temp = new unsigned char[w*h*3];
		//注意注意注意！倒着读！！！ 
		for (y = (h - 1); y != -1; y--){
			for (x = 0; x < w; x++){
				i = (x + y * w) * 3;
				fread(temp + i, 3, 1, fr);
				swap(temp[i], temp[i+2]); // BGR -> RGB
			}
			//padding
			int pad_of_each_row = (w*3) % 4;
			if (pad_of_each_row % 4 != 0)
				fread(pad, 1, 4-pad_of_each_row, fr);
		}
	}
	*W = w;
	*H = h;
	*pic = temp;
	fclose(fr);
	return true;
	
}

//PUZZLE -> PICTURE
bool puz_to_pic(int M, int N, int puzzle[], unsigned char** pic ,unsigned int W,unsigned int H){
	//变成 M*N个小块 ,每一个占 h*w , 把右下切掉	
	int h = H/M;   
	int w = W/N;   
	if(h*w == 0) //不够整除 
		return false;
	unsigned char* temp = new unsigned char[W*H*3];		
	for (int i=0; i<M*N; i++){
		int r = i/N; int c = i%N;
		int num = puzzle[i];
		if (num != -1){
			int r_p = (num-1)/N; int c_p = (num-1)%N;
			int dy = (r_p-r)*h;
			int dx = (c_p-c)*w;
			for (int x = c*w; x < c*w+w; x++){  
				for (int y = r*h; y < r*h+h; y++){
					for (int k=0; k<3; k++){ //RGB
						temp[(y*W+x)*3+k] = origin_picture[((y+dy)*W+(x+dx))*3+k];
					}
				}
			}
		}
	}
	//横黑线
	for(int i=1; i<M; i++){
		int y = i*h;
		for (int x=0; x<W; x++){
			for (int k=0; k<3; k++){
				temp[(y*W+x)*3+k] = '0';
			}
		} 
	} 
	//竖黑线
	for(int i=1; i<N; i++){
		int x = i*w;
		for (int y=0; y<H; y++){
			for (int k=0; k<3; k++){
				temp[(y*W+x)*3+k] = '0';
			}
		} 
	}
	*pic = temp;
	return true;
}


void save_picture(string path, unsigned char*pic, unsigned int W, unsigned int H) {
	const char* s = path.c_str(); 
	FILE *fw = fopen(s, "w");
	unsigned char BMP[14] = { 'B', 'M', 0, 0, 0, 0, 0, 0, 0, 0, 54, 0, 0, 0 };
	unsigned char DIB[40] = { 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 24, 0 };
	unsigned char pad[3] = {0};
	unsigned int size = 54 + W * H * 3; 
	unsigned int x, y, i,padding;
	unsigned char pix[3];
	BMP[2] = size;  
	BMP[3] = size / 256;
	BMP[4] = size / 256 / 256;
	BMP[5] = size / 256 / 256 / 256;
	DIB[4] = W;
	DIB[5] = W / 256;
	DIB[6] = W / 256 / 256;
	DIB[7] = W / 256 / 256 / 256;
	DIB[8] = H;
	DIB[9] = H / 256;
	DIB[10] = H / 256 / 256;
	DIB[11] = H / 256 / 256 / 256;
	fwrite(BMP, 14, 1, fw); 
	fwrite(DIB, 40, 1, fw);
	for (int y = H-1; y >= 0; y--){
		for (x = 0; x < W; x++){
			i = (x + y * W) * 3;
			for (int k=0; k<3; k++)
				pix[k]= pic[i+k];
			swap(pix[0],pix[2]);  // RGB -> BGR
			fwrite(pix, sizeof(pix), 1, fw);
		}
		//padding
		int pad_of_each_row = (W*3) % 4;
		if (pad_of_each_row % 4 != 0)
			fwrite(pad, 1, 4-pad_of_each_row, fw);
	 
	}
	cout << "Save Picture Success!" << endl;
	delete(pic);//养成释放记忆体的好习惯 
	fclose(fw);
}


void read_pic(){
	string s;
	cout << "\nPlease enter the path of the picture:\n";
	cout << "Please make sure it is a 24 bit-depth bmp file\n";
	cin >> s;
	int read_success = read_picture(s, &origin_picture, &W, &H);
	if (read_success)
		cout << "Read Picture Success!" << endl;
	else{
		cout << "Picture Not Found!" << endl;
		read_pic();
	}
} 

void save_pic(int M, int N,int puzzle[]){
	string s;
	cout << "Please enter your file name:" << endl;
	cin >> s;
	bool mark = puz_to_pic(M, N, puzzle, &output_picture, W, H);
	if (mark) 
		save_picture(s, output_picture, W, H);
	else 
		cout << "M,N is too large!" << endl;
}

/* 讀圖思路: 
int *origin_picture;
int w,h;
read_picture(,&origin_picure,&w,&h);

// M ,N puzzle[M*N]
int *temp = new int[w*h*3];
save_picture(,temp,w,h);
*/


