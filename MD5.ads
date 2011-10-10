-------------------------------------------------------------------------------
--                                                                           --
--                                  MD5                                      --
--                                                                           --
--                                MD5.ads                                    --
--                                                                           --
--                                 SPEC                                      --
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
with Interfaces;

package MD5 is

   type Unsigned_32 is mod (2 ** 32);

   type Unsigned_32_Array_T is array(Unsigned_32 range <>) of Unsigned_32;
   type Unsigned_8_Array_T is array(Unsigned_32 range <>) of Interfaces.Unsigned_8;

   Block_Size : Unsigned_32 := 64;

   type Context_T is
      record
         Message_Block   : Unsigned_8_Array_T(1..Block_Size);
         Count           : Unsigned_32_Array_T(1..2);
         State           : Unsigned_32_Array_T(1..4);
         Message_Digest  : Unsigned_8_Array_T(1..16);
         Computed        : Boolean;
      end record;


   ----------------------------------------------------------------------------------
   --
   -- Initialize
   --
   ----------------------------------------------------------------------------------
   procedure Init(Context : in out Context_T);

   ----------------------------------------------------------------------------------
   --
   -- Finish the MD5 digest opration
   --
   ----------------------------------------------------------------------------------
   procedure Finish(Context : in out Context_T);

   ----------------------------------------------------------------------------------
   --
   -- Calculating the MD5 value for the message in Message
   --
   ----------------------------------------------------------------------------------
   procedure Calculate(Message : Unsigned_8_Array_T);
end MD5;
