% given h, it returns v for downstream reservoir

function v=h2vUpstream(h)
v = (0.0132*exp(0.0274*(h/2)))*1.3;