/*
CS-UY 2214
Adapted from Jeff Epstein
Starter code for E20 simulator
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
void load_machine_code(ifstream &f, u_int16_t mem[]) {
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
void print_state(unsigned pc, u_int16_t regs[], uint16_t memory[], size_t memquantity) {
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
    u_int16_t pc = 0;
    uint16_t regs[NUM_REGS] = {0}; // all registers are initialized to 0
    uint16_t memory[MEM_SIZE] = {0}; // all memory is initialized to 0

    //Load f and parse using load_machine_code
    load_machine_code(f, memory);

    bool halt = false;
    while (!halt) { 
        
        // decode current instruction, if possible
        u_int16_t line = memory[pc];
        u_int16_t opcode = line >> 13;

        if (opcode == 0) {
            u_int16_t regA = (line >> 10) & 7; // bits 10-12
            u_int16_t regB = (line >> 7) & 7; // bits 7-9
            u_int16_t regDst = (line >> 4) & 7; // bits 4-6
            u_int16_t imm = line & 15; // bits 0-3

            if (imm == 0) { // add
                regs[regDst] = regs[regA] + regs[regB];
                pc += 1;
            }
            else if (imm == 1) { // sub
                regs[regDst] = regs[regA] - regs[regB];
                pc += 1;
            }
            else if (imm == 2) { // or
                regs[regDst] = regs[regA] | regs[regB];
                pc += 1;
            }
            else if (imm == 3) { // and
                regs[regDst] = regs[regA] & regs[regB];
                pc += 1;
            }
            else if (imm == 4) { // slt
                regs[regDst] = regs[regA] < regs[regB] ? 1 : 0;
                pc += 1;
            }
            else if (imm == 8) { // jr
                pc = regs[regA];
            }
            else {
                cerr << "Invalid instruction" << endl;
            }
        }
        else if (opcode == 1)  { // addi
            u_int16_t regSrc = (line >> 10) & 7; // bits 10-12
            u_int16_t regDst = (line >> 7) & 7; // bits 7-9
            u_int16_t imm = line & 127; // bits 0-6
            // sign extend 7 bit immediate to 16 bits
            if (imm & 64) imm |= 0xFF80; //TODO check if this works
            regs[regDst] = regs[regSrc] + imm;
            pc += 1;
            cout << "addi " << regSrc << "(" << regs[regSrc] << ") " << regDst << "(" << regs[regDst] << ") "  << endl;
        }
        else if (opcode == 2) { // j
            u_int16_t imm = line & 8191; // bits 0-12
            // check for halt
            if (pc == imm) {
                cout << "halt" << endl;
                halt = true;
                break;
            }
            cout << "j " << imm << endl;
            pc = imm;
        }
        else if (opcode == 3) { // jal
            u_int16_t imm = line & 8191; // bits 0-12
            regs[7] = pc + 1;
            pc = imm;
        }
        else if (opcode == 4) { // lw
            u_int16_t regAddr = (line >> 10) & 7; // bits 10-12
            u_int16_t regDst = (line >> 7) & 7; // bits 7-9
            u_int16_t imm = line & 127; // bits 0-6
            // sign extend 7 bit immediate to 16 bits
            if (imm & 64) imm |= 0xFF80;
            regs[regDst] = memory[regs[regAddr] + imm];
            pc += 1;
        }
        else if (opcode == 5) { // sw
            u_int16_t regAddr = (line >> 10) & 7; // bits 10-12
            u_int16_t regSrc = (line >> 7) & 7; // bits 7-9
            u_int16_t imm = line & 127; // bits 0-6
            // sign extend 7 bit immediate to 16 bits
            if (imm & 64) imm |= 0xFF80;
            memory[regs[regAddr] + imm] = regs[regSrc];
            pc += 1;
        }
        else if (opcode == 6) { // jeq
            cout << "jeq" << endl;
            u_int16_t regA = (line >> 10) & 7; // bits 10-12
            u_int16_t regB = (line >> 7) & 7; // bits 7-9
            u_int16_t rel_imm = line & 127; // bits 0-6
            // sign extend 7 bit immediate to 16 bits
            if (rel_imm & 64) rel_imm |= 0xFF80;
            pc = regs[regA] == regs[regB] ? pc + 1 + rel_imm : pc + 1;
        }
        else if (opcode == 7) { // slti
            u_int16_t regSrc = (line >> 10) & 7; // bits 10-12
            u_int16_t regDst = (line >> 7) & 7; // bits 7-9
            u_int16_t imm = line & 127; // bits 0-6
            // sign extend 7 bit immediate to 16 bits
            if (imm & 64) imm |= 0xFF80;
            regs[regDst] = regs[regSrc] < imm ? 1 : 0;
            pc += 1;
            cout << "slti " << regSrc << "(" << regs[regSrc] << ") " << regDst << "(" << regs[regDst] << ") "  << endl;
        }
        else { // .fill or error
            break;
        }
        
       
        // switch(opcode) {
        //     case 0: { // add, sub, or, and, slt, jr 
        //         unsigned regA = (line >> 10) & 7; // bits 10-12
        //         unsigned regB = (line >> 7) & 7; // bits 7-9
        //         unsigned regDst = (line >> 4) & 7; // bits 4-6
        //         unsigned imm = line & 15; // bits 0-3
                
        //         switch (imm) {
        //             case 0: { // add
        //                 regs[regDst] = regs[regA] + regs[regB];
        //                 pc += 1;
        //             }
        //             case 1: { // sub
        //                 regs[regDst] = regs[regA] - regs[regB];
        //                 pc +=1;
        //             }
        //             case 2: { // or
        //                 regs[regDst] = regs[regA] | regs[regB];
        //                 pc += 1;
        //             }
        //             case 3: { // and
        //                 regs[regDst] = regs[regA] & regs[regB];
        //                 pc += 1;
        //             }
        //             case 4: { // slt
        //                 regs[regDst] = regs[regA] < regs[regB] ? 1 : 0;
        //                 pc += 1;
        //             }
        //             case 8: { // jr
        //                 pc = regs[regA];
        //             }
        //             default: // error
        //                 cerr << "Invalid instruction" << endl;
        //         }
        //     }
        //     case 1: { // addi
        //         unsigned regSrc = (line >> 10) & 7; // bits 10-12
        //         unsigned regDst = (line >> 7) & 7; // bits 7-9
        //         unsigned imm = line & 127; // bits 0-6
        //         // sign extend 7 bit immediate to 16 bits
        //         if (imm & 64) imm |= 0xFF80; //TODO check if this works
        //         regs[regDst] = regs[regSrc] + imm;
        //         pc += 1;
        //     }
        //     case 2: { // j
        //         unsigned imm = line & 8191; // bits 0-12
        //         // check for halt
        //         if (pc == imm) {
        //             halt = true;
        //             break;
        //         }
        //         pc = imm;
        //     }
        //     case 3: { // jal
        //         unsigned imm = line & 8191; // bits 0-12
        //         regs[7] = pc + 1;
        //         pc = imm;
        //     }
        //     case 4: { // lw
        //         unsigned regAddr = (line >> 10) & 7; // bits 10-12
        //         unsigned regDst = (line >> 7) & 7; // bits 7-9
        //         unsigned imm = line & 127; // bits 0-6
        //         // sign extend 7 bit immediate to 16 bits
        //         if (imm & 64) imm |= 0xFF80; 
        //         regs[regDst] = memory[regs[regAddr] + imm];
        //         pc += 1;
        //     }
        //     case 5: { // sw
        //         unsigned regAddr = (line >> 10) & 7; // bits 10-12
        //         unsigned regSrc = (line >> 7) & 7; // bits 7-9
        //         unsigned imm = line & 127; // bits 0-6
        //         // sign extend 7 bit immediate to 16 bits
        //         if (imm & 64) imm |= 0xFF80;
        //         memory[regs[regAddr] + imm] = regs[regSrc];
        //         pc += 1;
        //     }
        //     case 6: { // jeq
        //         unsigned regA = (line >> 10) & 7; // bits 10-12
        //         unsigned regB = (line >> 7) & 7; // bits 7-9
        //         unsigned rel_imm = line & 127; // bits 0-6
        //         // sign extend 7 bit immediate to 16 bits
        //         if (rel_imm & 64) rel_imm |= 0xFF80;
        //         pc = regs[regA] == regs[regB] ? pc + rel_imm : pc + 1;
        //     }
        //     case 7: { // slti 
        //         unsigned regSrc = (line >> 10) & 7; // bits 10-12
        //         unsigned regDst = (line >> 7) & 7; // bits 7-9
        //         unsigned imm = line & 127; // bits 0-6
        //         // sign extend 7 bit immediate to 16 bits
        //         if (imm & 64) imm |= 0xFF80;
        //         regs[regDst] = regs[regSrc] < imm ? 1 : 0;
        //     }
        //     default: // .fill or error
        //         break;
        // }

    }

    // Print the final state of the simulator before ending, using print_state
    print_state(pc, regs, memory, 128);

    return 0;
}
//ra0Eequ6ucie6Jei0koh6phishohm9
