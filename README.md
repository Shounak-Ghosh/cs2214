# cs2214
Fall '23 Computer Architecture w/ Prof. Ratan Dey


## Verilog/GTKwave installation (Mac)
1. Install Homebrew
2. `brew install iverilog`
3. `brew install --cask gtkwave`
4. [Further instructions for Perl Switch module](https://ughe.github.io/2018/11/06/gtkwave-osx)
### Compilation
Given `test.v` (Circuit design file) and `test_tb.v1` (bechmark test file)
```
iverilog -o test.vvp test_tb.v
vvp test.vvp
```
This generates a `test.vcd` file which can be used for waveform analysis

### Waveform Analysis
1. run `gtkwave` (`gtkwave test.vcd` doe not seem to work)
2. Open a new tab (file menu/⌘T), select `test.vcd`
3. Select circuit in SST window
4. Select all components that appear (should match `test.v` file)
5. Either highlight and double click to view select waveforms or recursive import --> Append for all available waveforms
6. Select Time --> Zoom --> Zoom Best Fit
7. Red box or x means unknown value

### Synthesis

1. `brew install yosys`
2. Create `synth.ys` file ex:
``` 
read_verilog test.v
hierarchy; proc; opt; techmap; opt
write_verilog synth.v
show -format ps -prefix synth
```
3. This should generate `synth.v` and `synth.ps` files. The `.ps` file is a visual representation of the circuit and can be viewed with `open synth.ps`. The `.v` file is the gate-level Verilog circuit that can be used to generate hardware. 