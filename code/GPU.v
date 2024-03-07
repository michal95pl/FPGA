/*

gpu - module
clk = 40mhz
640 x 480

*/

module GPU(
    input gpu_clk,
    output reg h_sync,
    output reg v_sync,
    output reg color,
    output reg [8:0] address,
    input [639:0] data
    );
    
    reg [11:0] h_sync_counter = 1;
    reg [11:0] v_sync_counter = 1;
    
    always @ (posedge gpu_clk) begin
        
        // hsync clock
        if(h_sync_counter > 656 && h_sync_counter <= 720)
            h_sync <= 0;
        else
            h_sync <= 1;
        
        // vsync clock
        if (v_sync_counter > 481 && v_sync_counter <= 484)
           v_sync <= 1;
        else
           v_sync <= 0;
        
        
        // show pixel
        if (h_sync_counter <= 640) begin
            color <= data[h_sync_counter];
        end else
            color <= 0; // no active video frame
        
        
        if (h_sync_counter > 840) begin
            h_sync_counter <= 1;
            
            // end frame
            if (v_sync_counter > 500) begin
                v_sync_counter <= 1;
                address <= 0;
            end else begin
                v_sync_counter <= v_sync_counter + 1;
                address <= address + 1;
            end
        end else
            h_sync_counter <= h_sync_counter + 1;
    end
    
endmodule
