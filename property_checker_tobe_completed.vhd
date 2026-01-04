-- property_checker.vhd

library IEEE;
use IEEE.std_logic_1164.all;


entity property_checker is
    port(clk, cmd :    in    std_logic;
        req, gnt  :    in    std_logic_vector(0 to 2);
        fails     :    out   std_logic_vector(0 to 2):="000");
end property_checker;

architecture bhv of property_checker is

signal save_req : std_logic_vector(2 downto 0);
signal cmd_pending : std_logic;
signal count : integer := 0;
signal temp : std_logic_vector(0 to 2);

begin

process(clk)
    begin
        if clk'event and clk='0' then           
           
           if cmd_pending='1' then
               count <= count + 1;
           end if;
           
           if count>=3 then
               count<=0;
               cmd_pending<='0';
           end if;
           if cmd='1' then
               save_req <= req;
               cmd_pending<='1';
               count <= 1;
           end if;
        
        end if;
end process;

process(clk)
    begin
        
    if clk'event and clk='1' then
        --property 0
        if (count = 2 and (gnt/="001" or gnt/="010" or gnt/="100" or gnt /= "000")) then
            fails(0) <= '1';
        else
            fails(0) <= '0';
        end if;
       
        --property 1: cmd was OFF before two clock cycles and the gnt != 000
        if (cmd_pending = '0' and count = 2 and gnt /= "000") then
            fails(1) <= '1';
        else 
            fails(1) <= '0';
        end if; 
       
       --property 2: cmd was ON before two clock cycles and the gnt * saved req is 000
        temp <= gnt AND save_req;
        if (cmd_pending = '1' and count = 2 and temp = "000") then
            fails(2) <= '1';
        else 
            fails(2) <= '0';
        end if;       

   end if;
end process;

end bhv;
