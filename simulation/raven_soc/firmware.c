#include "../raven_defs.h"

// --------------------------------------------------------

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

// --------------------------------------------------------

void main()
{
	// UART divider used by the project simulation firmware.
	// The project testbench runs the selected SoC clock at 100 MHz.
	// The legacy tbuart model is not baud-matched to this divider, so the
	// testbench verifies UART transmit activity rather than decoded text.
	reg_uart_clkdiv = 625;

	// Write a banner to the UART; the project testbench verifies transmit activity.
        print("\n");
        print("  ____  _          ____         ____\n");
        print(" |  _ \\(_) ___ ___/ ___|  ___  / ___|\n");
        print(" | |_) | |/ __/ _ \\___ \\ / _ \\| |\n");
        print(" |  __/| | (_| (_) |__) | (_) | |___\n");
        print(" |_|   |_|\\___\\___/____/ \\___/ \\____|\n");
}

