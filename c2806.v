module TopLevel2806(I, CLK, S);
   input [3:0] I;
   input       CLK;
   output [2:0] S;

   wire [11:0] 	N;

   dff ff1( .CLK(CLK), .D(I[0]), .Q(N[0]) );

   dff ff2( .CLK(CLK), .D(I[1]), .Q(N[1]) );

   dff ff3( .CLK(CLK), .D(I[2]), .Q(N[2]) );

   xor2  i1( .A(N[0]), .B(N[1]), .Y(N[4]) );
   
   nand2 i2( .A(N[0]), .B(I[3]), .Y(N[5]) );

   nor2  i3( .A(N[1]), .B(N[2]), .Y(N[6]) );

   nand2 i4( .A(N[2]), .B(I[3]), .Y(N[7]) );

   or3   i5( .A(N[4]), .B(N[5]), .C(N[7]), .Y(N[8]) );

   dff  ff4( .CLK(CLK), .D(N[4]), .Q(N[9]) );

   dff  ff5( .CLK(CLK), .D(N[8]), .Q(N[11]) );

   dff  ff6( .CLK(CLK), .D(N[6]), .Q(N[10]) );

   and2  i6( .A(N[9]), .B(N[10]), .Y(S[0]) );

   xor2  i7( .A(N[9]), .B(N[11]), .Y(S[1]) );

   nand2 i8( .A(N[9]), .B(N[10]), .Y(N[3]) );

   or3   i9( .A(N[11]), .B(S[1]), .C(N[3]), .Y(S[2]) );

endmodule