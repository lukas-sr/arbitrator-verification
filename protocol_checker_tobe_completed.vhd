library IEEE;
use IEEE.std_logic_1164.all;


entity protocol_checker is
    port(
	clk, cmd 		:    in    std_logic;
        req		  	:    in    std_logic_vector(0 to 2);
        protocol_violation	:    out   std_logic:='0'
	);
end entity;

architecture bhv of protocol_checker is

	signal violation_1,violation_2 : std_logic := '0';
	signal last_cmd: std_logic:='0';
	signal count : integer := 0;

begin

	process(clk)
	begin
		if clk'event and clk='1' then 	
			-- Violation 1: if cmd is high two cycles in a row		
            if (cmd = '1' and last_cmd = '1') then
                violation_1 <= '1';
            else
                violation_1 <= '0';
            end if;
            
            -- Violation 2: if cmd is high and no request is made
            violation_2 <= '0';
            if (cmd = '1' and req = "000") then
                violation_2 <= '1';
            end if;

            last_cmd <= cmd;
		end if;
	end process;
	
	protocol_violation <= violation_1 or violation_2;
end bhv;