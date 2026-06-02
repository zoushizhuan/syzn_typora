function [ T ] = stdtrans( q,d,a,alfa )
T=[cos(q) -sin(q)*cos(alfa)   sin(q)*sin(alfa)  a*cos(q);
   sin(q)  cos(q)*cos(alfa)  -cos(q)*sin(alfa)  a*sin(q);
       0         sin(alfa)    cos(alfa)         d;
    0 0 0 1];
end
