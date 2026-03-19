module top(
    input clk,
    input rst_n,
    output [31:0] instruct,
    output [9:0] address,
    output [31:0] ALU_result,
    output [4:0] rd_address
);

    // -----------------------------------------------------------------
    // 信号定义
    // -----------------------------------------------------------------
    // IF阶段
    wire [9:0] PC;
    wire [31:0] instr_if;

    // IF/ID
    wire [31:0] instr_id;
    wire [9:0] PC_id;

    // ID阶段组合输出
    wire branch_id, memread_id, memwrite_id, ALUsrc_id, regwrite_id, jal_id, jalr_id;
    wire [1:0] memtoreg_id, ALUop_id;
    wire [31:0] read_data1_id, read_data2_id, imm_id;

    // ID/EX
    wire regwrite_ex, memread_ex, memwrite_ex, ALUsrc_ex, branch_ex, jal_ex, jalr_ex;
    wire [1:0] memtoreg_ex, ALUop_ex;
    wire [31:0] read_data1_ex, read_data2_ex, imm_ex, instr_ex;
    wire [4:0] rs1_ex, rs2_ex, rd_ex;
    wire [9:0] PC_ex;

    // EX阶段内部
    wire [3:0] alu_ctrl;
    wire [31:0] alu_src1, alu_src2, write_data_ex;
    wire [31:0] alu_result_ex;
    wire alu_zero_ex;
    wire [9:0] branch_target_ex;
    wire branch_taken_ex;

    // EX/MEM
    wire regwrite_mem, memread_mem, memwrite_mem, branch_mem, jal_mem;
    wire [1:0] memtoreg_mem;
    wire [31:0] alu_result_mem, write_data_mem, instr_mem;
    wire [4:0] rd_mem;
    wire [9:0] PC_mem;
    wire branch_taken_mem;
    wire [9:0] branch_target_mem;

    // MEM阶段
    wire [31:0] mem_data_mem;

    // MEM/WB
    wire regwrite_wb;
    wire [1:0] memtoreg_wb;
    wire jal_wb;
    wire [31:0] mem_data_wb, alu_result_wb, instr_wb;
    wire [4:0] rd_wb;
    wire [9:0] PC_wb;

    // WB阶段
    wire [31:0] write_data_wb;

    // 转发
    wire [1:0] forwardA, forwardB;

    // 冒险
    wire stall, flush_id;

    // -----------------------------------------------------------------
    // IF阶段
    // -----------------------------------------------------------------
    PC_reg u_PC_reg (
        .clk          (clk),
        .rst_n        (rst_n),
        .branch_target(branch_target_mem),
        .branch_taken (branch_taken_mem),
        .stall        (stall),
        .PCout        (PC)
    );
    assign address = PC;

    Instruction_Memory u_inst_mem (
        .ReadAddress(PC),
        .Instruction(instr_if)
    );
    assign instruct = instr_if;

    IF_ID u_if_id (
        .clk      (clk),
        .rst_n    (rst_n),
        .flush    (flush_id),
        .stall    (stall),
        .instr_in (instr_if),
        .PC_in    (PC),
        .instr_out(instr_id),
        .PC_out   (PC_id)
    );

    // -----------------------------------------------------------------
    // ID阶段
    // -----------------------------------------------------------------
    register u_reg (
        .clk            (clk),
        .rst_n          (rst_n),
        .regwrite       (regwrite_wb),
        .write_register (rd_wb),
        .write_data     (write_data_wb),
        .read_register1 (instr_id[19:15]),
        .read_data1     (read_data1_id),
        .read_register2 (instr_id[24:20]),
        .read_data2     (read_data2_id)
    );

    control u_control (
        .instruction(instr_id[6:0]),
        .branch     (branch_id),
        .memread    (memread_id),
        .memtoreg   (memtoreg_id),
        .ALUop      (ALUop_id),
        .memwrite   (memwrite_id),
        .ALUsrc     (ALUsrc_id),
        .regwrite   (regwrite_id),
        .jal        (jal_id),
        .jalr       (jalr_id)
    );

    immgen u_immgen (
        .instruct (instr_id),
        .immediate(imm_id)
    );

    hazard_detection u_hazard (
        .ID_rs1     (instr_id[19:15]),
        .ID_rs2     (instr_id[24:20]),
        .EX_rd      (rd_ex),
        .EX_memread (memread_ex),
        .stall      (stall)
    );

    assign flush_id = branch_taken_mem;

    ID_EX u_id_ex (
        .clk            (clk),
        .rst_n          (rst_n),
        .flush          (branch_taken_mem),
        .stall          (stall),
        .regwrite_in    (regwrite_id),
        .memtoreg_in    (memtoreg_id),
        .memread_in     (memread_id),
        .memwrite_in    (memwrite_id),
        .ALUsrc_in      (ALUsrc_id),
        .ALUop_in       (ALUop_id),
        .branch_in      (branch_id),
        .jal_in         (jal_id),
        .jalr_in        (jalr_id),
        .read_data1_in  (read_data1_id),
        .read_data2_in  (read_data2_id),
        .imm_in         (imm_id),
        .rs1_in         (instr_id[19:15]),
        .rs2_in         (instr_id[24:20]),
        .rd_in          (instr_id[11:7]),
        .PC_in          (PC_id),
        .instr_in       (instr_id),
        .regwrite_out   (regwrite_ex),
        .memtoreg_out   (memtoreg_ex),
        .memread_out    (memread_ex),
        .memwrite_out   (memwrite_ex),
        .ALUsrc_out     (ALUsrc_ex),
        .ALUop_out      (ALUop_ex),
        .branch_out     (branch_ex),
        .jal_out        (jal_ex),
        .jalr_out       (jalr_ex),
        .read_data1_out (read_data1_ex),
        .read_data2_out (read_data2_ex),
        .imm_out        (imm_ex),
        .rs1_out        (rs1_ex),
        .rs2_out        (rs2_ex),
        .rd_out         (rd_ex),
        .PC_out         (PC_ex),
        .instr_out      (instr_ex)
    );

    // -----------------------------------------------------------------
    // EX阶段
    // -----------------------------------------------------------------
    ALUcontrol u_aluctl (
        .ALUop          (ALUop_ex),
        .instruction    (instr_ex),      // 使用来自ID/EX的完整指令
        .control_signal (alu_ctrl)
    );

    forwarding_unit u_fwd (
        .EX_rs1     (rs1_ex),
        .EX_rs2     (rs2_ex),
        .MEM_rd     (rd_mem),
        .WB_rd      (rd_wb),
        .MEM_regwrite(regwrite_mem),
        .WB_regwrite(regwrite_wb),
        .forwardA   (forwardA),
        .forwardB   (forwardB)
    );

    // ALU源操作数选择
    assign alu_src1 = (forwardA == 2'b10) ? alu_result_mem :
                      (forwardA == 2'b01) ? write_data_wb :
                      read_data1_ex;

    // 第二操作数（可能转发，也可能来自立即数）
    wire [31:0] alu_src2_pre = (forwardB == 2'b10) ? alu_result_mem :
                               (forwardB == 2'b01) ? write_data_wb :
                               read_data2_ex;
    assign alu_src2 = ALUsrc_ex ? imm_ex : alu_src2_pre;

    // 存储数据（用于SW等）也需要转发，独立于ALU的第二操作数
    assign write_data_ex = (forwardB == 2'b10) ? alu_result_mem :
                           (forwardB == 2'b01) ? write_data_wb :
                           read_data2_ex;

    ALU u_alu (
        .control_signal(alu_ctrl),
        .read_data1    (alu_src1),
        .read_data2    (alu_src2),       // 注意：原ALU内部会根据ALU_src选择，但此处已外部选择，故固定ALU_src=0
        .immediate     (imm_ex),
        .ALU_src       (1'b0),            // 外部已选择
        .ALU_result    (alu_result_ex),
        .ALU_zero      (alu_zero_ex)
    );

    wire [31:0] jalr_target_full = alu_src1 + imm_ex;
    assign branch_target_ex = jalr_ex ? {jalr_target_full[9:1], 1'b0} : (PC_ex + imm_ex[9:0]);
    assign branch_taken_ex = jalr_ex | (branch_ex & alu_zero_ex);

    EX_MEM u_ex_mem (
        .clk               (clk),
        .rst_n             (rst_n),
        .flush             (branch_taken_mem),
        .stall             (1'b0),
        .regwrite_in       (regwrite_ex),
        .memtoreg_in       (memtoreg_ex),
        .memread_in        (memread_ex),
        .memwrite_in       (memwrite_ex),
        .branch_in         (branch_ex),
        .jal_in            (jal_ex),
        .ALU_result_in     (alu_result_ex),
        .write_data_in     (write_data_ex),
        .rd_in             (rd_ex),
        .PC_in             (PC_ex),
        .instr_in          (instr_ex),
        .branch_taken_in   (branch_taken_ex),
        .branch_target_in  (branch_target_ex),
        .regwrite_out      (regwrite_mem),
        .memtoreg_out      (memtoreg_mem),
        .memread_out       (memread_mem),
        .memwrite_out      (memwrite_mem),
        .branch_out        (branch_mem),
        .jal_out           (jal_mem),
        .ALU_result_out    (alu_result_mem),
        .write_data_out    (write_data_mem),
        .rd_out            (rd_mem),
        .PC_out            (PC_mem),
        .instr_out         (instr_mem),
        .branch_taken_out  (branch_taken_mem),
        .branch_target_out (branch_target_mem)
    );

    // -----------------------------------------------------------------
    // MEM阶段
    // -----------------------------------------------------------------
    memory u_memory (
        .CLK   (clk),
        .WRn   (memwrite_mem),
        .RDn   (memread_mem),
        .addr  (alu_result_mem[4:0]),
        .DIN   (write_data_mem),
        .DOUT  (mem_data_mem)
    );

    MEM_WB u_mem_wb (
        .clk            (clk),
        .rst_n          (rst_n),
        .flush          (1'b0),
        .stall          (1'b0),
        .regwrite_in    (regwrite_mem),
        .memtoreg_in    (memtoreg_mem),
        .jal_in         (jal_mem),
        .mem_data_in    (mem_data_mem),
        .alu_result_in  (alu_result_mem),
        .rd_in          (rd_mem),
        .PC_in          (PC_mem),
        .instr_in       (instr_mem),
        .regwrite_out   (regwrite_wb),
        .memtoreg_out   (memtoreg_wb),
        .jal_out        (jal_wb),
        .mem_data_out   (mem_data_wb),
        .alu_result_out (alu_result_wb),
        .rd_out         (rd_wb),
        .PC_out         (PC_wb),
        .instr_out      (instr_wb)
    );

    // -----------------------------------------------------------------
    // WB阶段
    // -----------------------------------------------------------------
    // 写回数据选择
    assign write_data_wb = (jal_wb) ? {22'b0, PC_wb + 10'd4} :
                           (memtoreg_wb == 2'b01) ? mem_data_wb :
                           (memtoreg_wb == 2'b11) ? {instr_wb[31:12], 12'b0} :
                           alu_result_wb;

    assign ALU_result = alu_result_ex;
    assign rd_address = rd_wb;

endmodule