module Counter(
					input logic swController, clock, incBut, decBut,
					input[7:0] logic display0, display1,
					output logic LEDR0, LEDR1
					);
	integer numStudent = 0;
	integer displayNum0 = 0;
	integer displayNum1 = 0;
	//Blinking clock frequency output
	BlinkingClock myClock(clock, blinkingClock);
	
	// displays
	hexDisplay hex0(displayNum0, dispOut0);
	hexDisplay hex1(displayNum1, dispOut1);
	
	// initial block to turn displays off.			
	initial begin
		display0 = 8'b1111_1111;
		display1 = 8'b1111_1111;
	end
	
	always @(swController, incButton, decButton) begin
		
		//On and off switch.
		if(swController) begin
			//display 0's.
			display0 = 8'b1100_0000;
			display1 = 8'b0000_0011;
		end
		else if(~swController) begin
			display0 = 8'b1111_1111;
			display1 = 8'b1111_1111;
			numStudent = 0;
			displayNum0 = 0;
			displayNum1 = 0;
		end
		else begin
		
			//Student enters
			if(incBut) begin
				numStudent++;
				display0 = dispOut0;
				display1 = dispOut1;
				if(numStudent == 20) begin
					LEDR0 = blinkingClock;
				end
				else if(numStudent >= 10) begin
					LEDR0 = 1;
				end
				else if(numStudent <= 17) begin
					LEDR1 = 1;
				end
			end
			
			//Student leaves
			else if(decBut) begin
				numStudent--;
				
				if(numStudent < 10) begin
					displayNum0 = numStudent;
					displayNum1 = 0;
				end
				
				else begin
					displayNum0 = numStudent % 10;
					displayNum1 = numStudent / 10;
				end
				
				display0 = dispOut0;
				display1 = dispOut1;
			end
			
		end
		
	end
	
	
endmodule


module hexDisplay (
						 input logic numStudent,
						 output logic display
						 );
	always @(numStudent) begin
	
		case(numStudent)
			0: display = 8'b1100_0000;
         1: display = 8'b1111_1001;
         2: display = 8'b1010_0100;
         3: display = 8'b1101_1000;
         4: display = 8'b1001_1001;
         5: display = 8'b1001_0010;
         6: display = 8'b1000_0010;
         7: display = 8'b1111_1000;
			8: display = 8'b1000_0000;
			9: display = 8'b1001_0000;
			default: display = 8'b1111_1111;
		endcase
			
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

