-------------------------------------------------------------------------------
--                                                                           --
--                                  MD5                                      --
--                                                                           --
--                                MD5.adb                                    --
--                                                                           --
--                                 BODY                                      --
--                                                                           --
--                   Copyright (C) 1997 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  MD5 is free software;  you can  redistribute it                          --
--  and/or modify it under terms of the  GNU General Public License          --
--  as published  by the Free Software  Foundation;  either version 2,       --
--  or (at your option) any later version.                                   --
--  MD5 is distributed in the hope that it will be                           --
--  useful, but WITHOUT ANY WARRANTY;  without even the  implied warranty    --
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  --
--  See the GNU General Public License for  more details.                    --
--  You should have  received  a copy of the GNU General                     --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with Conversion; use Conversion;

package body MD5 is

   S11 : constant Unsigned_32 := 7;
   S12 : constant Unsigned_32 := 12;
   S13 : constant Unsigned_32 := 17;
   S14 : constant Unsigned_32 := 22;

   S21 : constant Unsigned_32 := 5;
   S22 : constant Unsigned_32 := 9;
   S23 : constant Unsigned_32 := 14;
   S24 : constant Unsigned_32 := 20;

   S31 : constant Unsigned_32 := 4;
   S32 : constant Unsigned_32 := 11;
   S33 : constant Unsigned_32 := 16;
   S34 : constant Unsigned_32 := 23;

   S41 : constant Unsigned_32 := 6;
   S42 : constant Unsigned_32 := 10;
   S43 : constant Unsigned_32 := 15;
   S44 : constant Unsigned_32 := 21;

   ----------------------------------------------------------------------------------
   --
   --
   --
   ----------------------------------------------------------------------------------
   function F(X : Unsigned_32; Y : Unsigned_32; Z : Unsigned_32) return Unsigned_32 is
   begin
      return ((X and Y) or ((not X) and Z));
   end F;

   ----------------------------------------------------------------------------------
   --
   --
   --
   ----------------------------------------------------------------------------------
   function G(X : Unsigned_32; Y : Unsigned_32; Z : Unsigned_32) return Unsigned_32 is
   begin
      return ((X and Z) or ( Y and (not Z)));
   end G;

   ----------------------------------------------------------------------------------
   --
   --
   --
   ----------------------------------------------------------------------------------
   function H(X : Unsigned_32; Y : Unsigned_32; Z : Unsigned_32) return Unsigned_32 is
   begin
      return ( X xor Y xor Z);
   end H;

   ----------------------------------------------------------------------------------
   --
   --
   --
   ----------------------------------------------------------------------------------
   function I(X : Unsigned_32; Y : Unsigned_32; Z : Unsigned_32) return Unsigned_32 is
   begin
      return (Y xor (X or (not Z)));
   end I;

   ----------------------------------------------------------------------------------
   --
   -- Circular rotate X left N bits
   --
   ----------------------------------------------------------------------------------
   function Circular_Shift_Left(X : Unsigned_32; N : Positive) return Unsigned_32 is
      use Interfaces;

   begin
      return MD5.Unsigned_32(Interfaces.Shift_Left(Interfaces.Unsigned_32(X),N) or
                               Interfaces.Shift_Right(Interfaces.Unsigned_32(X),(32-N)));
   end Circular_Shift_Left;


   procedure FF(A : in out Unsigned_32;
                B : in Unsigned_32;
                C : in Unsigned_32;
                D : in Unsigned_32;
                X : in Unsigned_32;
                S : in Unsigned_32;
                AC  : in Unsigned_32) is
   begin
      A := Circular_Shift_Left(A + F(B,C,D) + X + AC, Positive(S)) + B;
   end FF;


   procedure GG(A : in out Unsigned_32;
                B : in Unsigned_32;
                C : in Unsigned_32;
                D : in Unsigned_32;
                X : in Unsigned_32;
                S : in Unsigned_32;
                AC  : in Unsigned_32) is
   begin
      A := Circular_Shift_Left(A + G(B,C,D) + X + AC, Positive(S)) + B;
   end GG;


   procedure HH(A : in out Unsigned_32;
                B : in Unsigned_32;
                C : in Unsigned_32;
                D : in Unsigned_32;
                X : in Unsigned_32;
                S : in Unsigned_32;
                AC  : in Unsigned_32) is
   begin
      A := Circular_Shift_Left(A + H(B,C,D) + X + AC, Positive(S)) + B;
   end HH;


   procedure II(A : in out Unsigned_32;
                B : in Unsigned_32;
                C : in Unsigned_32;
                D : in Unsigned_32;
                X : in Unsigned_32;
                S : in Unsigned_32;
                AC  : in Unsigned_32) is
   begin
      A := Circular_Shift_Left(A + I(B,C,D) + X + AC, Positive(S)) + B;
   end II;


   ----------------------------------------------------------------------------------
   --
   -- Decode Message Unsigned_8 Array into an Unsigned_32 Array returned in Output
   --
   ----------------------------------------------------------------------------------
   procedure Decode(Output : in out Unsigned_32_Array_T; Message : in Unsigned_8_Array_T; Start_Index : in out Unsigned_32 ; Length : Unsigned_32) is
      use Interfaces;
      Index : MD5.Unsigned_32 := 1;
      Limit : Unsigned_32 := Start_Index + Length;

   begin
      loop
                  exit when Start_Index >= Limit;
         Output(Index) := MD5.Unsigned_32(Interfaces.Unsigned_32(Message(Start_Index)) or
                          Interfaces.Shift_Left(Interfaces.Unsigned_32(Message(Start_Index +1)), 8) or
                          Interfaces.Shift_Left(Interfaces.Unsigned_32(Message(Start_Index +2)), 16) or
                          Interfaces.Shift_Left(Interfaces.Unsigned_32(Message(Start_Index +3)), 24));

         Index := Index + 1;
         Start_Index := Start_Index + 4;
      end loop;

   end Decode;


   ----------------------------------------------------------------------------------
   --
   -- Encode Message Unsigned_32 Array into Unsigned_8 Array returned in Output
   --
   -- Pre condition: Message'Length % 4 = 0
   --
   ----------------------------------------------------------------------------------
   procedure Encode(Output : in out  Unsigned_8_Array_T; Message : Unsigned_32_Array_T; Length : Unsigned_32) is
      use Interfaces;
      Index       : MD5.Unsigned_32 := 1;
      Start_Index : MD5.Unsigned_32 := 1;

   begin
      loop
         exit when Start_Index >= Length;

         Output(Start_Index) := Unsigned_8(Message(Index) and 16#000000FF#);
         Output(Start_Index+1) := Unsigned_8(Interfaces.Shift_Right(Interfaces.Unsigned_32(Message(Index)),8) and 16#FF#);
         Output(Start_Index+2) := Unsigned_8(Interfaces.Shift_Right(Interfaces.Unsigned_32(Message(Index)),16) and 16#FF#);
         Output(Start_Index+3) := Unsigned_8(Interfaces.Shift_Right(Interfaces.Unsigned_32(Message(Index)),24) and 16#FF#);

         Index := Index + 1;
         Start_Index := Start_Index + 4;
      end loop;
   end Encode;



   ----------------------------------------------------------------------------------
   --
   -- Apply the MD5 sequence on the Block
   --
   ----------------------------------------------------------------------------------
   procedure Transform(Context : in out Context_T; Block : in Unsigned_8_Array_T; Index : Unsigned_32) is
      A : Unsigned_32 := Context.State(1);
      B : Unsigned_32 := Context.State(2);
      C : Unsigned_32 := Context.State(3);
      D : Unsigned_32 := Context.State(4);

      X : Unsigned_32_Array_T (1..16);

      Index_Tmp : Unsigned_32 := Index;

   begin

      Decode(X, Block, Index_Tmp, Block_Size);

     -- Round 1: 1 - 16
     FF (A, B, C, D, X(1), S11, 16#D76AA478#);
     FF (D, A, B, C, X(2), S12, 16#E8C7B756#);
     FF (C, D, A, B, X(3), S13, 16#242070DB#);
     FF (B, C, D, A, X(4), S14, 16#C1BDCEEE#);
     FF (A, B, C, D, X(5), S11, 16#F57C0FAF#);
     FF (D, A, B, C, X(6), S12, 16#4787C62A#);
     FF (C, D, A, B, X(7), S13, 16#A8304613#);
     FF (B, C, D, A, X(8), S14, 16#FD469501#);
     FF (A, B, C, D, X(9), S11, 16#698098D8#);
     FF (D, A, B, C, X(10), S12, 16#8B44F7AF#);
     FF (C, D, A, B, X(11), S13, 16#FFFF5BB1#);
     FF (B, C, D, A, X(12), S14, 16#895CD7BE#);
     FF (A, B, C, D, X(13), S11, 16#6B901122#);
     FF (D, A, B, C, X(14), S12, 16#FD987193#);
     FF (C, D, A, B, X(15), S13, 16#A679438E#);
     FF (B, C, D, A, X(16), S14, 16#49B40821#);

     --Round 2: 17 - 32
     GG (A, B, C, D, X(2), S21, 16#F61E2562#);
     GG (D, A, B, C, X(7), S22, 16#C040B340#);
     GG (C, D, A, B, X(12), S23, 16#265E5A51#);
     GG (B, C, D, A, X(1), S24, 16#E9B6C7AA#);
     GG (A, B, C, D, X(6), S21, 16#D62F105D#);
     GG (D, A, B, C, X(11), S22,  16#2441453#);
     GG (C, D, A, B, X(16), S23, 16#D8A1E681#);
     GG (B, C, D, A, X(5), S24, 16#E7D3FBC8#);
     GG (A, B, C, D, X(10), S21, 16#21E1CDE6#);
     GG (D, A, B, C, X(15), S22, 16#C33707D6#);
     GG (C, D, A, B, X(4), S23, 16#F4D50D87#);
     GG (B, C, D, A, X(9), S24, 16#455A14ED#);
     GG (A, B, C, D, X(14), S21, 16#A9E3E905#);
     GG (D, A, B, C, X(3), S22, 16#FCEFA3F8#);
     GG (C, D, A, B, X(8), S23, 16#676F02D9#);
     GG (B, C, D, A, X(13), S24, 16#8D2A4C8A#);

     -- Round 3: 33 - 48
     HH (A, B, C, D, X(6), S31, 16#FFFA3942#);
     HH (D, A, B, C, X(9), S32, 16#8771F681#);
     HH (C, D, A, B, X(12), S33, 16#6D9D6122#);
     HH (B, C, D, A, X(15), S34, 16#FDE5380C#);
     HH (A, B, C, D, X(2), S31, 16#A4BEEA44#);
     HH (D, A, B, C, X(5), S32, 16#4BDECFA9#);
     HH (C, D, A, B, X(8), S33, 16#F6BB4B60#);
     HH (B, C, D, A, X(11), S34, 16#BEBFBC70#);
     HH (A, B, C, D, X(14), S31, 16#289B7EC6#);
     HH (D, A, B, C, X(1), S32, 16#EAA127FA#);
     HH (C, D, A, B, X(4), S33, 16#D4EF3085#);
     HH (B, C, D, A, X(7), S34,  16#4881D05#);
     HH (A, B, C, D, X(10), S31, 16#D9D4D039#);
     HH (D, A, B, C, X(13), S32, 16#E6DB99E5#);
     HH (C, D, A, B, X(16), S33, 16#1FA27CF8#);
     HH (B, C, D, A, X(3), S34, 16#C4AC5665#);

     -- Round 4: 49 - 64
     II (A, B, C, D, X(1), S41, 16#F4292244#);
     II (D, A, B, C, X(8), S42, 16#432AFF97#);
     II (C, D, A, B, X(15), S43, 16#AB9423A7#);
     II (B, C, D, A, X(6), S44, 16#FC93A039#);
     II (A, B, C, D, X(13), S41, 16#655B59C3#);
     II (D, A, B, C, X(4), S42, 16#8F0CCC92#);
     II (C, D, A, B, X(11), S43, 16#FFEFF47D#);
     II (B, C, D, A, X(2), S44, 16#85845DD1#);
     II (A, B, C, D, X(9), S41, 16#6FA87E4F#);
     II (D, A, B, C, X(16), S42, 16#FE2CE6E0#);
     II (C, D, A, B, X(7), S43, 16#A3014314#);
     II (B, C, D, A, X(14), S44, 16#4E0811A1#);
     II (A, B, C, D, X(5), S41, 16#F7537E82#);
     II (D, A, B, C, X(12), S42, 16#BD3AF235#);
     II (C, D, A, B, X(3), S43, 16#2AD7D2BB#);
     II (B, C, D, A, X(10), S44, 16#EB86D391#);

     Context.State(1) := Context.State(1) + A;
     Context.State(2) := Context.State(2) + B;
     Context.State(3) := Context.State(3) + C;
     Context.State(4) := Context.State(4) + D;
   end Transform;

   ----------------------------------------------------------------------------------
   --
   -- Initialize
   --
   ----------------------------------------------------------------------------------
   procedure Init(Context : in out Context_T) is
         begin
            Context.Count(1) := 0;
            Context.Count(2) := 0;

            Context.State(1) := 16#67452301#;
            Context.State(2) := 16#EFCDAB89#;
            Context.State(3) := 16#98BADCFE#;
            Context.State(4) := 16#10325476#;

            Context.Computed := False;
         end Init;


   ----------------------------------------------------------------------------------
   --
   -- Do an MD5 message diegst operation on the messageblock Message
   --
   ----------------------------------------------------------------------------------
   procedure Update(Context : in out Context_T; Message : Unsigned_8_Array_T; Length :Unsigned_32) is
      Index        : Unsigned_32 := ((Context.Count(1) / 8) mod Block_Size) +1;
      Index_2      : Unsigned_32 := 1;
      J            : Unsigned_32 := 1;
      First_Part   : Unsigned_32 := Block_Size - Index;

      Length_Shift : constant Unsigned_32 := Unsigned_32(Interfaces.Shift_Left(Interfaces.Unsigned_32(Length), 3));

   begin
      Context.Count(1) := Context.Count(1) + Length_Shift;

      if Context.Count(1) < Length_Shift then

         Context.Count(2) := Context.Count(2) + 1;
              end if;
         Context.Count(2) := Context.Count(2) + Unsigned_32(Interfaces.Shift_Right(Interfaces.Unsigned_32(Length), 29));

         -- Number of bytes to pad with:
         if Length > First_Part then
            for I in Index .. (Index +First_Part) loop
               Context.Message_Block(I) := Message(J);
               J := J+1;
            end loop;
            Transform(Context,Context.Message_Block,Context.Message_Block'First);

            First_Part := First_Part +2;
            Index_2 := First_Part;
            loop
               exit when (First_Part + Block_Size) > Length;
               Transform(Context,Message,First_part);
               First_Part := First_Part + Block_Size;
               Index_2 := First_Part;
            end loop;

            Index := 1;
         else
              Index_2 := 1;
         end if;

         -- Rest of the buffer:
         for I in Index .. Index + (Length - Index_2)  loop -- !!!!!! -1 added
            Context.Message_Block(I) := Message(Index_2);
            Index_2 := Index_2 +1;
         end loop;
   end Update;


   ----------------------------------------------------------------------------------
   --
   -- Finish the MD5 digest opration
   --
   ----------------------------------------------------------------------------------
   procedure Finish(Context : in out Context_T) is
      Padding : constant Unsigned_8_Array_T (1..64) := (1=> 16#80#, others => 0);
      Bits    : Unsigned_8_Array_T(1..8);
      Index   : Unsigned_32 := 0;
      Pad_Len : Unsigned_32 := 0;

   begin
      if not Context.Computed then
         Encode(Bits, Context.Count, 8);
         Index := (Context.Count(1) / 8) mod 64;

         if Index < 56 then
            Pad_Len := 56 - Index;
         else
            Pad_Len := 120 - Index;
         end if;

         Update(Context,Padding, Pad_len);
         Update(Context,Bits,8);
         Encode(Context.Message_Digest, Context.State, 16);
         Context.Computed := True;
      end if;
   end Finish;


   ----------------------------------------------------------------------------------
   --
   -- Calculating the MD5 value for the message in Message
   --
   ----------------------------------------------------------------------------------
   procedure Calculate(Message : Unsigned_8_Array_T) is
      Context : Context_T;

   begin
      Init(Context);
      Update(Context, Message, Message'Length);
      Finish(Context);

      for I in Context.Message_Digest'First .. Context.Message_Digest'Last loop
         Put_Hex_Value(Unsigned_32(Context.Message_Digest(I)));
      end loop;

       New_Line;
   end Calculate;
end MD5;
