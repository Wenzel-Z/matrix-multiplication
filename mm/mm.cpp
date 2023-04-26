#include <iostream>
#include <string>
#include <random>
#include <omp.h>

using namespace std;

int main(int argc, char** argv)
{
    int N;
    bool exit = false;
    bool printFlag = false;
    const int seed = 1;
    if (argc == 1) {
        cout << "Please enter either one or two arguments.\n";
        exit = true;
    }
    else if (argc == 2) {
        N = std::stoi(argv[1]);
    } 
    else if (argc == 3) {
        N = std::stoi(argv[1]);
        if ((argv[2] == std::string("Y")) || (argv[2] == std::string("y")) || (argv[2] == std::string("1"))) {
            printFlag = true;
        }
    } 
    if (!exit)
    {
        // Initialize
        int **result = new int*[N];
        int **matrix1 = new int*[N];
        int **matrix2 = new int*[N];
        for (int i = 0; i < N; i++) {
            matrix1[i] = new int[N];
            matrix2[i] = new int[N];
            result[i] = new int[N];
        }

        // Random Engine
        std::mt19937 engine(seed);
        std::uniform_int_distribution<int> dist(0, 100);

        // Populate
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                result[i][j] = 0;
                #ifdef TEST
                    matrix1[i][j] = 1;
                    matrix2[i][j] = 1;
                #else
                    matrix1[i][j] = dist(engine);
                    matrix2[i][j] = dist(engine);
                #endif
            }
        }

        double start;
        double end;
        start = omp_get_wtime();
        // Multiply
        #pragma omp parallel for
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                for (int k = 0; k < N; k++) {
                    result[i][j] = result[i][j] + (matrix1[i][k] * matrix2[k][j]);
                }
            }
        }
        end = omp_get_wtime();
        cout << "total time " << end - start << "\n"; // Print time spent in parallel region

        // Print
        if (printFlag) {
            cout << "Result matrix is\n";
            for (int i = 0; i < N; i++) {
                for (int j = 0; j < N; j++) {
                    cout << result[i][j] << " ";
                }
                cout << "\n";
            }
        }

        // Deallocate
        for (int i = 0; i < N; i++) {
            delete[] matrix1[i];
            delete[] matrix2[i];
            delete[] result[i];
        }
        delete[] matrix1;
        delete[] matrix2;
        delete[] result;
    }
    return 0;
}
