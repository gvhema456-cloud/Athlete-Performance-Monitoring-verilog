`timescale 1ns / 1ps

//======================================================
// AI-Powered Athlete Performance Monitoring and
// Smart Timing System Using Edge Devices
//
// VLSI Micro Project
//======================================================


//======================================================
// DESIGN MODULE
//======================================================

module athlete_monitor (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,

    output reg [7:0] time_count,
    output reg [1:0] performance
);

    // Indicates whether the athlete is currently running
    reg running;

    always @(posedge clk or posedge reset) begin

        // Reset the system
        if (reset) begin
            time_count <= 8'd0;
            performance <= 2'b00;
            running <= 1'b0;
        end

        else begin

            // Start timing
            if (start)
                running <= 1'b1;

            // Increment timer while running
            if (running)
                time_count <= time_count + 8'd1;

            // Stop timing and evaluate performance
            if (stop) begin

                running <= 1'b0;

                // Performance classification
                if (time_count < 8'd10)
                    performance <= 2'b00;       // Excellent

                else if (time_count < 8'd20)
                    performance <= 2'b01;       // Good

                else if (time_count < 8'd30)
                    performance <= 2'b10;       // Average

                else
                    performance <= 2'b11;       // Needs Improvement

            end
        end
    end

endmodule


//======================================================
// TESTBENCH MODULE
//======================================================

module athlete_monitor_tb;

    // Testbench inputs
    reg clk;
    reg reset;
    reg start;
    reg stop;

    // Outputs from the design
    wire [7:0] time_count;
    wire [1:0] performance;

    //==================================================
    // Instantiate the Design Under Test
    //==================================================

    athlete_monitor uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .time_count(time_count),
        .performance(performance)
    );

    //==================================================
    // Clock Generation
    // Clock period = 10 ns
    //==================================================

    always #5 clk = ~clk;

    //==================================================
    // Test Sequence
    //==================================================

    initial begin

        // Initial conditions
        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        stop = 1'b0;

        // Apply reset
        #20;
        reset = 1'b0;

        // Start athlete timing
        #10;
        start = 1'b1;

        #10;
        start = 1'b0;

        // Athlete is running
        #70;

        // Stop athlete timing
        stop = 1'b1;

        #10;
        stop = 1'b0;

        // Allow time to observe result
        #30;

        // End simulation
        $finish;

    end

endmodule
