library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tapc_fsm is
        Port ( 
            tck_i, tms_i, trst_i : in std_logic;
            tdo_o : out std_logic;
            tapState_v : out STD_LOGIC_VECTOR (3 downto 0);
            testLogicReset_O: out std_logic;
            capture_dr_o, update_dr_o, shift_dr_o, dr_clock: out std_logic;
            capture_ir_o, update_ir_o, shift_ir_o, ir_clock: out std_logic;
            tdo_ena: out std_logic;
            irdr_select_O: out std_logic
          );
end tapc_fsm;

architecture behaviour of tapc_fsm is
    type tapStateType_t is (
        testLogicReset, runTestIdle,
        select_dr_Scan, capture_dr, exit1_dr, shift_dr, pause_dr, exit2_dr, update_dr,
        select_ir_scan, capture_ir, shift_ir, exit1_ir, update_ir, pause_ir, exit2_ir
    );
    signal currentState_st, nextState_st: tapStateType_t;

begin
    delay_element: process(tck_i, tms_i, trst_i)
    begin
        if trst_i = '1' then
            currentState_st <= testLogicReset;
        elsif rising_edge(tck_i) then
            currentState_st <= nextState_st;
        end if;
    end process;

    fsm: process(currentState_st, tms_i)
    begin
        case currentState_st is
            when testLogicReset =>
                if tms_i = '1' then
                    nextState_st <= testLogicReset;
                else
                    nextState_st <= runTestIdle;
                end if;

            when runTestIdle =>
                if tms_i = '1' then
                    nextState_st <= select_dr_Scan;
                else
                    nextState_st <= runTestIdle;
                end if;

            when select_dr_Scan =>
                if tms_i = '1' then
                    nextState_st <= select_ir_scan;
                else
                    nextState_st <= capture_dr;
                end if;

            when capture_dr =>
                if tms_i = '1' then
                    nextState_st <= exit1_dr;
                else
                    nextState_st <= shift_dr;
                end if;

            when shift_dr =>
                if tms_i = '1' then
                    nextState_st <= exit1_dr;
                else
                    nextState_st <= shift_dr;
                end if;

            when exit1_dr =>
                if tms_i = '1' then
                    nextState_st <= update_dr;
                else
                    nextState_st <= pause_dr;
                end if;

            when pause_dr =>
                if tms_i = '1' then
                    nextState_st <= exit2_dr;
                else
                    nextState_st <= pause_dr;
                end if;

            when exit2_dr =>
                if tms_i = '1' then
                    nextState_st <= update_dr;
                else
                    nextState_st <= shift_dr;
                end if;

            when update_dr =>
                if tms_i = '1' then
                    nextState_st <= select_dr_Scan;
                else
                    nextState_st <= runTestIdle;
                end if;

            when select_ir_scan =>
                if tms_i = '1' then
                    nextState_st <= testLogicReset;
                else
                    nextState_st <= capture_ir;
                end if;

            when capture_ir =>
                if tms_i = '1' then
                    nextState_st <= exit1_ir;
                else
                    nextState_st <= shift_ir;
                end if;

            when shift_ir =>
                if tms_i = '1' then
                    nextState_st <= exit1_ir;
                else
                    nextState_st <= shift_ir;
                end if;

            when exit1_ir =>
                if tms_i = '1' then
                    nextState_st <= update_ir;
                else
                    nextState_st <= pause_ir;
                end if;

            when pause_ir =>
                if tms_i = '1' then
                    nextState_st <= exit2_ir;
                else
                    nextState_st <= pause_ir;
                end if;

            when exit2_ir =>
                if tms_i = '1' then
                    nextState_st <= update_ir;
                else
                    nextState_st <= shift_ir;
                end if;

            when update_ir =>
                if tms_i = '1' then
                    nextState_st <= select_dr_Scan;
                else
                    nextState_st <= runTestIdle;
                end if;

            when others =>
                nextState_st <= testLogicReset;
        end case;

        -- Just in case to verify the tap state for debug purpose!!
        tapState_v <= std_logic_vector(to_unsigned(tapStateType_t'pos(currentState_st), tapState_v'length));

    end process;

    --- Processing the output below for "data related states"
    capture_dr_o <= '1' when (currentState_st = capture_dr) else '0';
    update_dr_o <= '1' when (currentState_st = update_dr) else '0';
    shift_dr_o <= '1' when (currentState_st = shift_dr) else '0';
    dr_clock <= tck_i when (currentState_st = shift_dr) or (currentState_st = capture_dr) or (currentState_st = update_dr) else '0';

    --- Processing the output below for "instructions related states"
    capture_ir_o <= '1' when (currentState_st = capture_ir) else '0';
    update_ir_o <= '1' when (currentState_st = update_ir) else '0';
    shift_ir_o <= '1' when (currentState_st = shift_ir) else '0';
    ir_clock <= tck_i when (currentState_st = shift_ir) or (currentState_st = capture_ir) or (currentState_st = update_ir) else '0';

    -- Processing output for "testLogicReset state"
    testLogicReset_O <= '1' when (currentState_st = testLogicReset) else '0';
    
 
    
    
    irdr_select_O <= '0' when ( (currentState_st = select_dr_Scan) or (currentState_st = capture_dr) or (currentState_st = update_dr) or
                                (currentState_st = exit1_dr) or (currentState_st = shift_dr) or (currentState_st = exit2_dr)  or
                                ( (currentState_st = pause_dr) or  (currentState_st = select_ir_scan))
    );

    --- to shift the tdo_o on the falling edge of the tck_i
    negative_clock: process(trst_i, tck_i)
    begin
        if trst_i = '1' then
            tdo_ena <= '0';
        else
            if falling_edge(tck_i) then
                if currentState_st = shift_ir or currentState_st = shift_dr then
                    tdo_ena <= '1';
                else
                    tdo_ena <= '0';
                end if;
            end if;
        end if;
    end process;

end behaviour;

