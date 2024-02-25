----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/17/2023 06:37:52 PM
-- Design Name: 
-- Module Name: tdo_mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tdo_mux is
    Port ( trst_i : in STD_LOGIC;
           tck_i : in STD_LOGIC;
           tdo_ir_i : in STD_LOGIC;
           tdo_dr_i : in STD_LOGIC;
           irdr_select_i : in STD_LOGIC;
           tdo_ena_i : in STD_LOGIC;
           sel_dr_i : in STD_LOGIC;
           tdo_o : out STD_LOGIC);
end tdo_mux;

architecture Behavioral of tdo_mux is
signal tdo_buffer: STD_LOGIC;
begin


muxprocess: process(tdo_ena_i, sel_dr_i, tdo_dr_i, tdo_ir_i)
begin
            if (tdo_ena_i = '1') then                       -- negative edge triggering 
            if (sel_dr_i = '1') then                        -- data register selection
                tdo_o <= tdo_dr_i;
            else
                tdo_o <= tdo_ir_i;
           end if;
    end if;
                       
      end process;          
 
end Behavioral;
