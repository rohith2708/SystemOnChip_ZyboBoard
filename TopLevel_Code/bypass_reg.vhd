----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2023 07:19:28 AM
-- Design Name: 
-- Module Name: Bypass_Reg - Behavioral
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

entity Bypass_Reg is
    Port ( trst_i : in STD_LOGIC;
           tck_i : in STD_LOGIC;
           dr_clock_i : in STD_LOGIC;
           dr_shift_i : in STD_LOGIC;
           td_i : in STD_LOGIC;
           tdo_o : out STD_LOGIC);
end Bypass_Reg;

architecture Behavioral of Bypass_Reg is
 signal id_code: std_logic_vector(31 downto 0);

begin

-- sample architecture --
-- tdo_o <= (trst_i and tck_i and dr_clock_i and  dr_shift_i and  td_i);

bypassprocess: process(tck_i, trst_i)
begin
            if (trst_i ='1') then 
            tdo_o <= '1';           -- idcode output --
             end if;
            
           if(dr_shift_i = '1')then    
           if(dr_clock_i = '1')then   -- bypass mode--
             tdo_o <= td_i;            
           else
            tdo_o <= '0';
            end if;
           end if;
                       
      end process;      
            


end Behavioral;
