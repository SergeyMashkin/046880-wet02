
/******************************************************/

module AND_OR3a( O, P, Q, R, S, Y);

   input	O, P, Q, R, S;
   output Y;
   
   and2 Ao3a_0( .A(P), .B(Q), .Y(line0) );
   and3 Ao3a_1( .A(P), .B(R), .C(S), .Y(line1) );
   or3 Ao3a_2( .A(O), .B(line0), .C(line1), .Y(Y) );

endmodule // AND_OR3a


/******************************************************/

module AND_OR2( O, P, Q, Y);

   input	O, P, Q;
   output Y;
   
   and2 Ao2_0( .A(P), .B(Q), .Y(line0) );
   or2 Ao2_1( .A(O), .B(line0), .Y(Y) );

endmodule // AND_OR2


/******************************************************/

module XOR2a ( A, B, Y);

   input	A, B;
   output Y;

   inv  Xo0( .A(A), .Y(NotA) ),
       Xo1( .A(B), .Y(NotB) );
   
   nand2 Xo2( .A(NotA), .B(B), .Y(line2) ),
         Xo3( .A(NotB), .B(A), .Y(line3) ),
         Xo4( .A(line2), .B(line3), .Y(Y) );
   
endmodule // XOR2a


/******************************************************/

module AND_OR4a( O, P, Q, R, S, T, U, Y);

   input	O, P, Q, R, S, T, U;
   output Y;
   
   and2 Ao4a_0( .A(P), .B(Q), .Y(line0) );
   and3 Ao4a_1( .A(P), .B(R), .C(S), .Y(line1) );
   and4 Ao4a_2( .A(P), .B(R), .C(T), .D(U), .Y(line2) );
   or4 Ao4a_3( .A(O), .B(line0), .C(line1), .D(line2), .Y(Y) );

endmodule // AND_OR4a


/******************************************************/

module CLA4( Pbus, Gbus, Cin, Cybus );

   input [3:0]	 Pbus, Gbus;
   input		 Cin;
   output [3:0] Cybus;

   
// Cybus[0]=Cin
   buffer addedBuf139 (.A(Cin), .Y(Cybus[0]));


   AND_OR2  Cla4_0( Gbus[0], Pbus[0], Cin, Cybus[1] );

   AND_OR3a Cla4_1( Gbus[1], Pbus[1], Gbus[0], Pbus[0], Cin, Cybus[2] );

   AND_OR4a Cla4_2( Gbus[2], Pbus[2], Gbus[1], Pbus[1],
				Gbus[0], Pbus[0], Cin, Cybus[3] );

endmodule


/********************************************/

module Mux2_1( In0, In1, ContIn, Out );

   input	In0, In1, ContIn;
   output	Out;

   inv  Mux2_0( .A(ContIn), .Y(Not_ContIn) );
   and2 Mux2_1( .A(In0), .B(Not_ContIn), .Y(line1) ),
       Mux2_2( .A(In1), .B(ContIn), .Y(line2) );
   or2 Mux2_3( .A(line1), .B(line2), .Y(Out) );
   
endmodule // Mux2_1


/********************************************/

module Invert4( Inbus, Outbus );

   input [3:0]	 Inbus;
   output [3:0] Outbus;

   inv Inv4_0( .A(Inbus[0]), .Y(Outbus[0]) ),
      Inv4_1( .A(Inbus[1]), .Y(Outbus[1]) ),
      Inv4_2( .A(Inbus[2]), .Y(Outbus[2]) ),
      Inv4_3( .A(Inbus[3]), .Y(Outbus[3]) );
   
endmodule // Invert4


/********************************************/

module XOR4bit( In1bus, In2bus, Outbus );
   
   input [3:0]	 In1bus, In2bus;
   output [3:0] Outbus;
   
   XOR2a X4_0( .A(In1bus[0]), .B(In2bus[0]), .Y(Outbus[0]) ),
         X4_1( .A(In1bus[1]), .B(In2bus[1]), .Y(Outbus[1]) ),
         X4_2( .A(In1bus[2]), .B(In2bus[2]), .Y(Outbus[2]) ),
         X4_3( .A(In1bus[3]), .B(In2bus[3]), .Y(Outbus[3]) );
   
endmodule // XOR4bit


/****************************************************
 * Module: Mux3_1c
 * 
 * Function:
 *   ContLo:  0    1    0    1
 *   ContHi:  0    0    1    1
 *   Out   :  +   In0  In1  In2
 * 
 *  (+: not possible--guaranteed by ContHi and ContLo)
*****************************************************/

module Mux3_1c( In0, In1, In2, ContHi, ContLo, Out );

   input	In0, In1, In2, ContHi, ContLo;
   output	Out;

// the structure reflects the gate-level description
   inv  Mux3c_0( .A(ContHi), .Y(NotContHi) ),
       Mux3c_1( .A(ContLo), .Y(NotContLo) );
   and2 Mux3c_2( .A(In0), .B(NotContHi), .Y(line2) ),
       Mux3c_3( .A(In1), .B(NotContLo), .Y(line3) ),
       Mux3c_4( .A(ContHi), .B(ContLo), .Y(line4) ),
       Mux3c_5( .A(line4), .B(In2), .Y(line5) );
   or3 Mux3c_6( .A(line2), .B(line3), .C(line5), .Y(Out) );
   
endmodule // Mux3_1c


/******************************************************/

module CarryProp4( Pbus, Cin, Cybus );

   input [3:0]	 Pbus;
   input		 Cin;
   output [3:0] Cybus;

   
// Cybus[0]=Cin
   buffer addedBuf138 (.A(Cin), .Y(Cybus[0]));

   and2 CP0( .A(Pbus[0]), .B(Cin), .Y(Cybus[1]) );
   and3 CP1( .A(Pbus[1]), .B(Pbus[0]), .C(Cin), .Y(Cybus[2]) );
   and4 CP2( .A(Pbus[2]), .B(Pbus[1]), .C(Pbus[0]),
		  .D(Cin), .Y(Cybus[3]) );

endmodule // CarryProp4


/****************************************************
 * Module: Mux3_1b
 * 
 * Function:
 *   ContLo:  0    1    0    1
 *   ContHi:  0    0    1    1
 *   Out   : In0  In1  In2   +
 * 
 *  (+: not possible--guaranteed by ContHi and ContLo)
*****************************************************/

module Mux3_1b( In0, In1, In2, ContHi, ContLo, Out );

   input	In0, In1, In2, ContHi, ContLo;
   output	Out;

// the structure reflects the gate-level description
   inv  Mux3b_0( .A(ContHi), .Y(NotContHi) ),
       Mux3b_1( .A(ContLo), .Y(NotContLo) );
   and3 Mux3b_2( .A(In0), .B(NotContHi), .C(NotContLo), .Y(line2) ),
       Mux3b_3( .A(In1), .B(NotContHi), .C(ContLo), .Y(line3) );
   and2 Mux3b_4( .A(In2), .B(ContHi), .Y(line4) );
   or3 Mux3b_5( .A(line2), .B(line3), .C(line4), .Y(Out) );
   
endmodule // Mux3_1b


/******************************************************/

module Mux8_1( In0, In1, In2, In3, In4, In5, In6, In7,
			Sel, Out );

   input		In0, In1, In2, In3, In4, In5, In6, In7;
   input [7:0]	Sel;
   output		Out;

   and2 M0( .A(In0), .B(Sel[0]), .Y(t0) ),
       M1( .A(In1), .B(Sel[1]), .Y(t1) ),
       M2( .A(In2), .B(Sel[2]), .Y(t2) ),
       M3( .A(In3), .B(Sel[3]), .Y(t3) ),
       M4( .A(In4), .B(Sel[4]), .Y(t4) ),
       M5( .A(In5), .B(Sel[5]), .Y(t5) ),
       M6( .A(In6), .B(Sel[6]), .Y(t6) ),
       M7( .A(In7), .B(Sel[7]), .Y(t7) );

   or8 M8( .A(t0), .B(t1), .C(t2), .D(t3), .E(t4),
		 .F(t5), .G(t6), .H(t7), .Y(Out) );

endmodule // Mux8_1


/********************************************/

module XOR3a( A, B, C, Y);

   input	A, B, C;
   output Y;
   
   inv  Xo3_0( .A(A), .Y(NotA) ),
       Xo3_1( .A(B), .Y(NotB) ),
       Xo3_2( .A(C), .Y(NotC) );
   and3 Xo3_3( .A(NotA), .B(NotB), .C(C), .Y(line3) ),
	  Xo3_4( .A(NotA), .B(B), .C(NotC), .Y(line4) ),
	  Xo3_5( .A(A), .B(NotB), .C(NotC), .Y(line5) ),
       	Xo3_6( .A(A), .B(B), .C(C), .Y(line6) );
   nor2 Xo3_7( .A(line3), .B(line4), .Y(line7) ),
       	Xo3_8( .A(line5), .B(line6), .Y(line8) );
   nand2 Xo3_9( .A(line7), .B(line8), .Y(Y) );

endmodule // XOR3a


/********************************************/

module Mux4bit3_1c( In0, In1, In2, ContHi, ContLo, Out );

   input [3:0]	 In0, In1, In2;
   input		 ContHi, ContLo;
   output [3:0] Out;

   Mux3_1c M4b3c_0( In0[0], In1[0], In2[0], ContHi, ContLo, Out[0] ),
           M4b3c_1( In0[1], In1[1], In2[1], ContHi, ContLo, Out[1] ),
           M4b3c_2( In0[2], In1[2], In2[2], ContHi, ContLo, Out[2] ),
           M4b3c_3( In0[3], In1[3], In2[3], ContHi, ContLo, Out[3] );

endmodule // Mux4bit3_1c


/********************************************
 * Submodule: CalcCinPropLo
 * 
 * Function: the CinPropLo line indicates whether
 *           Cin propagates to the upper half.
 * 
 * In Arithmetic Mode, it's (Cin.PropLo)
 * In Logic mode (Mode=1), it's either
 *               (InB[0].InB[1].InB[2].InB[3]).Cin or
 *               (!InB[0].!InB[1].!InB[2].!InB[3]).Cin
 *             as selected by InBpropSel.
 * !!! I have no idea about its use in Logic mode.
 * It may be a special feature.
********************************************/

