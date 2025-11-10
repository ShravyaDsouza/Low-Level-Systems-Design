#include <iostream>
#include <vector>
#include <string>
#define PI 3.14159

using namespace std;

struct Point {
    int x;
    int y;
};

class Circle {
private:
    double radius;
public:
    Circle(double r) : radius(r) {}
    double area() {
        return PI * radius * radius;
    }
};

enum Color { RED, GREEN, BLUE };

int add(int a, int b) {
    return a + b;
}

void printMessage(string msg) {
    cout << msg << endl;
}

int main() {
    int num = 10;
    float arr[5] = {1.2, 2.3, 3.4, 4.5, 5.6};
    bool flag = true;
    double *ptr = new double(5.0);
    Point p1;
    p1.x = 3;
    p1.y = 4;

    Circle c1(10.5);
    double area = c1.area();
    cout << "Area: " << area << endl;

    for (int i = 0; i < 5; ++i) {
        cout << arr[i] << " ";
    }

    if (flag && (num > 5)) {
        printMessage("Condition met!");
    } else {
        printMessage("Condition not met.");
    }

    delete ptr;
    return 0;
}
