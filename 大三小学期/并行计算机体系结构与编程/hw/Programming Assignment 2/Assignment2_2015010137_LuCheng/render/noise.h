#ifndef __NOISE_H__
#define __NOISE_H__


void vec2CellNoise(float location[3], float result[2], int index);

void getNoiseTables(int** permX, int** permY, float** value1D);

#endif