module CalcCinPropLo( InBLo, PropLo, Cin, Mode, InBpropSel, CinPropLo);

   input [3:0]	InBLo;
   input		PropLo, Cin, Mode, InBpropSel;
   output		CinPropLo;

   and4    CCP0( .A(InBLo[0]), .B(InBLo[1]), .C(InBLo[2]),
			 .D(InBLo[3]), .Y(InBLoAND) );
   nor4    CCP1( .A(InBLo[0]), .B(InBLo[1]), .C(InBLo[2]),
			 .D(InBLo[3]), .Y(InBLoNOR) );
   Mux2_1 CCP2( InBLoAND, InBLoNOR, InBpropSel, InBprop ),
          CCP3( PropLo, InBprop, Mode, Pr );
   and2    CCP4( .A(Cin), .B(Pr), .Y(CinPropLo) );

endmodule // CalcCinPropLo


/********************************************
 * Module: Logic_and_GP
 * 
 * Function: generate the P, G, XP, XG signals
 *  used for addition and logic operations.
 * 
 * - All 16 functions of (InA,InB) are generated
 *   as selected by ContSel
 * - If Mask=1, XP=P xor InA (*), and XG=0
 *   If Mask=0, XP=P, and XG=G
 * 
 * (*) the xor modifies P and creates a different
 * function for XP.
 * 
********************************************/

module Logic_and_GP( InA, InB, ContSel, Mask,
				 P, G, XP, XG );

   input		InA, InB;
   input [3:0]	ContSel;
   input		Mask;
   output		P, G, XP, XG;

   Mux2_1 LGP0( ContSel[0], ContSel[1], InB, Mx0 ),
          LGP1( ContSel[2], ContSel[3], InB, Mx1 );
   and2    LGP2( .A(InA), .B(Mx1), .Y(G) );
   or2    LGP3( .A(InA), .B(Mx0), .Y(InAMx0) );
   nand2    LGP4( .A(InA), .B(Mx1), .Y(InAMx1) );
   and2    LGP5( .A(InAMx0), .B(InAMx1), .Y(P) );
   and2    LGP6( .A(Mask), .B(InA), .Y(InAMask) );
   XOR2a  LGP7( .A(InAMask), .B(P), .Y(XP) );
   inv     LGP8( .A(Mask), .Y(NotMask) );
   and2    LGP9( .A(G), .B(NotMask), .Y(XG) );

endmodule // Logic_and_GP


/****************************************************
 * Module: Mux4_1a
 * 
 * Function:
 *            Sel:  0    1    2    3
 *            Out: In0  In1  In2  In3
*****************************************************/

module Mux4_1a( In0, In1, In2, In3, Sel, Out );

   input		In0, In1, In2, In3;
   input [3:0]	Sel;
   output		Out;

   and2 Mux4a_0( .A(In0), .B(Sel[0]), .Y(line0) ),
       Mux4a_1( .A(In1), .B(Sel[1]), .Y(line1) ),
       Mux4a_2( .A(In2), .B(Sel[2]), .Y(line2) ),
       Mux4a_3( .A(In3), .B(Sel[3]), .Y(line3) );
   or4 Mux4a_4( .A(line0), .B(line1), .C(line2), .D(line3), .Y(Out) );
   
endmodule // Mux4_1a


/******************************************************/

module CLAblock( Pbus, Gbus, Cin1, Cin2, Cybus);

   input [3:0]	Pbus, Gbus;
   input	Cin1, Cin2;
   output [3:0]	Cybus;

   wire [3:0]	 Cy1bus, Cy2bus;

// Note 1: Cybus[i]: carry from bit (i-1) into bit i
   CLA4       Cb0( Pbus, Gbus, Cin1, Cy1bus );
   CarryProp4 Cb1( Pbus, Cin2, Cy2bus );

// Note 2: Both OR and XOR will work below
   XOR4bit  Cb2( Cy1bus, Cy2bus, Cybus );

endmodule // CLABlock


/********************************************
 * Module: Mux3_1a
 * 
 * Function:
 *   ContLo:  0    1    0    1
 *   ContHi:  0    0    1    1
 *   Out   : In0  In1  In2  In2
 * 
********************************************/

module Mux3_1a( In0, In1, In2, ContHi, ContLo, Out );

   input	In0, In1, In2, ContHi, ContLo;
   output	Out;

// the structure reflects the gate-level description
   or2 Mux3a_0( .A(ContHi), .B(ContLo), .Y(ContOr) );
   inv  Mux3a_1( .A(ContHi), .Y(NotContHi) ),
       Mux3a_2( .A(ContOr), .Y(Cont00) );
   and2 Mux3a_3( .A(NotContHi), .B(ContOr), .Y(Cont01) );
   and2 Mux3a_4( .A(In0), .B(Cont00), .Y(line4) ),
       Mux3a_5( .A(In1), .B(Cont01), .Y(line5) ),
       Mux3a_6( .A(In2), .B(ContHi), .Y(line6) );
   or3 Mux3a_7( .A(line4), .B(line5), .C(line6), .Y(Out) );
   
endmodule // Mux3_1a


/********************************************/

module Invert8( Inbus, Outbus );

   input [7:0]	 Inbus;
   output [7:0] Outbus;

   Invert4 Inv8_0( Inbus[3:0], Outbus[3:0] ),
           Inv8_1( Inbus[7:4], Outbus[7:4] );
   
endmodule // Invert8


/********************************************/

module Logic_and_GP8bit( InAbus, InBbus, ContSel, Mode, Mask7_6,
					Pbus, Gbus, XPbus, XGbus );

   input [7:0]	 InAbus, InBbus;
   input [3:0]	 ContSel;
   input		 Mode, Mask7_6;
   output [7:0] Pbus, Gbus, XPbus, XGbus;

   Logic_and_GP LGP8_0( InAbus[0], InBbus[0], ContSel, Mode,
				    Pbus[0], Gbus[0], XPbus[0], XGbus[0] ),
                LGP8_1( InAbus[1], InBbus[1], ContSel, Mode,
				    Pbus[1], Gbus[1], XPbus[1], XGbus[1] ),
                LGP8_2( InAbus[2], InBbus[2], ContSel, Mode,
				    Pbus[2], Gbus[2], XPbus[2], XGbus[2] ),
                LGP8_3( InAbus[3], InBbus[3], ContSel, Mode,
				    Pbus[3], Gbus[3], XPbus[3], XGbus[3] ),
                LGP8_4( InAbus[4], InBbus[4], ContSel, Mode,
				    Pbus[4], Gbus[4], XPbus[4], XGbus[4] ),
                LGP8_5( InAbus[5], InBbus[5], ContSel, Mode,
				    Pbus[5], Gbus[5], XPbus[5], XGbus[5] ),
                LGP8_6( InAbus[6], InBbus[6], ContSel, Mask7_6,
				    Pbus[6], Gbus[6], XPbus[6], XGbus[6] ),
                LGP8_7( InAbus[7], InBbus[7], ContSel, Mask7_6,
				    Pbus[7], Gbus[7], XPbus[7], XGbus[7] );

endmodule // Logic_and_GP8


/*****************************************************
 * Module: CalcCarry
 * 
 * Function: calculate the carry signals (XCarrybus)
 *  and a few other outputs (Carry4, Cout, Cout_in0,
 *  PropThru, Overflow)
 * 
 * Note: XCarrybus[i]: carry from bit (i-1) into bit i
******************************************************/

module CalcCarry( InBLo, Pbus, Gbus, XPbus, XGbus, Cin, Mode,
		  InBpropSel, XCarrybus, Carry4, Cout,
		  Cout_in0, PropThru, Overflow );

   input [3:0]	InBLo;
   input [7:0]	Pbus, Gbus, XPbus, XGbus;
   input	Cin, Mode, InBpropSel;
   output [7:0]	XCarrybus;
   output	Carry4, Cout;
   output	Cout_in0, PropThru, Overflow;

// first take care of  PropThru
   and4 CC0( .A(Pbus[0]), .B(Pbus[1]), .C(Pbus[2]), .D(Pbus[3]),
		  .Y(PropLo) ),
       CC1( .A(Pbus[4]), .B(Pbus[5]), .C(Pbus[6]), .D(Pbus[7]),
		  .Y(PropHi) );
   and2 CC2( .A(PropLo), .B(PropHi), .Y(PropThru) );
   
   inv CC3( .A(Mode), .Y(NotMode) );
   
