/*
CS-UY 2214
Adapted from Jeff Epstein
E20 Simulator (load_machine_code and print_state were provided)
sim.cpp
*/

#include <cstddef>
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <iomanip>
#include <regex>
#include <cstdlib>
#include <cstdint> // all our integers are unsigned 16 bit (uint16_t)

using namespace std;

// Some helpful constant values that we'll be using.
size_t const static NUM_REGS = 8;
size_t const static MEM_SIZE = 1<<13;
size_t const static REG_SIZE = 1<<16;

/*
    Loads an E20 machine code file into the list
    provided by mem. We assume that mem is
    large enough to hold the values in the machine
    code file.

    @param f Open file to read from
    @param mem Array represetnting memory into which to read program
*/
void load_machine_code(ifstream &f, uint16_t mem[]) {
    regex machine_code_re("^ram\\[(\\d+)\\] = 16'b(\\d+);.*$");
    size_t expectedaddr = 0;
    string line;
    while (getline(f, line)) {
        smatch sm;
        if (!regex_match(line, sm, machine_code_re)) {
            cerr << "Can't parse line: " << line << endl;
            exit(1);
        }
        size_t addr = stoi(sm[1], nullptr, 10);
        unsigned line = stoi(sm[2], nullptr, 2);
        if (addr != expectedaddr) {
            cerr << "Memory addresses encountered out of sequence: " << addr << endl;
            exit(1);
        }
        if (addr >= MEM_SIZE) {
            cerr << "Program too big for memory" << endl;
            exit(1);
        }
        expectedaddr ++;
        mem[addr] = line;
    }
}

/*
    Prints the current state of the simulator, including
    the current program counter, the current register values,
    and the first memquantity elements of memory.

    @param pc The final value of the program counter
    @param regs Final value of all registers
    @param memory Final value of memory
    @param memquantity How many words of memory to dump
*/
void print_state(uint16_t pc, uint16_t regs[], uint16_t memory[], size_t memquantity) {
    cout << setfill(' ');
    cout << "Final state:" << endl;
    cout << "\tpc=" <<setw(5)<< pc << endl;

    for (size_t reg=0; reg<NUM_REGS; reg++)
        cout << "\t$" << reg << "="<<setw(5)<<regs[reg]<<endl;

    cout << setfill('0');
    bool cr = false;
    for (size_t count=0; count<memquantity; count++) {
        cout << hex << setw(4) << memory[count] << " ";
        cr = true;
        if (count % 8 == 7) {
            cout << endl;
            cr = false;
        }
    }
    if (cr)
        cout << endl;
}

/**
    Main function
    Takes command-line args as documented below
*/
int main(int argc, char *argv[]) {
    /*
        Parse the command-line arguments
    */
    char *filename = nullptr;
    bool do_help = false;
    bool arg_error = false;
    for (int i=1; i<argc; i++) {
        string arg(argv[i]);
        if (arg.rfind("-",0)==0) {
            if (arg== "-h" || arg == "--help")
                do_help = true;
            else
                arg_error = true;
        } else {
            if (filename == nullptr)
                filename = argv[i];
            else
                arg_error = true;
        }
    }
    /* Display error message if appropriate */
    if (arg_error || do_help || filename == nullptr) {
        cerr << "usage " << argv[0] << " [-h] filename" << endl << endl;
        cerr << "Simulate E20 machine" << endl << endl;
        cerr << "positional arguments:" << endl;
        cerr << "  filename    The file containing machine code, typically with .bin suffix" << endl<<endl;
        cerr << "optional arguments:"<<endl;
        cerr << "  -h, --help  show this help message and exit"<<endl;
        return 1;
    }

    ifstream f(filename);
    if (!f.is_open()) {
        cerr << "Can't open file "<<filename<<endl;
        return 1;
    }

    // initialize pc, regs, memory
    uint16_t pc = 0;
    uint16_t regs[NUM_REGS] = {0}; // all registers are initialized to 0
    uint16_t memory[MEM_SIZE] = {0}; // all memory is initialized to 0

    //Load f and parse using load_machine_code
    load_machine_code(f, memory);

    bool halt = false;
    while (!halt) { 
        // decode current line, if possible
        uint16_t true_pos = pc % MEM_SIZE;
        uint16_t line = memory[true_pos];

        // extract all possible arguments
        uint16_t opcode = line >> 13;
        uint16_t imm13 = line & 8191; // bits 0-12
        uint16_t imm7 = line & 127; // bits 0-6
        uint16_t regA = (line >> 10) & 7; // bits 10-12
        uint16_t regB = (line >> 7) & 7; // bits 7-9
        uint16_t regC = (line >> 4) & 7; // bits 4-6
        uint16_t func = line & 15; // bits 0-3

        switch (opcode) {
            case 0: {
                switch (func) {
                    case 0: { // add
                        regs[regC] = regs[regA] + regs[regB];
                        pc++;
                        break;
                    }
                    case 1: { // sub
                        regs[regC] = regs[regA] - regs[regB];
                        pc++;
                        break;
                    }
                    case 2: { // or
                        regs[regC] = regs[regA] | regs[regB];
                        pc++;                       
                        break;
                    }
                    case 3: { // and
                        regs[regC] = regs[regA] & regs[regB];
                        pc++;
                        break;
                    }
                    case 4: { // slt
                        regs[regC] = (regs[regA] < regs[regB]) ? 1 : 0;
                        pc++;
                        break;
                    }
                    case 8: { // jr
                        pc = regs[regA];
                        break;
                    }
                }
                if (regC == 0) regs[0] = 0; // $0 is always 0
                break;
            }
            case 1: { // addi
                // sign extend 7 bit immediate to 16 bits
                if (imm7 & 64) imm7 |= 0xFF80;
                regs[regB] = regs[regA] + imm7;
                if (regB == 0) regs[0] = 0; // $0 is always 0
                pc++;
                break;
            }
            case 2: { // j
                if (pc == imm13) halt = true; // tight loop, halt
                pc = imm13;
                break;
            }
            case 3: { // jal
                regs[7] = pc + 1;
                pc = imm13;
                break;
            }
            case 4: { // lw
                // sign extend 7 bit immediate to 16 bits
                if (imm7 & 64) imm7 |= 0xFF80;
                regs[regB] = memory[(regs[regA] + imm7) % MEM_SIZE];
                if (regB == 0) regs[0] = 0; // $0 is always 0
                pc++;
                break;
            }
            case 5: { // sw
                // sign extend 7 bit immediate to 16 bits
                if (imm7 & 64) imm7 |= 0xFF80;
                memory[(regs[regA] + imm7) % MEM_SIZE] = regs[regB];
                pc++;
                break;
            }
            case 6: { // jeq
                // sign extend 7 bit immediate to 16 bits
                if (imm7 & 64) imm7 |= 0xFF80;
                pc = (regs[regA] == regs[regB]) ? pc + 1 + imm7 : pc + 1;
                break;
            }
            case 7: { //slti
                // sign extend 7 bit immediate to 16 bits
                if (imm7 & 64) imm7 |= 0xFF80;
                regs[regB] = (regs[regA] < imm7) ? 1 : 0;
                if (regB == 0) regs[0] = 0; // $0 is always 0
                pc++;
                break;
            }
        }
    }

    // Print the final state of the simulator before ending, using print_state
    print_state(pc, regs, memory, 128);
    return 0;
}
//ra0Eequ6ucie6Jei0koh6phishohm9
