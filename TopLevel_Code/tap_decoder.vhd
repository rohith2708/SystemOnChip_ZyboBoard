----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/17/2023 11:39:04 AM
-- Design Name: 
-- Module Name: tap_decoder - Behavioral
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

entity tap_decoder is
port(      clk_dr_i : in STD_LOGIC;
           shift_dr_i : in STD_LOGIC;
           update_dr_i : in STD_LOGIC;
           ir_i : in std_logic_vector(31 downto 0);
           test_mode_o : out STD_LOGIC;
           select_tdo_o : out STD_LOGIC;
           clk_by_o : out STD_LOGIC;
           shift_by_o : out STD_LOGIC;
           clk_bs_o : out STD_LOGIC;
           shift_bs_o : out STD_LOGIC;
           upd_bs_o : out STD_LOGIC;
           test_code_o : out std_logic_vector(2 downto 0);
           dbg0_mode_o : out STD_LOGIC;
           dbg0_clk_o : out STD_LOGIC;
           dbg0_shift_o : out STD_LOGIC;
           dbg0_upd_o : out STD_LOGIC);
end tap_decoder;
architecture Behavioral of tap_decoder is
    type instruction is (EXTEST, SAMPLE, PRELOAD, IDCODE, BYPASS,SCANCHAIN);
    signal I: instruction;
   
begin 
    process(ir_i) 
    begin    
        case ir_i is 
            when "00000000000000000000000000000000" => I <= EXTEST;
            when "00000000000000000000000000000001" => I <= SAMPLE;
            when "00000000000000000000000000000010" => I <= IDCODE;
            when "00000000000000000000000000000011" => I <= SCANCHAIN;
            when "11111111111111111111111111111111" => I <= BYPASS;
            when "00000000000000000000000000000111" => I <= PRELOAD;
            when others => -- Handle other cases if needed
                I <= EXTEST; -- or assign a default value
        end case;

        if (I = SCANCHAIN) then
            test_mode_o <= '1';
            dbg0_mode_o <= '1';
            dbg0_clk_o <= clk_dr_i;
            dbg0_shift_o <= shift_dr_i;
            dbg0_upd_o <= update_dr_i;
        end if;
    end process;


--test code logic --
 test_code_o <= "000" when I = EXTEST;
 test_code_o <= "001" when I = SAMPLE;
 test_code_o <= "010" when I = SCANCHAIN;
 test_code_o <= "011" when I = PRELOAD;
 test_code_o <= "111" when I = BYPASS; 


test_mode_o <= '1' when I = EXTEST else '0';
select_tdo_o <= '1' when (I = BYPASS OR I = IDCODE) else '0';
shift_by_o <= shift_dr_i;
clk_by_o <= clk_dr_i when (I = BYPASS or I = IDCODE) else '0';

-- scan chain mode ---
dbg0_shift_o <= shift_dr_i when I= SCANCHAIN else '0';
dbg0_clk_o <= clk_dr_i when I = SCANCHAIN else '0';

end Behavioral;
