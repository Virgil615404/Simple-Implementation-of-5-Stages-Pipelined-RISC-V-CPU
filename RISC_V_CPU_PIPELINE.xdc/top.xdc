## Clock input
set_property PACKAGE_PIN R2 [get_ports clk]          ;# 改成你板子的时钟脚
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name sys_clk -period 10.000 [get_ports clk]   ;# 100MHz

## Reset input
set_property PACKAGE_PIN C2 [get_ports rst_n]        ;# 改成你板子的复位脚
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## Optional: ignore async reset timing in datapath analysis
set_false_path -from [get_ports rst_n]