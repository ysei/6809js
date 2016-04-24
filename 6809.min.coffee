#
#Published under the MIT License (MIT)
#
#Copyright (c) 2014 Martin Maly, http://retrocip.cz, http://www.uelectronics.info,
#twitter: @uelectronics
#
((a, b) ->
  unless typeof module is "undefined"
    module.exports = b()
  else
    if typeof define is "function" and typeof define.amd is "object"
      define b
    else
      this[a] = b()
) "CPU6809", ->
  r = undefined
  o = undefined
  e = undefined
  c = undefined
  g = undefined
  i = undefined
  an = undefined
  aq = undefined
  aa = undefined
  b = 1
  Y = 2
  ab = 4
  h = 8
  ao = 16
  d = 32
  az = 64
  aH = 128
  aj = 65534
  ai = 65532
  ay = 65530
  aD = 65528
  av = 65526
  G = 65524
  F = 65522
  ac = 0
  ae = undefined
  n = undefined
  u = undefined
  aw = [ 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 0, 6, 6, 3, 6, 0, 0, 2, 4, 0, 0, 5, 9, 0, 2, 3, 0, 3, 2, 8, 6, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0, 5, 3, 6, 9, 11, 0, 19, 2, 0, 0, 2, 2, 0, 2, 2, 2, 2, 2, 0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0, 2, 2, 2, 2, 2, 0, 2, 2, 0, 2, 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 0, 6, 6, 3, 6, 7, 0, 0, 7, 7, 0, 7, 7, 7, 7, 7, 0, 7, 7, 4, 7, 2, 2, 2, 4, 2, 2, 2, 0, 2, 2, 2, 2, 4, 7, 3, 0, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5, 5, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 8, 6, 6, 2, 2, 2, 4, 2, 2, 2, 0, 2, 2, 2, 2, 3, 0, 3, 0, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6 ]
  B = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 6, 6, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 6, 6, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7 ]
  H = [ 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8 ]
  j = (aJ, T, aK) ->
    aq |= (((aJ ^ T ^ aK ^ (aK >> 1)) & 128) >> 6)

  a = (aJ, T, aK) ->
    aq |= (((aJ ^ T ^ aK ^ (aK >> 1)) & 32768) >> 14)

  I = ->
    r * 256 + o

  al = (T) ->
    r = (T >> 8) & 255
    o = T & 255

  W = (T) ->
    n --i, T & 255

  M = (T) ->
    n --i, T & 255
    n --i, (T >> 8) & 255

  v = (T) ->
    n --g, T & 255

  ap = (T) ->
    n --g, T & 255
    n --g, (T >> 8) & 255

  l = (T) ->
    u i++

  aG = (T) ->
    u(i++) * 256 + u(i++)

  aA = (T) ->
    u g++

  O = (T) ->
    u(g++) * 256 + u(g++)

  K = (aJ) ->
    T = 0
    if aJ & 128
      M an
      T += 2
    if aJ & 64
      M g
      T += 2
    if aJ & 32
      M c
      T += 2
    if aJ & 16
      M e
      T += 2
    if aJ & 8
      W aa
      T++
    if aJ & 4
      W o
      T++
    if aJ & 2
      W r
      T++
    if aJ & 1
      W aq
      T++
    ac += T

  J = (aJ) ->
    T = 0
    if aJ & 128
      ap an
      T += 2
    if aJ & 64
      ap i
      T += 2
    if aJ & 32
      ap c
      T += 2
    if aJ & 16
      ap e
      T += 2
    if aJ & 8
      v aa
      T++
    if aJ & 4
      v o
      T++
    if aJ & 2
      v r
      T++
    if aJ & 1
      v aq
      T++
    ac += T

  am = (aJ) ->
    T = 0
    if aJ & 1
      aq = l()
      T++
    if aJ & 2
      r = l()
      T++
    if aJ & 4
      o = l()
      T++
    if aJ & 8
      aa = l()
      T++
    if aJ & 16
      e = aG()
      T += 2
    if aJ & 32
      c = aG()
      T += 2
    if aJ & 64
      g = aG()
      T += 2
    if aJ & 128
      an = aG()
      T += 2
    ac += T

  ak = (aJ) ->
    T = 0
    if aJ & 1
      aq = aA()
      T++
    if aJ & 2
      r = aA()
      T++
    if aJ & 4
      o = aA()
      T++
    if aJ & 8
      aa = aA()
      T++
    if aJ & 16
      e = O()
      T += 2
    if aJ & 32
      c = O()
      T += 2
    if aJ & 64
      i = O()
      T += 2
    if aJ & 128
      an = O()
      T += 2
    ac += T

  N = (T) ->
    switch T & 15
      when 0
        I()
      when 1
        e
      when 2
        c
      when 3
        g
      when 4
        i
      when 5
        an
      when 8
        r
      when 9
        o
      when 10
        aq
      when 11
        aa
      else
        null

  D = (aJ, T) ->
    switch aJ & 15
      when 0
        al T
        return
      when 1
        e = T
        return
      when 2
        c = T
        return
      when 3
        g = T
        return
      when 4
        i = T
        return
      when 5
        an = T
        return
      when 8
        r = T
        return
      when 9
        o = T
        return
      when 10
        aq = T
        return
      when 11
        aa = T
        return
      else
        return

  w = (T, aJ) ->
    aK = T & 136
    aK = 0  if aK is 128 or aK is 8
    if aJ
      aK = N(T >> 4)
      D T >> 4, N(T)
      D T, aK
    else
      D T, N(T >> 4)

  S = (T) ->
    (if (T > 127) then (T - 256) else T)

  V = (T) ->
    (if (T > 32767) then (T - 65536) else T)

  s = ->
    T = u(an++)
    an &= 65535
    T

  ar = ->
    aJ = u(an++)
    an &= 65535
    T = u(an++)
    an &= 65535
    aJ * 256 + T

  E = (aK) ->
    aJ = u(aK++)
    aK &= 65535
    T = u(aK++)
    aK &= 65535
    aJ * 256 + T

  f = (aJ, T) ->
    n aJ++, (T >> 8) & 255
    aJ &= 65535
    n aJ, T & 255

  q = ->
    T = s()
    aN = undefined
    switch T & 96
      when 0
        aN = e
      when 32
        aN = c
      when 64
        aN = g
      when 96
        aN = i
    aL = null
    aM = null
    aK = undefined
    if T & 128
      switch T & 15
        when 0
          aM = aN
          aL = aN + 1
          ac += 2
        when 1
          aM = aN
          aL = aN + 2
          ac += 3
        when 2
          aL = aN - 1
          aM = aL
          ac += 2
        when 3
          aL = aN - 2
          aM = aL
          ac += 3
        when 4
          aM = aN
        when 5
          aM = aN + S(o)
          ac += 1
        when 6
          aM = aN + S(r)
          ac += 1
        when 7
          aM = 0
        when 8
          aM = aN + S(s())
          ac += 1
        when 9
          aM = aN + V(ar())
          ac += 4
        when 10
          aM = 0
        when 11
          ac += 4
          aM = aN + I()
        when 12
          aK = S(s())
          aM = an + aK
          ac += 1
        when 13
          aK = V(ar())
          aM = an + aK
          ac += 5
        when 14
          aM = 0
        when 15
          ac += 5
          aM = ar()
      aM &= 65535
      if T & 16
        aM = u(aM) * 256 + u((aM + 1) & 65535)
        ac += 3
    else
      aJ = T & 31
      aJ -= 32  if aJ > 15
      aM = aN + aJ
      ac += 1
    if aL isnt null
      switch T & 96
        when 0
          e = aL
        when 32
          c = aL
        when 64
          g = aL
        when 96
          i = aL
    aM & 65535

  z = (T) ->
    aq &= ~(ab | h)
    aq |= ab  if T is 0
    aq |= h  if T & 32768

  ag = (T) ->
    T++
    T &= 255
    aq &= ~(ab | Y | h)
    aq |= H[T]
    aq |= Y  if T is 0 or T is 128
    T

  x = (T) ->
    T--
    T &= 255
    aq &= ~(ab | Y | h)
    aq |= H[T]
    aq |= Y  if T is 127 or T is 255
    T

  p = (T, aK) ->
    aJ = T - aK
    aq &= ~(b | ab | Y | h)
    aq |= H[aJ & 255]
    aq |= b  if aJ & 256
    j T, aK, aJ
    aJ & 255

  af = (T, aK) ->
    aJ = T - aK
    aq &= ~(b | ab | Y | h)
    aq |= ab  if (aJ & 65535) is 0
    aq |= h  if aJ & 32768
    aq |= b  if aJ & 65536
    a T, aK, aJ
    aJ & 65535

  P = (T, aK) ->
    aJ = T + aK
    aq &= ~(d | b | ab | Y | h)
    aq |= H[aJ & 255]
    aq |= b  if aJ & 256
    j T, aK, aJ
    aq |= d  if (aJ ^ T ^ aK) & 16
    aJ & 255

  Q = (T, aK) ->
    aJ = T + aK
    aq &= ~(b | ab | Y | h)
    aq |= ab  if (aJ & 65535) is 0
    aq |= h  if aJ & 32768
    aq |= b  if aJ & 65536
    a T, aK, aJ
    aJ & 65535

  R = (T, aK) ->
    aJ = T + aK + (aq & b)
    aq &= ~(d | b | ab | Y | h)
    aq |= H[aJ & 255]
    aq |= b  if aJ & 256
    j T, aK, aJ
    aq |= d  if (aJ ^ T ^ aK) & 16
    aJ & 255

  y = (T, aK) ->
    aJ = T - aK - (aq & b)
    aq &= ~(b | ab | Y | h)
    aq |= H[aJ & 255]
    aq |= b  if aJ & 256
    j T, aK, aJ
    aJ & 255

  aB = (T, aK) ->
    aJ = T - aK
    aq &= ~(b | ab | Y | h)
    aq |= H[aJ & 255]
    aq |= b  if aJ & 256
    j T, aK, aJ
    return

  aE = (T, aK) ->
    aJ = T - aK
    aq &= ~(b | ab | Y | h)
    aq |= ab  if (aJ & 65535) is 0
    aq |= h  if aJ & 32768
    aq |= b  if aJ & 65536
    a T, aK, aJ
    return

  aC = (T) ->
    aq &= ~(b | ab | Y | h)
    aq |= Y  if T is 128
    T = ((~T) & 255) + 1
    aq |= ab  if T is 0
    aq |= h | b  if T & 128
    T

  ah = (T) ->
    aq &= ~(ab | b | h)
    aq |= b  if T & 1
    T >>= 1
    aq |= ab  if T is 0
    T & 255

  aF = (T) ->
    aq &= ~(ab | b | h)
    aq |= b  if T & 1
    T = (T & 128) | (T >> 1)
    aq |= H[T]
    T

  aI = (T) ->
    aJ = T
    aq &= ~(ab | b | h | Y)
    aq |= b  if T & 128
    T <<= 1
    aq |= H[T]
    aq |= Y  if (T ^ aJ) & 128
    T

  m = (T) ->
    aJ = T
    aK = aq & b
    aq &= ~(ab | b | h | Y)
    aq |= b  if T & 128
    T = T << 1 | aK
    aq |= H[T]
    aq |= Y  if (T ^ aJ) & 128
    T

  k = (T) ->
    aJ = aq & b
    aq &= ~(ab | b | h)
    aq |= b  if T & 1
    T = T >> 1 | aJ << 7
    aq |= H[T]
    T

  U = (T, aJ) ->
    aq &= ~(ab | h | Y)
    T ^= aJ
    aq |= H[T]
    T

  A = (T, aJ) ->
    aq &= ~(ab | h | Y)
    T |= aJ
    aq |= H[T]
    T

  ax = (T, aJ) ->
    aq &= ~(ab | h | Y)
    T &= aJ
    aq |= H[T]
    T

  ad = (T) ->
    aq &= ~(ab | h | Y)
    T ^= 255
    aq |= H[T]
    T

  C = ->
    aa * 256 + s()

  L = ->
    aP = ac
    ae
    aO = null
    aK = null
    T = an
    aN = s()
    ac += aw[aN]
    switch aN
      when 0
        aO = C()
        n aO, aC(u(aO))
      when 3
        aO = C()
        n aO, ad(u(aO))
      when 4
        aO = C()
        n aO, ah(u(aO))
      when 6
        aO = C()
        n aO, k(u(aO))
      when 7
        aO = C()
        n aO, aF(u(aO))
      when 8
        aO = C()
        n aO, aI(u(aO))
      when 9
        aO = C()
        n aO, m(u(aO))
      when 10
        aO = C()
        n aO, x(u(aO))
      when 12
        aO = C()
        n aO, ag(u(aO))
      when 13
        aO = C()
        aK = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[aK]
      when 14
        aO = C()
        an = aO
      when 15
        aO = C()
        n aO, 0
        aq &= ~(b | h | Y)
        aq |= ab
      when 18, 19
    , 22
        aO = V(ar())
        an += aO
      when 23
        aO = V(ar())
        M an
        an += aO
      when 25
        aM = 0
        aJ = r & 240
        aL = r & 15
        aM |= 6  if aL > 9 or aq & 32
        aM |= 96  if aJ > 128 and aL > 9
        aM |= 96  if aJ > 144 or aq & 1
        aO = aM + r
        aq &= ~(b | h | ab | Y)
        aq |= b  if aO & 256
        r = aO & 255
        aq |= flags[r]
      when 26
        aq |= s()
      when 28
        aq &= s()
      when 29
        r = (if (o & 128) then 255 else 0)
        z I()
        aq &= ~Y
      when 30
        aK = s()
        w aK, true
      when 31
        aK = s()
        w aK, false
      when 32
        aO = S(s())
        an += aO
      when 33
        aO = S(s())
      when 34
        aO = S(s())
        an += aO  unless aq & (b | ab)
      when 35
        aO = S(s())
        an += aO  if aq & (b | ab)
      when 36
        aO = S(s())
        an += aO  unless aq & b
      when 37
        aO = S(s())
        an += aO  if aq & b
      when 38
        aO = S(s())
        an += aO  unless aq & ab
      when 39
        aO = S(s())
        an += aO  if aq & ab
      when 40
        aO = S(s())
        an += aO  unless aq & Y
      when 41
        aO = S(s())
        an += aO  if aq & Y
      when 42
        aO = S(s())
        an += aO  unless aq & h
      when 43
        aO = S(s())
        an += aO  if aq & h
      when 44
        aO = S(s())
        an += aO  unless (aq & h) ^ ((aq & Y) << 2)
      when 45
        aO = S(s())
        an += aO  if (aq & h) ^ ((aq & Y) << 2)
      when 46
        aO = S(s())
        an += aO  unless (aq & h) ^ ((aq & Y) << 2) or (aq & ab)
      when 47
        aO = S(s())
        an += aO  if (aq & h) ^ ((aq & Y) << 2) or (aq & ab)
      when 48
        e = q()
        if e is 0
          aq |= ab
        else
          aq &= ~ab
      when 49
        c = q()
        if c is 0
          aq |= ab
        else
          aq &= ~ab
      when 50
        i = q()
      when 51
        g = q()
      when 52
        K s()
      when 53
        am s()
      when 54
        J s()
      when 55
        ak s()
      when 57
        an = aG()
      when 58
        e += o
      when 59
        aq = l()
        if cc & aH
          ac += 9
          r = l()
          o = l()
          aa = l()
          e = aG()
          c = aG()
          g = aG()
        an = aG()
      when 60
        aq &= s()
      when 61
        aO = r * o
        if aO is 0
          aq |= ab
        else
          aq &= ~ab
        if aO & 128
          aq |= b
        else
          aq &= ~b
        al aO
      when 63
        aq |= aH
        M an
        M g
        M c
        M e
        W aa
        W o
        W r
        W aq
        aq |= ao | az
        an = E(ay)
      when 64
        r = aC(r)
      when 67
        r = ad(r)
      when 68
        r = ah(r)
      when 70
        r = k(r)
      when 71
        r = aF(r)
      when 72
        r = aI(r)
      when 73
        r = m(r)
      when 74
        r = x(r)
      when 76
        r = ag(r)
      when 77
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 79
        r = 0
        aq &= ~(h | Y | b)
        aq |= ab
      when 80
        o = aC(o)
      when 83
        o = ad(o)
      when 84
        o = ah(o)
      when 86
        o = k(o)
      when 87
        o = aF(o)
      when 88
        o = aI(o)
      when 89
        o = m(o)
      when 90
        o = x(o)
      when 92
        o = ag(o)
      when 93
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 95
        o = 0
        aq &= ~(h | Y | b)
        aq |= ab
      when 96
        aO = q()
        n aO, aC(u(aO))
      when 99
        aO = q()
        n aO, ad(u(aO))
      when 100
        aO = q()
        n aO, ah(u(aO))
      when 102
        aO = q()
        n aO, k(u(aO))
      when 103
        aO = q()
        n aO, aF(u(aO))
      when 104
        aO = q()
        n aO, aI(u(aO))
      when 105
        aO = q()
        n aO, m(u(aO))
      when 106
        aO = q()
        n aO, x(u(aO))
      when 108
        aO = q()
        n aO, ag(u(aO))
      when 109
        aO = q()
        aK = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[aK]
      when 110
        aO = q()
        an = aO
      when 111
        aO = q()
        n aO, 0
        aq &= ~(b | h | Y)
        aq |= ab
      when 112
        aO = ar()
        n aO, aC(u(aO))
      when 115
        aO = ar()
        n aO, ad(u(aO))
      when 116
        aO = ar()
        n aO, ah(u(aO))
      when 118
        aO = ar()
        n aO, k(u(aO))
      when 119
        aO = ar()
        n aO, aF(u(aO))
      when 120
        aO = ar()
        n aO, aI(u(aO))
      when 121
        aO = ar()
        n aO, m(u(aO))
      when 122
        aO = ar()
        n aO, x(u(aO))
      when 124
        aO = ar()
        n aO, ag(u(aO))
      when 125
        aO = ar()
        aK = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[aK]
      when 126
        aO = ar()
        an = aO
      when 127
        aO = ar()
        n aO, 0
        aq &= ~(b | h | Y)
        aq |= ab
      when 128
        r = p(r, s())
      when 129
        aB r, s()
      when 130
        r = y(r, s())
      when 131
        al af(I(), ar())
      when 132
        r = ax(r, s())
      when 133
        ax r, s()
      when 134
        r = s()
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 136
        r = U(r, s())
      when 137
        r = R(r, s())
      when 138
        r = A(r, s())
      when 139
        r = P(r, s())
      when 140
        aE e, ar()
      when 141
        aO = S(s())
        M an
        an += aO
      when 142
        e = ar()
        z e
        aq &= ~Y
      when 144
        aO = C()
        r = p(r, u(aO))
      when 145
        aO = C()
        aB r, u(aO)
      when 146
        aO = C()
        r = y(r, u(aO))
      when 147
        aO = C()
        al af(I(), E(aO))
      when 148
        aO = C()
        r = ax(r, u(aO))
      when 149
        aO = C()
        ax r, u(aO)
      when 150
        aO = C()
        r = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 151
        aO = C()
        n aO, r
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 152
        aO = C()
        r = U(r, u(aO))
      when 153
        aO = C()
        r = R(r, u(aO))
      when 154
        aO = C()
        r = A(r, u(aO))
      when 155
        aO = C()
        r = P(r, u(aO))
      when 156
        aO = C()
        aE e, E(aO)
      when 157
        aO = C()
        M an
        an = aO
      when 158
        aO = C()
        e = E(aO)
        z e
        aq &= ~Y
      when 159
        aO = C()
        f aO, e
        z e
        aq &= ~Y
      when 160
        aO = q()
        r = p(r, u(aO))
      when 161
        aO = q()
        aB r, u(aO)
      when 162
        aO = q()
        r = y(r, u(aO))
      when 163
        aO = q()
        al af(I(), E(aO))
      when 164
        aO = q()
        r = ax(r, u(aO))
      when 165
        aO = q()
        ax r, u(aO)
      when 166
        aO = q()
        r = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 167
        aO = q()
        n aO, r
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 168
        aO = q()
        r = U(r, u(aO))
      when 169
        aO = q()
        r = R(r, u(aO))
      when 170
        aO = q()
        r = A(r, u(aO))
      when 171
        aO = q()
        r = P(r, u(aO))
      when 172
        aO = q()
        aE e, E(aO)
      when 173
        aO = q()
        M an
        an = aO
      when 174
        aO = q()
        e = E(aO)
        z e
        aq &= ~Y
      when 175
        aO = q()
        f aO, e
        z e
        aq &= ~Y
      when 176
        aO = ar()
        r = p(r, u(aO))
      when 177
        aO = ar()
        aB r, u(aO)
      when 178
        aO = ar()
        r = y(r, u(aO))
      when 179
        aO = ar()
        al af(I(), E(aO))
      when 180
        aO = ar()
        r = ax(r, u(aO))
      when 181
        aO = ar()
        ax r, u(aO)
      when 182
        aO = ar()
        r = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 183
        aO = ar()
        n aO, r
        aq &= ~(ab | h | Y)
        aq |= H[r]
      when 184
        aO = ar()
        r = U(r, u(aO))
      when 185
        aO = ar()
        r = R(r, u(aO))
      when 186
        aO = ar()
        r = A(r, u(aO))
      when 187
        aO = ar()
        r = P(r, u(aO))
      when 188
        aO = ar()
        aE e, E(aO)
      when 189
        aO = ar()
        M an
        an = aO
      when 190
        aO = ar()
        e = E(aO)
        z e
        aq &= ~Y
      when 191
        aO = ar()
        f aO, e
        z e
        aq &= ~Y
      when 192
        o = p(o, s())
      when 193
        aB o, s()
      when 194
        o = y(o, s())
      when 195
        al Q(I(), ar())
      when 196
        o = ax(o, s())
      when 197
        ax o, s()
      when 198
        o = s()
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 200
        o = U(o, s())
      when 201
        o = R(o, s())
      when 202
        o = A(o, s())
      when 203
        o = P(o, s())
      when 204
        aO = ar()
        al aO
        z aO
        aq &= ~Y
      when 206
        g = ar()
        z g
        aq &= ~Y
      when 208
        aO = C()
        o = p(o, u(aO))
      when 209
        aO = C()
        aB o, u(aO)
      when 210
        aO = C()
        o = y(o, u(aO))
      when 211
        aO = C()
        al Q(I(), E(aO))
      when 212
        aO = C()
        o = ax(o, u(aO))
      when 213
        aO = C()
        ax o, u(aO)
      when 214
        aO = C()
        o = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 215
        aO = C()
        n aO, o
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 216
        aO = C()
        o = U(o, u(aO))
      when 217
        aO = C()
        o = R(o, u(aO))
      when 218
        aO = C()
        o = A(o, u(aO))
      when 219
        aO = C()
        o = P(o, u(aO))
      when 220
        aO = C()
        aK = E(aO)
        al aK
        z aK
        aq &= ~Y
      when 221
        aO = C()
        f aO, I()
        aq &= ~Y
      when 222
        aO = C()
        g = E(aO)
        z e
        aq &= ~Y
      when 223
        aO = C()
        f aO, g
        z g
        aq &= ~Y
      when 224
        aO = q()
        o = p(o, u(aO))
      when 225
        aO = q()
        aB o, u(aO)
      when 226
        aO = q()
        o = y(o, u(aO))
      when 227
        aO = q()
        al Q(I(), E(aO))
      when 228
        aO = q()
        o = ax(o, u(aO))
      when 229
        aO = q()
        ax o, u(aO)
      when 230
        aO = q()
        o = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 231
        aO = q()
        n aO, o
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 232
        aO = q()
        o = U(o, u(aO))
      when 233
        aO = q()
        o = R(o, u(aO))
      when 234
        aO = q()
        o = A(o, u(aO))
      when 235
        aO = q()
        o = P(o, u(aO))
      when 236
        aO = q()
        aK = E(aO)
        al aK
        z aK
        aq &= ~Y
      when 237
        aO = q()
        f aO, I()
        aq &= ~Y
      when 238
        aO = q()
        g = E(aO)
        z g
        aq &= ~Y
      when 239
        aO = q()
        f aO, g
        z g
        aq &= ~Y
      when 240
        aO = ar()
        o = p(o, u(aO))
      when 241
        aO = ar()
        aB o, u(aO)
      when 242
        aO = ar()
        o = y(o, u(aO))
      when 243
        aO = ar()
        al Q(I(), E(aO))
      when 244
        aO = ar()
        o = ax(o, u(aO))
      when 245
        aO = ar()
        ax o, u(aO)
      when 246
        aO = ar()
        o = u(aO)
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 247
        aO = ar()
        n aO, o
        aq &= ~(ab | h | Y)
        aq |= H[o]
      when 248
        aO = ar()
        o = U(o, u(aO))
      when 249
        aO = ar()
        o = R(o, u(aO))
      when 250
        aO = ar()
        o = A(o, u(aO))
      when 251
        aO = ar()
        o = P(o, u(aO))
      when 252
        aO = ar()
        aK = E(aO)
        al aK
        z aK
        aq &= ~Y
      when 253
        aO = ar()
        f aO, I()
        aq &= ~Y
      when 254
        aO = ar()
        g = E(aO)
        z g
        aq &= ~Y
      when 255
        aO = ar()
        f aO, g
        z g
        aq &= ~Y
      when 16
        aN = s()
        ac += B[aN]
        switch aN
          when 33
            aO = V(ar())
          when 34
            aO = V(ar())
            an += aO  unless aq & (b | ab)
          when 35
            aO = V(ar())
            an += aO  if aq & (b | ab)
          when 36
            aO = V(ar())
            an += aO  unless aq & b
          when 37
            aO = V(ar())
            an += aO  if aq & b
          when 38
            aO = V(ar())
            an += aO  unless aq & ab
          when 39
            aO = V(ar())
            an += aO  if aq & ab
          when 40
            aO = V(ar())
            an += aO  unless aq & Y
          when 41
            aO = V(ar())
            an += aO  if aq & Y
          when 42
            aO = V(ar())
            an += aO  unless aq & h
          when 43
            aO = V(ar())
            an += aO  if aq & h
          when 44
            aO = V(ar())
            an += aO  unless (aq & h) ^ ((aq & Y) << 2)
          when 45
            aO = V(ar())
            an += aO  if (aq & h) ^ ((aq & Y) << 2)
          when 46
            aO = V(ar())
            an += aO  unless (aq & h) ^ ((aq & Y) << 2) or (aq & ab)
          when 47
            aO = V(ar())
            an += aO  if (aq & h) ^ ((aq & Y) << 2) or (aq & ab)
          when 63
            aq |= aH
            M an
            M g
            M c
            M e
            W aa
            W o
            W r
            W aq
            aq |= ao | az
            an = E(G)
          when 131
            aE I(), ar()
          when 140
            aE c, ar()
          when 142
            c = ar()
            z c
            aq &= ~Y
          when 147
            aO = C()
            aE I(), E(aO)
          when 156
            aO = C()
            aE c, E(aO)
          when 158
            aO = C()
            c = E(aO)
            z c
            aq &= ~Y
          when 159
            aO = C()
            f aO, c
            z c
            aq &= ~Y
          when 163
            aO = q()
            aE I(), E(aO)
          when 172
            aO = q()
            aE c, E(aO)
          when 174
            aO = q()
            c = E(aO)
            z c
            aq &= ~Y
          when 175
            aO = q()
            f aO, c
            z c
            aq &= ~Y
          when 179
            aO = ar()
            aE I(), E(aO)
          when 188
            aO = ar()
            aE c, E(aO)
          when 190
            aO = ar()
            c = E(aO)
            z c
            aq &= ~Y
          when 191
            aO = ar()
            f aO, c
            z c
            aq &= ~Y
          when 206
            i = ar()
            z i
            aq &= ~Y
          when 222
            aO = C()
            i = E(aO)
            z i
            aq &= ~Y
          when 223
            aO = C()
            f aO, i
            z i
            aq &= ~Y
          when 238
            aO = q()
            i = E(aO)
            z i
            aq &= ~Y
          when 239
            aO = q()
            f aO, i
            z i
            aq &= ~Y
          when 254
            aO = ar()
            i = E(aO)
            z i
            aq &= ~Y
          when 255
            aO = ar()
            f aO, i
            z i
            aq &= ~Y
      when 17
        aN = s()
        ac += B[aN]
        switch aN
          when 63
            aq |= aH
            M an
            M g
            M c
            M e
            W aa
            W o
            W r
            W aq
            aq |= ao | az
            an = E(F)
          when 131
            aE g, ar()
          when 140
            aE i, ar()
          when 147
            aO = C()
            aE g, E(aO)
          when 156
            aO = C()
            aE i, E(aO)
          when 163
            aO = q()
            aE g, E(aO)
          when 172
            aO = q()
            aE i, E(aO)
          when 179
            aO = ar()
            aE g, E(aO)
          when 188
            aO = ar()
            aE i, E(aO)
    r &= 255
    o &= 255
    aq &= 255
    aa &= 255
    e &= 65535
    c &= 65535
    g &= 65535
    i &= 65535
    an &= 65535
    ac - aP

  Z = ->
    an = E(aj)
    aa = 0
    aq |= az | ao
    ac = 0

  t = [ [ 2, 1, "NEG" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 2, 1, "COM" ], [ 2, 1, "LSR" ], [ 1, 0, "???" ], [ 2, 1, "ROR" ], [ 2, 1, "ASR" ], [ 2, 1, "LSL" ], [ 2, 1, "ROL" ], [ 2, 1, "DEC" ], [ 1, 0, "???" ], [ 2, 1, "INC" ], [ 2, 1, "TST" ], [ 2, 1, "JMP" ], [ 2, 1, "CLR" ], [ 1, 0, "Prefix" ], [ 1, 0, "Prefix" ], [ 1, 2, "NOP" ], [ 1, 2, "SYNC" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 3, 3, "LBRA" ], [ 3, 3, "LBSR" ], [ 1, 0, "???" ], [ 1, 2, "DAA" ], [ 2, 4, "ORCC" ], [ 1, 0, "???" ], [ 2, 4, "ANDCC" ], [ 1, 2, "SEX" ], [ 2, 20, "EXG" ], [ 2, 20, "TFR" ], [ 2, 5, "BRA" ], [ 2, 5, "BRN" ], [ 2, 5, "BHI" ], [ 2, 5, "BLS" ], [ 2, 5, "BCC" ], [ 2, 5, "BCS" ], [ 2, 5, "BNE" ], [ 2, 5, "BEQ" ], [ 2, 5, "BVC" ], [ 2, 5, "BVS" ], [ 2, 5, "BPL" ], [ 2, 5, "BMI" ], [ 2, 5, "BGE" ], [ 2, 5, "BLT" ], [ 2, 5, "BGT" ], [ 2, 5, "BLE" ], [ 2, 6, "LEAX" ], [ 2, 6, "LEAY" ], [ 2, 6, "LEAS" ], [ 2, 6, "LEAU" ], [ 2, 10, "PSHS" ], [ 2, 10, "PULS" ], [ 2, 11, "PSHU" ], [ 2, 11, "PULU" ], [ 1, 0, "???" ], [ 1, 2, "RTS" ], [ 1, 2, "ABX" ], [ 1, 2, "RTI" ], [ 2, 2, "CWAI" ], [ 1, 2, "MUL" ], [ 1, 2, "RESET" ], [ 1, 2, "SWI1" ], [ 1, 2, "NEGA" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 1, 2, "COMA" ], [ 1, 2, "LSRA" ], [ 1, 0, "???" ], [ 1, 2, "RORA" ], [ 1, 2, "ASRA" ], [ 1, 2, "ASLA" ], [ 1, 2, "ROLA" ], [ 1, 2, "DECA" ], [ 1, 0, "???" ], [ 1, 2, "INCA" ], [ 1, 2, "TSTA" ], [ 1, 0, "???" ], [ 1, 2, "CLRA" ], [ 1, 2, "NEGB" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 1, 2, "COMB" ], [ 1, 2, "LSRB" ], [ 1, 0, "???" ], [ 1, 2, "RORB" ], [ 1, 2, "ASRB" ], [ 1, 2, "ASLB" ], [ 1, 2, "ROLB" ], [ 1, 2, "DECB" ], [ 1, 0, "???" ], [ 1, 2, "INCB" ], [ 1, 2, "TSTB" ], [ 1, 0, "???" ], [ 1, 2, "CLRB" ], [ 2, 6, "NEG" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 2, 6, "COM" ], [ 2, 6, "LSR" ], [ 1, 0, "???" ], [ 2, 6, "ROR" ], [ 2, 6, "ASR" ], [ 2, 6, "LSL" ], [ 2, 6, "ROL" ], [ 2, 6, "DEC" ], [ 1, 0, "???" ], [ 2, 6, "INC" ], [ 2, 6, "TST" ], [ 2, 6, "JMP" ], [ 2, 6, "CLR" ], [ 3, 7, "NEG" ], [ 1, 0, "???" ], [ 1, 0, "???" ], [ 3, 7, "COM" ], [ 3, 7, "LSR" ], [ 1, 0, "???" ], [ 3, 7, "ROR" ], [ 3, 7, "ASR" ], [ 3, 7, "LSL" ], [ 3, 7, "ROL" ], [ 3, 7, "DEC" ], [ 1, 0, "???" ], [ 3, 7, "INC" ], [ 3, 7, "TST" ], [ 3, 7, "JMP" ], [ 3, 7, "CLR" ], [ 2, 4, "SUBA" ], [ 2, 4, "CMPA" ], [ 2, 4, "SBCA" ], [ 3, 8, "SUBD" ], [ 2, 4, "ANDA" ], [ 2, 4, "BITA" ], [ 2, 4, "LDA" ], [ 1, 0, "???" ], [ 2, 4, "EORA" ], [ 2, 4, "ADCA" ], [ 2, 4, "ORA" ], [ 2, 4, "ADDA" ], [ 3, 8, "CMPX" ], [ 2, 5, "BSR" ], [ 3, 8, "LDX" ], [ 1, 0, "???" ], [ 2, 1, "SUBA" ], [ 2, 1, "CMPA" ], [ 2, 1, "SBCA" ], [ 2, 1, "SUBd" ], [ 2, 1, "ANDA" ], [ 2, 1, "BITA" ], [ 2, 1, "LDA" ], [ 2, 1, "STA" ], [ 2, 1, "EORA" ], [ 2, 1, "ADCA" ], [ 2, 1, "ORA" ], [ 2, 1, "ADDA" ], [ 2, 1, "CMPX" ], [ 2, 1, "JSR" ], [ 2, 1, "LDX" ], [ 2, 1, "STX" ], [ 2, 6, "SUBA" ], [ 2, 6, "CMPA" ], [ 2, 6, "SBCA" ], [ 2, 6, "SUBD" ], [ 2, 6, "ANDA" ], [ 2, 6, "BITA" ], [ 2, 6, "LDA" ], [ 2, 6, "STA" ], [ 2, 6, "EORA" ], [ 2, 6, "ADCA" ], [ 2, 6, "ORA" ], [ 2, 6, "ADDA" ], [ 2, 6, "CMPX" ], [ 2, 6, "JSR" ], [ 2, 6, "LDX" ], [ 2, 6, "STX" ], [ 3, 7, "SUBA" ], [ 3, 7, "CMPA" ], [ 3, 7, "SBCA" ], [ 3, 7, "SUBD" ], [ 3, 7, "ANDA" ], [ 3, 7, "BITA" ], [ 3, 7, "LDA" ], [ 3, 7, "STA" ], [ 3, 7, "EORA" ], [ 3, 7, "ADCA" ], [ 3, 7, "ORA" ], [ 3, 7, "ADDA" ], [ 3, 7, "CMPX" ], [ 3, 7, "JSR" ], [ 3, 7, "LDX" ], [ 3, 7, "STX" ], [ 2, 4, "SUBB" ], [ 2, 4, "CMPB" ], [ 2, 4, "SBCB" ], [ 3, 8, "ADDD" ], [ 2, 4, "ANDB" ], [ 2, 4, "BITB" ], [ 2, 4, "LDB" ], [ 1, 0, "???" ], [ 2, 4, "EORB" ], [ 2, 4, "ADCB" ], [ 2, 4, "ORB" ], [ 2, 4, "ADDB" ], [ 3, 8, "LDD" ], [ 1, 0, "???" ], [ 3, 8, "LDU" ], [ 1, 0, "???" ], [ 2, 1, "SUBB" ], [ 2, 1, "CMPB" ], [ 2, 1, "SBCB" ], [ 2, 1, "ADDD" ], [ 2, 1, "ANDB" ], [ 2, 1, "BITB" ], [ 2, 1, "LDB" ], [ 2, 1, "STB" ], [ 2, 1, "EORB" ], [ 2, 1, "ADCB" ], [ 2, 1, "ORB " ], [ 2, 1, "ADDB" ], [ 2, 1, "LDD " ], [ 2, 1, "STD " ], [ 2, 1, "LDU " ], [ 2, 1, "STU " ], [ 2, 6, "SUBB" ], [ 2, 6, "CMPB" ], [ 2, 6, "SBCB" ], [ 2, 6, "ADDD" ], [ 2, 6, "ANDB" ], [ 2, 6, "BITB" ], [ 2, 6, "LDB" ], [ 2, 6, "STB" ], [ 2, 6, "EORB" ], [ 2, 6, "ADCB" ], [ 2, 6, "ORB" ], [ 2, 6, "ADDB" ], [ 2, 6, "LDD" ], [ 2, 6, "STD" ], [ 2, 6, "LDU" ], [ 2, 6, "STU" ], [ 3, 7, "SUBB" ], [ 3, 7, "CMPB" ], [ 3, 7, "SBCB" ], [ 3, 7, "ADDD" ], [ 3, 7, "ANDB" ], [ 3, 7, "BITB" ], [ 3, 7, "LDB" ], [ 3, 7, "STB" ], [ 3, 7, "EORB" ], [ 3, 7, "ADCB" ], [ 3, 7, "ORB" ], [ 3, 7, "ADDB" ], [ 3, 7, "LDD" ], [ 3, 7, "STD" ], [ 3, 7, "LDU" ], [ 3, 7, "STU" ] ]
  at =
    63: [ 2, 2, "SWI3" ]
    131: [ 4, 8, "CMPU" ]
    140: [ 4, 8, "CMPS" ]
    147: [ 3, 1, "CMPU" ]
    156: [ 3, 1, "CMPS" ]
    163: [ 3, 6, "CMPU" ]
    172: [ 3, 6, "CMPS" ]
    179: [ 4, 7, "CMPU" ]
    188: [ 4, 7, "CMPS" ]

  au =
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

  X = (aX, a3, a2, a0, aZ, T) ->
    aR = (a7, a6) ->
      a5 = a7.toString(16)
      a5 = "0" + a5  while a5.length < a6
      a5.toUpperCase()

    aL = (a5) ->
      aR a5 & 255, 2

    aK = (a5) ->
      aR a5, 4

    aM = undefined
    aP = undefined
    aW = undefined
    aU = t[aX]
    if aX is 16
      aU = au[a3]
      return [ "???", 2 ]  if aU is `undefined`
      aX = a3
      a3 = a2
      a2 = a0
      a0 = aZ
    if aX is 17
      aU = at[a3]
      return [ "???", 2 ]  if aU is `undefined`
      aX = a3
      a3 = a2
      a2 = a0
      a0 = aZ
    aT = aU[0]
    aS = aU[1]
    aN = aU[2]
    switch aS
      when 0, 1
        aN += " $" + aL(a3)
      when 2, 3
        aN += " #$" + aK((if (a3 * 256 + a2) < 32768 then (a3 * 256 + a2 + T) else (a3 * 256 + a2 + T - 65536)))
      when 4
        aN += " #$" + aL(a3)
      when 5
        aN += " #$" + aK((if (a3) < 128 then (a3 + T + 2) else (a3 + T - 254)))
      when 6
        aN += " "
        aJ = a3
        aQ = [ "X", "Y", "U", "S" ][(aJ & 96) >> 5]
        unless aJ & 128
          aV = aJ & 31
          aV = aV - 32  if aV > 15
          aN += aV + "," + aQ
          break
        aO = aJ & 16
        a4 = aJ & 15
        a1 = (if (a2 > 127) then (a2 - 256) else a2)
        aY = (if ((a2 * 256 + a0) > 32767) then ((a2 * 256 + a0) - 65536) else (a2 * 256 + a0))
        unless aO
          switch a4
            when 0
              aN += "," + aQ + "+"
            when 1
              aN += "," + aQ + "++"
            when 2
              aN += ",-" + aQ
            when 3
              aN += ",--" + aQ
            when 4
              aN += "," + aQ
            when 5
              aN += "B," + aQ
            when 6
              aN += "A," + aQ
            when 7
              aN += "???"
            when 8
              aN += a1 + "," + aQ
              aT++
            when 9
              aN += aY + "," + aQ
              aT += 2
            when 10
              aN += "???"
            when 11
              aN += "D," + aQ
            when 12
              aN += a1 + ",PC"
              aT++
            when 13
              aN += aY + ",PC"
              aT += 2
            when 14
              aN += "???"
            when 15
              aN += "$" + aK((a2 * 256 + a0))
              aT += 2
        else
          switch a4
            when 0
              aN += "???"
            when 1
              aN += "[," + aQ + "++]"
            when 2
              aN += "???"
            when 3
              aN += "[,--" + aQ + "]"
            when 4
              aN += "[," + aQ + "]"
            when 5
              aN += "[B," + aQ + "]"
            when 6
              aN += "[A," + aQ + "]"
            when 7
              aN += "???"
            when 8
              aN += "[" + a1 + "," + aQ + "]"
              aT++
            when 9
              aN += "[" + aY + "," + aQ + "]"
              aT += 2
            when 10
              aN += "???"
            when 11
              aN += "[D," + aQ + "]"
            when 12
              aN += "[" + a1 + ",PC]"
              aT++
            when 13
              aN += "[" + aY + ",PC]"
              aT += 2
            when 14
              aN += "???"
            when 15
              aN += "[$" + aK((a2 * 256 + a0)) + "]"
              aT += 2
      when 7
        aN += " $" + aK(a3 * 256 + a2)
      when 8
        aN += " #$" + aK(a3 * 256 + a2)
      when 10
        aM = [ "PC", "U", "Y", "X", "DP", "B", "A", "CC" ]
        aP = []
        aW = 0
        while aW < 8
          aP.push aM[7 - aW]  if (a3 & 1) isnt 0
          a3 >>= 1
          aW++
        aN += " " + aP.join(",")
      when 11
        aM = [ "PC", "S", "Y", "X", "DP", "B", "A", "CC" ]
        aP = []
        aW = 0
        while aW < 8
          aP.push aM[7 - aW]  if (a3 & 1) isnt 0
          a3 >>= 1
          aW++
        aN += " " + aP.join(",")
      when 20
        aM = [ "D", "X", "Y", "U", "S", "PC", "?", "?", "A", "B", "CC", "DP", "?", "?", "?", "?" ]
        aN += " " + aM[a3 >> 4] + "," + aM[a3 & 15]
    [ aN, aT ]

  steps: (T) ->
    T -= L()  while T > 0

  T: ->
    ac

  reset: Z
  init: (aJ, aK, T) ->
    n = aJ
    u = aK
    ticks = T
    Z()

  status: ->
    pc: an
    sp: i
    u: g
    a: r
    b: o
    x: e
    y: c
    dp: aa
    flags: aq

  interrupt: ->

  nmi: ->

  set: (T, aJ) ->
    switch T.toUpperCase()
      when "PC"
        an = aJ
        return
      when "A"
        r = aJ
        return
      when "B"
        o = aJ
        return
      when "X"
        e = aJ
        return
      when "Y"
        c = aJ
        return
      when "SP"
        i = aJ
        return
      when "U"
        g = aJ
        return
      when "FLAGS"
        aq = aJ
        return

  flagsToString: ->
    aK = ""
    aJ = "EFHINZVC"
    T = 0

    while T < 8
      aL = aq & (128 >> T)
      if aL is 0
        aK += aJ[T].toLowerCase()
      else
        aK += aJ[T]
      T++
    aK

  disasm: X
