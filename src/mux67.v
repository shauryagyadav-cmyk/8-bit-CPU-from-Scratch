module mux67 (
    input  [7:0] address,
    input  [7:0] data,
    input        write_mem_cpu,

    output [7:0] write_data_mem,
    output [7:0] data_uart,
    output [7:0] address_mem,
    output       uart_start,
    output       write_mem
);

    // Address bus passed straight through to RAM
    assign address_mem    = address;
    
    // Data bus passed directly to RAM and UART
    assign write_data_mem = data;
    assign data_uart      = data;

    // Check if target is the UART Data write address (254 or 252 based on your shift logic)
    wire is_uart_write = (address == 8'd254) || (address == 8'd252);

    // RAM Write Enable: Enabled ONLY when write_mem_cpu is high AND we are NOT writing to UART
    assign write_mem      = write_mem_cpu && !is_uart_write;

    // UART Start Pulse: Triggered ONLY when writing to the UART Data address
    assign uart_start     = write_mem_cpu && is_uart_write;

endmodule