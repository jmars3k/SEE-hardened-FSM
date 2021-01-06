`timescale 1 ns / 1 ps
`define PERIOD 7'd63		//64 clocks between step pulses


module see_hardened_FSM_tb ();

//************************************ module io ******************************

//system clock and reset
	reg clk = 1;
	always #25 clk = ~clk;	//20MHz clk, period = 50nS, half period = 25ns
	
	reg reset;
	reg step;
	
	wire sec;
	wire [3:0] d;
	
	reg [6:0] counter;

	initial begin
		reset = 1'b1;		//in reset
		#100 reset = 1'b0;	//out of reset

	end
	
	always @(posedge clk) begin
		if (reset)
			counter <= 7'd0;
		else if (counter == `PERIOD)
			counter <= 7'd0;
		else
			counter <= counter + 1;
	end
	
	assign step = (counter == `PERIOD)? 1'b1:1'b0;
	
	
	see_hardened_FSM see_hardened_FSM_inst(.clk(clk), .reset(reset), .step(step), .sec(sec), .d(d));


endmodule
