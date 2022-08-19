% given v, it returns h for upstream reservoir

function h=v2hUpstream(v)
h = (159.05*(v/1.3)^0.1992)*2;