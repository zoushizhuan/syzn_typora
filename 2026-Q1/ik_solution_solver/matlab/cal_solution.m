clear
clc
syms q1 q2 q3 q4 q5 q6 alfa d1 a2 a3 d4 d5 d6
syms nx ox ax px ny oy ay py nz oz az pz
alfa=sym(pi)/2;
% d1 = vpa(89.459);
% a2 = vpa(-425);
% a3 = vpa(-392.25);
% d4 = vpa(109.15);
% d5 = vpa(94.65);
% d6 = vpa(82.3);
T1=stdtrans(q1,     d1,  0, alfa);
T2=stdtrans(q2,     0,  a2, 0);
T3=stdtrans(q3,     0,  a3, 0);
T4=stdtrans(q4,     d4,  0, alfa);
T5=stdtrans(q5,     d5,  0, -alfa);
T6=stdtrans(q6,     d6,  0, 0);
%T=T1*T2*T3*T4*T5*T6;
T = [nx ox ax px;
    ny oy ay py;
    nz oz az pz;
    0 0 0 1];
rot_x_alpha4 = stdtrans(0,0,0,-alfa);
TL = collect(simplify(T2*T3*T4*rot_x_alpha4))
TR = collect(simplify(inv(T1)*T*inv(T6)*inv(T5)))
exp = simplify(cos(q2+q3)*cos(q2)+sin(q2+q3)*sin(q2))
