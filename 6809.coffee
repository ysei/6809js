#
#The MIT License (MIT)
#
#Copyright (c) 2014 Martin Maly, http://retrocip.cz, http://www.uelectronics.info,
#twitter: @uelectronics
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the "Software"), to deal in
#the Software without restriction, including without limitation the rights to
#use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
#the Software, and to permit persons to whom the Software is furnished to do so,
#subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
#FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
#COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
#IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
((name, definition) ->
  unless typeof module is "undefined"
    module.exports = definition()
  else if typeof define is "function" and typeof define.amd is "object"
    define definition
  else
    this[name] = definition()
) "CPU6809", ->
  rA = undefined
  rB = undefined
  rX = undefined
  rY = undefined
  rU = undefined
  rS = undefined
  PC = undefined
  CC = undefined
  DP = undefined
  F_CARRY = 1
  F_OVERFLOW = 2
  F_ZERO = 4
  F_NEGATIVE = 8
  F_IRQMASK = 16
  F_HALFCARRY = 32
  F_FIRQMASK = 64
  F_ENTIRE = 128
  vecRESET = 0xFFFE
  vecNMI = 0xFFFC
  vecSWI = 0xFFFA
  vecIRQ = 0xFFF8
  vecFIRQ = 0xFFF6
  vecSWI2 = 0xFFF4
  vecSWI3 = 0xFFF2
  T = 0
  IRQs = undefined
  byteTo = undefined
  byteAt = undefined
  # 00-0F 
  # 10-1F 
  # 20-2F 
  # 30-3F 
  # 40-4F 
  # 50-5F 
  # 60-6F 
  # 70-7F 
  # 80-8F 
  # 90-9F 
  # A0-AF 
  # B0-BF 
  # C0-CF 
  # D0-DF 
  # E0-EF 
  cycles = [ 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 0, 6, 6, 3, 6, 0, 0, 2, 4, 0, 0, 5, 9, 0, 2, 3, 0, 3, 2, 8, 6, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0, 5, 3, 6, 9, 11, 0, 19, 2, 0, 0, 2, 2, 0, 2, 2, 2, 2, 2, 0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0, 2, 2, 2, 2, 2, 0, 2, 2, 0, 2, 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 0, 6, 6, 3, 6, 7, 0, 0, 7, 7, 0, 7, 7, 7, 7, 7, 0, 7, 7, 4, 7, 2, 2, 2, 4, 2, 2, 2, 0, 2, 2, 2, 2, 4, 7, 3, 0, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5, 5, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 8, 6, 6, 2, 2, 2, 4, 2, 2, 2, 0, 2, 2, 2, 2, 3, 0, 3, 0, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6 ] # F0-FF
  
  # Instruction timing for the two-byte opcodes 
  # 00-0F 
  # 10-1F 
  # 20-2F 
  # 30-3F 
  # 40-4F 
  # 50-5F 
  # 60-6F 
  # 70-7F 
  # 80-8F 
  # 90-9F 
  # A0-AF 
  # B0-BF 
  # C0-CF 
  # D0-DF 
  # E0-EF 
  cycles2 = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 6, 6, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 6, 6, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7 ] # F0-FF
  
  # Negative and zero flags for quicker flag settings 
  # 00-0F 
  # 10-1F 
  # 20-2F 
  # 30-3F 
  # 40-4F 
  # 50-5F 
  # 60-6F 
  # 70-7F 
  # 80-8F 
  # 90-9F 
  # A0-AF 
  # B0-BF 
  # C0-CF 
  # D0-DF 
  # E0-EF 
  flagsNZ = [ 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8 ] # F0-FF
  setV8 = (a, b, r) ->
    CC |= (((a ^ b ^ r ^ (r >> 1)) & 0x80) >> 6)

  setV16 = (a, b, r) ->
    CC |= (((a ^ b ^ r ^ (r >> 1)) & 0x8000) >> 14)

  getD = ->
    rA * 256 + rB

  setD = (v) ->
    rA = (v >> 8) & 0xff
    rB = v & 0xff

  PUSHB = (b) ->
    byteTo --rS, b & 0xff

  PUSHW = (b) ->
    byteTo --rS, b & 0xff
    byteTo --rS, (b >> 8) & 0xff

  PUSHBU = (b) ->
    byteTo --rU, b & 0xff

  PUSHWU = (b) ->
    byteTo --rU, b & 0xff
    byteTo --rU, (b >> 8) & 0xff

  PULLB = (b) ->
    byteAt rS++

  PULLW = (b) ->
    byteAt(rS++) * 256 + byteAt(rS++)

  PULLBU = (b) ->
    byteAt rU++

  PULLWU = (b) ->
    byteAt(rU++) * 256 + byteAt(rU++)

  PSHS = (ucTemp) ->
    i = 0
    if ucTemp & 0x80
      PUSHW PC
      i += 2
    if ucTemp & 0x40
      PUSHW rU
      i += 2
    if ucTemp & 0x20
      PUSHW rY
      i += 2
    if ucTemp & 0x10
      PUSHW rX
      i += 2
    if ucTemp & 0x8
      PUSHB DP
      i++
    if ucTemp & 0x4
      PUSHB rB
      i++
    if ucTemp & 0x2
      PUSHB rA
      i++
    if ucTemp & 0x1
      PUSHB CC
      i++
    T += i #timing

  PSHU = (ucTemp) ->
    i = 0
    if ucTemp & 0x80
      PUSHWU PC
      i += 2
    if ucTemp & 0x40
      PUSHWU rS
      i += 2
    if ucTemp & 0x20
      PUSHWU rY
      i += 2
    if ucTemp & 0x10
      PUSHWU rX
      i += 2
    if ucTemp & 0x8
      PUSHBU DP
      i++
    if ucTemp & 0x4
      PUSHBU rB
      i++
    if ucTemp & 0x2
      PUSHBU rA
      i++
    if ucTemp & 0x1
      PUSHBU CC
      i++
    T += i #timing

  PULS = (ucTemp) ->
    i = 0
    if ucTemp & 0x1
      CC = PULLB()
      i++
    if ucTemp & 0x2
      rA = PULLB()
      i++
    if ucTemp & 0x4
      rB = PULLB()
      i++
    if ucTemp & 0x8
      DP = PULLB()
      i++
    if ucTemp & 0x10
      rX = PULLW()
      i += 2
    if ucTemp & 0x20
      rY = PULLW()
      i += 2
    if ucTemp & 0x40
      rU = PULLW()
      i += 2
    if ucTemp & 0x80
      PC = PULLW()
      i += 2
    T += i #timing

  PULU = (ucTemp) ->
    i = 0
    if ucTemp & 0x1
      CC = PULLBU()
      i++
    if ucTemp & 0x2
      rA = PULLBU()
      i++
    if ucTemp & 0x4
      rB = PULLBU()
      i++
    if ucTemp & 0x8
      DP = PULLBU()
      i++
    if ucTemp & 0x10
      rX = PULLWU()
      i += 2
    if ucTemp & 0x20
      rY = PULLWU()
      i += 2
    if ucTemp & 0x40
      rS = PULLWU()
      i += 2
    if ucTemp & 0x80
      PC = PULLWU()
      i += 2
    T += i #timing

  getPBR = (ucPostByte) ->
    switch ucPostByte & 0xf
      when 0x00 # D
        getD()
      when 0x1 # X
        rX
      when 0x2 # Y
        rY
      when 0x3 # U
        rU
      when 0x4 # S
        rS
      when 0x5 # PC
        PC
      when 0x8 # A
        rA
      when 0x9 # B
        rB
      when 0xA # CC
        CC
      when 0xB # DP
        DP
      else # illegal
        null

  setPBR = (ucPostByte, v) ->
    switch ucPostByte & 0xf # Get destination register
      when 0x00 # D
        setD v
        return
      when 0x1 # X
        rX = v
        return
      when 0x2 # Y
        rY = v
        return
      when 0x3 # U
        rU = v
        return
      when 0x4 # S
        rS = v
        return
      when 0x5 # PC
        PC = v
        return
      when 0x8 # A
        rA = v
        return
      when 0x9 # B
        rB = v
        return
      when 0xA # CC
        CC = v
        return
      when 0xB # DP
        DP = v
        return
      else # illegal
        return

  TFREXG = (ucPostByte, bExchange) ->
    ucTemp = ucPostByte & 0x88
    ucTemp = 0  if ucTemp is 0x80 or ucTemp is 0x08 # PROBLEM!
    if bExchange
      ucTemp = getPBR(ucPostByte >> 4)
      setPBR ucPostByte >> 4, getPBR(ucPostByte)
      setPBR ucPostByte, ucTemp
    else # Transfer
      setPBR ucPostByte, getPBR(ucPostByte >> 4)

  signed = (x) ->
    (if (x > 127) then (x - 256) else x)

  signed16 = (x) ->
    (if (x > 32767) then (x - 65536) else x)

  fetch = ->
    v = byteAt(PC++)
    PC &= 0xffff
    v

  fetch16 = ->
    v1 = byteAt(PC++)
    PC &= 0xffff
    v2 = byteAt(PC++)
    PC &= 0xffff
    v1 * 256 + v2

  ReadWord = (addr) ->
    v1 = byteAt(addr++)
    addr &= 0xffff
    v2 = byteAt(addr++)
    addr &= 0xffff
    v1 * 256 + v2

  WriteWord = (addr, v) ->
    byteTo addr++, (v >> 8) & 0xff
    addr &= 0xffff
    byteTo addr, v & 0xff

  PostByte = ->
    pb = fetch()
    preg = undefined
    switch pb & 0x60
      when 0
        preg = rX
      when 0x20
        preg = rY
      when 0x40
        preg = rU
      when 0x60
        preg = rS
    xchg = null
    addr = null
    sTemp = undefined
    if pb & 0x80 # Complex stuff
      switch pb & 0x0f
        when 0 # EA = ,reg+
          addr = preg
          xchg = preg + 1
          T += 2
        when 1 # EA = ,reg++
          addr = preg
          xchg = preg + 2
          T += 3
        when 2 # EA = ,-reg
          xchg = preg - 1
          addr = xchg
          T += 2
        when 3 # EA = ,--reg
          xchg = preg - 2
          addr = xchg
          T += 3
        when 4 # EA = ,reg
          addr = preg
        when 5 # EA = ,reg + B
          
          #usAddr = *pReg + (signed short)(signed char)regs->ucRegB;
          addr = preg + signed(rB)
          T += 1
        when 6 # EA = ,reg + A
          addr = preg + signed(rA)
          T += 1
        when 7 # illegal
          addr = 0
        when 8 # EA = ,reg + 8-bit offset
          addr = preg + signed(fetch())
          T += 1
        when 9 # EA = ,reg + 16-bit offset
          addr = preg + signed16(fetch16())
          T += 4
        when 0xA # illegal
          addr = 0
        when 0xB # EA = ,reg + D
          T += 4
          addr = preg + getD()
        when 0xC # EA = PC + 8-bit offset
          sTemp = signed(fetch())
          addr = PC + sTemp
          T += 1
        when 0xD # EA = PC + 16-bit offset
          sTemp = signed16(fetch16())
          addr = PC + sTemp
          T += 5
        when 0xe # Illegal
          addr = 0
        when 0xF # EA = [,address]
          T += 5
          addr = fetch16()
      # switch 
      addr &= 0xffff
      if pb & 0x10 # Indirect addressing
        addr = byteAt(addr) * 256 + byteAt((addr + 1) & 0xffff)
        T += 3
    # Just a 5 bit signed offset + register 
    else
      sByte = pb & 0x1f
      # Two's complement 5-bit value 
      sByte -= 32  if sByte > 15
      addr = preg + sByte
      T += 1
    if xchg isnt null
      switch pb & 0x60
        when 0
          rX = xchg
        when 0x20
          rY = xchg
        when 0x40
          rU = xchg
        when 0x60
          rS = xchg
    addr & 0xffff # Return the effective address

  flagsNZ16 = (word) ->
    CC &= ~(F_ZERO | F_NEGATIVE)
    CC |= F_ZERO  if word is 0
    CC |= F_NEGATIVE  if word & 0x8000

  
  # ============= Operations
  oINC = (b) ->
    b++
    b &= 0xff
    CC &= ~(F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[b]
    CC |= F_OVERFLOW  if b is 0 or b is 0x80
    b

  oDEC = (b) ->
    b--
    b &= 0xff
    CC &= ~(F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[b]
    CC |= F_OVERFLOW  if b is 0x7f or b is 0xff
    b

  oSUB = (b, v) ->
    temp = b - v
    
    #temp &= 0xff;
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[temp & 0xff]
    CC |= F_CARRY  if temp & 0x100
    setV8 b, v, temp
    temp & 0xff

  oSUB16 = (b, v) ->
    temp = b - v
    
    #temp &= 0xff;
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= F_ZERO  if (temp & 0xffff) is 0
    CC |= F_NEGATIVE  if temp & 0x8000
    CC |= F_CARRY  if temp & 0x10000
    setV16 b, v, temp
    temp & 0xffff

  oADD = (b, v) ->
    temp = b + v
    
    #temp &= 0xff;
    CC &= ~(F_HALFCARRY | F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[temp & 0xff]
    CC |= F_CARRY  if temp & 0x100
    setV8 b, v, temp
    CC |= F_HALFCARRY  if (temp ^ b ^ v) & 0x10
    temp & 0xff

  oADD16 = (b, v) ->
    temp = b + v
    
    #temp &= 0xff;
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= F_ZERO  if (temp & 0xffff) is 0
    CC |= F_NEGATIVE  if temp & 0x8000
    CC |= F_CARRY  if temp & 0x10000
    setV16 b, v, temp
    temp & 0xffff

  oADC = (b, v) ->
    temp = b + v + (CC & F_CARRY)
    
    #temp &= 0xff;
    CC &= ~(F_HALFCARRY | F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[temp & 0xff]
    CC |= F_CARRY  if temp & 0x100
    setV8 b, v, temp
    CC |= F_HALFCARRY  if (temp ^ b ^ v) & 0x10
    temp & 0xff

  oSBC = (b, v) ->
    temp = b - v - (CC & F_CARRY)
    
    #temp &= 0xff;
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[temp & 0xff]
    CC |= F_CARRY  if temp & 0x100
    setV8 b, v, temp
    temp & 0xff

  oCMP = (b, v) ->
    temp = b - v
    
    #temp &= 0xff;
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= flagsNZ[temp & 0xff]
    CC |= F_CARRY  if temp & 0x100
    setV8 b, v, temp
    return

  oCMP16 = (b, v) ->
    temp = b - v
    
    #temp &= 0xff;
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= F_ZERO  if (temp & 0xffff) is 0
    CC |= F_NEGATIVE  if temp & 0x8000
    CC |= F_CARRY  if temp & 0x10000
    setV16 b, v, temp
    return

  oNEG = (b) ->
    CC &= ~(F_CARRY | F_ZERO | F_OVERFLOW | F_NEGATIVE)
    CC |= F_OVERFLOW  if b is 0x80
    b = ((~b) & 0xff) + 1
    CC |= F_ZERO  if b is 0
    CC |= F_NEGATIVE | F_CARRY  if b & 0x80
    b

  oLSR = (b) ->
    CC &= ~(F_ZERO | F_CARRY | F_NEGATIVE)
    CC |= F_CARRY  if b & 0x01
    b >>= 1
    CC |= F_ZERO  if b is 0
    b & 0xff

  oASR = (b) ->
    CC &= ~(F_ZERO | F_CARRY | F_NEGATIVE)
    CC |= F_CARRY  if b & 0x01
    b = (b & 0x80) | (b >> 1)
    CC |= flagsNZ[b]
    b

  oASL = (b) ->
    temp = b
    CC &= ~(F_ZERO | F_CARRY | F_NEGATIVE | F_OVERFLOW)
    CC |= F_CARRY  if b & 0x80
    b <<= 1
    CC |= flagsNZ[b]
    CC |= F_OVERFLOW  if (b ^ temp) & 0x80
    b

  oROL = (b) ->
    temp = b
    oldc = CC & F_CARRY
    CC &= ~(F_ZERO | F_CARRY | F_NEGATIVE | F_OVERFLOW)
    CC |= F_CARRY  if b & 0x80
    b = b << 1 | oldc
    CC |= flagsNZ[b]
    CC |= F_OVERFLOW  if (b ^ temp) & 0x80
    b

  oROR = (b) ->
    oldc = CC & F_CARRY
    CC &= ~(F_ZERO | F_CARRY | F_NEGATIVE)
    CC |= F_CARRY  if b & 0x01
    b = b >> 1 | oldc << 7
    CC |= flagsNZ[b]
    
    #    if ((b ^ temp) & 0x80) CC|=F_OVERFLOW;
    b

  oEOR = (b, v) ->
    CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
    b ^= v
    CC |= flagsNZ[b]
    b

  oOR = (b, v) ->
    CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
    b |= v
    CC |= flagsNZ[b]
    b

  oAND = (b, v) ->
    CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
    b &= v
    CC |= flagsNZ[b]
    b

  oCOM = (b) ->
    CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
    b ^= 0xff
    CC |= flagsNZ[b]
    b

  
  #----common
  dpadd = ->
    
    #direct page + 8bit index
    DP * 256 + fetch()

  step = ->
    oldT = T
    IRQs
    
    #;;;
    addr = null
    pb = null
    oldPC = PC
    opcode = fetch()
    T += cycles[opcode]
    switch opcode
      when 0x00 #NEG DP
        addr = dpadd()
        byteTo addr, oNEG(byteAt(addr))
      when 0x03 #COM DP
        addr = dpadd()
        byteTo addr, oCOM(byteAt(addr))
      when 0x04 #LSR DP
        addr = dpadd()
        byteTo addr, oLSR(byteAt(addr))
      when 0x06 #ROR DP
        addr = dpadd()
        byteTo addr, oROR(byteAt(addr))
      when 0x07 #ASR DP
        addr = dpadd()
        byteTo addr, oASR(byteAt(addr))
      when 0x08 #ASL DP
        addr = dpadd()
        byteTo addr, oASL(byteAt(addr))
      when 0x09 #ROL DP
        addr = dpadd()
        byteTo addr, oROL(byteAt(addr))
      when 0x0A #DEC DP
        addr = dpadd()
        byteTo addr, oDEC(byteAt(addr))
      when 0x0C #INC DP
        addr = dpadd()
        byteTo addr, oINC(byteAt(addr))
      when 0x0D #TST DP
        addr = dpadd()
        pb = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[pb]
      when 0x0E #JMP DP
        addr = dpadd()
        PC = addr
      when 0x0F #CLR DP
        addr = dpadd()
        byteTo addr, 0
        CC &= ~(F_CARRY | F_NEGATIVE | F_OVERFLOW)
        CC |= F_ZERO
      #NOP
      when 0x12, 0x13 #SYNC
    , 0x16 #LBRA relative
        addr = signed16(fetch16())
        PC += addr
      when 0x17 #LBSR relative
        addr = signed16(fetch16())
        PUSHW PC
        PC += addr
      when 0x19 #DAA
        cf = 0
        nhi = rA & 0xf0
        nlo = rA & 0x0f
        cf |= 0x06  if nlo > 0x09 or CC & 0x20
        cf |= 0x60  if nhi > 0x80 and nlo > 0x09
        cf |= 0x60  if nhi > 0x90 or CC & 0x01
        addr = cf + rA
        CC &= ~(F_CARRY | F_NEGATIVE | F_ZERO | F_OVERFLOW)
        CC |= F_CARRY  if addr & 0x100
        rA = addr & 0xff
        CC |= flags[rA]
      when 0x1A #ORCC
        CC |= fetch()
      when 0x1C #ANDCC
        CC &= fetch()
      when 0x1D #SEX
        rA = (if (rB & 0x80) then 0xff else 0)
        flagsNZ16 getD()
        CC &= ~F_OVERFLOW
      when 0x1E #EXG
        pb = fetch()
        TFREXG pb, true
      when 0x1F #EXG
        pb = fetch()
        TFREXG pb, false
      when 0x20 #BRA
        addr = signed(fetch())
        PC += addr
      when 0x21 #BRN
        addr = signed(fetch())
      when 0x22 #BHI
        addr = signed(fetch())
        PC += addr  unless CC & (F_CARRY | F_ZERO)
      when 0x23 #BLS
        addr = signed(fetch())
        PC += addr  if CC & (F_CARRY | F_ZERO)
      when 0x24 #BCC
        addr = signed(fetch())
        PC += addr  unless CC & F_CARRY
      when 0x25 #BCS
        addr = signed(fetch())
        PC += addr  if CC & F_CARRY
      when 0x26 #BNE
        addr = signed(fetch())
        PC += addr  unless CC & F_ZERO
      when 0x27 #BEQ
        addr = signed(fetch())
        PC += addr  if CC & F_ZERO
      when 0x28 #BVC
        addr = signed(fetch())
        PC += addr  unless CC & F_OVERFLOW
      when 0x29 #BVS
        addr = signed(fetch())
        PC += addr  if CC & F_OVERFLOW
      when 0x2A #BPL
        addr = signed(fetch())
        PC += addr  unless CC & F_NEGATIVE
      when 0x2B #BMI
        addr = signed(fetch())
        PC += addr  if CC & F_NEGATIVE
      when 0x2C #BGE
        addr = signed(fetch())
        PC += addr  unless (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2)
      when 0x2D #BLT
        addr = signed(fetch())
        PC += addr  if (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2)
      when 0x2E #BGT
        addr = signed(fetch())
        PC += addr  unless (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2) or (CC & F_ZERO)
      when 0x2F #BLE
        addr = signed(fetch())
        PC += addr  if (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2) or (CC & F_ZERO)
      when 0x30 #LEAX
        rX = PostByte()
        if rX is 0
          CC |= F_ZERO
        else
          CC &= ~F_ZERO
      when 0x31 #LEAY
        rY = PostByte()
        if rY is 0
          CC |= F_ZERO
        else
          CC &= ~F_ZERO
      when 0x32 #LEAS
        rS = PostByte()
      when 0x33 #LEAU
        rU = PostByte()
      when 0x34 #PSHS
        PSHS fetch()
      when 0x35 #PULS
        PULS fetch()
      when 0x36 #PSHU
        PSHU fetch()
      when 0x37 #PULU
        PULU fetch()
      when 0x39 #RTS
        PC = PULLW()
      when 0x3A #ABX
        rX += rB
      when 0x3B #RTI
        CC = PULLB()
        if cc & F_ENTIRE
          T += 9
          rA = PULLB()
          rB = PULLB()
          DP = PULLB()
          rX = PULLW()
          rY = PULLW()
          rU = PULLW()
        PC = PULLW()
      when 0x3C #CWAI **todo
        CC &= fetch()
      when 0x3D #MUL
        addr = rA * rB
        if addr is 0
          CC |= F_ZERO
        else
          CC &= ~F_ZERO
        if addr & 0x80
          CC |= F_CARRY
        else
          CC &= ~F_CARRY
        setD addr
      when 0x3F #SWI
        CC |= F_ENTIRE
        PUSHW PC
        PUSHW rU
        PUSHW rY
        PUSHW rX
        PUSHB DP
        PUSHB rB
        PUSHB rA
        PUSHB CC
        CC |= F_IRQMASK | F_FIRQMASK
        PC = ReadWord(vecSWI)
      when 0x40
        rA = oNEG(rA)
      when 0x43
        rA = oCOM(rA)
      when 0x44
        rA = oLSR(rA)
      when 0x46
        rA = oROR(rA)
      when 0x47
        rA = oASR(rA)
      when 0x48
        rA = oASL(rA)
      when 0x49
        rA = oROL(rA)
      when 0x4A
        rA = oDEC(rA)
      when 0x4C
        rA = oINC(rA)
      when 0x4D
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0x4F
        rA = 0
        CC &= ~(F_NEGATIVE | F_OVERFLOW | F_CARRY)
        CC |= F_ZERO
      when 0x50
        rB = oNEG(rB)
      when 0x53
        rB = oCOM(rB)
      when 0x54
        rB = oLSR(rB)
      when 0x56
        rB = oROR(rB)
      when 0x57
        rB = oASR(rB)
      when 0x58
        rB = oASL(rB)
      when 0x59
        rB = oROL(rB)
      when 0x5A
        rB = oDEC(rB)
      when 0x5C
        rB = oINC(rB)
      when 0x5D
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0x5F
        rB = 0
        CC &= ~(F_NEGATIVE | F_OVERFLOW | F_CARRY)
        CC |= F_ZERO
      when 0x60 #NEG indexed
        addr = PostByte()
        byteTo addr, oNEG(byteAt(addr))
      when 0x63 #COM indexed
        addr = PostByte()
        byteTo addr, oCOM(byteAt(addr))
      when 0x64 #LSR indexed
        addr = PostByte()
        byteTo addr, oLSR(byteAt(addr))
      when 0x66 #ROR indexed
        addr = PostByte()
        byteTo addr, oROR(byteAt(addr))
      when 0x67 #ASR indexed
        addr = PostByte()
        byteTo addr, oASR(byteAt(addr))
      when 0x68 #ASL indexed
        addr = PostByte()
        byteTo addr, oASL(byteAt(addr))
      when 0x69 #ROL indexed
        addr = PostByte()
        byteTo addr, oROL(byteAt(addr))
      when 0x6A #DEC indexed
        addr = PostByte()
        byteTo addr, oDEC(byteAt(addr))
      when 0x6C #INC indexed
        addr = PostByte()
        byteTo addr, oINC(byteAt(addr))
      when 0x6D #TST indexed
        addr = PostByte()
        pb = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[pb]
      when 0x6E #JMP indexed
        addr = PostByte()
        PC = addr
      when 0x6F #CLR indexed
        addr = PostByte()
        byteTo addr, 0
        CC &= ~(F_CARRY | F_NEGATIVE | F_OVERFLOW)
        CC |= F_ZERO
      when 0x70 #NEG extended
        addr = fetch16()
        byteTo addr, oNEG(byteAt(addr))
      when 0x73 #COM extended
        addr = fetch16()
        byteTo addr, oCOM(byteAt(addr))
      when 0x74 #LSR extended
        addr = fetch16()
        byteTo addr, oLSR(byteAt(addr))
      when 0x76 #ROR extended
        addr = fetch16()
        byteTo addr, oROR(byteAt(addr))
      when 0x77 #ASR extended
        addr = fetch16()
        byteTo addr, oASR(byteAt(addr))
      when 0x78 #ASL extended
        addr = fetch16()
        byteTo addr, oASL(byteAt(addr))
      when 0x79 #ROL extended
        addr = fetch16()
        byteTo addr, oROL(byteAt(addr))
      when 0x7A #DEC extended
        addr = fetch16()
        byteTo addr, oDEC(byteAt(addr))
      when 0x7C #INC extended
        addr = fetch16()
        byteTo addr, oINC(byteAt(addr))
      when 0x7D #TST extended
        addr = fetch16()
        pb = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[pb]
      when 0x7E #JMP extended
        addr = fetch16()
        PC = addr
      when 0x7F #CLR extended
        addr = fetch16()
        byteTo addr, 0
        CC &= ~(F_CARRY | F_NEGATIVE | F_OVERFLOW)
        CC |= F_ZERO
      
      # regs A,X
      when 0x80 #SUBA imm
        rA = oSUB(rA, fetch())
      when 0x81 #CMPA imm
        oCMP rA, fetch()
      when 0x82 #SBCA imm
        rA = oSBC(rA, fetch())
      when 0x83 #SUBD imm
        setD oSUB16(getD(), fetch16())
      when 0x84 #ANDA imm
        rA = oAND(rA, fetch())
      when 0x85 #BITA imm
        oAND rA, fetch()
      when 0x86 #LDA imm
        rA = fetch()
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0x88 #EORA imm
        rA = oEOR(rA, fetch())
      when 0x89 #ADCA imm
        rA = oADC(rA, fetch())
      when 0x8A #ORA imm
        rA = oOR(rA, fetch())
      when 0x8B #ADDA imm
        rA = oADD(rA, fetch())
      when 0x8C #CMPX imm
        oCMP16 rX, fetch16()
      when 0x8D #JSR imm
        addr = signed(fetch())
        PUSHW PC
        PC += addr
      when 0x8E #LDX imm
        rX = fetch16()
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0x90 #SUBA direct
        addr = dpadd()
        rA = oSUB(rA, byteAt(addr))
      when 0x91 #CMPA direct
        addr = dpadd()
        oCMP rA, byteAt(addr)
      when 0x92 #SBCA direct
        addr = dpadd()
        rA = oSBC(rA, byteAt(addr))
      when 0x93 #SUBD direct
        addr = dpadd()
        setD oSUB16(getD(), ReadWord(addr))
      when 0x94 #ANDA direct
        addr = dpadd()
        rA = oAND(rA, byteAt(addr))
      when 0x95 #BITA direct
        addr = dpadd()
        oAND rA, byteAt(addr)
      when 0x96 #LDA direct
        addr = dpadd()
        rA = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0x97 #STA direct
        addr = dpadd()
        byteTo addr, rA
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0x98 #EORA direct
        addr = dpadd()
        rA = oEOR(rA, byteAt(addr))
      when 0x99 #ADCA direct
        addr = dpadd()
        rA = oADC(rA, byteAt(addr))
      when 0x9A #ORA direct
        addr = dpadd()
        rA = oOR(rA, byteAt(addr))
      when 0x9B #ADDA direct
        addr = dpadd()
        rA = oADD(rA, byteAt(addr))
      when 0x9C #CMPX direct
        addr = dpadd()
        oCMP16 rX, ReadWord(addr)
      when 0x9D #JSR direct
        addr = dpadd()
        PUSHW PC
        PC = addr
      when 0x9E #LDX direct
        addr = dpadd()
        rX = ReadWord(addr)
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0x9F #STX direct
        addr = dpadd()
        WriteWord addr, rX
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0xA0 #SUBA indexed
        addr = PostByte()
        rA = oSUB(rA, byteAt(addr))
      when 0xA1 #CMPA indexed
        addr = PostByte()
        oCMP rA, byteAt(addr)
      when 0xA2 #SBCA indexed
        addr = PostByte()
        rA = oSBC(rA, byteAt(addr))
      when 0xA3 #SUBD indexed
        addr = PostByte()
        setD oSUB16(getD(), ReadWord(addr))
      when 0xA4 #ANDA indexed
        addr = PostByte()
        rA = oAND(rA, byteAt(addr))
      when 0xA5 #BITA indexed
        addr = PostByte()
        oAND rA, byteAt(addr)
      when 0xA6 #LDA indexed
        addr = PostByte()
        rA = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0xA7 #STA indexed
        addr = PostByte()
        byteTo addr, rA
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0xA8 #EORA indexed
        addr = PostByte()
        rA = oEOR(rA, byteAt(addr))
      when 0xA9 #ADCA indexed
        addr = PostByte()
        rA = oADC(rA, byteAt(addr))
      when 0xAA #ORA indexed
        addr = PostByte()
        rA = oOR(rA, byteAt(addr))
      when 0xAB #ADDA indexed
        addr = PostByte()
        rA = oADD(rA, byteAt(addr))
      when 0xAC #CMPX indexed
        addr = PostByte()
        oCMP16 rX, ReadWord(addr)
      when 0xAD #JSR indexed
        addr = PostByte()
        PUSHW PC
        PC = addr
      when 0xAE #LDX indexed
        addr = PostByte()
        rX = ReadWord(addr)
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0xAF #STX indexed
        addr = PostByte()
        WriteWord addr, rX
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0xB0 #SUBA extended
        addr = fetch16()
        rA = oSUB(rA, byteAt(addr))
      when 0xB1 #CMPA extended
        addr = fetch16()
        oCMP rA, byteAt(addr)
      when 0xB2 #SBCA extended
        addr = fetch16()
        rA = oSBC(rA, byteAt(addr))
      when 0xB3 #SUBD extended
        addr = fetch16()
        setD oSUB16(getD(), ReadWord(addr))
      when 0xB4 #ANDA extended
        addr = fetch16()
        rA = oAND(rA, byteAt(addr))
      when 0xB5 #BITA extended
        addr = fetch16()
        oAND rA, byteAt(addr)
      when 0xB6 #LDA extended
        addr = fetch16()
        rA = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0xB7 #STA extended
        addr = fetch16()
        byteTo addr, rA
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rA]
      when 0xB8 #EORA extended
        addr = fetch16()
        rA = oEOR(rA, byteAt(addr))
      when 0xB9 #ADCA extended
        addr = fetch16()
        rA = oADC(rA, byteAt(addr))
      when 0xBA #ORA extended
        addr = fetch16()
        rA = oOR(rA, byteAt(addr))
      when 0xBB #ADDA extended
        addr = fetch16()
        rA = oADD(rA, byteAt(addr))
      when 0xBC #CMPX extended
        addr = fetch16()
        oCMP16 rX, ReadWord(addr)
      when 0xBD #JSR extended
        addr = fetch16()
        PUSHW PC
        PC = addr
      when 0xBE #LDX extended
        addr = fetch16()
        rX = ReadWord(addr)
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0xBF #STX extended
        addr = fetch16()
        WriteWord addr, rX
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      
      #Regs B, Y
      when 0xC0 #SUBB imm
        rB = oSUB(rB, fetch())
      when 0xC1 #CMPB imm
        oCMP rB, fetch()
      when 0xC2 #SBCB imm
        rB = oSBC(rB, fetch())
      when 0xC3 #ADDD imm
        setD oADD16(getD(), fetch16())
      when 0xC4 #ANDB imm
        rB = oAND(rB, fetch())
      when 0xC5 #BITB imm
        oAND rB, fetch()
      when 0xC6 #LDB imm
        rB = fetch()
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xC8 #EORB imm
        rB = oEOR(rB, fetch())
      when 0xC9 #ADCB imm
        rB = oADC(rB, fetch())
      when 0xCA #ORB imm
        rB = oOR(rB, fetch())
      when 0xCB #ADDB imm
        rB = oADD(rB, fetch())
      when 0xCC #LDD imm
        addr = fetch16()
        setD addr
        flagsNZ16 addr
        CC &= ~F_OVERFLOW
      when 0xCE #LDU imm
        rU = fetch16()
        flagsNZ16 rU
        CC &= ~F_OVERFLOW
      when 0xD0 #SUBB direct
        addr = dpadd()
        rB = oSUB(rB, byteAt(addr))
      when 0xD1 #CMPB direct
        addr = dpadd()
        oCMP rB, byteAt(addr)
      when 0xD2 #SBCB direct
        addr = dpadd()
        rB = oSBC(rB, byteAt(addr))
      when 0xD3 #ADDD direct
        addr = dpadd()
        setD oADD16(getD(), ReadWord(addr))
      when 0xD4 #ANDB direct
        addr = dpadd()
        rB = oAND(rB, byteAt(addr))
      when 0xD5 #BITB direct
        addr = dpadd()
        oAND rB, byteAt(addr)
      when 0xD6 #LDB direct
        addr = dpadd()
        rB = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xD7 #STB direct
        addr = dpadd()
        byteTo addr, rB
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xD8 #EORB direct
        addr = dpadd()
        rB = oEOR(rB, byteAt(addr))
      when 0xD9 #ADCB direct
        addr = dpadd()
        rB = oADC(rB, byteAt(addr))
      when 0xDA #ORB direct
        addr = dpadd()
        rB = oOR(rB, byteAt(addr))
      when 0xDB #ADDB direct
        addr = dpadd()
        rB = oADD(rB, byteAt(addr))
      when 0xDC #LDD direct
        addr = dpadd()
        pb = ReadWord(addr)
        setD pb
        flagsNZ16 pb
        CC &= ~F_OVERFLOW
      when 0xDD #STD direct
        addr = dpadd()
        WriteWord addr, getD()
        CC &= ~F_OVERFLOW
      when 0xDE #LDU direct
        addr = dpadd()
        rU = ReadWord(addr)
        flagsNZ16 rX
        CC &= ~F_OVERFLOW
      when 0xDF #STU direct
        addr = dpadd()
        WriteWord addr, rU
        flagsNZ16 rU
        CC &= ~F_OVERFLOW
      when 0xE0 #SUBB indexed
        addr = PostByte()
        rB = oSUB(rB, byteAt(addr))
      when 0xE1 #CMPB indexed
        addr = PostByte()
        oCMP rB, byteAt(addr)
      when 0xE2 #SBCB indexed
        addr = PostByte()
        rB = oSBC(rB, byteAt(addr))
      when 0xE3 #ADDD indexed
        addr = PostByte()
        setD oADD16(getD(), ReadWord(addr))
      when 0xE4 #ANDB indexed
        addr = PostByte()
        rB = oAND(rB, byteAt(addr))
      when 0xE5 #BITB indexed
        addr = PostByte()
        oAND rB, byteAt(addr)
      when 0xE6 #LDB indexed
        addr = PostByte()
        rB = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xE7 #STB indexed
        addr = PostByte()
        byteTo addr, rB
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xE8 #EORB indexed
        addr = PostByte()
        rB = oEOR(rB, byteAt(addr))
      when 0xE9 #ADCB indexed
        addr = PostByte()
        rB = oADC(rB, byteAt(addr))
      when 0xEA #ORB indexed
        addr = PostByte()
        rB = oOR(rB, byteAt(addr))
      when 0xEB #ADDB indexed
        addr = PostByte()
        rB = oADD(rB, byteAt(addr))
      when 0xEC #LDD indexed
        addr = PostByte()
        pb = ReadWord(addr)
        setD pb
        flagsNZ16 pb
        CC &= ~F_OVERFLOW
      when 0xED #STD indexed
        addr = PostByte()
        WriteWord addr, getD()
        CC &= ~F_OVERFLOW
      when 0xEE #LDU indexed
        addr = PostByte()
        rU = ReadWord(addr)
        flagsNZ16 rU
        CC &= ~F_OVERFLOW
      when 0xEF #STU indexed
        addr = PostByte()
        WriteWord addr, rU
        flagsNZ16 rU
        CC &= ~F_OVERFLOW
      when 0xF0 #SUBB extended
        addr = fetch16()
        rB = oSUB(rB, byteAt(addr))
      when 0xF1 #CMPB extended
        addr = fetch16()
        oCMP rB, byteAt(addr)
      when 0xF2 #SBCB extended
        addr = fetch16()
        rB = oSBC(rB, byteAt(addr))
      when 0xF3 #ADDD extended
        addr = fetch16()
        setD oADD16(getD(), ReadWord(addr))
      when 0xF4 #ANDB extended
        addr = fetch16()
        rB = oAND(rB, byteAt(addr))
      when 0xF5 #BITB extended
        addr = fetch16()
        oAND rB, byteAt(addr)
      when 0xF6 #LDB extended
        addr = fetch16()
        rB = byteAt(addr)
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xF7 #STB extended
        addr = fetch16()
        byteTo addr, rB
        CC &= ~(F_ZERO | F_NEGATIVE | F_OVERFLOW)
        CC |= flagsNZ[rB]
      when 0xF8 #EORB extended
        addr = fetch16()
        rB = oEOR(rB, byteAt(addr))
      when 0xF9 #ADCB extended
        addr = fetch16()
        rB = oADC(rB, byteAt(addr))
      when 0xFA #ORB extended
        addr = fetch16()
        rB = oOR(rB, byteAt(addr))
      when 0xFB #ADDB extended
        addr = fetch16()
        rB = oADD(rB, byteAt(addr))
      when 0xFC #LDD extended
        addr = fetch16()
        pb = ReadWord(addr)
        setD pb
        flagsNZ16 pb
        CC &= ~F_OVERFLOW
      when 0xFD #STD extended
        addr = fetch16()
        WriteWord addr, getD()
        CC &= ~F_OVERFLOW
      when 0xFE #LDU extended
        addr = fetch16()
        rU = ReadWord(addr)
        flagsNZ16 rU
        CC &= ~F_OVERFLOW
      when 0xFF #STU extended
        addr = fetch16()
        WriteWord addr, rU
        flagsNZ16 rU
        CC &= ~F_OVERFLOW
      
      # page 1
      when 0x10 #page 1
        opcode = fetch()
        T += cycles2[opcode]
        switch opcode
          when 0x21 #BRN
            addr = signed16(fetch16())
          when 0x22 #BHI
            addr = signed16(fetch16())
            PC += addr  unless CC & (F_CARRY | F_ZERO)
          when 0x23 #BLS
            addr = signed16(fetch16())
            PC += addr  if CC & (F_CARRY | F_ZERO)
          when 0x24 #BCC
            addr = signed16(fetch16())
            PC += addr  unless CC & F_CARRY
          when 0x25 #BCS
            addr = signed16(fetch16())
            PC += addr  if CC & F_CARRY
          when 0x26 #BNE
            addr = signed16(fetch16())
            PC += addr  unless CC & F_ZERO
          when 0x27 #BEQ
            addr = signed16(fetch16())
            PC += addr  if CC & F_ZERO
          when 0x28 #BVC
            addr = signed16(fetch16())
            PC += addr  unless CC & F_OVERFLOW
          when 0x29 #BVS
            addr = signed16(fetch16())
            PC += addr  if CC & F_OVERFLOW
          when 0x2A #BPL
            addr = signed16(fetch16())
            PC += addr  unless CC & F_NEGATIVE
          when 0x2B #BMI
            addr = signed16(fetch16())
            PC += addr  if CC & F_NEGATIVE
          when 0x2C #BGE
            addr = signed16(fetch16())
            PC += addr  unless (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2)
          when 0x2D #BLT
            addr = signed16(fetch16())
            PC += addr  if (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2)
          when 0x2E #BGT
            addr = signed16(fetch16())
            PC += addr  unless (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2) or (CC & F_ZERO)
          when 0x2F #BLE
            addr = signed16(fetch16())
            PC += addr  if (CC & F_NEGATIVE) ^ ((CC & F_OVERFLOW) << 2) or (CC & F_ZERO)
          when 0x3f #SWI2
            CC |= F_ENTIRE
            PUSHW PC
            PUSHW rU
            PUSHW rY
            PUSHW rX
            PUSHB DP
            PUSHB rB
            PUSHB rA
            PUSHB CC
            CC |= F_IRQMASK | F_FIRQMASK
            PC = ReadWord(vecSWI2)
          when 0x83 #CMPD imm
            oCMP16 getD(), fetch16()
          when 0x8C #CMPY imm
            oCMP16 rY, fetch16()
          when 0x8E #LDY imm
            rY = fetch16()
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0x93 #CMPD direct
            addr = dpadd()
            oCMP16 getD(), ReadWord(addr)
          when 0x9C #CMPY direct
            addr = dpadd()
            oCMP16 rY, ReadWord(addr)
          when 0x9E #LDY direct
            addr = dpadd()
            rY = ReadWord(addr)
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0x9F #STY direct
            addr = dpadd()
            WriteWord addr, rY
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0xA3 #CMPD indexed
            addr = PostByte()
            oCMP16 getD(), ReadWord(addr)
          when 0xAC #CMPY indexed
            addr = PostByte()
            oCMP16 rY, ReadWord(addr)
          when 0xAE #LDY indexed
            addr = PostByte()
            rY = ReadWord(addr)
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0xAF #STY indexed
            addr = PostByte()
            WriteWord addr, rY
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0xB3 #CMPD extended
            addr = fetch16()
            oCMP16 getD(), ReadWord(addr)
          when 0xBC #CMPY extended
            addr = fetch16()
            oCMP16 rY, ReadWord(addr)
          when 0xBE #LDY extended
            addr = fetch16()
            rY = ReadWord(addr)
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0xBF #STY extended
            addr = fetch16()
            WriteWord addr, rY
            flagsNZ16 rY
            CC &= ~F_OVERFLOW
          when 0xCE #LDS imm
            rS = fetch16()
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
          when 0xDE #LDS direct
            addr = dpadd()
            rS = ReadWord(addr)
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
          when 0xDF #STS direct
            addr = dpadd()
            WriteWord addr, rS
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
          when 0xEE #LDS indexed
            addr = PostByte()
            rS = ReadWord(addr)
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
          when 0xEF #STS indexed
            addr = PostByte()
            WriteWord addr, rS
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
          when 0xFE #LDS extended
            addr = fetch16()
            rS = ReadWord(addr)
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
          when 0xFF #STS extended
            addr = fetch16()
            WriteWord addr, rS
            flagsNZ16 rS
            CC &= ~F_OVERFLOW
      
      # page 2
      when 0x11 #page 2
        opcode = fetch()
        T += cycles2[opcode]
        switch opcode
          when 0x3f #SWI3
            CC |= F_ENTIRE
            PUSHW PC
            PUSHW rU
            PUSHW rY
            PUSHW rX
            PUSHB DP
            PUSHB rB
            PUSHB rA
            PUSHB CC
            CC |= F_IRQMASK | F_FIRQMASK
            PC = ReadWord(vecSWI3)
          when 0x83 #CMPU imm
            oCMP16 rU, fetch16()
          when 0x8C #CMPS imm
            oCMP16 rS, fetch16()
          when 0x93 #CMPU imm
            addr = dpadd()
            oCMP16 rU, ReadWord(addr)
          when 0x9C #CMPS imm
            addr = dpadd()
            oCMP16 rS, ReadWord(addr)
          when 0xA3 #CMPU imm
            addr = PostByte()
            oCMP16 rU, ReadWord(addr)
          when 0xAC #CMPS imm
            addr = PostByte()
            oCMP16 rS, ReadWord(addr)
          when 0xB3 #CMPU imm
            addr = fetch16()
            oCMP16 rU, ReadWord(addr)
          when 0xBC #CMPS imm
            addr = fetch16()
            oCMP16 rS, ReadWord(addr)
    rA &= 0xff
    rB &= 0xff
    CC &= 0xff
    DP &= 0xff
    rX &= 0xffff
    rY &= 0xffff
    rU &= 0xffff
    rS &= 0xffff
    PC &= 0xffff
    T - oldT

  reset = ->
    PC = ReadWord(vecRESET)
    DP = 0
    CC |= F_FIRQMASK | F_IRQMASK
    T = 0

  
  #---------- Disassembler
  
  #
  #ILLEGAL 0
  #DIRECT 1
  #INHERENT 2
  #BRANCH_REL_16 3
  #IMMEDIAT_8 4
  #BRANCH_REL_8 5
  #INDEXED 6
  #EXTENDED 7
  #IMMEDIAT_16 8
  #
  #PSHS 10
  #PSHU 11
  #
  #EXG, TFR 20
  #
  ds = [ [ 2, 1, "NEG" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 2, 1, "COM" ], [ 2, 1, "LSR" ], [ 1, 0, "???" ], [ 2, 1, "ROR" ], [ 2, 1, "ASR" ], [ 2, 1, "LSL" ], [ 2, 1, "ROL" ], [ 2, 1, "DEC" ], [ 1, 0, "???" ], [ 2, 1, "INC" ], [ 2, 1, "TST" ], [ 2, 1, "JMP" ], [ 2, 1, "CLR" ], [ 1, 0, "Prefix" ], [ 1, 0, "Prefix" ], [ 1, 2, "NOP" ], [ 1, 2, "SYNC" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 3, 3, "LBRA" ], [ 3, 3, "LBSR" ], [ 1, 0, "???" ], [ 1, 2, "DAA" ], [ 2, 4, "ORCC" ], [ 1, 0, "???" ], [ 2, 4, "ANDCC" ], [ 1, 2, "SEX" ], [ 2, 20, "EXG" ], [ 2, 20, "TFR" ], [ 2, 5, "BRA" ], [ 2, 5, "BRN" ], [ 2, 5, "BHI" ], [ 2, 5, "BLS" ], [ 2, 5, "BCC" ], [ 2, 5, "BCS" ], [ 2, 5, "BNE" ], [ 2, 5, "BEQ" ], [ 2, 5, "BVC" ], [ 2, 5, "BVS" ], [ 2, 5, "BPL" ], [ 2, 5, "BMI" ], [ 2, 5, "BGE" ], [ 2, 5, "BLT" ], [ 2, 5, "BGT" ], [ 2, 5, "BLE" ], [ 2, 6, "LEAX" ], [ 2, 6, "LEAY" ], [ 2, 6, "LEAS" ], [ 2, 6, "LEAU" ], [ 2, 10, "PSHS" ], [ 2, 10, "PULS" ], [ 2, 11, "PSHU" ], [ 2, 11, "PULU" ], [ 1, 0, "???" ], [ 1, 2, "RTS" ], [ 1, 2, "ABX" ], [ 1, 2, "RTI" ], [ 2, 2, "CWAI" ], [ 1, 2, "MUL" ], [ 1, 2, "RESET" ], [ 1, 2, "SWI1" ], [ 1, 2, "NEGA" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 1, 2, "COMA" ], [ 1, 2, "LSRA" ], [ 1, 0, "???" ], [ 1, 2, "RORA" ], [ 1, 2, "ASRA" ], [ 1, 2, "ASLA" ], [ 1, 2, "ROLA" ], [ 1, 2, "DECA" ], [ 1, 0, "???" ], [ 1, 2, "INCA" ], [ 1, 2, "TSTA" ], [ 1, 0, "???" ], [ 1, 2, "CLRA" ], [ 1, 2, "NEGB" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 1, 2, "COMB" ], [ 1, 2, "LSRB" ], [ 1, 0, "???" ], [ 1, 2, "RORB" ], [ 1, 2, "ASRB" ], [ 1, 2, "ASLB" ], [ 1, 2, "ROLB" ], [ 1, 2, "DECB" ], [ 1, 0, "???" ], [ 1, 2, "INCB" ], [ 1, 2, "TSTB" ], [ 1, 0, "???" ], [ 1, 2, "CLRB" ], [ 2, 6, "NEG" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 2, 6, "COM" ], [ 2, 6, "LSR" ], [ 1, 0, "???" ], [ 2, 6, "ROR" ], [ 2, 6, "ASR" ], [ 2, 6, "LSL" ], [ 2, 6, "ROL" ], [ 2, 6, "DEC" ], [ 1, 0, "???" ], [ 2, 6, "INC" ], [ 2, 6, "TST" ], [ 2, 6, "JMP" ], [ 2, 6, "CLR" ], [ 3, 7, "NEG" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 3, 7, "COM" ], [ 3, 7, "LSR" ], [ 1, 0, "???" ], [ 3, 7, "ROR" ], [ 3, 7, "ASR" ], [ 3, 7, "LSL" ], [ 3, 7, "ROL" ], [ 3, 7, "DEC" ], [ 1, 0, "???" ], [ 3, 7, "INC" ], [ 3, 7, "TST" ], [ 3, 7, "JMP" ], [ 3, 7, "CLR" ], [ 2, 4, "SUBA" ], [ 2, 4, "CMPA" ], [ 2, 4, "SBCA" ], [ 3, 8, "SUBD" ], [ 2, 4, "ANDA" ], [ 2, 4, "BITA" ], [ 2, 4, "LDA" ], [ 1, 0, "???" ], [ 2, 4, "EORA" ], [ 2, 4, "ADCA" ], [ 2, 4, "ORA" ], [ 2, 4, "ADDA" ], [ 3, 8, "CMPX" ], [ 2, 5, "BSR" ], [ 3, 8, "LDX" ], [ 1, 0, "???" ], [ 2, 1, "SUBA" ], [ 2, 1, "CMPA" ], [ 2, 1, "SBCA" ], [ 2, 1, "SUBd" ], [ 2, 1, "ANDA" ], [ 2, 1, "BITA" ], [ 2, 1, "LDA" ], [ 2, 1, "STA" ], [ 2, 1, "EORA" ], [ 2, 1, "ADCA" ], [ 2, 1, "ORA" ], [ 2, 1, "ADDA" ], [ 2, 1, "CMPX" ], [ 2, 1, "JSR" ], [ 2, 1, "LDX" ], [ 2, 1, "STX" ], [ 2, 6, "SUBA" ], [ 2, 6, "CMPA" ], [ 2, 6, "SBCA" ], [ 2, 6, "SUBD" ], [ 2, 6, "ANDA" ], [ 2, 6, "BITA" ], [ 2, 6, "LDA" ], [ 2, 6, "STA" ], [ 2, 6, "EORA" ], [ 2, 6, "ADCA" ], [ 2, 6, "ORA" ], [ 2, 6, "ADDA" ], [ 2, 6, "CMPX" ], [ 2, 6, "JSR" ], [ 2, 6, "LDX" ], [ 2, 6, "STX" ], [ 3, 7, "SUBA" ], [ 3, 7, "CMPA" ], [ 3, 7, "SBCA" ], [ 3, 7, "SUBD" ], [ 3, 7, "ANDA" ], [ 3, 7, "BITA" ], [ 3, 7, "LDA" ], [ 3, 7, "STA" ], [ 3, 7, "EORA" ], [ 3, 7, "ADCA" ], [ 3, 7, "ORA" ], [ 3, 7, "ADDA" ], [ 3, 7, "CMPX" ], [ 3, 7, "JSR" ], [ 3, 7, "LDX" ], [ 3, 7, "STX" ], [ 2, 4, "SUBB" ], [ 2, 4, "CMPB" ], [ 2, 4, "SBCB" ], [ 3, 8, "ADDD" ], [ 2, 4, "ANDB" ], [ 2, 4, "BITB" ], [ 2, 4, "LDB" ], [ 1, 0, "???" ], [ 2, 4, "EORB" ], [ 2, 4, "ADCB" ], [ 2, 4, "ORB" ], [ 2, 4, "ADDB" ], [ 3, 8, "LDD" ], [ 1, 0, "???" ], [ 3, 8, "LDU" ], [ 1, 0, "???" ], [ 2, 1, "SUBB" ], [ 2, 1, "CMPB" ], [ 2, 1, "SBCB" ], [ 2, 1, "ADDD" ], [ 2, 1, "ANDB" ], [ 2, 1, "BITB" ], [ 2, 1, "LDB" ], [ 2, 1, "STB" ], [ 2, 1, "EORB" ], [ 2, 1, "ADCB" ], [ 2, 1, "ORB " ], [ 2, 1, "ADDB" ], [ 2, 1, "LDD " ], [ 2, 1, "STD " ], [ 2, 1, "LDU " ], [ 2, 1, "STU " ], [ 2, 6, "SUBB" ], [ 2, 6, "CMPB" ], [ 2, 6, "SBCB" ], [ 2, 6, "ADDD" ], [ 2, 6, "ANDB" ], [ 2, 6, "BITB" ], [ 2, 6, "LDB" ], [ 2, 6, "STB" ], [ 2, 6, "EORB" ], [ 2, 6, "ADCB" ], [ 2, 6, "ORB" ], [ 2, 6, "ADDB" ], [ 2, 6, "LDD" ], [ 2, 6, "STD" ], [ 2, 6, "LDU" ], [ 2, 6, "STU" ], [ 3, 7, "SUBB" ], [ 3, 7, "CMPB" ], [ 3, 7, "SBCB" ], [ 3, 7, "ADDD" ], [ 3, 7, "ANDB" ], [ 3, 7, "BITB" ], [ 3, 7, "LDB" ], [ 3, 7, "STB" ], [ 3, 7, "EORB" ], [ 3, 7, "ADCB" ], [ 3, 7, "ORB" ], [ 3, 7, "ADDB" ], [ 3, 7, "LDD" ], [ 3, 7, "STD" ], [ 3, 7, "LDU" ], [ 3, 7, "STU" ] ]
  ds11 =
    63: [ 2, 2, "SWI3" ]
    131: [ 4, 8, "CMPU" ]
    140: [ 4, 8, "CMPS" ]
    147: [ 3, 1, "CMPU" ]
    156: [ 3, 1, "CMPS" ]
    163: [ 3, 6, "CMPU" ]
    172: [ 3, 6, "CMPS" ]
    179: [ 4, 7, "CMPU" ]
    188: [ 4, 7, "CMPS" ]

  ds10 =
    33: [ 5, 3, "LBRN" ]
    34: [ 5, 3, "LBHI" ]
    35: [ 5, 3, "LBLS" ]
    36: [ 5, 3, "LBCC" ]
    37: [ 5, 3, "LBCS" ]
    38: [ 5, 3, "LBNE" ]
    39: [ 5, 3, "LBEQ" ]
    40: [ 5, 3, "LBVC" ]
    41: [ 5, 3, "LBVS" ]
    42: [ 5, 3, "LBPL" ]
    43: [ 5, 3, "LBMI" ]
    44: [ 5, 3, "LBGE" ]
    45: [ 5, 3, "LBLT" ]
    46: [ 5, 3, "LBGT" ]
    47: [ 5, 3, "LBLE" ]
    63: [ 2, 2, "SWI2" ]
    131: [ 4, 8, "CMPD" ]
    140: [ 4, 8, "CMPY" ]
    142: [ 4, 8, "LDY" ]
    147: [ 3, 1, "CMPD" ]
    156: [ 3, 1, "CMPY" ]
    158: [ 3, 1, "LDY" ]
    159: [ 3, 1, "STY" ]
    163: [ 3, 6, "CMPD" ]
    172: [ 3, 6, "CMPY" ]
    174: [ 3, 6, "LDY" ]
    175: [ 3, 6, "STY" ]
    179: [ 4, 7, "CMPD" ]
    188: [ 4, 7, "CMPY" ]
    190: [ 4, 7, "LDY" ]
    191: [ 4, 7, "STY" ]
    206: [ 4, 8, "LDS" ]
    222: [ 3, 1, "LDS" ]
    223: [ 3, 1, "STS" ]
    238: [ 3, 6, "LDS" ]
    239: [ 3, 6, "STS" ]
    254: [ 4, 7, "LDS" ]
    255: [ 4, 7, "STS" ]

  
  #
  #ILLEGAL 0
  #DIRECT 1
  #INHERENT 2
  #BRANCH_REL_16 3
  #IMMEDIAT_8 4
  #BRANCH_REL_8 5
  #INDEXED 6
  #EXTENDED 7
  #IMMEDIAT_16 8
  #
  disasm = (i, a, b, c, d, pc) ->
    toHexN = (n, d) ->
      s = n.toString(16)
      s = "0" + s  while s.length < d
      s.toUpperCase()

    toHex2 = (n) ->
      toHexN n & 0xff, 2

    toHex4 = (n) ->
      toHexN n, 4

    rx = undefined
    ro = undefined
    j = undefined
    sx = ds[i]
    if i is 0x10
      sx = ds10[a]
      return [ "???", 2 ]  if sx is `undefined`
      i = a
      a = b
      b = c
      c = d
    if i is 0x11
      sx = ds11[a]
      return [ "???", 2 ]  if sx is `undefined`
      i = a
      a = b
      b = c
      c = d
    bytes = sx[0]
    mode = sx[1]
    mnemo = sx[2]
    switch mode
      #invalid
      when 0, 1 #direct page
        mnemo += " $" + toHex2(a)
      # inherent
      when 2, 3 #brel16
        mnemo += " #$" + toHex4((if (a * 256 + b) < 32768 then (a * 256 + b + pc) else (a * 256 + b + pc - 65536)))
      when 4 #imm8
        mnemo += " #$" + toHex2(a)
      when 5 #brel8
        mnemo += " #$" + toHex4((if (a) < 128 then (a + pc + 2) else (a + pc - 254)))
      when 6 #indexed, postbyte etc.
        mnemo += " "
        pb = a
        ixr = [ "X", "Y", "U", "S" ][(pb & 0x60) >> 5]
        unless pb & 0x80
          
          #direct5
          disp = pb & 0x1f
          disp = disp - 32  if disp > 15
          mnemo += disp + "," + ixr
          break
        ind = pb & 0x10
        mod = pb & 0x0f
        ofs8 = (if (b > 127) then (b - 256) else b)
        ofs16 = (if ((b * 256 + c) > 32767) then ((b * 256 + c) - 65536) else (b * 256 + c))
        unless ind
          switch mod
            when 0
              mnemo += "," + ixr + "+"
            when 1
              mnemo += "," + ixr + "++"
            when 2
              mnemo += ",-" + ixr
            when 3
              mnemo += ",--" + ixr
            when 4
              mnemo += "," + ixr
            when 5
              mnemo += "B," + ixr
            when 6
              mnemo += "A," + ixr
            when 7
              mnemo += "???"
            when 8
              mnemo += ofs8 + "," + ixr
              bytes++
            when 9
              mnemo += ofs16 + "," + ixr
              bytes += 2
            when 10
              mnemo += "???"
            when 11
              mnemo += "D," + ixr
            when 12
              mnemo += ofs8 + ",PC"
              bytes++
            when 13
              mnemo += ofs16 + ",PC"
              bytes += 2
            when 14
              mnemo += "???"
            when 15
              mnemo += "$" + toHex4((b * 256 + c))
              bytes += 2
        else
          switch mod
            when 0
              mnemo += "???"
            when 1
              mnemo += "[," + ixr + "++]"
            when 2
              mnemo += "???"
            when 3
              mnemo += "[,--" + ixr + "]"
            when 4
              mnemo += "[," + ixr + "]"
            when 5
              mnemo += "[B," + ixr + "]"
            when 6
              mnemo += "[A," + ixr + "]"
            when 7
              mnemo += "???"
            when 8
              mnemo += "[" + ofs8 + "," + ixr + "]"
              bytes++
            when 9
              mnemo += "[" + ofs16 + "," + ixr + "]"
              bytes += 2
            when 10
              mnemo += "???"
            when 11
              mnemo += "[D," + ixr + "]"
            when 12
              mnemo += "[" + ofs8 + ",PC]"
              bytes++
            when 13
              mnemo += "[" + ofs16 + ",PC]"
              bytes += 2
            when 14
              mnemo += "???"
            when 15
              mnemo += "[$" + toHex4((b * 256 + c)) + "]"
              bytes += 2
      when 7 #extended
        mnemo += " $" + toHex4(a * 256 + b)
      when 8 #imm16
        mnemo += " #$" + toHex4(a * 256 + b)
      when 10 #pshs, puls
        rx = [ "PC", "U", "Y", "X", "DP", "B", "A", "CC" ]
        ro = []
        j = 0
        while j < 8
          ro.push rx[7 - j]  if (a & 1) isnt 0
          a >>= 1
          j++
        mnemo += " " + ro.join(",")
      when 11 #pshs, puls
        rx = [ "PC", "S", "Y", "X", "DP", "B", "A", "CC" ]
        ro = []
        j = 0
        while j < 8
          ro.push rx[7 - j]  if (a & 1) isnt 0
          a >>= 1
          j++
        mnemo += " " + ro.join(",")
      when 20 #TFR etc
        rx = [ "D", "X", "Y", "U", "S", "PC", "?", "?", "A", "B", "CC", "DP", "?", "?", "?", "?" ]
        mnemo += " " + rx[a >> 4] + "," + rx[a & 0x0f]
    [ mnemo, bytes ]

  
  #---------- Exports
  steps: (Ts) ->
    
    #T=0;
    Ts -= step()  while Ts > 0

  T: ->
    T

  reset: reset
  init: (bt, ba, tck) ->
    byteTo = bt
    byteAt = ba
    ticks = tck
    reset()

  status: ->
    pc: PC
    sp: rS
    u: rU
    a: rA
    b: rB
    x: rX
    y: rY
    dp: DP
    flags: CC

  interrupt: ->

  
  #
  #        if (flags & fINT) {
  #            return;
  #        }
  #        //flags |= fBKC;
  #        stPushWord(pc);
  #        stPush(flags);
  #        flags |= fINT;
  #        pc=wordAt(IrqTo);
  #        T+=7;
  #        //console.log(pc);
  #        
  nmi: ->

  
  #
  #        return;
  #        stPushWord(pc);
  #        stPush(flags);
  #        flags |= fINT;
  #        pc=wordAt(NMITo);
  #        T+=7;
  #        //console.log(pc);
  #        
  set: (reg, value) ->
    switch reg.toUpperCase()
      when "PC"
        PC = value
        return
      when "A"
        rA = value
        return
      when "B"
        rB = value
        return
      when "X"
        rX = value
        return
      when "Y"
        rY = value
        return
      when "SP"
        rS = value
        return
      when "U"
        rU = value
        return
      when "FLAGS"
        CC = value
        return

  flagsToString: ->
    f = ""
    fx = "EFHINZVC"
    i = 0

    while i < 8
      n = CC & (0x80 >> i)
      if n is 0
        f += fx[i].toLowerCase()
      else
        f += fx[i]
      i++
    f

  disasm: disasm
