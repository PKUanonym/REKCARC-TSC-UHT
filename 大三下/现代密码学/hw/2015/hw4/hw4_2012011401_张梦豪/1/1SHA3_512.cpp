#include<iostream>
#include<map>
#include<string>
#include<vector>
#include<cstdio>
#include<cstring>
#include<cassert>
#include<algorithm>

using namespace std;

const unsigned long long RC[24] = {  0x0000000000000001,
                                     0x0000000000008082,
                                     0x800000000000808A,
                                     0x8000000080008000,
                                     0x000000000000808B,
                                     0x0000000080000001,
                                     0x8000000080008081,
                                     0x8000000000008009,
                                     0x000000000000008A,
                                     0x0000000000000088,
                                     0x0000000080008009,
                                     0x000000008000000A,
                                     0x000000008000808B,
                                     0x800000000000008B,
                                     0x8000000000008089,
                                     0x8000000000008003,
                                     0x8000000000008002,
                                     0x8000000000000080,
                                     0x000000000000800A,
                                     0x800000008000000A,
                                     0x8000000080008081,
                                     0x8000000000008080,
                                     0x0000000080000001,
                                     0x8000000080008008 };

const unsigned long long r[5][5] = {{0, 36, 3, 41, 18},
                                    {1, 44, 10, 45, 2},
                                    {62, 6, 43, 15, 61},
                                    {28, 55, 25, 21, 56},
                                    {27, 20, 39, 8, 14}};


// Circular shift "x" left by "n" bits                                    
unsigned long long ROTL(const unsigned long long &x,int n)
{
    return ((x) << (n) | ((x) >> (64 - (n))));
}

// Converts a string of 0's and 1's to its equivalent character representation
unsigned char binary_to_char( const string& binary_string )
{
    assert( binary_string.size() == 8 );
	int res = 0;
	for ( size_t i = 0; i < binary_string.size(); i++ )
	{
        assert( binary_string[i] == '1' || binary_string[i] == '0' );
		res <<= 1;
		res += binary_string[i] - '0';
	}
	return ( unsigned char ) res;
}

// Converts a character into its equivalent binary representation of exactly 8 bits and append it to "binary"
void char_to_binary( const unsigned char& c, vector<bool>& binary )
{
	string res;
	unsigned int c_bak = c;
	int char_length = 8;
	while ( char_length-- )
	{
		res += ( char )( ( c_bak & 1 ) + '0' );
		c_bak >>= 1;
	}
	reverse( res.begin(), res.end() );
	for ( int i = 0; i < ( int )res.size(); i++ )
	{
		binary.push_back( res[i] == '1' ? true : false );
	}
}

// Converts an unsigned long long into its equivalent binary representation of exactly 64 bits
string ULL_to_binary( const unsigned long long& n )
{
	string res;
	unsigned long long n_bak = n;
	int ULL_size = 64;
	while ( ULL_size-- )
	{
		res += ( char )( ( n_bak & 1 ) + '0' );
		n_bak >>= 1;
	}
	reverse( res.begin(), res.end() );
	return res;
}

// Converts binary input of exactly 64 bits to its equivalent ULL representation
unsigned long long binary_to_ULL( const vector<bool>& binary )
{
	assert( binary.size() == 64 );
	unsigned long long res = 0;
	for ( size_t i = 0; i < binary.size(); i++ )
	{
		res <<= 1;
		res += binary[i];
	}
	return res;
}

// Converts a string of exactly 8 characters to its equivalent unsigned long long form
unsigned long long string_to_ULL( const string& s )
{
	assert( s.size() == 8 ); 
	vector<bool> s_binary;
	for ( int i = 0; i < ( int )s.size(); i++ )
	{
		char_to_binary( s[i], s_binary );
	}
	return binary_to_ULL( s_binary );
}

// Converts a binary string with size as a multiple of 4 of to its equivalent HEX form
string binary_to_HEX( const string& s )
{
	assert( s.size() % 4 == 0 );
	static map<string, char> bin_to_hex_mapping;
	bin_to_hex_mapping["0000"] = '0';
	bin_to_hex_mapping["0001"] = '1';
	bin_to_hex_mapping["0010"] = '2';
	bin_to_hex_mapping["0011"] = '3';
	bin_to_hex_mapping["0100"] = '4';
	bin_to_hex_mapping["0101"] = '5';
	bin_to_hex_mapping["0110"] = '6';
	bin_to_hex_mapping["0111"] = '7';
	bin_to_hex_mapping["1000"] = '8';
	bin_to_hex_mapping["1001"] = '9';
	bin_to_hex_mapping["1010"] = 'a';
	bin_to_hex_mapping["1011"] = 'b';
	bin_to_hex_mapping["1100"] = 'c';
	bin_to_hex_mapping["1101"] = 'd';
	bin_to_hex_mapping["1110"] = 'e';
	bin_to_hex_mapping["1111"] = 'f';
	string res;
	for ( size_t i = 0; i < s.size(); i += 4 )
	{
		assert( bin_to_hex_mapping.find( s.substr( i, 4 ) ) != bin_to_hex_mapping.end() );
		res += bin_to_hex_mapping[s.substr( i, 4 )];
	}
	return res;
}

