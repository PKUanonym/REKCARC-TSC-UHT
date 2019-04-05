#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string>
#include <stdio.h>
using namespace std;
bool hasWay[21][21];
double way[21][21];
int ct[21];
int M, N;
int main() {
	char input[] = "input0.txt";
	char output[] = "output0.txt";
	for (int imm = 0; imm < 10; imm++) {
		input[5] = imm + '0';
		output[6] = imm + '0';
		if (freopen(input, "r", stdin) == NULL) {
			cout << "wrong";
		}
		freopen(output, "w", stdout);
		cin >> N >> M;
		cout << N << ' ' << M << "\n==========================\n";
		for (int j1 = 0; j1 < 21; j1++) {
			for (int j2 = 0; j2 < 21; j2++) {
				hasWay[j1][j2] = false;
				way[j1][j2] = 0;
			}
			ct[j1] = 0;
		}

		for (int j = 0; j < M; j++) {
			int u, v;
			double c;
			cin >> u >> v >> c;
			hasWay[u][v] = true;
			hasWay[v][u] = true;
			way[u][v] = c;
			way[v][u] = c;
		}

		for (int i1 = 1; i1 <= N; i1++) {
			cout << ' ' << i1 << endl;
		}
		fclose(stdin);
		fclose(stdout);
	}
	return 0;
}