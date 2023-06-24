{
    --------------------------------------------
    Filename: signal.adc.adc083x.spin
    Author: Jesse Burt
    Description: Driver for the TI ADC083x family of ADCs
    Copyright (c) 2023
    Started Jun 21, 2023
    Updated Jun 24, 2023
    See end of file for terms of use.
    --------------------------------------------
}

CON

    { limits }
    ADC_BITS        = 8
    SCK_FREQ_MAX    = 400_000
    SCK_FREQ_DEF    = 100_000

    { scaling }
    VREF            = 5_000                         ' 5V
    ADC_RANGE       = (1 << ADC_BITS)
    ADC_MAX         = ADC_RANGE-1
    ADC_SCALE_1V    = 1_000

VAR

    long _CS, _SCK, _MOSI, _MISO
    long _sck_hperiod

PUB null()
' This is not a top-level object

PUB startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN, SCK_FREQ): status
' Start using custom IO pins
'   CS_PIN: chip select
'   SCK_PIN: serial clock
'   MOSI_PIN: master-out slave-in (ADC0832, ADC0834, ADC0838 only)
'   MISO_PIN: master-in slave-out (all models)
'   SCK_FREQ: serial clock frequency (400_000 maximum; maximum not enforced)
' Returns:
'   core/cog # of parent + 1
'   or FALSE if unsuccessful (bad I/O pin assignment)
    if ( lookdown(CS_PIN: 0..31) and lookdown(SCK_PIN: 0..31) and lookdown(MISO_PIN: 0..31) )
        longmove(@_CS, @CS_PIN, 4)          ' copy i/o pins to hub var
        outa[_CS] := 1                      ' set i/o pins initial/idle state
        dira[_CS] := 1
        outa[_SCK] := 0
        dira[_SCK] := 1
        dira[_MISO] := 0
#ifdef __OUTPUT_ASM__
        calc_sck_half_period(SCK_FREQ)
#endif
        return (cogid + 1)
    ' if this point is reached, something above failed
    ' Re-check I/O pin assignments, bus speed, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE

PUB stop()
' Stop the driver
'   Restore i/o pins to default state
'   Clear out global variables
    dira[_CS] := 0
    dira[_SCK] := 0
    if ( lookdown(_MOSI: 0..31) )
        dira[_MOSI] := 0
    dira[_MISO] := 0
    longfill(@_CS, 0, 4)

PUB defaults()
' Factory default settings

PUB adc2volts(adc_word)
' Convert ADC word to microvolts
    return ((adc_word * ADC_SCALE_1V) / ADC_RANGE) * VREF

PUB adc_data(): w | cs, sck, mosi, miso, sck_hperiod
' ADC word
'   Returns: u8
    longmove(@cs, @_CS, 5)                      ' copy i/o pins and timing

    outa[cs] := 0                               ' select the chip
    !outa[sck]                                  ' pulse clock to bring MISO out of tri-state
    !outa[sck]

    w := 0
    repeat 8
        !outa[sck]
#ifdef __OUTPUT_ASM__
        waitcnt(cnt+sck_hperiod)                ' pace the clock properly if building PASM code
#endif                                          '   (not necessary when building bytecode)
        !outa[sck]
#ifdef __OUTPUT_ASM__
        waitcnt(cnt+sck_hperiod)
#endif
        w := (w << 1) | ina[miso]               ' sample _after_ the clock pulse
    outa[cs] := 1

CON OVERHEAD_CYCLES = 29
PUB calc_sck_half_period(sck_freq)
' Calculate SCK half period in system ticks
    _sck_hperiod := ((clkfreq / sck_freq) / 2)-OVERHEAD_CYCLES

{ pull in code common to all ADC drivers, e.g., voltage() }
#include "signal.adc.common.spinh"

DAT
{
Copyright (c) 2023 Jesse Burt

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