// CinPropLo: indicates whether Cin propagates to the upper half
   CalcCinPropLo CC4( InBLo, PropLo, Cin, Mode, InBpropSel, CinPropLo);

   AND_OR4a CC5( Gbus[3], Pbus[3], Gbus[2], Pbus[2], Gbus[1], Pbus[1],
			  Gbus[0], LocalC0Lo );
   AND_OR4a CC6( Gbus[7], Pbus[7], Gbus[6], Pbus[6], Gbus[5], Pbus[5],
			  Gbus[4], LocalC0Hi );

   and2 CC7( .A(LocalC0Lo), .B(NotMode), .Y(LoC0_M) );
   
   CLAblock CC8( XPbus[3:0], XGbus[3:0], 1'b0,   Cin,       XCarrybus[3:0] ),
            CC9( XPbus[7:4], XGbus[7:4], LoC0_M, CinPropLo, XCarrybus[7:4] );
   
// Cout_in0, Carry4, Cout
   AND_OR2  CC10( LocalC0Hi, LocalC0Lo, PropHi, Cout_in0 );
   or2      CC11( .A(CinPropLo), .B(LoC0_M), .Y(Carry4) );
   and2     CC12( .A(CinPropLo), .B(PropHi), .Y(line12) );
   or2      CC13( .A(Cout_in0), .B(line12), .Y(Cout) );

// Overflow = Ovf_Carry8 XOR XCarrybus[7]
//   
   AND_OR2  CC14( LocalC0Hi, LoC0_M, PropHi, Cout_M_in0);
   XOR2a    CC15( .A(Cout_M_in0), .B(line12), .Y(Ovf_Carry8) );
   XOR2a    CC16( .A(Ovf_Carry8), .B(XCarrybus[7]), .Y(Overflow) );
 
endmodule // CalcCarry


/********************************************/

module Mux8bit3_1c( In0, In1, In2, ContHi, ContLo, Out );

   input [7:0]	 In0, In1, In2;
   input		 ContHi, ContLo;
   output [7:0] Out;

   Mux4bit3_1c M8b3c_0( In0[3:0], In1[3:0], In2[3:0],
			ContHi, ContLo, Out[3:0] ),
               M8b3c_1( In0[7:4], In1[7:4], In2[7:4],
			ContHi, ContLo, Out[7:4] );

endmodule // Mux8bit3_1c


/******************************************************/

module LogicBlockM9( Abus, Bbus, ContInp, T1bus, T2bus );

   input [7:0]	 Abus, Bbus;
   input		 ContInp;
   output [3:0] T1bus;
   output [1:0] T2bus;

   wire [7:0]	 NotAbus, NotBbus;

// T1[0] = T1[0]_0, T1[0]_1
//         T1[0]_0 = A[7].(A[5]+[6])
//         T1[0]_1 = XNOR( A[7], A[6], A[5], A[4])

   Invert8 BM0( Abus, NotAbus );
   nand2     BM1( .A(NotAbus[6]), .B(NotAbus[5]), .Y(NotA6_5) );
   and2     BM2( .A(Abus[7]), .B(NotA6_5), .Y(T1_0_0) );
   XOR2a   BM3( .A(NotAbus[4]), .B(NotAbus[5]), .Y(XA5_4) ),
           BM4( .A(NotAbus[6]), .B(Abus[7]), .Y(NotXA7_6) ),
           BM5( .A(XA5_4), .B(NotXA7_6), .Y(T1_0_1) );
   Mux2_1  BM6( T1_0_0, T1_0_1, ContInp, T1bus[0] );

// T1[1] = T1[1]_0, T1[1]_1
//         T1[1]_0 = !A[7].A[6].(!A[5]+!A[4]).!A[3].!A[2].!A[1].!A[0]
//                   (check for patterns 8'h40, 8'h50, 8'h60)
//         T1[1]_1 = XNOR( B[7], B[6], B[5], B[4])

   and3      BM7( .A(NotAbus[3]), .B(NotAbus[2]), .C(NotAbus[1]),
			  .Y(NotA3_1) );
   and2      BM8( .A(NotAbus[0]), .B(NotA3_1), .Y(NotA3_0) );
   nand2      BM9( .A(Abus[4]), .B(Abus[5]), .Y(NdA5_4) );
   and4     BM10( .A(NotA3_0), .B(NdA5_4), .C(NotAbus[7]),
			  .D(Abus[6]), .Y(T1_1_0) );
   XOR2a   BM11( .A(Bbus[4]), .B(Bbus[5]), .Y(XB5_4) ),
           BM12( .A(Bbus[7]), .B(Bbus[6]), .Y(XB7_6) ),
           BM13( .A(XB5_4), .B(XB7_6), .Y(XB7_4) );
   inv      BM14( .A(XB7_4), .Y(T1_1_1) );
   Mux2_1  BM15( T1_1_0, T1_1_1, ContInp, T1bus[1] );

// T1[2] = XNOR( A[0], A[1], A[2], A[3])

   XOR2a   BM16( .A(NotAbus[0]), .B(NotAbus[1]), .Y(XA1_0) ),
           BM17( .A(NotAbus[2]), .B(NotAbus[3]), .Y(XA3_2) ),
           BM18( .A(XA1_0), .B(XA3_2), .Y(XA3_0) );
   inv      BM19( .A(XA3_0), .Y(T1bus[2]) );

// T1[3] = XNOR( B[0], B[1], B[2], B[3])

   XOR2a   BM20( .A(Bbus[0]), .B(Bbus[1]), .Y(XB1_0) ),
           BM21( .A(Bbus[2]), .B(Bbus[3]), .Y(XB3_2) ),
           BM22( .A(XB1_0), .B(XB3_2), .Y(XB3_0) );
   inv      BM23( .A(XB3_0), .Y(T1bus[3]) );

// T2[0] = A[3]+A[2].A[1]

   nand2     BM24( .A(NotAbus[2]), .B(NotAbus[1]), .Y(NotA1_0) );
   and2     BM25( .A(Abus[3]), .B(NotA1_0), .Y(T2bus[0]) );

// T2[1] = !(A[3]+A[2]+A[1]+A[0])

   and2     BM26( .A(NotAbus[0]), .B(NotA3_1), .Y(T2bus[1]) );

endmodule // LogicBlockM9


/********************************************/

module ParityTree9bit( Inbus, ParOut );

   input [8:0]	Inbus;
   output		ParOut;

   XOR2a PT1( .A(Inbus[0]), .B(Inbus[1]), .Y(line1) ),
         PT2( .A(Inbus[2]), .B(Inbus[3]), .Y(line2) ),
         PT3( .A(Inbus[4]), .B(Inbus[5]), .Y(line3) ),
         PT4( .A(Inbus[6]), .B(Inbus[7]), .Y(line4) ),
         PT5( .A(line1), .B(line2), .Y(line5) );
   XOR3a PT6( .A(line3), .B(line4), .C(Inbus[8]), .Y(line6) );
   XOR2a PT7( .A(line5), .B(line6), .Y(ParOut) );

endmodule // ParityTree9bit


/********************************************/

module BCD_add6_digit( Inbus, Outbus );

   input [3:0]	 Inbus;
   output [3:0] Outbus;

   
// Outbus[0] = Inbus[0]
   buffer addedBuf153 (.A(Inbus[0]), .Y(Outbus[0]));

   inv    BaD0( .A(Inbus[1]), .Y(Outbus[1]) );
   XOR2a BaD1( .A(Inbus[2]), .B(Inbus[1]), .Y(line1) );
   inv    BaD2( .A(line1), .Y(Outbus[2]) ),
         BaD3( .A(Inbus[2]), .Y(line3) ),
         BaD4( .A(Inbus[3]), .Y(line4) );
   nand3   BaD5( .A(Outbus[1]), .B(line3), .C(line4), .Y(Outbus[3]) );

endmodule // BCD_add6_digit





/***************************************************************************
 * Definition of non-standard multiplexers of c3540
***************************************************************************/

module Mux8bit3_1a( In0, In1, In2, ContHi, ContLo, Out );

   input [7:0]	 In0, In1, In2;
   input		 ContHi, ContLo;
   output [7:0] Out;

   Mux3_1a M8b3a_0( In0[0], In1[0], In2[0], ContHi, ContLo, Out[0] ),
           M8b3a_1( In0[1], In1[1], In2[1], ContHi, ContLo, Out[1] ),
           M8b3a_2( In0[2], In1[2], In2[2], ContHi, ContLo, Out[2] ),
           M8b3a_3( In0[3], In1[3], In2[3], ContHi, ContLo, Out[3] ),
           M8b3a_4( In0[4], In1[4], In2[4], ContHi, ContLo, Out[4] ),
           M8b3a_5( In0[5], In1[5], In2[5], ContHi, ContLo, Out[5] ),
           M8b3a_6( In0[6], In1[6], In2[6], ContHi, ContLo, Out[6] ),
           M8b3a_7( In0[7], In1[7], In2[7], ContHi, ContLo, Out[7] );

endmodule // Mux8bit3_1a


/****************************************************/

module Mux4bit4_1a( In0, In1, In2, In3, Sel, Out );

   input [3:0]	 In0, In1, In2, In3;
   input [3:0]	 Sel;
   output [3:0] Out;

   Mux4_1a M4b4a_0( In0[0], In1[0], In2[0], In3[0], Sel[3:0], Out[0] ),
           M4b4a_1( In0[1], In1[1], In2[1], In3[1], Sel[3:0], Out[1] ),
           M4b4a_2( In0[2], In1[2], In2[2], In3[2], Sel[3:0], Out[2] ),
           M4b4a_3( In0[3], In1[3], In2[3], In3[3], Sel[3:0], Out[3] );

endmodule // Mux4_1a


/******************************************************/

module Mux8bit8_1( In0, In1, In2, In3, In4, In5, In6, In7,
			    Sel, Out );

   input [7:0]	 In0, In1, In2, In3, In4, In5, In6, In7;
   input [7:0]	 Sel;
   output [7:0] Out;
   
   Mux8_1  M8_0( In0[0], In1[0], In2[0], In3[0],
		 In4[0], In5[0], In6[0], In7[0], Sel, Out[0] ),
           M8_1( In0[1], In1[1], In2[1], In3[1],
		 In4[1], In5[1], In6[1], In7[1], Sel, Out[1] ),
           M8_2( In0[2], In1[2], In2[2], In3[2],
		 In4[2], In5[2], In6[2], In7[2], Sel, Out[2] ),
           M8_3( In0[3], In1[3], In2[3], In3[3],
		 In4[3], In5[3], In6[3], In7[3], Sel, Out[3] ),
           M8_4( In0[4], In1[4], In2[4], In3[4],
		 In4[4], In5[4], In6[4], In7[4], Sel, Out[4] ),
           M8_5( In0[5], In1[5], In2[5], In3[5],
		 In4[5], In5[5], In6[5], In7[5], Sel, Out[5] ),
           M8_6( In0[6], In1[6], In2[6], In3[6],
		 In4[6], In5[6], In6[6], In7[6], Sel, Out[6] ),
           M8_7( In0[7], In1[7], In2[7], In3[7],
		 In4[7], In5[7], In6[7], In7[7], Sel, Out[7] );

endmodule // Mux8bit8_1



/***************************************************************************
 * Description of some basic gates/modules
***************************************************************************/

module ParityTree8bit( Inbus, ParOut );

   input [7:0]	Inbus;
   output		ParOut;

   XOR2a PT1( .A(Inbus[0]), .B(Inbus[1]), .Y(line1) ),
         PT2( .A(Inbus[2]), .B(Inbus[3]), .Y(line2) ),
         PT3( .A(Inbus[4]), .B(Inbus[5]), .Y(line3) ),
         PT4( .A(Inbus[6]), .B(Inbus[7]), .Y(line4) ),
         PT5( .A(line1), .B(line2), .Y(line5) ),
         PT6( .A(line3), .B(line4), .Y(line6) ),
         PT7( .A(line5), .B(line6), .Y(ParOut) );

endmodule // ParityTree8bit


/******************************************************/

module BCD_sub6_digit( Inbus, Carry, Outbus );

   input [3:0]	 Inbus;
   input		 Carry;
   output [3:0] Outbus;

   
// Outbus[0] = Inbus[0]
   buffer addedBuf137 (.A(Inbus[0]), .Y(Outbus[0]));

   inv    Bsd0( .A(Carry), .Y(NotCarry) );
   XOR2a Bsd1( .A(Inbus[1]), .B(NotCarry), .Y(Outbus[1]) );
   and2   Bsd2( .A(Inbus[1]), .B(NotCarry), .Y(line2) );
   XOR2a Bsd3( .A(Inbus[2]), .B(line2), .Y(Outbus[2]) );
   and4   Bsd4( .A(Inbus[3]), .B(Inbus[2]), .C(Inbus[1]),
			.D(NotCarry), .Y(line4) );
   and2   Bsd5( .A(Inbus[3]), .B(Carry), .Y(line5) );
   or2   Bsd6( .A(line4), .B(line5), .Y(Outbus[3]) );

endmodule // BCD_sub6_digit


/******************************************************/

module DecodeContSignals( CodeIn, CodeOut );

   input [3:0]	 CodeIn;
   output [7:0] CodeOut;

   and2 DCS0( .A(CodeIn[0]), .B(CodeIn[1]), .Y(tmp0) );
   inv  DCS1( .A(tmp0), .Y(tmp1) ),
       DCS2( .A(CodeIn[0]), .Y(tmp2) );
   nand2 DCS3( .A(CodeIn[0]), .B(CodeIn[3]), .Y(tmp3) );
   and2 DCS4( .A(CodeIn[0]), .B(CodeIn[3]), .Y(tmp4) );
   nor2 DCS5( .A(tmp2), .B(CodeIn[2]), .Y(tmp5) );
   and2 DCS6( .A(tmp3), .B(tmp1), .Y(tmp6) ),
       DCS7( .A(tmp4), .B(tmp1), .Y(tmp7) );
   or2 DCS8( .A(tmp2), .B(CodeIn[2]), .Y(tmp8) );
   inv  DCS9( .A(CodeIn[3]), .Y(tmp9) );
   and2 DCS10( .A(tmp9), .B(tmp0), .Y(tmp10) ),
       DCS11( .A(CodeIn[3]), .B(tmp0), .Y(tmp11) );
   

   and2 DCS13( .A(tmp5), .B(tmp7), .Y(CodeOut[0]) ),
       DCS14( .A(tmp6), .B(tmp8), .Y(CodeOut[1]) ),
       DCS15( .A(tmp8), .B(tmp7), .Y(CodeOut[2]) ),
       DCS16( .A(tmp5), .B(tmp10), .Y(CodeOut[3]) ),
       DCS17( .A(tmp5), .B(tmp11), .Y(CodeOut[4]) ),
       DCS18( .A(tmp8), .B(tmp10), .Y(CodeOut[5]) ),
       DCS19( .A(tmp8), .B(tmp11), .Y(CodeOut[6]) ),
       DCS12( .A(tmp5), .B(tmp6), .Y(CodeOut[7]) );
   
endmodule // DecodeContSignals


/********************************************/

module Mux4bit3_1b( In0, In1, In2, ContHi, ContLo, Out );

   input [3:0]	 In0, In1, In2;
   input		 ContHi, ContLo;
   output [3:0] Out;

   Mux3_1b M4b3b_0( In0[0], In1[0], In2[0], ContHi, ContLo, Out[0] ),
           M4b3b_1( In0[1], In1[1], In2[1], ContHi, ContLo, Out[1] ),
           M4b3b_2( In0[2], In1[2], In2[2], ContHi, ContLo, Out[2] ),
           M4b3b_3( In0[3], In1[3], In2[3], ContHi, ContLo, Out[3] );

endmodule // Mux4bit3_1b



/***************************************************************************
 * Module 5: ALU_Core
 * 
 * Function: performs arithmetic/logic operations
 * 
 *  - the result is obtained by XORing XPbus and XCarrybus (module M6).
 *  - The Mode signal, generated from the ContIn bus, specifies
 *    whether a logical or arithmetic operation is to be performed.
 *  - The 4-bit ContSel bus specifies the logical operations and
 *    what operands to use for the arithmetic operations.
 *    Example:
 *      ContSel=1000 => XP = InA AND InB               (logical)
 *            XP XOR Carry = (InA AND InB) plus InBbus (arithmetic)
 * 
***************************************************************************/

module ALU_Core( InAbus, InBbus, Cin, ContIn,
		 XPbus, XCarrybus, XCarry2, Carry4, Cout,
		 Cout_in0, PropThru, Overflow );
			  

   input [7:0]	InAbus, InBbus;
   input	Cin;
   input [13:0]	ContIn;
   output [7:0]	XPbus, XCarrybus;
   output	XCarry2, Carry4, Cout;
   output	Cout_in0, PropThru, Overflow;

   wire [7:0]	Pbus, Gbus, XGbus;
   wire [3:0]	ContSel;
   
// first: create Mode and Mask7_6 signals
// Mode    = !Cont0. Cont1. !Cont2. Cont8. Cont9
// Mask7_6 = !Cont0. Cont1. !Cont2. Cont8
   
   inv  UM5_0( .A(ContIn[0]), .Y(NotCont0) ),
       UM5_1( .A(ContIn[2]), .Y(NotCont2) );
   and3 UM5_2( .A(NotCont0), .B(ContIn[1]), .C(NotCont2), .Y(ModeAux) ),
       UM5_3( .A(ModeAux), .B(ContIn[8]), .C(ContIn[9]), .Y(Mode) );
   and2 UM5_4( .A(ModeAux), .B(ContIn[8]), .Y(Mask7_6) );

// Mode=1: LOGIC MODE      (Mask7_6 is also 1)
// Mode=0: ARITHMETIC MODE
//   ( In this mode, if Mask7_6=1, then the 7th and 6th bits
//     of InAbus are masked, i.e., they are assumed 0 )

   
// ContSel[3:0] = { ContIn[7], ContIn[10], ContIn[12:11] }
   buffer addedBuf141 (.A(ContIn[7]), .Y(ContSel[3]));
   buffer addedBuf142 (.A(ContIn[10]), .Y(ContSel[2]));
   buffer addedBuf143 (.A(ContIn[12]), .Y(ContSel[1]));
   buffer addedBuf144 (.A(ContIn[11]), .Y(ContSel[0]));


   Logic_and_GP8bit UM5_5( InAbus, InBbus, ContSel, Mode, Mask7_6,
			   Pbus, Gbus, XPbus, XGbus );
   
   CalcCarry UM5_6( InBbus[3:0], Pbus, Gbus, XPbus, XGbus, Cin, Mode,
		    ContIn[10], XCarrybus, Carry4, Cout,
		    Cout_in0, PropThru, Overflow );

   
// XCarry2 = XCarrybus[2]
   buffer addedBuf140 (.A(XCarrybus[2]), .Y(XCarry2));


endmodule // ALU_Core



/***************************************************************************
 * Module 11: MuxModule11
 * 
 * Function: a 3:1 mux with inputs Wbus (from MuxModule10), Funcbus
 *  (from the XOR of XP and XCarry) and F_BCDbus (from BCD_sub).
 * 
***************************************************************************/

module MuxModule11( Wbus, Funcbus, F_BCDbus, ContIn, Zbus );
   
   input [7:0]	 Wbus, Funcbus, F_BCDbus;
   input [13:0] ContIn;
   output [7:0] Zbus;

// Mux select inputs:
//   ContHi = Cont0. !(Cont1. !Cont2. Cont6)
//   ContLo = !(Cont0. !Cont1. Cont2. !Cont5)

   inv  UM11_0( .A(ContIn[1]), .Y(NotCont1) ),
       UM11_1( .A(ContIn[2]), .Y(NotCont2) ),
       UM11_2( .A(ContIn[5]), .Y(NotCont5) );
   nand3 UM11_3( .A(ContIn[1]), .B(NotCont2), .C(ContIn[6]), .Y(tmp0) );
   and2 UM11_4( .A(ContIn[0]), .B(tmp0), .Y(ContHi) );
   nand4 UM11_5( .A(ContIn[0]), .B(NotCont1), .C(ContIn[2]),
		 .D(NotCont5), .Y(ContLo) );

   Mux8bit3_1c UM11_7( Wbus, Funcbus, F_BCDbus, ContHi, ContLo, Zbus);

endmodule // MuxModule11



/***************************************************************************
 * Module M8: Shifter
 * 
 * Function: Abus is shifted both left and right by 1 to 8 bits.
 *   The Q and R buses fill the empty positions.
 * 
***************************************************************************/

module Shifter( Abus, Qbus, Rbus, ContIn, Sbus );

   input [7:0]	 Abus, Qbus, Rbus;
   input [13:0] ContIn;
   output [7:0] Sbus;
   
   wire [7:0]	 ContShift;
   wire [7:0]	 ShiftQ0bus, ShiftQ1bus, ShiftQ2bus, ShiftQ3bus,
		 ShiftQ4bus, ShiftQ5bus, ShiftQ6bus, ShiftQ7bus,
		 ShiftR0bus, ShiftR1bus, ShiftR2bus, ShiftR3bus,
		 ShiftR4bus, ShiftR5bus, ShiftR6bus, ShiftR7bus,
		 ShiftQout, ShiftRout;
   
   
   DecodeContSignals UM8_0( {ContIn[12:10],ContIn[2]}, ContShift );

   
// ShiftQ0bus[7:0]={ Qbus[0],   Abus[7:1] }
   buffer addedBuf9 (.A(Qbus[0]), .Y(ShiftQ0bus[7]));
   buffer addedBuf10 (.A(Abus[7]), .Y(ShiftQ0bus[6]));
   buffer addedBuf11 (.A(Abus[6]), .Y(ShiftQ0bus[5]));
   buffer addedBuf12 (.A(Abus[5]), .Y(ShiftQ0bus[4]));
   buffer addedBuf13 (.A(Abus[4]), .Y(ShiftQ0bus[3]));
   buffer addedBuf14 (.A(Abus[3]), .Y(ShiftQ0bus[2]));
   buffer addedBuf15 (.A(Abus[2]), .Y(ShiftQ0bus[1]));
   buffer addedBuf16 (.A(Abus[1]), .Y(ShiftQ0bus[0]));

// ShiftQ1bus[7:0]={ Qbus[1:0], Abus[7:2] }
   buffer addedBuf17 (.A(Qbus[1]), .Y(ShiftQ1bus[7]));
   buffer addedBuf18 (.A(Qbus[0]), .Y(ShiftQ1bus[6]));
   buffer addedBuf19 (.A(Abus[7]), .Y(ShiftQ1bus[5]));
   buffer addedBuf20 (.A(Abus[6]), .Y(ShiftQ1bus[4]));
   buffer addedBuf21 (.A(Abus[5]), .Y(ShiftQ1bus[3]));
   buffer addedBuf22 (.A(Abus[4]), .Y(ShiftQ1bus[2]));
   buffer addedBuf23 (.A(Abus[3]), .Y(ShiftQ1bus[1]));
   buffer addedBuf24 (.A(Abus[2]), .Y(ShiftQ1bus[0]));

// ShiftQ2bus[7:0]={ Qbus[2:0], Abus[7:3] }
   buffer addedBuf25 (.A(Qbus[2]), .Y(ShiftQ2bus[7]));
   buffer addedBuf26 (.A(Qbus[1]), .Y(ShiftQ2bus[6]));
   buffer addedBuf27 (.A(Qbus[0]), .Y(ShiftQ2bus[5]));
   buffer addedBuf28 (.A(Abus[7]), .Y(ShiftQ2bus[4]));
   buffer addedBuf29 (.A(Abus[6]), .Y(ShiftQ2bus[3]));
   buffer addedBuf30 (.A(Abus[5]), .Y(ShiftQ2bus[2]));
   buffer addedBuf31 (.A(Abus[4]), .Y(ShiftQ2bus[1]));
   buffer addedBuf32 (.A(Abus[3]), .Y(ShiftQ2bus[0]));

// ShiftQ3bus[7:0]={ Qbus[3:0], Abus[7:4] }
   buffer addedBuf33 (.A(Qbus[3]), .Y(ShiftQ3bus[7]));
   buffer addedBuf34 (.A(Qbus[2]), .Y(ShiftQ3bus[6]));
   buffer addedBuf35 (.A(Qbus[1]), .Y(ShiftQ3bus[5]));
   buffer addedBuf36 (.A(Qbus[0]), .Y(ShiftQ3bus[4]));
   buffer addedBuf37 (.A(Abus[7]), .Y(ShiftQ3bus[3]));
   buffer addedBuf38 (.A(Abus[6]), .Y(ShiftQ3bus[2]));
   buffer addedBuf39 (.A(Abus[5]), .Y(ShiftQ3bus[1]));
   buffer addedBuf40 (.A(Abus[4]), .Y(ShiftQ3bus[0]));

// ShiftQ4bus[7:0]={ Qbus[4:0], Abus[7:5] }
   buffer addedBuf41 (.A(Qbus[4]), .Y(ShiftQ4bus[7]));
   buffer addedBuf42 (.A(Qbus[3]), .Y(ShiftQ4bus[6]));
   buffer addedBuf43 (.A(Qbus[2]), .Y(ShiftQ4bus[5]));
   buffer addedBuf44 (.A(Qbus[1]), .Y(ShiftQ4bus[4]));
   buffer addedBuf45 (.A(Qbus[0]), .Y(ShiftQ4bus[3]));
   buffer addedBuf46 (.A(Abus[7]), .Y(ShiftQ4bus[2]));
   buffer addedBuf47 (.A(Abus[6]), .Y(ShiftQ4bus[1]));
   buffer addedBuf48 (.A(Abus[5]), .Y(ShiftQ4bus[0]));

// ShiftQ5bus[7:0]={ Qbus[5:0], Abus[7:6] }
   buffer addedBuf49 (.A(Qbus[5]), .Y(ShiftQ5bus[7]));
   buffer addedBuf50 (.A(Qbus[4]), .Y(ShiftQ5bus[6]));
   buffer addedBuf51 (.A(Qbus[3]), .Y(ShiftQ5bus[5]));
   buffer addedBuf52 (.A(Qbus[2]), .Y(ShiftQ5bus[4]));
   buffer addedBuf53 (.A(Qbus[1]), .Y(ShiftQ5bus[3]));
   buffer addedBuf54 (.A(Qbus[0]), .Y(ShiftQ5bus[2]));
   buffer addedBuf55 (.A(Abus[7]), .Y(ShiftQ5bus[1]));
   buffer addedBuf56 (.A(Abus[6]), .Y(ShiftQ5bus[0]));

// ShiftQ6bus[7:0]={ Qbus[6:0], Abus[7] }
   buffer addedBuf57 (.A(Qbus[6]), .Y(ShiftQ6bus[7]));
   buffer addedBuf58 (.A(Qbus[5]), .Y(ShiftQ6bus[6]));
   buffer addedBuf59 (.A(Qbus[4]), .Y(ShiftQ6bus[5]));
   buffer addedBuf60 (.A(Qbus[3]), .Y(ShiftQ6bus[4]));
   buffer addedBuf61 (.A(Qbus[2]), .Y(ShiftQ6bus[3]));
   buffer addedBuf62 (.A(Qbus[1]), .Y(ShiftQ6bus[2]));
   buffer addedBuf63 (.A(Qbus[0]), .Y(ShiftQ6bus[1]));
   buffer addedBuf64 (.A(Abus[7]), .Y(ShiftQ6bus[0]));

// ShiftQ7bus[7:0]={ Qbus[7:0] }
   buffer addedBuf65 (.A(Qbus[7]), .Y(ShiftQ7bus[7]));
   buffer addedBuf66 (.A(Qbus[6]), .Y(ShiftQ7bus[6]));
   buffer addedBuf67 (.A(Qbus[5]), .Y(ShiftQ7bus[5]));
   buffer addedBuf68 (.A(Qbus[4]), .Y(ShiftQ7bus[4]));
   buffer addedBuf69 (.A(Qbus[3]), .Y(ShiftQ7bus[3]));
   buffer addedBuf70 (.A(Qbus[2]), .Y(ShiftQ7bus[2]));
   buffer addedBuf71 (.A(Qbus[1]), .Y(ShiftQ7bus[1]));
   buffer addedBuf72 (.A(Qbus[0]), .Y(ShiftQ7bus[0]));

// ShiftR0bus[7:0]={ Abus[6:0], Rbus[7] }
   buffer addedBuf73 (.A(Abus[6]), .Y(ShiftR0bus[7]));
   buffer addedBuf74 (.A(Abus[5]), .Y(ShiftR0bus[6]));
   buffer addedBuf75 (.A(Abus[4]), .Y(ShiftR0bus[5]));
   buffer addedBuf76 (.A(Abus[3]), .Y(ShiftR0bus[4]));
   buffer addedBuf77 (.A(Abus[2]), .Y(ShiftR0bus[3]));
   buffer addedBuf78 (.A(Abus[1]), .Y(ShiftR0bus[2]));
   buffer addedBuf79 (.A(Abus[0]), .Y(ShiftR0bus[1]));
   buffer addedBuf80 (.A(Rbus[7]), .Y(ShiftR0bus[0]));

// ShiftR1bus[7:0]={ Abus[5:0], Rbus[7:6] }
   buffer addedBuf81 (.A(Abus[5]), .Y(ShiftR1bus[7]));
   buffer addedBuf82 (.A(Abus[4]), .Y(ShiftR1bus[6]));
   buffer addedBuf83 (.A(Abus[3]), .Y(ShiftR1bus[5]));
   buffer addedBuf84 (.A(Abus[2]), .Y(ShiftR1bus[4]));
   buffer addedBuf85 (.A(Abus[1]), .Y(ShiftR1bus[3]));
   buffer addedBuf86 (.A(Abus[0]), .Y(ShiftR1bus[2]));
   buffer addedBuf87 (.A(Rbus[7]), .Y(ShiftR1bus[1]));
   buffer addedBuf88 (.A(Rbus[6]), .Y(ShiftR1bus[0]));

// ShiftR2bus[7:0]={ Abus[4:0], Rbus[7:5] }
   buffer addedBuf89 (.A(Abus[4]), .Y(ShiftR2bus[7]));
   buffer addedBuf90 (.A(Abus[3]), .Y(ShiftR2bus[6]));
   buffer addedBuf91 (.A(Abus[2]), .Y(ShiftR2bus[5]));
   buffer addedBuf92 (.A(Abus[1]), .Y(ShiftR2bus[4]));
   buffer addedBuf93 (.A(Abus[0]), .Y(ShiftR2bus[3]));
   buffer addedBuf94 (.A(Rbus[7]), .Y(ShiftR2bus[2]));
   buffer addedBuf95 (.A(Rbus[6]), .Y(ShiftR2bus[1]));
   buffer addedBuf96 (.A(Rbus[5]), .Y(ShiftR2bus[0]));

// ShiftR3bus[7:0]={ Abus[3:0], Rbus[7:4] }
   buffer addedBuf97 (.A(Abus[3]), .Y(ShiftR3bus[7]));
   buffer addedBuf98 (.A(Abus[2]), .Y(ShiftR3bus[6]));
   buffer addedBuf99 (.A(Abus[1]), .Y(ShiftR3bus[5]));
   buffer addedBuf100 (.A(Abus[0]), .Y(ShiftR3bus[4]));
   buffer addedBuf101 (.A(Rbus[7]), .Y(ShiftR3bus[3]));
   buffer addedBuf102 (.A(Rbus[6]), .Y(ShiftR3bus[2]));
   buffer addedBuf103 (.A(Rbus[5]), .Y(ShiftR3bus[1]));
   buffer addedBuf104 (.A(Rbus[4]), .Y(ShiftR3bus[0]));

// ShiftR4bus[7:0]={ Abus[2:0], Rbus[7:3] }
   buffer addedBuf105 (.A(Abus[2]), .Y(ShiftR4bus[7]));
   buffer addedBuf106 (.A(Abus[1]), .Y(ShiftR4bus[6]));
   buffer addedBuf107 (.A(Abus[0]), .Y(ShiftR4bus[5]));
   buffer addedBuf108 (.A(Rbus[7]), .Y(ShiftR4bus[4]));
   buffer addedBuf109 (.A(Rbus[6]), .Y(ShiftR4bus[3]));
   buffer addedBuf110 (.A(Rbus[5]), .Y(ShiftR4bus[2]));
   buffer addedBuf111 (.A(Rbus[4]), .Y(ShiftR4bus[1]));
   buffer addedBuf112 (.A(Rbus[3]), .Y(ShiftR4bus[0]));

// ShiftR5bus[7:0]={ Abus[1:0], Rbus[7:2] }
   buffer addedBuf113 (.A(Abus[1]), .Y(ShiftR5bus[7]));
   buffer addedBuf114 (.A(Abus[0]), .Y(ShiftR5bus[6]));
   buffer addedBuf115 (.A(Rbus[7]), .Y(ShiftR5bus[5]));
   buffer addedBuf116 (.A(Rbus[6]), .Y(ShiftR5bus[4]));
   buffer addedBuf117 (.A(Rbus[5]), .Y(ShiftR5bus[3]));
   buffer addedBuf118 (.A(Rbus[4]), .Y(ShiftR5bus[2]));
   buffer addedBuf119 (.A(Rbus[3]), .Y(ShiftR5bus[1]));
   buffer addedBuf120 (.A(Rbus[2]), .Y(ShiftR5bus[0]));

// ShiftR6bus[7:0]={ Abus[0], Rbus[7:1] }
   buffer addedBuf121 (.A(Abus[0]), .Y(ShiftR6bus[7]));
   buffer addedBuf122 (.A(Rbus[7]), .Y(ShiftR6bus[6]));
   buffer addedBuf123 (.A(Rbus[6]), .Y(ShiftR6bus[5]));
   buffer addedBuf124 (.A(Rbus[5]), .Y(ShiftR6bus[4]));
   buffer addedBuf125 (.A(Rbus[4]), .Y(ShiftR6bus[3]));
   buffer addedBuf126 (.A(Rbus[3]), .Y(ShiftR6bus[2]));
   buffer addedBuf127 (.A(Rbus[2]), .Y(ShiftR6bus[1]));
   buffer addedBuf128 (.A(Rbus[1]), .Y(ShiftR6bus[0]));

// ShiftR7bus[7:0]={ Rbus[7:0] }
   buffer addedBuf129 (.A(Rbus[7]), .Y(ShiftR7bus[7]));
   buffer addedBuf130 (.A(Rbus[6]), .Y(ShiftR7bus[6]));
   buffer addedBuf131 (.A(Rbus[5]), .Y(ShiftR7bus[5]));
   buffer addedBuf132 (.A(Rbus[4]), .Y(ShiftR7bus[4]));
   buffer addedBuf133 (.A(Rbus[3]), .Y(ShiftR7bus[3]));
   buffer addedBuf134 (.A(Rbus[2]), .Y(ShiftR7bus[2]));
   buffer addedBuf135 (.A(Rbus[1]), .Y(ShiftR7bus[1]));
   buffer addedBuf136 (.A(Rbus[0]), .Y(ShiftR7bus[0]));

   
   Mux8bit8_1 UM8_1( ShiftQ0bus, ShiftQ1bus, ShiftQ2bus, ShiftQ3bus,
		     ShiftQ4bus, ShiftQ5bus, ShiftQ6bus, ShiftQ7bus,
		     ContShift, ShiftQout ),
              UM8_2( ShiftR0bus, ShiftR1bus, ShiftR2bus, ShiftR3bus,
		     ShiftR4bus, ShiftR5bus, ShiftR6bus, ShiftR7bus,
		     ContShift, ShiftRout );
   
   Mux2_1 UM8_3( ShiftQout[0], ShiftRout[0], ContIn[3], Sbus[0] ),
          UM8_4( ShiftQout[1], ShiftRout[1], ContIn[3], Sbus[1] ),
          UM8_5( ShiftQout[2], ShiftRout[2], ContIn[3], Sbus[2] ),
          UM8_6( ShiftQout[3], ShiftRout[3], ContIn[3], Sbus[3] ),
          UM8_7( ShiftQout[4], ShiftRout[4], ContIn[3], Sbus[4] ),
          UM8_8( ShiftQout[5], ShiftRout[5], ContIn[3], Sbus[5] ),
          UM8_9( ShiftQout[6], ShiftRout[6], ContIn[3], Sbus[6] );
   
// there is an additional mux for Sbus[7]

   Mux2_1 UM8_10( ShiftQout[7], ShiftRout[7], ContIn[3], Sbus7_0 ),
          UM8_11( Sbus7_0, Abus[7], ContIn[5], Sbus[7] );

endmodule // Shifter



/***************************************************************************
 * Module 1: BCD_add6
 * 
 * Function: adds '6' to each digit for performing BCD addition with
 *  an adder based on 2's complement arithmetic.
 * 
***************************************************************************/

module BCD_add6( Inbus, Outbus );

   input [7:0]	 Inbus;
   output [7:0] Outbus;
   
   BCD_add6_digit UM1_0( Inbus[3:0], Outbus[3:0] ),
                  UM1_1( Inbus[7:4], Outbus[7:4] );
   
endmodule // BCD_add6


/********************************************/

module XOR8bit( In1bus, In2bus, Outbus );
   
   input [7:0]	 In1bus, In2bus;
   output [7:0] Outbus;
   
   XOR4bit X8_0( In1bus[3:0], In2bus[3:0], Outbus[3:0] ),
           X8_1( In1bus[7:4], In2bus[7:4], Outbus[7:4] );
   
endmodule // XOR8bit



/***************************************************************************
 * Module 7: BCD_sub6
 * 
 * Function: conversion back to BCD by subtracting 6 from each digit
 *   if no carry is generated by that digit.
 * 
***************************************************************************/

module BCD_sub6( Inbus, Carry4, Cout, Outbus );

   input [7:0]	 Inbus;
   input		 Carry4, Cout;
   output [7:0] Outbus;

   BCD_sub6_digit UM7_0( Inbus[3:0], Carry4, Outbus[3:0] ),
                  UM7_1( Inbus[7:4], Cout, Outbus[7:4] );

endmodule // BCD_sub6


/***************************************************************************
 * Module 4: MainMux2_B
 * 
 * Function: selection of 5 input buses including Bbus.
 * 
***************************************************************************/

module MainMux2_B( In0, K, In2, In3, In4, ContIn, Out );

   input [7:0]	 In0;
   input		 K;
   input [7:0]	 In2, In3, In4;
   input [13:0] ContIn;
   output [7:0] Out;

   wire [7:0]	 temp, In1;
   wire		 MSelHi, MSelLo1, MSelLo2, MSelLo3;
   
   
// In1[7:0] = { K, K, K, K, K, K, K, K }
   buffer addedBuf145 (.A(K), .Y(In1[7]));
   buffer addedBuf146 (.A(K), .Y(In1[6]));
   buffer addedBuf147 (.A(K), .Y(In1[5]));
   buffer addedBuf148 (.A(K), .Y(In1[4]));
   buffer addedBuf149 (.A(K), .Y(In1[3]));
   buffer addedBuf150 (.A(K), .Y(In1[2]));
   buffer addedBuf151 (.A(K), .Y(In1[1]));
   buffer addedBuf152 (.A(K), .Y(In1[0]));

 
   Mux8bit3_1a UM4_0( In2[7:0], In3[7:0], In4[7:0],
				  ContIn[3], ContIn[4], temp[7:0] );

// some control logic to generate multiplexer control signals
   and2 UM4_1( .A(ContIn[3]), .B(ContIn[5]), .Y(line1) );
   inv  UM4_2( .A(line1), .Y(line2) );
   and3 UM4_3( .A(ContIn[0]), .B(ContIn[1]), .C(line2),
		    .Y(MSelHi) );                                       // Epsilon
   inv  UM4_4( .A(ContIn[0]), .Y(line4) ),                         // !A1
       UM4_5( .A(ContIn[5]), .Y(line5) );                         // !C3 
   and3 UM4_6( .A(line4), .B(ContIn[6]), .C(line5), .Y(MSelLo1) );
   and2 UM4_7( .A(line4), .B(ContIn[6]), .Y(MSelLo2) );
   or2 UM4_8( .A(ContIn[5]), .B(ContIn[6]), .Y(line8) );
   and2 UM4_9( .A(line4), .B(line8), .Y(MSelLo3) );

   Mux3_1b     UM4_11( In0[0], In1[0], temp[0],
				   MSelHi, MSelLo1, Out[0] ),
               UM4_12( In0[1], In1[1], temp[1],
				   MSelHi, MSelLo1, Out[1] ),
               UM4_13( In0[2], In1[2], temp[2],
				   MSelHi, MSelLo1, Out[2] ),
               UM4_14( In0[3], In1[3], temp[3],
				   MSelHi, MSelLo2, Out[3] );
   Mux4bit3_1b UM4_15( In0[7:4], In1[7:4], temp[7:4],
				   MSelHi, MSelLo3, Out[7:4] );

endmodule // MainMux2_B



/***************************************************************************
 * Module 10: MuxModule10
 * 
 * Function: a 3:1 mux with inputs Sbus (from Shifter),
 *   Hbus (from MuxModule9), and XPbus (from ALU_Core).
 * 
***************************************************************************/

module MuxModule10( Sbus, Hbus, XPbus, ContIn, Wbus );
   
   input [7:0]	 Sbus, Hbus, XPbus;
   input [13:0] ContIn;
   output [7:0] Wbus;

// Mux select inputs:
//   ContHi = !(Cont0. Cont1. (!Cont2+Cont7))
//   ContLo1= !(!Cont1. !Cont2. !Cont3) = Cont1+Cont2+Cont3
//   ContLo2= !(!Cont1. !Cont3) = Cont1+Cont3

   inv  UM10_0( .A(ContIn[1]), .Y(NotCont1) ),
       UM10_1( .A(ContIn[2]), .Y(NotCont2) ),
       UM10_2( .A(ContIn[3]), .Y(NotCont3) );
   or2 UM10_3( .A(NotCont2), .B(ContIn[7]), .Y(tmp0) );
   nand3 UM10_4( .A(ContIn[0]), .B(ContIn[1]), .C(tmp0), .Y(ContHi) );
   nand3 UM10_5( .A(NotCont1), .B(NotCont2), .C(NotCont3), .Y(ContLo1) );
   nand2 UM10_6( .A(NotCont1), .B(NotCont3), .Y(ContLo2) );

   Mux4bit3_1c UM10_7( Sbus[3:0], XPbus[3:0], Hbus[3:0],
		       ContHi, ContLo1, Wbus[3:0]),
               UM10_8( Sbus[7:4], XPbus[7:4], Hbus[7:4],
		       ContHi, ContLo2, Wbus[7:4]);

endmodule // MuxModule10



/***************************************************************************
 * Module 9: MuxModule9
 * 
 * Function: computes some logic functions of A and B buses.
 *  Also includes a 3:1 mux.
 * 
***************************************************************************/

module MuxModule9( Abus, Bbus, ContIn, SLbus );

   input [7:0]	 Abus, Bbus;
   input [13:0] ContIn;
   output [7:0] SLbus;

   wire [3:0]	 temp1bus;
   wire [1:0]	 temp2bus;
   wire		 temp3;

   
// SLbus[7:4] = Abus[7:4]
   buffer addedBuf5 (.A(Abus[7]), .Y(SLbus[7]));
   buffer addedBuf6 (.A(Abus[6]), .Y(SLbus[6]));
   buffer addedBuf7 (.A(Abus[5]), .Y(SLbus[5]));
   buffer addedBuf8 (.A(Abus[4]), .Y(SLbus[4]));


   LogicBlockM9 UM9_0( Abus, Bbus, ContIn[6], temp1bus, temp2bus );
   
// Mux select inputs:
//   ContHi = !(Cont0. !Cont1. Cont2. Cont3)
//   ContLo = !(Cont0. !Cont1. Cont2. !Cont3)

   inv  UM9_1( .A(ContIn[1]), .Y(NotCont1) ),
       UM9_2( .A(ContIn[3]), .Y(NotCont3) );
   and3 UM9_3( .A(ContIn[0]), .B(NotCont1), .C(ContIn[2]), .Y(temp3) );
   nand2 UM9_4( .A(temp3), .B(ContIn[3]), .Y(ContHi) ),
       UM9_5( .A(temp3), .B(NotCont3), .Y(ContLo) );
   
   Mux4bit3_1c UM9_6( temp1bus, {2'b00, temp2bus}, Abus[3:0],
				  ContHi, ContLo, SLbus[3:0] );

endmodule // MuxModule9



/***************************************************************************
 * Module 13: MiscLogic
 * 
 * Function: miscellaneous logic with 3:1 muxes
 * 
***************************************************************************/

module MiscLogic( Abus, Bbus, Carry4, Overflow, ContIn, MiscOuts );

   input [7:0]	Abus, Bbus;
   input	Carry4, Overflow;
   input [13:0]	ContIn;
   output [4:0]	MiscOuts;
   
   wire [7:0]	Not_Abus;
   wire		Misc0_0, Misc0_1, Misc0_2,
		Misc1_0, Misc1_1, Misc1_2,
		Misc2_0, Misc2_1, Misc2_2;
   wire		ContHi_Misc0, ContLo_Misc0,
		ContHi_Misc1, ContLo_Misc1,
		ContHi_Misc2, ContLo_Misc2;
   
   Invert8 UM13_0( Abus, Not_Abus );

//---------------------------

// Misc_0 = (A5 xor A6).A4.A7 + A5.!A7
   XOR2a UM13_1( .A(Abus[5]), .B(Abus[6]), .Y(tmp0) );
   and3   UM13_2( .A(tmp0), .B(Abus[4]), .C(Abus[7]), .Y(tmp1) );
   and2   UM13_3( .A(Abus[5]), .B(Not_Abus[7]), .Y(tmp2) );
   or2   UM13_4( .A(tmp1), .B(tmp2), .Y(Misc0_0) );

// Misc0_1 = A0. (A1 xor A2)
   XOR2a UM13_5( .A(Abus[1]), .B(Abus[2]), .Y(tmp3) );
   and2   UM13_6( .A(Abus[0]), .B(tmp3), .Y(Misc0_1) );

   
// Misc0_2 = Overflow
   buffer addedBuf4 (.A(Overflow), .Y(Misc0_2));


   inv    UM13_7( .A(ContIn[1]), .Y(NotCont1) ),
         UM13_8( .A(ContIn[5]), .Y(NotCont5) );
   nand2   UM13_9( .A(ContIn[0]), .B(NotCont1), .Y(ContHi_Misc0) );
   nand3   UM13_10( .A(ContIn[0]), .B(ContIn[1]), .C(ContIn[2]),
		    .Y(ContLo_Misc0) );

   Mux3_1c UM13_11( Misc0_0, Misc0_1, Misc0_2,
		    ContHi_Misc0, ContLo_Misc0, MiscOuts[0] );

//---------------------------

// Misc1_0 = A7.(A5+A6)
   or2   UM13_12( .A(Abus[5]), .B(Abus[6]), .Y(tmp4) );
   and2   UM13_13( .A(Abus[7]), .B(tmp4), .Y(Misc1_0) );

   
// Misc1_1 = Carry4
   buffer addedBuf3 (.A(Carry4), .Y(Misc1_1));

   
// Misc1_2 = !A0.!A1.!A2.!A3
   and4   UM13_14( .A(Not_Abus[0]), .B(Not_Abus[1]), .C(Not_Abus[2]),
			   .D(Not_Abus[3]), .Y(Misc1_2) );

   nand4   UM13_27( .A(ContIn[0]), .B(NotCont1), .C(ContIn[2]),
			   .D(NotCont5), .Y(ContHi_Misc1) );
   
// ContLo_Misc1 = ContIn[0]
   buffer addedBuf2 (.A(ContIn[0]), .Y(ContLo_Misc1));


   Mux3_1c UM13_28( Misc1_0, Misc1_1, Misc1_2,
				ContHi_Misc1, ContLo_Misc1, MiscOuts[1] );

//---------------------------

   
// Misc2_0 = Misc1_0
   buffer addedBuf1 (.A(Misc1_0), .Y(Misc2_0));


// Misc2_1 = B3.(B1+B2)
   or2   UM13_29( .A(Bbus[1]), .B(Bbus[2]), .Y(tmp5) );
   and2   UM13_30( .A(Bbus[3]), .B(tmp5), .Y(Misc2_1) );

// Misc2_2 = A0.B0+A1.B1+...+A7.B7

   nand2   UM13_31( .A(Abus[0]), .B(Bbus[0]), .Y(pr0) ),
         UM13_32( .A(Abus[1]), .B(Bbus[1]), .Y(pr1) ),
         UM13_33( .A(Abus[2]), .B(Bbus[2]), .Y(pr2) ),
         UM13_34( .A(Abus[3]), .B(Bbus[3]), .Y(pr3) ),
         UM13_35( .A(Abus[4]), .B(Bbus[4]), .Y(pr4) ),
         UM13_36( .A(Abus[5]), .B(Bbus[5]), .Y(pr5) ),
         UM13_37( .A(Abus[6]), .B(Bbus[6]), .Y(pr6) ),
         UM13_38( .A(Abus[7]), .B(Bbus[7]), .Y(pr7) );
   and4   UM13_39( .A(pr0), .B(pr1), .C(pr2), .D(pr3), .Y(pr3_0) ),
         UM13_40( .A(pr4), .B(pr5), .C(pr6), .D(pr7), .Y(pr7_4) );
   nand2   UM13_41( .A(pr3_0), .B(pr7_4), .Y(Misc2_2) );
 
   
// ContHi_Misc2 = ContLo_Misc0
   buffer addedBuf0 (.A(ContLo_Misc0), .Y(ContHi_Misc2));

   nand3   UM13_42( .A(ContIn[0]), .B(NotCont1), .C(ContIn[2]),
		    .Y(ContLo_Misc2) );

   Mux3_1c UM13_43( Misc2_0, Misc2_1, Misc2_2,
		    ContHi_Misc2, ContLo_Misc2, NotMiscOuts2 );
   inv UM13_43_1( .A(NotMiscOuts2), .Y(MiscOuts[2]) );

//---------------------------

// MiscOuts[3] = !(A3.(A2+A1))
   or2   UM13_44( .A(Abus[1]), .B(Abus[2]), .Y(tmp6) );
   and2   UM13_45( .A(Abus[3]), .B(tmp6), .Y(tmp7) );
   inv    UM13_46( .A(tmp7), .Y(MiscOuts[3]) );

// MiscOuts[4] = !A4.!A5. !A6. !A7
   and4   UM13_47( .A(Not_Abus[4]), .B(Not_Abus[5]), .C(Not_Abus[6]),
			   .D(Not_Abus[7]), .Y(MiscOuts[4]) );

endmodule // MiscLogic



/***************************************************************************
 * Module 12: Flags
 * 
 * Function: computes some zero flags for Zbus, and parities for Abus,
 *   Bbus and Zbus.
 * 
***************************************************************************/

module Flags( Zbus, Abus, Bbus, ContIn, Not_ZeroZ, ZeroZ_Cont,
	      OddParZ, OddParA, OddParB, OddParZ_Cont );

   input [7:0]	Zbus, Abus, Bbus;
   input [13:0]	ContIn;
   output	Not_ZeroZ, ZeroZ_Cont;
   output	OddParZ, OddParA, OddParB, OddParZ_Cont;

   wire [7:0]	Not_Zbus;


   Invert8 UM12_0( Zbus, Not_Zbus );

   and4 UM12_1( .A(Not_Zbus[0]), .B(Not_Zbus[1]), .C(Not_Zbus[2]),
			.D(Not_Zbus[3]), .Y(ZeroZ_Lo) ),
       UM12_2( .A(Not_Zbus[4]), .B(Not_Zbus[5]), .C(Not_Zbus[6]),
			.D(Not_Zbus[7]), .Y(ZeroZ_Hi) );
   and2 UM12_3( .A(ZeroZ_Lo), .B(ZeroZ_Hi), .Y(ZeroZ) );

// Not_ZeroZ= Z0+Z1+...Z7

   inv  UM12_4( .A(ZeroZ), .Y(Not_ZeroZ) );

// An intermediate control signal: ContFlag = !Cont0+Cont1
   inv  UM12_5( .A(ContIn[8]), .Y(NotCont8) );
   or2 UM12_6( .A(NotCont8), .B(ContIn[9]), .Y(ContFlag) );
   inv  UM12_7( .A(ContFlag), .Y(NotContFlag) );

// ZeroZ_Cont = !Cont0 + ZeroZ + !Z6.!Z7. !ContFlag
//   (Note: ContFlag masks top two bits Z6 and Z7 for ZeroZ_Cont)

   and3 UM12_8( .A(Not_Zbus[6]), .B(Not_Zbus[7]), .C(NotContFlag), .Y(tmp0) );
   nor2 UM12_9( .A(tmp0), .B(ZeroZ), .Y(tmp1) );
   nand2 UM12_10( .A(ContIn[8]), .B(tmp1), .Y(ZeroZ_Cont) );

//      OddParA = Xnor(A0,A1,...,A7)
//      OddParB = Xnor(B0,B1,...,B7)
//      OddParZ = Xnor(Z0,Z1,...,Z7)
// OddParZ_Cont = Xnor(Z0,Z1,..,Z5,ContFlag.Z6,ContFlag.Z7, Cont13.!ContFlag)
//   (Note: ContFlag masks top two bits Z6 and Z7 for OddParZ_Cont)
   
   ParityTree8bit UM12_11( Abus, EvenParA ),
                  UM12_12( Bbus, EvenParB ),
                  UM12_13( Zbus, EvenParZ );

   and2 UM12_14( .A(NotContFlag), .B(ContIn[13]), .Y(ContPar) ),
       UM12_15( .A(ContFlag), .B(Zbus[7]), .Y(PZ7) ),
       UM12_16( .A(ContFlag), .B(Zbus[6]), .Y(PZ6) );
   ParityTree9bit UM12_17( {ContPar,PZ7,PZ6,Zbus[5:0]}, EvenParZ_Cont );

   inv UM12_18( .A(EvenParA), .Y(OddParA) ),
      UM12_19( .A(EvenParB), .Y(OddParB) ),
      UM12_20( .A(EvenParZ), .Y(OddParZ) ),
      UM12_21( .A(EvenParZ_Cont), .Y(OddParZ_Cont) );

endmodule // Flags


/***************************************************************************
 * Module 3: MainMux1_A
 * 
 * Function: selection of 6 input buses including Abus.
 * 
***************************************************************************/

module MainMux1_A( In0, In1, In2, In3, In4, In5, Sel, Out );

   input [7:0]	 In0, In1, In2, In3, In4, In5;
   input [3:0]	 Sel;
   output [7:0] Out;

   wire [7:0]	 temp;
   wire		 MSel0, MSel1a, MSel1b;
   wire		 MSel2, MSel3a, MSel3b;
   
   Mux8bit3_1a UM3_0( In3[7:0], In4[7:0], In5[7:0],
				  Sel[2], Sel[3], temp[7:0] );

// some control logic to generate multiplexer control signals
   nand2 UM3_1( .A(Sel[0]), .B(Sel[1]), .Y(line1) );
   nand3 UM3_2( .A(Sel[0]), .B(Sel[2]), .C(Sel[3]), .Y(line2) );
   and2 UM3_3( .A(line1), .B(line2), .Y(line3) );                // gamma
   inv  UM3_4( .A(line3), .Y(MSel0) );
   and2 UM3_5( .A(Sel[1]), .B(Sel[2]), .Y(line5) );
   inv  UM3_6( .A(line5), .Y(line6) );
   or2 UM3_7( .A(Sel[0]), .B(line6), .Y(line7) );                // lambda
   inv  UM3_8( .A(line7), .Y(MSel2) ),
       UM3_9( .A(Sel[3]), .Y(line9) ),                           // !C6
       UM3_10( .A(Sel[2]), .Y(line10) );                         // !C9
   or2 UM3_11( .A(line9), .B(Sel[0]), .Y(line11) ),              // A1+!C6
       UM3_12( .A(line10), .B(Sel[0]), .Y(line12) );             // A1+!C6
   and3 UM3_13( .A(line3), .B(line7), .C(line11), .Y(MSel1a) ),
       UM3_14( .A(line3), .B(line7), .C(line12), .Y(MSel1b) );
   inv  UM3_15( .A(line11), .Y(line15) ),                         // !(A1+!C6)
       UM3_16( .A(line12), .Y(line16) );                         // !(A1+!C9)
   and3 UM3_17( .A(line3), .B(line7), .C(line15), .Y(MSel3a) ),
       UM3_18( .A(line3), .B(line7), .C(line16), .Y(MSel3b) );   

   Mux4bit4_1a UM3_19( temp[3:0], In0[3:0], In1[3:0], In2[3:0],
				   {MSel3a, MSel2, MSel1a, MSel0}, Out[3:0] ),
               UM3_20( temp[7:4], In0[7:4], In1[7:4], In2[7:4],
				   {MSel3b, MSel2, MSel1b, MSel0}, Out[7:4] );

endmodule // MainMux1_A



/***************************************************************************/
/***************************************************************************/

module TopLevel3540( Abus, Bbus, Qbus, Rbus, Tbus, Cin, K, ContIn,
				 Zbus, Not_ZeroZ, ZeroZ_Cont,
				 OddParZ, OddParA, OddParB, OddParZ_Cont,
				 XCarry2, Cout_in0, PropThru, MiscOuts );

   input [7:0]	 Abus, Bbus;
   input [7:0]	 Qbus, Rbus;
   input [1:0]	 Tbus;
   input		 K;
   input		 Cin;
   input [13:0] ContIn;

   output [7:0] Zbus;
   output		 Not_ZeroZ, ZeroZ_Cont;
   output		 OddParZ, OddParA, OddParB, OddParZ_Cont;
   output		 XCarry2, Cout_in0, PropThru;
   output [4:0] MiscOuts;


   wire [7:0]	 A_BCDbus, Not_Abus;
   wire [7:0]	 MAbus, MBbus;
   wire [7:0]	 XPbus, XCarrybus, Funcbus;
   wire [7:0]	 F_BCDbus, Hbus, Shiftbus, Wbus;


   BCD_add6 M1( Abus, A_BCDbus );
   Invert8  M2( Abus, Not_Abus );

   MainMux1_A M3( Abus, Not_Abus, 8'h00, { Qbus[1:0], Abus[7:2] },
			   { Abus[6:0], Rbus[7] }, A_BCDbus,
			   ContIn[3:0], MAbus );

   MainMux2_B M4( Bbus, K, { Tbus[1:0], Bbus[7:2] },
			   { Tbus[0], Bbus[7:1] }, { Abus[4:0], Rbus[7:5] },
			   ContIn, MBbus );

   ALU_Core M5( MAbus, MBbus, Cin, ContIn,
		XPbus, XCarrybus, XCarry2, Carry4, Cout,
		Cout_in0, PropThru, Overflow );
   
   XOR8bit M6( XPbus, XCarrybus, Funcbus );
   
   BCD_sub6 M7( Funcbus, Carry4, Cout, F_BCDbus );
   
// various muxes

   Shifter M8( Abus, Qbus, Rbus, ContIn, Shiftbus );

   MuxModule9 M9( Abus, Bbus, ContIn, Hbus );
   
   MuxModule10 M10( Shiftbus, Hbus, XPbus, ContIn, Wbus );

   MuxModule11 M11( Funcbus, F_BCDbus, Wbus, ContIn, Zbus );

// flags

   Flags M12( Zbus, Abus, Bbus, ContIn, Not_ZeroZ, ZeroZ_Cont,
		    OddParZ, OddParA, OddParB, OddParZ_Cont);
   
// Miscellaneous logic

   MiscLogic M13( Abus, Bbus, Carry4, Overflow, ContIn, MiscOuts );
   
endmodule // TopLevel3540

/****************************************************************************
 *                                                                          *
 *  VERILOG HIGH-LEVEL DESCRIPTION OF THE ISCAS-85 BENCHMARK CIRCUIT c3540  *
 *                                                                          *  
 *                                                                          *
 *  Written by   : Hakan Yalcin (hyalcin@cadence.com)                       *
 *  Verified by  : Jonathan David Hauke (jhauke@eecs.umich.edu)             *
 *                                                                          *
 *  First created: Feb 11, 1997                                             *
 *  Last modified: May  9, 1998                                             *
 *                                                                          *
****************************************************************************/

