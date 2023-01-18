module Counter( input logic swController, reset, clock, incBut, decBut,
output logic[7:0] display0, display1, display2, display3,
 output logic LEDR0, LEDR1, LEDR2, LEDR3
 );
        reg[8:0] count=1;
        reg[8:0] countover;
        integer increased = 0;

        reg[9:0] decCount = 9;
        reg[9:0] decCountOver = 10;
        BlinkingClock myClock(clock, blinkingClock);


      initial begin
                display0 = 8'b1100_0000;
                display1 = 8'b1100_0000;
                display2 = 8'b1100_0000;
                display3 = 8'b1010_0100;
                LEDR1 = 0;
                LEDR0 = 0;
        end

       task hexdisplay(input[8:0]  value, output reg [7:0] display);
        case(value)
            0: display = 8'b1100_0000;
            1: display = 8'b1111_1001;
            2: display = 8'b1010_0100;
            3: display = 8'b1011_0000;
            4: display = 8'b1001_1001;
            5: display = 8'b1001_0010;
            6: display = 8'b1000_0010;
            7: display = 8'b1111_1000;
            8: display = 8'b1000_0000;
            9: display = 8'b1001_1000;
            default: display = 8'b1100_1111;
       endcase
    endtask




         always@(swController) begin
                if(swController) begin
                        LEDR1 = blinkingClock;
                end
                else if(~swController) begin
                        LEDR1 = 0;
                end
         end

        //adding
        always@(posedge incBut) begin
                if(reset) begin
                        LEDR0 = 0;
                        display1=8'b1100_0000;
                        display0=8'b1100_0000;
                        count <= 0;
                        countover <= 0;
                end
                else begin

                        if(countover >= 10) begin
                        // 20
                                display1 = 8'b1010_0100;
                                display0 = 8'b1100_0000;

                                LEDR0 = blinkingClock;

                        end
                        else if(count >= 10) begin
                                // 10 or up
                                LEDR0 = 1;
         
                                display1 = 8'b1111_1001;
                                countover <= countover + 1;
                                hexdisplay(countover, display0);

                        end
                        else begin
                                // 0-9
                                count <= count + 1;

                                hexdisplay(count, display0);
                        end
                end
        end

                //subtracting
                always@(posedge decBut) begin
                if(reset) begin
                        display2=8'b1100_0000;
                        display3=8'b1010_0100;
                        decCount <= 10;
                        decCountOver <= 10;
                end
                else begin
                        if(decCountOver == 10)begin
                                display2 =8'b1100_0000;
                                display3 =8'b1010_0100;
                                decCountOver <= decCountOver - 1;

                        end
                        else if(decCountOver > 0) begin
                                // 19 -> 10
                                display3 = 8'b1111_1001;
                                decCountOver <= decCountOver - 1;
                                hexdisplay(decCountOver, display2);

                        end
                        else if(decCountOver == 0) begin
                                // 0-9
                                decCount <= decCount - 1;
                                display3 = 8'b1100_0000;
                                hexdisplay(decCount, display2);
                        end
                        else if(decCount <= 0) begin
                                display2 = 8'b1100_0000;
                                display3 = 8'b1100_0000;
                        end

                end

        end
endmodule




module BlinkingClock(
                      input clk,
                      output logic slow_clock
                                          );
        logic [29:0] counter; //12 bit counter you can increase that
        parameter slowParam=12500000;
        always @(posedge clk)
        begin
                counter <= counter+1;
                if (counter >= slowParam)
                begin
                                counter <= 0;
                                slow_clock <= ~slow_clock;
                end
        end

endmodule
