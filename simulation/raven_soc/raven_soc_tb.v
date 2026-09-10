`timescale 1 ns/1 ps

`include "raven_soc_xcelium.v"
`include "../XSPRAM_1024X32_M8P.v"
`include "../spiflash.v"
`include "../tbuart.v"

module raven_soc_tb;

    reg pll_clk;
    reg ext_clk;
    reg ext_clk_sel;
    reg ext_reset;
    reg reset;

    initial begin
        pll_clk = 1'b0;
        forever #5 pll_clk = ~pll_clk;   // 100 MHz
    end

    initial begin
        ext_clk = 1'b0;
        forever #20 ext_clk = ~ext_clk;
    end

    wire        ram_wenb;
    wire [9:0]  ram_addr;
    wire [31:0] ram_wdata;
    wire [31:0] ram_rdata;
    wire        ram_rdy;

    wire [15:0] gpio_out;
    reg  [15:0] gpio_in;
    wire [15:0] gpio_pullup;
    wire [15:0] gpio_pulldown;
    wire [15:0] gpio_outenb;

    wire        adc0_ena;
    wire        adc0_convert;
    reg  [9:0]  adc0_data;
    reg         adc0_done;
    wire        adc0_clk;
    wire [1:0]  adc0_inputsrc;

    wire        adc1_ena;
    wire        adc1_convert;
    wire        adc1_clk;
    wire [1:0]  adc1_inputsrc;
    reg  [9:0]  adc1_data;
    reg         adc1_done;

    wire        dac_ena;
    wire [9:0]  dac_value;

    wire        analog_out_sel;
    wire        opamp_ena;
    wire        opamp_bias_ena;
    wire        bg_ena;

    wire        comp_ena;
    wire [1:0]  comp_ninputsrc;
    wire [1:0]  comp_pinputsrc;
    wire        rcosc_ena;

    wire        overtemp_ena;
    reg         overtemp;
    reg         rcosc_in;
    reg         xtal_in;
    reg         comp_in;
    reg         spi_sck;

    reg  [7:0]  spi_ro_config;
    reg         spi_ro_xtal_ena;
    reg         spi_ro_reg_ena;
    reg         spi_ro_pll_cp_ena;
    reg         spi_ro_pll_vco_ena;
    reg         spi_ro_pll_bias_ena;
    reg  [3:0]  spi_ro_pll_trim;

    reg  [11:0] spi_ro_mfgr_id;
    reg  [7:0]  spi_ro_prod_id;
    reg  [3:0]  spi_ro_mask_rev;

    wire ser_tx;
    reg  ser_rx;

    reg  irq_pin;
    reg  irq_spi;
    wire trap;

    wire flash_csb;
    wire flash_clk;

    wire flash_io0_oeb;
    wire flash_io1_oeb;
    wire flash_io2_oeb;
    wire flash_io3_oeb;

    wire flash_io0_do;
    wire flash_io1_do;
    wire flash_io2_do;
    wire flash_io3_do;

    wire flash_io0_di;
    wire flash_io1_di;
    wire flash_io2_di;
    wire flash_io3_di;

    wire flash_io0;
    wire flash_io1;
    wire flash_io2;
    wire flash_io3;

    assign flash_io0 = flash_io0_oeb ? 1'bz : flash_io0_do;
    assign flash_io1 = flash_io1_oeb ? 1'bz : flash_io1_do;
    assign flash_io2 = flash_io2_oeb ? 1'bz : flash_io2_do;
    assign flash_io3 = flash_io3_oeb ? 1'bz : flash_io3_do;

    assign flash_io0_di = flash_io0;
    assign flash_io1_di = flash_io1;
    assign flash_io2_di = flash_io2;
    assign flash_io3_di = flash_io3;

    raven_soc uut (
        .pll_clk(pll_clk),
        .ext_clk(ext_clk),
        .ext_clk_sel(ext_clk_sel),
        .ext_reset(ext_reset),
        .reset(reset),

        .ram_wenb(ram_wenb),
        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata),
        .ram_rdata(ram_rdata),

        .gpio_out(gpio_out),
        .gpio_in(gpio_in),
        .gpio_pullup(gpio_pullup),
        .gpio_pulldown(gpio_pulldown),
        .gpio_outenb(gpio_outenb),

        .adc0_ena(adc0_ena),
        .adc0_convert(adc0_convert),
        .adc0_data(adc0_data),
        .adc0_done(adc0_done),
        .adc0_clk(adc0_clk),
        .adc0_inputsrc(adc0_inputsrc),

        .adc1_ena(adc1_ena),
        .adc1_convert(adc1_convert),
        .adc1_clk(adc1_clk),
        .adc1_inputsrc(adc1_inputsrc),
        .adc1_data(adc1_data),
        .adc1_done(adc1_done),

        .dac_ena(dac_ena),
        .dac_value(dac_value),

        .analog_out_sel(analog_out_sel),
        .opamp_ena(opamp_ena),
        .opamp_bias_ena(opamp_bias_ena),
        .bg_ena(bg_ena),

        .comp_ena(comp_ena),
        .comp_ninputsrc(comp_ninputsrc),
        .comp_pinputsrc(comp_pinputsrc),
        .rcosc_ena(rcosc_ena),

        .overtemp_ena(overtemp_ena),
        .overtemp(overtemp),
        .rcosc_in(rcosc_in),
        .xtal_in(xtal_in),
        .comp_in(comp_in),
        .spi_sck(spi_sck),

        .spi_ro_config(spi_ro_config),
        .spi_ro_xtal_ena(spi_ro_xtal_ena),
        .spi_ro_reg_ena(spi_ro_reg_ena),
        .spi_ro_pll_cp_ena(spi_ro_pll_cp_ena),
        .spi_ro_pll_vco_ena(spi_ro_pll_vco_ena),
        .spi_ro_pll_bias_ena(spi_ro_pll_bias_ena),
        .spi_ro_pll_trim(spi_ro_pll_trim),

        .spi_ro_mfgr_id(spi_ro_mfgr_id),
        .spi_ro_prod_id(spi_ro_prod_id),
        .spi_ro_mask_rev(spi_ro_mask_rev),

        .ser_tx(ser_tx),
        .ser_rx(ser_rx),

        .irq_pin(irq_pin),
        .irq_spi(irq_spi),
        .trap(trap),

        .flash_csb(flash_csb),
        .flash_clk(flash_clk),

        .flash_io0_oeb(flash_io0_oeb),
        .flash_io1_oeb(flash_io1_oeb),
        .flash_io2_oeb(flash_io2_oeb),
        .flash_io3_oeb(flash_io3_oeb),

        .flash_io0_do(flash_io0_do),
        .flash_io1_do(flash_io1_do),
        .flash_io2_do(flash_io2_do),
        .flash_io3_do(flash_io3_do),

        .flash_io0_di(flash_io0_di),
        .flash_io1_di(flash_io1_di),
        .flash_io2_di(flash_io2_di),
        .flash_io3_di(flash_io3_di)
    );

    XSPRAM_1024X32_M8P ram (
        .Q(ram_rdata),
        .D(ram_wdata),
        .A(ram_addr),
        .CLK(pll_clk),
        .CEn(1'b0),
        .WEn(ram_wenb),
        .OEn(1'b0),
        .RDY(ram_rdy)
    );

    spiflash #(
        .FILENAME("firmware.hex")
    ) flash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(flash_io2),
        .io3(flash_io3)
    );

    tbuart tbuart (
        .ser_rx(ser_tx)
    );

    integer ser_tx_edges;
    integer flash_clk_edges;

    initial begin
        ser_tx_edges = 0;
        flash_clk_edges = 0;
    end

    always @(ser_tx) begin
        if ($time > 200)
            ser_tx_edges = ser_tx_edges + 1;
    end

    always @(negedge ser_tx) begin
        if ($time > 200)
            $display("UART TX start bit detected at time %0t", $time);
    end

    always @(posedge flash_clk) begin
        if ($time > 200)
            flash_clk_edges = flash_clk_edges + 1;
    end

    initial begin
        $dumpfile("raven_soc.vcd");
        $dumpvars(0, raven_soc_tb);

        ext_clk_sel = 1'b0;
        ext_reset   = 1'b0;
        reset       = 1'b1;

        gpio_in = 16'h0000;

        adc0_data = 10'd0;
        adc0_done = 1'b0;
        adc1_data = 10'd0;
        adc1_done = 1'b0;

        overtemp = 1'b0;
        rcosc_in = 1'b0;
        xtal_in  = 1'b0;
        comp_in  = 1'b0;
        spi_sck  = 1'b0;

        spi_ro_config       = 8'h00;
        spi_ro_xtal_ena     = 1'b0;
        spi_ro_reg_ena      = 1'b0;
        spi_ro_pll_cp_ena   = 1'b0;
        spi_ro_pll_vco_ena  = 1'b0;
        spi_ro_pll_bias_ena = 1'b0;
        spi_ro_pll_trim     = 4'h0;

        spi_ro_mfgr_id  = 12'h000;
        spi_ro_prod_id  = 8'h00;
        spi_ro_mask_rev = 4'h0;

        ser_rx  = 1'b1;
        irq_pin = 1'b0;
        irq_spi = 1'b0;

        #200;
        reset = 1'b0;

    repeat (3000000) @(posedge pll_clk);

    $display("Flash clock edges: %0d", flash_clk_edges);
    $display("UART TX edges: %0d", ser_tx_edges);
    $display("Trap value: %b", trap);

    if (ser_tx_edges == 0)
        $display("WARNING: No UART TX activity observed during this simulation window.");
    else
        $display("UART TX activity observed.");

    if (trap)
        $display("WARNING: trap asserted.");
    else
        $display("Trap stayed low.");

    $display("Finished raven_soc simulation.");
    $finish;
    end

endmodule
