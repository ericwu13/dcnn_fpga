/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2' in SOPC Builder design 'qsysP01'
 * SOPC Builder design path: ../../qsysP01.sopcinfo
 *
 * Generated: Sat Jul 07 22:13:08 CST 2018
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x10100820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 75000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1d
#define ALT_CPU_DCACHE_BYPASS_MASK 0x80000000
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x10080020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 75000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_EXTRA_EXCEPTION_INFO
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x1d
#define ALT_CPU_NAME "nios2"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x10080000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x10100820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 75000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x1d
#define NIOS2_DCACHE_BYPASS_MASK 0x80000000
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x10080020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_EXTRA_EXCEPTION_INFO
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x1d
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x10080000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_NIOS2_GEN2
#define __ALTERA_UP_AVALON_RS232
#define __ALTPLL
#define __TEST_SLAVE


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x10101108
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x10101108
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x10101108
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "qsysP01"


/*
 * altpll_0 configuration
 *
 */

#define ALTPLL_0_BASE 0x101010d0
#define ALTPLL_0_IRQ -1
#define ALTPLL_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ALTPLL_0_NAME "/dev/altpll_0"
#define ALTPLL_0_SPAN 16
#define ALTPLL_0_TYPE "altpll"
#define ALT_MODULE_CLASS_altpll_0 altpll


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * hex0 configuration
 *
 */

#define ALT_MODULE_CLASS_hex0 altera_avalon_pio
#define HEX0_BASE 0x101010b0
#define HEX0_BIT_CLEARING_EDGE_REGISTER 0
#define HEX0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HEX0_CAPTURE 0
#define HEX0_DATA_WIDTH 7
#define HEX0_DO_TEST_BENCH_WIRING 0
#define HEX0_DRIVEN_SIM_VALUE 0
#define HEX0_EDGE_TYPE "NONE"
#define HEX0_FREQ 75000000
#define HEX0_HAS_IN 0
#define HEX0_HAS_OUT 1
#define HEX0_HAS_TRI 0
#define HEX0_IRQ -1
#define HEX0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HEX0_IRQ_TYPE "NONE"
#define HEX0_NAME "/dev/hex0"
#define HEX0_RESET_VALUE 0
#define HEX0_SPAN 16
#define HEX0_TYPE "altera_avalon_pio"


/*
 * hex1 configuration
 *
 */

#define ALT_MODULE_CLASS_hex1 altera_avalon_pio
#define HEX1_BASE 0x10101070
#define HEX1_BIT_CLEARING_EDGE_REGISTER 0
#define HEX1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HEX1_CAPTURE 0
#define HEX1_DATA_WIDTH 7
#define HEX1_DO_TEST_BENCH_WIRING 0
#define HEX1_DRIVEN_SIM_VALUE 0
#define HEX1_EDGE_TYPE "NONE"
#define HEX1_FREQ 75000000
#define HEX1_HAS_IN 0
#define HEX1_HAS_OUT 1
#define HEX1_HAS_TRI 0
#define HEX1_IRQ -1
#define HEX1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HEX1_IRQ_TYPE "NONE"
#define HEX1_NAME "/dev/hex1"
#define HEX1_RESET_VALUE 0
#define HEX1_SPAN 16
#define HEX1_TYPE "altera_avalon_pio"


/*
 * hex2 configuration
 *
 */

#define ALT_MODULE_CLASS_hex2 altera_avalon_pio
#define HEX2_BASE 0x10101080
#define HEX2_BIT_CLEARING_EDGE_REGISTER 0
#define HEX2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HEX2_CAPTURE 0
#define HEX2_DATA_WIDTH 7
#define HEX2_DO_TEST_BENCH_WIRING 0
#define HEX2_DRIVEN_SIM_VALUE 0
#define HEX2_EDGE_TYPE "NONE"
#define HEX2_FREQ 75000000
#define HEX2_HAS_IN 0
#define HEX2_HAS_OUT 1
#define HEX2_HAS_TRI 0
#define HEX2_IRQ -1
#define HEX2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HEX2_IRQ_TYPE "NONE"
#define HEX2_NAME "/dev/hex2"
#define HEX2_RESET_VALUE 0
#define HEX2_SPAN 16
#define HEX2_TYPE "altera_avalon_pio"


/*
 * hex3 configuration
 *
 */

#define ALT_MODULE_CLASS_hex3 altera_avalon_pio
#define HEX3_BASE 0x10101090
#define HEX3_BIT_CLEARING_EDGE_REGISTER 0
#define HEX3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HEX3_CAPTURE 0
#define HEX3_DATA_WIDTH 7
#define HEX3_DO_TEST_BENCH_WIRING 0
#define HEX3_DRIVEN_SIM_VALUE 0
#define HEX3_EDGE_TYPE "NONE"
#define HEX3_FREQ 75000000
#define HEX3_HAS_IN 0
#define HEX3_HAS_OUT 1
#define HEX3_HAS_TRI 0
#define HEX3_IRQ -1
#define HEX3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HEX3_IRQ_TYPE "NONE"
#define HEX3_NAME "/dev/hex3"
#define HEX3_RESET_VALUE 0
#define HEX3_SPAN 16
#define HEX3_TYPE "altera_avalon_pio"


/*
 * hex4 configuration
 *
 */

