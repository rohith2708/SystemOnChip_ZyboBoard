----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/17/2023 11:29:21 PM
-- Design Name: 
-- Module Name: register_irdr - Behavioral
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

entity register_dr is
    Port ( trst_i : in STD_LOGIC;
           clk_i : in STD_LOGIC;
           ser_in_i : in STD_LOGIC;
           clock_dr_i : in STD_LOGIC;
           shift_dr_i : in STD_LOGIC;
           mode_i : in STD_LOGIC;
           upd_dr_i : in STD_LOGIC;
           data_in_i : in STD_LOGIC;
           test_code_i :in std_logic_vector(2 downto 0);
           data_out_o : out STD_LOGIC;
           ser_out_o : out STD_LOGIC);
end register_dr;

architecture Behavioral of register_dr is
  type instruction is (EXTEST, SAMPLE, PRELOAD, IDCODE, BYPASS,SCANCHAIN);
  signal I: instruction;

signal internal_data :std_logic;
signal data_output: std_logic;

begin

 process(test_code_i) 
    begin    
        case test_code_i is 
            when "000" => I <= EXTEST;
            when "001" => I <= SAMPLE;
            when "010" => I <= SCANCHAIN;
            when "011" => I <= PRELOAD;
            when others => -- Handle other cases if needed
                I <= EXTEST; -- or assign a default value
        end case;
end process;

shift_datareg_process : process(clk_i, trst_i, I)
begin 
    if (trst_i ='1') then
    internal_data <= '0';
         elsif(clk_i'event and clk_i ='1')then
    if(clock_dr_i = '1')then
        if(shift_dr_i = '0')then 
            internal_data <= data_in_i;
          else 
          internal_data <= ser_in_i;
         
             if(I = PRELOAD) then                           -- In preload mode directly give the data out in parallel post shift --
                   data_out_o <= internal_data;
             elsif(I = SAMPLE) then
                    ser_out_o <= internal_data;             -- moving the data out serially after the execution in sample mode --
             end if;
         end if ;
         end if;
         end if;
end process;

update_datareg_process : process(clk_i, trst_i)
begin 
    if (trst_i ='1') then
    data_output <= '0';
    elsif (clk_i'event and clk_i ='1')then
    if(upd_dr_i = '1')then
    data_output <= internal_data;
    end if;
    end if;
    end process;
    
    data_out_o <= data_output;
    ser_out_o <= internal_data;

end Behavioral;
