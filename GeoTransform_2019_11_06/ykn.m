function [r c] = ykn(X,Y,Z,dx)

A = dx(1) + dx(2) * X + dx(3)  * Y + dx(4)  * Z;
D = 1     + dx(5) * X + dx(6)  * Y + dx(7)  * Z;
B = dx(8) + dx(9) * X + dx(10) * Y + dx(11) * Z;

r = A/D;
c = B/D;