#define ALT_MODULE_CLASS_hex4 altera_avalon_pio
#define HEX4_BASE 0x101010a0
#define HEX4_BIT_CLEARING_EDGE_REGISTER 0
#define HEX4_BIT_MODIFYING_OUTPUT_REGISTER 0
#define HEX4_CAPTURE 0
#define HEX4_DATA_WIDTH 7
#define HEX4_DO_TEST_BENCH_WIRING 0
#define HEX4_DRIVEN_SIM_VALUE 0
#define HEX4_EDGE_TYPE "NONE"
#define HEX4_FREQ 75000000
#define HEX4_HAS_IN 0
#define HEX4_HAS_OUT 1
#define HEX4_HAS_TRI 0
#define HEX4_IRQ -1
#define HEX4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define HEX4_IRQ_TYPE "NONE"
#define HEX4_NAME "/dev/hex4"
#define HEX4_RESET_VALUE 0
#define HEX4_SPAN 16
#define HEX4_TYPE "altera_avalon_pio"


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x10101108
#define JTAG_UART_0_IRQ 1
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * led_output configuration
 *
 */

#define ALT_MODULE_CLASS_led_output altera_avalon_pio
#define LED_OUTPUT_BASE 0x101010c0
#define LED_OUTPUT_BIT_CLEARING_EDGE_REGISTER 0
#define LED_OUTPUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_OUTPUT_CAPTURE 0
#define LED_OUTPUT_DATA_WIDTH 18
#define LED_OUTPUT_DO_TEST_BENCH_WIRING 0
#define LED_OUTPUT_DRIVEN_SIM_VALUE 0
#define LED_OUTPUT_EDGE_TYPE "NONE"
#define LED_OUTPUT_FREQ 75000000
#define LED_OUTPUT_HAS_IN 0
#define LED_OUTPUT_HAS_OUT 1
#define LED_OUTPUT_HAS_TRI 0
#define LED_OUTPUT_IRQ -1
#define LED_OUTPUT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_OUTPUT_IRQ_TYPE "NONE"
#define LED_OUTPUT_NAME "/dev/led_output"
#define LED_OUTPUT_RESET_VALUE 0
#define LED_OUTPUT_SPAN 16
#define LED_OUTPUT_TYPE "altera_avalon_pio"


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x10080000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "qsysP01_onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 1
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 409600
#define ONCHIP_MEMORY2_0_SPAN 409600
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * rs232_0 configuration
 *
 */

#define ALT_MODULE_CLASS_rs232_0 altera_up_avalon_rs232
#define RS232_0_BASE 0x10101100
#define RS232_0_IRQ 0
#define RS232_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define RS232_0_NAME "/dev/rs232_0"
#define RS232_0_SPAN 8
#define RS232_0_TYPE "altera_up_avalon_rs232"


/*
 * sdram_control configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_control altera_avalon_new_sdram_controller
#define SDRAM_CONTROL_BASE 0x8000000
#define SDRAM_CONTROL_CAS_LATENCY 3
#define SDRAM_CONTROL_CONTENTS_INFO
#define SDRAM_CONTROL_INIT_NOP_DELAY 0.0
#define SDRAM_CONTROL_INIT_REFRESH_COMMANDS 2
#define SDRAM_CONTROL_IRQ -1
#define SDRAM_CONTROL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_CONTROL_IS_INITIALIZED 1
#define SDRAM_CONTROL_NAME "/dev/sdram_control"
#define SDRAM_CONTROL_POWERUP_DELAY 100.0
#define SDRAM_CONTROL_REFRESH_PERIOD 15.625
#define SDRAM_CONTROL_REGISTER_DATA_IN 1
#define SDRAM_CONTROL_SDRAM_ADDR_WIDTH 0x19
#define SDRAM_CONTROL_SDRAM_BANK_WIDTH 2
#define SDRAM_CONTROL_SDRAM_COL_WIDTH 10
#define SDRAM_CONTROL_SDRAM_DATA_WIDTH 32
#define SDRAM_CONTROL_SDRAM_NUM_BANKS 4
#define SDRAM_CONTROL_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_CONTROL_SDRAM_ROW_WIDTH 13
#define SDRAM_CONTROL_SHARED_DATA 0
#define SDRAM_CONTROL_SIM_MODEL_BASE 0
#define SDRAM_CONTROL_SPAN 134217728
#define SDRAM_CONTROL_STARVATION_INDICATOR 0
#define SDRAM_CONTROL_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_CONTROL_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_CONTROL_T_AC 5.5
#define SDRAM_CONTROL_T_MRD 3
#define SDRAM_CONTROL_T_RCD 20.0
#define SDRAM_CONTROL_T_RFC 70.0
#define SDRAM_CONTROL_T_RP 20.0
#define SDRAM_CONTROL_T_WR 14.0


/*
 * sysid_qsys_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_qsys_0 altera_avalon_sysid_qsys
#define SYSID_QSYS_0_BASE 0x101010f8
#define SYSID_QSYS_0_ID 0
#define SYSID_QSYS_0_IRQ -1
#define SYSID_QSYS_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_QSYS_0_NAME "/dev/sysid_qsys_0"
#define SYSID_QSYS_0_SPAN 8
#define SYSID_QSYS_0_TIMESTAMP 1530972499
#define SYSID_QSYS_0_TYPE "altera_avalon_sysid_qsys"


/*
 * test_slave_0 configuration
 *
 */

#define ALT_MODULE_CLASS_test_slave_0 test_slave
#define TEST_SLAVE_0_BASE 0x10101114
#define TEST_SLAVE_0_IRQ -1
#define TEST_SLAVE_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TEST_SLAVE_0_NAME "/dev/test_slave_0"
#define TEST_SLAVE_0_SPAN 4
#define TEST_SLAVE_0_TYPE "test_slave"

#endif /* __SYSTEM_H_ */