// Reverses the order of bytes in the input string of exactly 8 characters
string toggle_endianness( const string& ull )
{
	assert( ull.size() == 8 );
	string ull_bak = ull;
	for ( int i = 0; i < 4; i++ )
	{
		swap( ull_bak[i], ull_bak[7 - i] );
	}
	return ull_bak;
}

// Reverses the order of bytes in the input
unsigned long long toggle_endianness( const unsigned long long& ull )
{
	string ull_binary = ULL_to_binary( ull );
	assert( ull_binary.size() == 64 );
	string ull_chars;
	for ( int i = 0; i < 64; i += 8 )
	{
		ull_chars += binary_to_char( ull_binary.substr( i, 8 ) );
	}
	assert( ull_chars.size() == 8 );
	ull_chars = toggle_endianness( ull_chars );
	return string_to_ULL( ull_chars );
}


void Round( vector<vector<unsigned long long> >& S, const int& RC_index )
{
	//  Theta Step
	vector<unsigned long long> C( 5 );
	for ( int i = 0; i < 5; i++ )
	{
		C[i] = S[i][0] ^ S[i][1] ^ S[i][2] ^ S[i][3] ^ S[i][4];
	}
	vector<unsigned long long> D( 5 );
	for ( int i = 0; i < 5; i++ )
	{
		D[i] = C[( i - 1 + 5 ) % 5] ^ ROTL( C[( i + 1 ) % 5], 1 );
	}
	for ( int i = 0; i < 5; i++ )
	{
		for ( int j = 0; j < 5; j++ )
		{
			S[i][j] ^= D[i];
		}
	}

	//Rho and pi steps
	vector<vector<unsigned long long> > B( 5, vector<unsigned long long> ( 5, 0 ) );
	for ( int i = 0; i < 5; i++ )
	{
		for ( int j = 0; j < 5; j++ )
		{
			B[j][( 2 * i + 3 * j ) % 5] = ROTL( S[i][j], r[i][j] );
		}
	}

	// Xi step
	for ( int i = 0; i < 5; i++ )
	{
		for ( int j = 0; j < 5; j++ )
		{
			S[i][j] = B[i][j] ^ ( ( ~B[( i + 1 ) % 5][j] ) & B[( i + 2 ) % 5][j] );
		}
	}

	// L step
	S[0][0] ^= RC[RC_index];
}

void KECCAK_f( vector<vector<unsigned long long> >& S )
{
	for ( int i = 0; i < 24; i++ )
	{
		Round( S, i );
	}
}

// Returns a block of 72 character ( 576 bits ) from the message
string get_message_block( const string& message, const int& block_index )
{
	return message.substr( block_index * 72, 72 );
}

// Pads the message such that its length is a mulitple of 576 bits ( 72 characters )
string pad_message( const string& message )
{
	string res = message;
	size_t remaining = 576 - ( ( message.size() * 8 ) % 576 );
	if ( remaining )
	{
		if ( remaining == 8 )
		{
			res += binary_to_char( "10000110" );
		}
		else
		{
			res += binary_to_char( "00000110" );
			res.append( ( remaining - 16 ) / 8, '\0' );
			res += binary_to_char( "10000000" );
		}
	}
	assert( res.size() && res.size() % 72 == 0 );
	return res;
}

string SHA3_512( string message )
{
    //message += (char)(0x40);
	message = pad_message( message );
	unsigned long long message_block_count = ( message.size() * 8 ) / 576;
	vector<vector<unsigned long long> > S( 5, vector<unsigned long long> ( 5, 0 ) );
	for ( size_t i = 0; i < message_block_count; i++ )
	{
		string block = get_message_block( message, i );
		for ( int y = 0; y < 5; y++ )
		{
			for ( int x = 0; x < 5; x++ )
			{
				if ( x + 5 * y < 9 )
				{
					S[x][y] ^= string_to_ULL( toggle_endianness( block.substr( ( x + 5 * y ) * 8, 8 ) ) );
				}
			}
		}
		KECCAK_f( S );
	}
	string digest;
	for ( int y = 0, k = 0; y < 5; y++ )
	{
		for ( int x = 0; x < 5; x++ )
		{
			if ( x + 5 * y < 9 && k < 8 )
			{
				digest += ULL_to_binary( toggle_endianness( S[x][y] ) );
				k++;
			}
		}
	}
	return digest;
}

int main()
{
	string str;
    cout<<"input a string:"<<endl;
    //cin>>str;
    //str="";
    for (int i=0;i<1000000;i++)
    {
        str+='a';
    }
	string digest = SHA3_512(str);
	cout << "SHA3_512:"<<binary_to_HEX( digest ) << endl;
    
    return 0;
}
