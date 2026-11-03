module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs: Duty cycle setting (0-255)
    output wire [7:0] uo_out,   // Dedicated outputs: PWM signal out on pin 0
    input  wire [7:0] uio_in,   // Bidirectional pins (Unused)
    output wire [7:0] uio_out,  // Bidirectional pins (Unused)
    output wire [7:0] uio_oe,   // Bidirectional pin configuration
    input  wire       ena,      // Enable signal (Unused)
    input  wire       clk,      // System clock
    input  wire       rst_n     // Active-low reset
);

    reg [7:0] counter;
    reg pwm_out;

    // Synchronous logic for the counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'b0;
            pwm_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            // Compare counter with the input duty cycle
            pwm_out <= (counter < ui_in) ? 1'b1 : 1'b0;
        end
    end

    // Assign internal PWM register to output pin 0. Tie remaining 7 pins to 0.
    assign uo_out = {7'b0, pwm_out};

    // Tie off unused bidirectional pins to 0 to prevent Vulkos errors
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
