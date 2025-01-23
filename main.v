`timescale 1ns / 1ns

module mips(input wire clk,rst);
    reg [7:0] inst[0:4096];
    reg [7:0] data[0:16384];

    reg [31:0] pc;
    reg [31:0] registers[0:31];

    reg [31:0] currInst;

    wire [31:0] sign_ext_imm = {{16{currInst[15]}}, currInst[15:0]};

    always @(posedge clk or posedge rst ) begin: block
        if(rst==0) begin  //rst
            pc <=0;
        end
        else begin
            currInst <= {inst[pc],inst[pc+1],inst[pc+2],inst[pc+3]};

            if(currInst[31:26] == 6'h00) begin //R-type
                if(currInst[5:0] == 6'h20) begin //add
                    registers[currInst[15:11]] <= registers[currInst[25:21]] + registers[currInst[20:16]];

                    $display("add");
                end 
                else if(currInst[5:0] == 6'h22) begin //sub
                    registers[currInst[15:11]] <= registers[currInst[25:21]] - registers[currInst[20:16]];

                    $display("sub");
                end
            end

            else if(currInst[31:26] == 6'h23) begin //lw
                registers[currInst[25:21]] <= data[registers[currInst[20:16]] + sign_ext_imm];
                    
                    $display("lw");
            end

            else if(currInst[31:26] == 6'h2b) begin //sw
                data[registers[currInst[20:16]] + sign_ext_imm] <= registers[currInst[25:21]];

                    $display("sw");
            end

            else if(currInst[31:26] == 6'h04) begin //beq
                $display("beq");
                if(registers[currInst[25:21]] == registers[currInst[20:16]]) begin
                    pc <= pc + 4 + (sign_ext_imm << 2);

                    disable block;

                end
            end

            else if(currInst[31:26] == 6'h05) begin //bne
                $display("bne");
                if(registers[currInst[25:21]] != registers[currInst[20:16]]) begin
                    pc <= pc + 4 + (sign_ext_imm << 2);
                    disable block;
                end
            end

            pc <= pc + 4;

            $display("%h",currInst);
            $display("pc:%d",pc);
        end
    end

endmodule;



module mip_tb;

    reg clk;
    reg rst;
    integer i;

    mips hi(clk, rst);


    initial begin
        clk = 0;
        rst = 0;

        hi.inst[0] = 8'h01; // add $t1, $t2, $t3
        hi.inst[1] = 8'h4b; 
        hi.inst[2] = 8'h48; 
        hi.inst[3] = 8'h20; 

        hi.inst[4] = 8'h02; // sub $s1, $s2, $s3
        hi.inst[5] = 8'h53;
        hi.inst[6] = 8'h88; 
        hi.inst[7] = 8'h22; 

        hi.inst[8] = 8'h8d; // lw $t1, -100($t2)
        hi.inst[9] = 8'h49; 
        hi.inst[10] = 8'hff; 
        hi.inst[11] = 8'h9c; 

        hi.inst[12] = 8'had; // sw $t2, 100($t2)
        hi.inst[13] = 8'h4a; 
        hi.inst[14] = 8'h00; 
        hi.inst[15] = 8'h64; 

        hi.inst[16] = 8'h11; // beq $t1, $t2,label
        hi.inst[17] = 8'h2a; 
        hi.inst[18] = 8'h00; 
        hi.inst[19] = 8'h01; 

        hi.inst[20] = 8'h15; // bne $t0, $t1, label
        hi.inst[21] = 8'h4d; 
        hi.inst[22] = 8'h00; 
        hi.inst[23] = 8'h00; 


        for (i = 0; i < 32; i = i + 1) begin
            hi.registers[i] = i; 
        end

        #10 rst = 1;

        #100;

        $display("Register Values:");
        for (i = 0; i < 32; i = i + 1) begin
            $display("Register[%0d] = %0d", i, hi.registers[i]);
        end

        $finish;
    end


    always #5 clk = ~clk;

    initial begin
        $dumpfile("main.vcd"); // Specify the output file name
        $dumpvars(0, mip_tb);  // Dump all variables in the testbench
    end


endmodule
