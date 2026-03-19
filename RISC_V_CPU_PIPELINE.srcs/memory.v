module memory(
    input CLK,
    input WRn,
    input RDn,
    input [4:0] addr,
    input [31:0] DIN,
    output reg [31:0] DOUT
);
    reg [31:0] memory_unit[0:31];
    always @(posedge CLK) begin
        if (WRn) memory_unit[addr] <= DIN;
    end
    always @(*) begin
        if (RDn)
            DOUT = memory_unit[addr];
        else
            DOUT = 32'd0;
    end
endmodule