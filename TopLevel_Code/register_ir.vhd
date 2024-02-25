----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2023 12:22:20 PM
-- Design Name: 
-- Module Name: register_ir - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_ir is
    Port ( 
           trst_i : in STD_LOGIC;
           clk_i : in STD_LOGIC;
           ser_in_i : in STD_LOGIC;
           clock_ir_i : in STD_LOGIC;
           shift_ir_i : in STD_LOGIC;
           ir_rst_i : in STD_LOGIC;
           upd_ir_i : in STD_LOGIC;
           data_in_i : in STD_LOGIC;
           data_out_o : out STD_LOGIC;
           ir_pardata_c : out STD_LOGIC;
           ir_reg_out_s : out STD_LOGIC_VECTOR(31 downto 0);
           tdo_ir_s: out STD_LOGIC);
           
end register_ir;

architecture Behavioral of register_ir is
signal internal_data_cell_1 :std_logic;
signal internal_data_cell_2 :std_logic;
signal data_output_cell_2 :std_logic;
signal data_output_cell_1: std_logic;
--signal ir_storage : bit_vector(7 downto 0);
signal ir_storage : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
-- sample architecture --
-- ir_pardata_c <= (trst_i and clk_i and ser_in_i) or (clock_ir_i and shift_ir_i);
-- ir_reg_out_s <= (ir_rst_i and upd_ir_i and data_in_i);
-- tdo_ir_s <= ir_rst_i and upd_ir_i;



mode_selection_method : process(ser_in_i, clock_ir_i)
begin
    if rising_edge(clock_ir_i) then
        -- Shift existing bits to the left
        for ii in 0 to 30 loop
            ir_storage(ii) <= ir_storage(ii + 1);
            ir_storage(30) <= ser_in_i;
        end loop;
        -- Add incoming bit to the rightmost position
        
    end if; 
end process;


ir_shift_process : process(clk_i, trst_i)
begin 
    if (trst_i ='1') then
    internal_data_cell_1 <= '0';
         --elsif(clk_i ='1')then
    elsif rising_edge(clk_i) then
    if(clock_ir_i = '1')then
        if(shift_ir_i = '0')then 
            internal_data_cell_1 <= data_in_i;
          else 
          internal_data_cell_1 <= ser_in_i;
         end if ;
         end if;
         end if;  
         end process;
         
         
ir_upd_process :process(clk_i, trst_i, ir_rst_i)
begin 
if(trst_i ='1') then 
    data_output_cell_2 <= ir_rst_i;
         
       elsif(clk_i'event and clk_i = '1') then
    if(upd_ir_i ='1')then 
        data_output_cell_2 <= internal_data_cell_1;
    end if;
    end if;
    end process;
    
    tdo_ir_s <= data_output_cell_2;
    data_out_o <= data_output_cell_2;
    

end Behavioral;


