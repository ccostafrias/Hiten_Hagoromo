local function calcula_determinante_3x3(a, b, c)
  -- FORMULA: det(A) = a1​(b2​c3 ​− b3​c2​) − a2​(b1​c3​ − b3​c1​) + a3​(b1​c2 ​− b2​c1​)
  local det = a[1] * (b[2]*c[3] - b[3]*c[2])
            - a[2] * (b[1]*c[3] - b[3]*c[1])
            + a[3] * (b[1]*c[2] - b[2]*c[1])

  return det
end

function verify_mouse_inside()
  -- α1.Xa + α2.Xb + α3.Xc = Xp
  -- α1.Ya + α2.Yb + α3.Yc = Yp
  -- α1.1  + α2.1  + α3.1  = 1

  local aCol   = {Triangle.vertices[1], Triangle.vertices[2], 1}
  local bCol   = {Triangle.vertices[3], Triangle.vertices[4], 1}
  local cCol   = {Triangle.vertices[5], Triangle.vertices[6], 1}
  local resCol = {love.mouse.getX()   , love.mouse.getY()   , 1}

  local detMain   = calcula_determinante_3x3(aCol  , bCol  , cCol)
  local detAlpha1 = calcula_determinante_3x3(resCol, bCol  , cCol)
  local detAlpha2 = calcula_determinante_3x3(aCol  , resCol, cCol)
  local detAlpha3 = calcula_determinante_3x3(aCol  , bCol  , resCol)

  local alpha1 = detAlpha1/detMain
  local alpha2 = detAlpha2/detMain
  local alpha3 = detAlpha3/detMain

  if alpha1 > 0 and alpha2 > 0 and alpha3 > 0 then
    return true
  else
    return false
  end

  print(alpha1, alpha2, alpha3)
end