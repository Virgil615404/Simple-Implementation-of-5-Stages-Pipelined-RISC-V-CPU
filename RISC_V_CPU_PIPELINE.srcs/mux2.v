module mux2(
  memtoreg,
  jal     ,
  instruct,
  out1      ,                           //memory output data
  out2      ,                           //ALUresult
  out3      ,   						  //PC+4
  writedata
);
input [1:0]memtoreg;
input jal     ;
input [31:0]instruct;
input [31:0]out1;
input [31:0]out2;
input [9:0 ]out3;
 
output reg [31:0]writedata;
 
wire PC_plus_4;
assign PC_plus_4 = out3 + 10'd4;
 
always@(*)
 if(jal == 1'b1)
  writedata = {22'b0,PC_plus_4};
 else if(memtoreg == 2'b01)
  writedata = out1;  
 else if(memtoreg == 2'b11) 
  writedata = {instruct[31:12],12'b0};
  else 
  writedata = out2;
endmodule