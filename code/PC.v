module PC(
    input sys_clk,
    output wire h_sync,
    output wire v_sync,
    output wire green
    );
    
    wire gpu_clk;
    
    wire [8:0] gpu_mem_addr;
    wire [639:0] gpu_mem_reg;
    
    
    main_clk_prescaler inst (
        .gpu_clk(gpu_clk),   
        .locked(locked),
        .clk_in(sys_clk)
  );
    
    GPU gpu_inst (
        .gpu_clk(gpu_clk),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .color(green),
        .address(gpu_mem_addr),
        .data(gpu_mem_reg)
    );
    
    wire [8:0] mem_addr;
    wire [639:0] mem_data;
    //wire graphic_clk;
    wire enable = 1'b1;
    wire mem_clk;
    
    reg graphic_clk = 0;
    reg [31:0] prescaller = 0;
    
    always @(posedge sys_clk) begin
        prescaller <= prescaller + 1;
        if (prescaller >= (50000-1))
            prescaller <= 0;
            
        graphic_clk <= (prescaller < 25000)? 1 : 0;
    
    end
    
    
    
    Vram Vram_inst (
        .a(mem_addr),
        .d(mem_data),
        .dpra(gpu_mem_addr),
        .clk(mem_clk),
        .we(enable),
        .dpo(gpu_mem_reg)
    );
    
    Graphic(
        graphic_clk,
        mem_clk,
        mem_addr,
        mem_data
    );
    
endmodule
