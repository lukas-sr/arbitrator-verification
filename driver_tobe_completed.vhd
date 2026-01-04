-- driver.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;      -- UNIFORM, TRUNC
use ieee.numeric_std.all;    -- TO_UNSIGNED
use std.textio.all;
use ieee.std_logic_textio.all;

entity driver is
    port(
        clk : in std_logic;
        cmd : inout std_logic;
        n1, n2, n3 : in signed(0 to 1);
        req : inout std_logic_vector(0 to 2)
    );
end entity;

architecture bhv of driver is
    constant n : real := 10.0;

    file log_file : text open write_mode is "Display.txt";
begin

process(clk)
    -- Random generator
    variable seed1, seed2 : positive := 1;
    variable rand : real;

    variable int_rand_wait : integer := 0;
    variable int_rand_req  : integer := 0;
    variable count         : integer := 0;

    variable req_next : std_logic_vector(2 downto 0) := "000";
begin

    if rising_edge(clk) then

        -- Generate new random values when counter expires
        if count = 0 then

            -- Random wait between 1 and n cycles
            UNIFORM(seed1, seed2, rand);
            int_rand_wait := integer(trunc(rand * n)) + 1;

            -- Random req between 0 and 7
            UNIFORM(seed1, seed2, rand);
            int_rand_req := integer(trunc(rand * 8.0));
            req_next := std_logic_vector(to_unsigned(int_rand_req, 3));

            count := int_rand_wait;
            req <= req_next;
            cmd <= '1';

        else
            count := count - 1;
            cmd <= '0';
        end if;

    end if;
end process;


-- Display process ( to show in display.txt file)
process(clk)
    variable L : line;
begin
    if rising_edge(clk) then
        if cmd = '1' then
            write(L, string'("Driver is alive "));
            write(L, string'("REQ="));
            write(L, req);
            write(L, string'(" N1="));
            write(L, integer'image(to_integer(n1)));
            write(L, string'(" N2="));
            write(L, integer'image(to_integer(n2)));
            write(L, string'(" N3="));
            write(L, integer'image(to_integer(n3)));
            writeline(log_file, L);
        end if;
    end if;
end process;


end architecture;
