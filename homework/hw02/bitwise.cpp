#include <iostream>
#include <string>

using namespace std;

string decimalToBinary(int num)
{
    string str;
      while(num){
      if(num & 1) // 1
        str+='1';
      else // 0
        str+='0';
      num>>=1; // Right Shift by 1 
    }   
      return str;
}

// 5
unsigned int toggleBit2(unsigned int x) {
    return x ^ 2;
}

// 6
unsigned int flipOffBit5(unsigned int x) {
    return x & ~(1 << 4);
}

// 7
unsigned int repeatBitsThrice(unsigned int x) {
    return (x & 7) << 6 | (x & 7) << 3 | (x & 7);
}

// 8
bool detectBitPattern(unsigned int x) {
    int n = (x & 15 << 5) >> 5;
    // cout << decimalToBinary(n) << endl;
    return (x & 15 << 5) >> 5 == 9 | (x & 15 << 5) >> 5 == 13;
}


int main() {
    // 5
    cout << toggleBit2(90) << " " << toggleBit2(45) << endl;

    // 6
    cout << flipOffBit5(90) << " " << flipOffBit5(45) << endl;

    // 7
    cout << repeatBitsThrice(5) << endl;

    // 8
    cout << detectBitPattern(943) << " " << detectBitPattern(47) << endl;

    //9
    bool a = 2 && 5;
    int b = 2 & 5;

    cout << "a = " << a << endl;
    cout << "b = " << b << endl;

}