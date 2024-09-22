#include <fstream>
#include <string>
#include <vector>
#include <sstream>
int main() {
    std::ifstream file("a.txt");
    std::string str;
    std::getline(file, str);
    // split into vector<int>
    std::vector<int> vec;
    std::istringstream iss(str);
    int number;
    while (cin >> number) {
        vec.push_back(number);
    }
    return 0;
}
