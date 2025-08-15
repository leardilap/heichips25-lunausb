
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spad_env_f_bit is
  generic (
    WIN_BITS   : positive := 16;  
    PCNT_WIDTH : positive := 16   
  );
  port (
    clk            : in  std_logic;
    spad_hit_async : in  std_logic;
    env_bit        : out std_logic;
    env_valid      : out std_logic
  );
end entity;

architecture rtl of spad_env_f_bit is
   
  signal s0, s1, s1_d : std_logic := '0';
  signal rise_spad    : std_logic := '0';

  
  signal win_cnt      : unsigned(WIN_BITS-1 downto 0) := (others => '0');
  signal win_rollover : std_logic := '0';
  constant WIN_MAX    : unsigned(WIN_BITS-1 downto 0)
                      := to_unsigned((2**WIN_BITS) - 1, WIN_BITS);

  
  signal pulse_cnt : unsigned(PCNT_WIDTH-1 downto 0) := (others => '0');

   
  signal lsb_parity : std_logic;
  signal prev_bit   : std_logic := '0';
  signal prev2_bit  : std_logic := '0';
  signal mix        : std_logic := '0';

  signal env_reg  : std_logic := '0';
  signal env_stb  : std_logic := '0';
begin
  
  process(clk)
  begin
    if rising_edge(clk) then
      s0   <= spad_hit_async;
      s1   <= s0;
      s1_d <= s1;
      
      rise_spad <= (not s1_d) and s1;
    end if;
  end process;

  
  process(clk)
  begin
    if rising_edge(clk) then
      if win_cnt = WIN_MAX then
        win_cnt      <= (others => '0');
        win_rollover <= '1';
      else
        win_cnt      <= win_cnt + 1;
        win_rollover <= '0';
      end if;
    end if;
  end process;

   
  process(clk)
  begin
    if rising_edge(clk) then
      if rise_spad = '1' then
        pulse_cnt <= pulse_cnt + 1;
      end if;

      if win_rollover = '1' then
        pulse_cnt <= (others => '0');
      end if;
    end if;
  end process;

  
   
  lsb_parity <= std_logic(pulse_cnt(0)) xor std_logic(pulse_cnt(1))
             xor std_logic(pulse_cnt(2)) xor std_logic(pulse_cnt(3));

  mix <= lsb_parity xor prev_bit xor prev2_bit;

  process(clk)
  begin
    if rising_edge(clk) then
      env_stb <= '0'; -- default low

      if win_rollover = '1' then
        env_reg <= mix;
        env_stb <= '1';

        -- shift history (no loops)
        prev2_bit <= prev_bit;
        prev_bit  <= mix;
      end if;
    end if;
  end process;

  env_bit   <= env_reg;
  env_valid <= env_stb;
end architecture;
