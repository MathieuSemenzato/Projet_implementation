LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_interface_tb is
end i2s_interface_tb;

architecture tb_arch of i2s_interface_tb is
    constant CLK_PERIOD : time := 10 ns;
    
    signal mclk : std_logic := '0';
    signal rst : std_logic := '0';
    signal din : std_logic := '0';
    signal dout : std_logic_vector(23 downto 0);
    signal valid : std_logic;
    
    -- Add signals for your clock generation if not provided by your design
    signal tb_clk : std_logic := '0';

    -- Instantiate your I2S interface
    component i2s_interface
        port (
            mclk  : in std_logic;
            rst   : in std_logic;
            din   : in std_logic;
            dout  : out std_logic_vector(23 downto 0);
            valid : out std_logic
        );
    end component;

begin
    -- Instantiate the I2S interface
    uut : i2s_interface
        port map (
            mclk  => mclk,
            rst   => rst,
            din   => din,
            dout  => dout,
            valid => valid
        );

    -- Clock generation process (for simulation purposes)
    clk_process: process
    begin
        wait for CLK_PERIOD / 2;
        tb_clk <= not tb_clk;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Initialize inputs
        rst <= '1';
        wait for CLK_PERIOD;
        rst <= '0';
        
        -- Stimulate data input and observe output
        for i in 0 to 1000 loop
            din <= '0';
            wait for CLK_PERIOD;
            din <= '1';
            wait for CLK_PERIOD;
        end loop;

        -- Add any additional simulation scenarios as needed

        wait;
    end process;

end tb_arch;

