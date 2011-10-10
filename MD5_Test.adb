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

with MD5; use MD5;
with Ada.Text_IO; use Ada.Text_IO;

procedure MD5_Test is

   Procedure Test(Message_Str : String; Expected : String) is
        Message : Unsigned_8_Array_T(1..Message_Str'Length);
   begin
      Put_Line("********************************************************");
      Put_Line("Message test : " & Message_Str);
      Put_Line("Message length : " & Integer'Image(Message_Str'Length));
      Put_Line("Expected Output:  " & Expected);

      -- Copy Message String to byte buffer:
      for I in Message_Str'First .. Message_Str'Last loop
         Message(Unsigned_32(I)) := Character'Pos (Message_Str(I));
      end loop;

     Put("Generated output: ");
     Calculate(Message);
      Put_Line("********************************************************");
   end Test;


begin
    Test("This the first test","87FEAF9FCDA6C182750B6BBC48D3744A");   Test("a","0CC175B9C0F1B6A831C399E269772661");
    Test("","D41D8CD98F00B204E9800998ECF8427E");
    Test("ord!' He Said, 'there's an infinite number of monkeys outside","D9F126C4BF1DA599A14BDEF18B4F6CD4");
    Test("Ford!' He Said, 'there's an infinite number of monkeys outside","72D3255080853FF580C0E5A86DE81303");
    Test(" Ford!' He Said, 'there's an infinite number of monkeys outside","1F24467A077615FB223C5145A2F2A483");
    Test("a Ford!' He Said, 'there's an infinite number of monkeys outside","1FCD1CAAA121AC918F6E16004FA510E2");
    Test("ab Ford!' He Said, 'there's an infinite number of monkeys outside","7E0FB9EE9FAEA49A0F671E5A40ECBEBE");
    Test("Arthur Looked Up. 'Ford!' He Said, 'there's an infinite number of monkeys outside who want to talk to us about this script for Hamlet they've worked out.",
         "7994A28280C71114DFBEDBD324FBC4E9");
    Test("Arthur Looked Up. 'Ford!' He Said, 'there's an infinite number of monkeys outside who","97B4BDA595407A5DD0A1BDC239341F49");



end MD5_Test;

