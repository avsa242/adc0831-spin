{
----------------------------------------------------------------------------------------------------
    Filename:       ADC083x-Demo.spin
    Description:    Demo of the ADC083x ADC driver
    Author:         Jesse Burt
    Started:        Jun 21, 2023
    Updated:        May 6, 2025
    Copyright (c) 2025 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    adc:    "signal.adc.adc083x" | CS=0, SCK=1, MOSI=-1, MISO=2, SPI_FREQ=400_000
    time:   "time"


PUB main() | v

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    adc.start()
    ser.strln(@"ADC083x driver started")

    repeat
        v := adc.voltage()
        ser.pos_xy(0, 3)
        ser.printf(@"Voltage: %d.%06.6dv\n\r",  (v / 1_000_000), ...
                                                ||(v // 1_000_000) )


DAT
{
Copyright (c) 2025 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

