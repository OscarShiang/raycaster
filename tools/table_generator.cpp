#include <cctype>
#include <fstream>
#include <iostream>
#include <string>

#include "precalculator.h"

using namespace std;

void generate_table(string filename, string data)
{
    fstream out(filename, ios::out);
    string macro_id;
    for (int i = 0; i < filename.length(); i++) {
    }

    char marcro_id[filename.length() + 1];
    for (int i = 0; i < filename.length(); i++) {
        switch (filename[i]) {
        case '.':
            marcro_id[i] = '_';
            break;
        default:
            marcro_id[i] = toupper(filename[i]);
        }
    }
    marcro_id[filename.length()] = '\0';
    string macro(marcro_id);

    /* Add dependencies */
    out << "#include \"raycaster.h\""
        << "\n\n";

    /* Add protect marco */
    out << "#ifndef " << macro << '\n';
    out << "#define " << macro << "\n\n";

    out << data;

    out << "#endif /* " << macro << " */" << '\n';

    out.close();
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        cout << "[ERR] Output filename is needed" << endl;
        exit(-1);
    }

    string filename(argv[1]);

    RayCasterPrecalculator calculator;
    string data = calculator.Precalculate();

    generate_table(filename, data);

    return 0;
}
