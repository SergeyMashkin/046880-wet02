module buffer (A, Y);
   input A;
   output Y;
endmodule

module inv (A, Y);
   input A;
   output Y;
endmodule

module nor2 (A, B, Y );
   input A, B;
   output Y;
endmodule

module or2 (A, B, Y );
   input A, B;
   output Y;
endmodule

module nand2 (A, B, Y );
   input A, B;
   output Y;
endmodule

module and2 (A, B, Y );
   input A, B;
   output Y;
endmodule


module xor2 (A, B, Y );
   input A, B;
   output Y;
endmodule

module or3 (A, B, C, Y );
   input A, B, C;
   output Y;
endmodule

module nor3 (A, B, C, Y );
   input A, B, C;
   output Y;
endmodule

module and3 (A, B, C, Y );
   input A, B, C;
   output Y;
endmodule

module nand3 (A, B, C, Y );
   input A, B, C;
   output Y;
endmodule

module or4 (A, B, C, D, Y );
   input A, B, C, D;
   output Y;
endmodule

module nor4 (A, B, C, D, Y );
   input A, B, C, D;
   output Y;
endmodule

module and4 (A, B, C, D, Y );
   input A, B, C, D;
   output Y;
endmodule

module nand4 (A, B, C, D, Y );
   input A, B, C, D;
   output Y;
endmodule

module or5 (A, B, C, D, E, Y );
   input A, B, C, D, E;
   output Y;
endmodule

module nor5 (A, B, C, D, E, Y );
   input A, B, C, D, E;
   output Y;
endmodule

module and5 (A, B, C, D, E, Y );
   input A, B, C, D, E;
   output Y;
endmodule

module nand5 (A, B, C, D, E, Y );
   input A, B, C, D, E;
   output Y;
endmodule

module or6 (A, B, C, D, E, F, Y );
   input A, B, C, D, E, F;
   output Y;
endmodule

module nor6 (A, B, C, D, E, F, Y );
   input A, B, C, D, E, F;
   output Y;
endmodule

module and6 (A, B, C, D, E, F, Y );
   input A, B, C, D, E, F;
   output Y;
endmodule

module nand6 (A, B, C, D, E, F, Y );
   input A, B, C, D, E, F;
   output Y;
endmodule

module or7 (A, B, C, D, E, F, G, Y );
   input A, B, C, D, E, F, G;
   output Y;
endmodule

module nor7 (A, B, C, D, E, F, G, Y );
   input A, B, C, D, E, F, G;
   output Y;
endmodule

module and7 (A, B, C, D, E, F, G, Y );
   input A, B, C, D, E, F, G;
   output Y;
endmodule

module nand7 (A, B, C, D, E, F, G, Y );
   input A, B, C, D, E, F, G;
   output Y;
endmodule

module or8 (A, B, C, D, E, F, G, H, Y );
   input A, B, C, D, E, F, G, H;
   output Y;
endmodule

module nor8 (A, B, C, D, E, F, G, H, Y );
   input A, B, C, D, E, F, G, H;
   output Y;
endmodule

module and8 (A, B, C, D, E, F, G, H, Y );
   input A, B, C, D, E, F, G, H;
   output Y;
endmodule

module nand8 (A, B, C, D, E, F, G, H, Y );
   input A, B, C, D, E, F, G, H;
   output Y;
endmodule

module or9 (A, B, C, D, E, F, G, H, I, Y );
   input A, B, C, D, E, F, G, H, I;
   output Y;
endmodule

module nor9 (A, B, C, D, E, F, G, H, I, Y );
   input A, B, C, D, E, F, G, H, I;
   output Y;
endmodule

module and9 (A, B, C, D, E, F, G, H, I, Y );
   input A, B, C, D, E, F, G, H, I;
   output Y;
endmodule

module nand9 (A, B, C, D, E, F, G, H, I, Y );
   input A, B, C, D, E, F, G, H, I;
   output Y;
endmodule

module not (Y, A );
   input A;
   output Y;
endmodule

module nor (Y, A, B );
   input A, B;
   output Y;
endmodule

module or (Y, A, B );
   input A, B;
   output Y;
endmodule

module nand (Y, A, B );
   input A, B;
   output Y;
endmodule

module and (Y, A, B );
   input A, B;
   output Y;
endmodule

module dff(D,CLK,Q);
   input D, CLK;
   output Q;

   wire not_out[0:4];
   wire and_out[0:3];
   wire nor_out[0:2];

   inv not_0 (.A(D), .Y(not_out[0]));
   inv not_1 (.A(not_out[0]), .Y(not_out[1]));
   inv not_2 (.A(not_out[1]), .Y(not_out[2]));
   inv not_3 (.A(CLK), .Y(not_out[3]));
   and and_0 (.A(not_out[2]),.B(not_out[3]),.Y(and_out[0]));
   and and_1 (.A(not_out[1]), .B(not_out[3]), .Y(and_out[1]));
   nor nor_0 (.A(and_out[0]), .B(nor_out[1]) , .Y(nor_out[0]));
   nor nor_1 (.A(and_out[1]), .B(nor_out[0]), .Y(nor_out[1]));
   inv not_4 (.A(nor_out[1]), .Y(not_out[4]));
   and and_2 (.A(not_out[4]), .B(CLK), .Y(and_out[2]));
   and and_3 (.A(nor_out[1]), .B(CLK), .Y(and_out[3]));
   nor nor_2 (.A(and_out[2]), .B(Q), .Y(nor_out[2]));
   nor nor_3 (.A(and_out[3]), .B(nor_out[2]), .Y(Q));

endmodule