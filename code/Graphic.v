/*

    low level graphic module to draw very basic shapes

*/

module Graphic(
    input wire clk,
    output wire mem_clk,
    output wire [8:0] mem_addr,
    output wire [639:0] mem_data
    );
    
    reg [15:0] x1 = 260;
    reg [15:0] x2 = 260;
    reg [15:0] y1 = 60;
    reg [15:0] y2 = 200;
    
    reg start_flag = 0;
    wire ready_reg;
    
    reg latch = 0;
    
    always @(posedge clk) begin
    
        if (ready_reg == 0 && latch == 0) begin
        
            /*if (x1 < 300) begin
                x1 <= x1 + 1;
                x2 <= x2 + 1;
            end else begin
                x1 <= 260;
                x2 <= 260;
            end*/
            
            start_flag <= 1;
            latch <= 1;
            
        end else begin
            start_flag <= 0;
            latch <= 0;
            
        end
    
    end
    
    DrawLine(
        clk,  
        x1,
        x2, 
        y1, 
        y2,
        start_flag,
        ready_reg,
        mem_addr, 
        mem_data,
        mem_clk
    );
    
endmodule

// return address and data to write to memory
// straight line
module DrawLine(
    input wire clk,
    input wire [15:0] x1,
    input wire [15:0] x2,
    input wire [15:0] y1,
    input wire [15:0] y2, // y2 larger than y1
    input wire start, // starting flag: 1 - start, 0 - stop
    output reg ready, // ready flag to draw new line (0 - stop, 1 - running)
    output reg [8:0] mem_addr,  // y in memory
    output reg [639:0] mem_data, // x in memory
    output reg mem_clk
);

    // for y height
    reg [8:0] counter = 0;

    always @(posedge clk) begin
    
        mem_data[x1] <= 1; // set pixel
        
        if (ready == 1) begin
        
            if (mem_clk == 1) begin
            
                if (counter < (y2 - y1)) begin
                    mem_addr <= y1 + counter;
                    counter <= counter + 1;
                end else begin
                    // end drawing
                    counter <= 0;
                    ready <= 0;
                end
                
                mem_clk <= 0;
            end else
                mem_clk <= 1;
                
        end else
            ready <= start; 
    end

endmodule