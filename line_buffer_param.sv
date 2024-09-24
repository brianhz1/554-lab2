module line_buffer_param
#(
	parameter width = 1280,	// row width
	parameter depth = 12	// data 
)
(
	input clk,
	input rst_n,
	input en,	// shift if high
	input [width-1:0] d_shift_in,
	output [width-1:0] d_out_0, // first in
	output [width-1:0] d_out_1	// second in
);

	logic [depth-1:0] data [$clog2(width)-1:0];
	
	assign d_out_0 = data[width-1];
	assign d_out_1 = data[width-2];
	
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			for (integer i = 0; i < width; i = i + 1) begin
				data[i] <= 0;
			end
		end
		else if (en) begin
			data[0] <= d_shift_in;
			for (integer i = 0; i < width - 1; i = i + 1) begin
				data[i+1] = data[i];
			end
		end
	end
endmodule