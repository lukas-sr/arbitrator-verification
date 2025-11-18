library IEEE;
use IEEE.std_logic_1164.all;


entity protocol_checker is
    port(clk, cmd :    in    std_logic;
        req		  :    in    std_logic_vector(0 to 2);
        protocol_violation    :    out   std_logic:='0');
end entity;

architecture bhv of protocol_checker is

	signal violation_1,violation_2 : std_logic;
	signal last_cmd: std_logic:='0';
	signal count : integer := 0;

begin

	process(clk)
	begin
		if clk'event and clk='1' then 			
			--Property 1      
			violation_1 <=  --to be completed
			
			--Property 2
			violation_2 <= '0';
			if () then      --to be completed  
                violation_2 <=  
         end if;  
		end if;
	end process;

	protocol_violation <= violation_1 or violation_2;

end bhv;