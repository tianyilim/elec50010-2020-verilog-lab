module CPU_MU0_delay1(
    input logic clk,
    input logic rst,
    output logic running,
    output logic[11:0] address,
    output logic write,
    output logic read,
    output logic[15:0] writedata,
    input logic[15:0] readdata
    );

    /* Using an enum to define constants */
    typedef enum logic[3:0] {
        OPCODE_LDA = 4'd0,
        OPCODE_STO = 4'd1,
        OPCODE_ADD = 4'd2,
        OPCODE_SUB = 4'd3,
        OPCODE_JMP = 4'd4,
        OPCODE_JGE = 4'd5,
        OPCODE_JNE = 4'd6,
        OPCODE_STP = 4'd7,
        OPCODE_OUT = 4'd8
    } opcode_t;

    /* Another enum to define CPU states. */
    typedef enum logic[2:0] {
        FETCH = 3'b000,
        EXEC1 = 3'b001,
        EXEC2  = 3'b010,
        HALTED =      3'b100
    } state_t;

    logic[11:0] pc, pc_next;
    logic[15:0] acc;

    logic[15:0] instr, instr_reg;
    opcode_t instr_opcode;
    logic[11:0] instr_constant;

    logic[1:0] state;

    always @(*) begin
        //handle RAM address, read and write lines 
        if(state==FETCH) begin  
            address = pc;
        end
        else if(state==EXEC1) begin
            case(instr_opcode)
                OPCODE_ADD: address = instr_constant;
                OPCODE_SUB: address = instr_constant;
                OPCODE_LDA: address = instr_constant;
                OPCODE_STO: address = instr_constant;
                OPCODE_JMP: address = instr_constant;
                OPCODE_JGE: begin
                    if(acc > 0) begin
                        address = instr_constant;
                    end
                    else begin
                        address = pc;
                    end
                end     
                OPCODE_JNE: begin
                    if(acc != 0) begin
                        address = instr_constant;
                    end
                    else begin
                        address = pc;
                    end
                end
                default: address = pc;  
            endcase         
        end
        else if(state==EXEC2) begin 
            address = pc;
        end
        else if(state==HALTED) begin
            address = pc;
        end
    end
    
    assign write = (state==EXEC1) ? instr_opcode==OPCODE_STO : 0;
    assign read = 1;
    assign writedata = acc;

    assign instr_opcode = (state==EXEC1) ? readdata[15:12] : instr_reg[15:12];
    assign instr_constant = (state==EXEC1) ? readdata[11:0] : instr_reg[11:0];

    wire[11:0] pc_increment;
    assign pc_increment = pc + 1;

    initial begin
        state = HALTED;
        running = 0;
        pc = 0;
        instr_reg = 0;
        acc = 0;
    end

    always @(posedge clk) begin
        $display("PC: %h, opcode: %b, address: %d RAM OUT: %b",pc,instr_opcode,address,readdata);
        $display("Acc: %d, Cycle: %b", acc,state);
        // $display("IR: %b",instr_reg);
        if (rst) begin
            $display("CPU : INFO  : Resetting.");
            state <= FETCH;
            pc <= 0;
            acc <= 0;
            running <= 1;
        end
        else if(state==FETCH) begin
            pc <= pc_increment;
            state <= EXEC1;
        end
        else if(state==EXEC1) begin
            case(instr_opcode)
                OPCODE_LDA: begin
                    instr_reg <= readdata;
                    state <= EXEC2;
                end
                OPCODE_STO: begin         
                    instr_reg <= readdata;      
                    state <= EXEC2;
                end
                OPCODE_ADD: begin
                    instr_reg <= readdata;
                    state <= EXEC2;
                end
                OPCODE_SUB: begin
                    instr_reg <= readdata;                    
                    state <= EXEC2;
                end
                OPCODE_JMP: begin
                    pc <= instr_constant + 1;
                    instr_reg <= readdata;
                    state <= EXEC1;
                end
                OPCODE_JGE: begin
                    if(acc > 0) begin
                        pc <= instr_constant + 1;
                    end
                    else begin
                        pc <= pc_increment;
                    end
                    instr_reg <= readdata;
                    state <= EXEC1;
                end
                OPCODE_JNE: begin
                    if (acc != 0) begin
                        pc <= instr_constant + 1;
                    end
                    else begin
                        pc <= pc_increment;
                    end
                    instr_reg <= readdata;
                    state <= EXEC1;
                end
                OPCODE_OUT: begin
                    $display("CPU : OUT   : %d", $signed(acc));
                    pc <= pc_increment;
                    instr_reg <= readdata;
                    state <= EXEC1;
                end
                OPCODE_STP: begin
                    // Stop the simulation
                    $display("CPU stopped");
                    state <= HALTED;
                    running <= 0;
                end
            endcase
        end
        else if(state==EXEC2) begin //pipeline stall
            case(instr_opcode)
                OPCODE_ADD: begin
                    acc <= acc + readdata;
                end
                OPCODE_SUB: begin
                    acc <= acc - readdata;
                end
                OPCODE_LDA: begin
                    acc <= readdata;
                end
            endcase
            pc <= pc_increment;
            state <= EXEC1;
        end

    end

endmodule