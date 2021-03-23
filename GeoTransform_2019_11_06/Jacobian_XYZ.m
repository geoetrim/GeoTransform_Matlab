% Sub-design matrix related to d(XYZ) of check points
% Calculates A matrix for all check points, and re-arranges it for selected points

%Sýralama: X (U, Latitude), Y (V, Longitude), Z (W, Height)
%RPCs are started from the 11th line in the original RPC file (i.e. from a000)

function A = Jacobian_XYZ

a000 = rpc( 1);	b000 = rpc(21); c000 = rpc(41); d000 = rpc(61); %        1
a010 = rpc( 2); b010 = rpc(22); c010 = rpc(42); d010 = rpc(62); % V	     2
a100 = rpc( 3); b100 = rpc(23); c100 = rpc(43); d100 = rpc(63); % U	     3
a001 = rpc( 4); b001 = rpc(24); c001 = rpc(44); d001 = rpc(64); % W	     4
a110 = rpc( 5); b110 = rpc(25); c110 = rpc(45); d110 = rpc(65); % U*V	 5
a011 = rpc( 6); b011 = rpc(26); c011 = rpc(46); d011 = rpc(66); % V*W	 6
a101 = rpc( 7); b101 = rpc(27); c101 = rpc(47); d101 = rpc(67); % U*W	 7
a020 = rpc( 8); b020 = rpc(28); c020 = rpc(48); d020 = rpc(68); % V^2	 8
a200 = rpc( 9); b200 = rpc(29); c200 = rpc(49); d200 = rpc(69); % U^2	 9
a002 = rpc(10); b002 = rpc(30); c002 = rpc(50); d002 = rpc(70); % W^2	10
a111 = rpc(11); b111 = rpc(31); c111 = rpc(51); d111 = rpc(71); % U*V*W	11
a030 = rpc(12); b030 = rpc(32); c030 = rpc(52); d030 = rpc(72); % V^3	12
a210 = rpc(13); b210 = rpc(33); c210 = rpc(53); d210 = rpc(73); % U^2*V	13
a012 = rpc(14); b012 = rpc(34); c012 = rpc(54); d012 = rpc(74); % V*W^2	14
a120 = rpc(15); b120 = rpc(35); c120 = rpc(55); d120 = rpc(75); % U*V^2	15
a300 = rpc(16); b300 = rpc(36); c300 = rpc(56); d300 = rpc(76); % U^3	16
a102 = rpc(17); b102 = rpc(37); c102 = rpc(57); d102 = rpc(77); % U*W^2	17
a021 = rpc(18); b021 = rpc(38); c021 = rpc(58); d021 = rpc(78); % V^2*W	18
a201 = rpc(19); b201 = rpc(39); c201 = rpc(59); d201 = rpc(79); % U^2*W	19
a003 = rpc(20); b003 = rpc(40); c003 = rpc(60); d003 = rpc(80); % W^3	20

if Sr == 1
    r_bracket_U = [a100 b100];
    r_bracket_V = [a010 b010];
    r_bracket_W = [a001 b001];
    c_bracket_U = [c100 d100];
    c_bracket_V = [c010 d010];
    c_bracket_W = [c001 d001];

elseif Sr == 2
    r_bracket_U = [a100 + a110 * V + a101 * W + 2 * a200 * U, b100 + b110 * V + b101 * W + 2 * b200 * U];
    r_bracket_V = [a010 + a110 * U + a011 * W + 2 * a020 * V, b010 + b110 * U + b011 * W + 2 * b020 * V];
    r_bracket_W = [a001 + a011 * V + a101 * U + 2 * a002 * W, b001 + b011 * V + b101 * U + 2 * b002 * W];
    c_bracket_U = [c100 + c110 * V + c101 * W + 2 * c200 * U, d100 + d110 * V + d101 * W + 2 * d200 * U];
    c_bracket_V = [c010 + c110 * U + c011 * W + 2 * c020 * V, d010 + d110 * U + d011 * W + 2 * d020 * V];
    c_bracket_W = [c001 + c011 * V + c101 * U + 2 * c002 * W, d001 + d011 * V + d101 * U + 2 * d002 * W];
    
elseif Sr == 3
    r_bracket_U = [a100 + a110 * V + a101 * W + 2 * a200 * U + a111 * V * W + 2 * a210 * V * U + a120 * V^2 + 3 * a300 * U^2 + a102 * W^2 + 2 * a201 * U * W, b100 + b110 * V + b101 * W + 2 * b200 * U + b111 * V * W + 2 *b210 * V * U + b120 * V^2 + 3 * b300 * U^2 + b102 * W^2 + 2 * b201 * U * W];
    r_bracket_V = [a010 + a110 * U + a011 * W + 2 * a020 * V + a111 * U * W + 3 * a030 * V^2 + a210 * U^2 + a012 * W^2 + 2 * a120 * V * U + 2 * a021 * V * W, b010 + b110 * U + b011 * W + 2 * b020 * V + b111 * U * W + 3 * b030 * V^2 + b210 * U^2 + b012 * W^2 + 2 * b120 * V * U + 2 * b021 * V * ];
    r_bracket_W = [a001 + a011 * V + a101 * U + 2 * a002 * W + a111 * U * V + 2 * a012 * V * W + 2 * a102 * U * W + a021 * V^2 + a201 * U^2 + 3 * a003 * W^2, b001 + b011 * V + b101 * U + 2 * b002 * W + b111 * U * V + 2 * b012 * V * W + 2 * b102 * U * W + b021 * V^2 + b201 * U^2 + 3 * b003 * W^2];
    c_bracket_U = [c100 + c110 * V + c101 * W + 2 * c200 * U + c111 * V * W + 2 * c210 * V * U + c120 * V^2 + 3 * c300 * U^2 + c102 * W^2 + 2 * c201 * U * W, d100 + d110 * V + d101 * W + 2 * d200 * U + d111 * V * W + 2 *d210 * V * U + d120 * V^2 + 3 * d300 * U^2 + d102 * W^2 + 2 * d201 * U * W];
    c_bracket_V = [c010 + c110 * U + c011 * W + 2 * c020 * V + c111 * U * W + 3 * c030 * V^2 + c210 * U^2 + c012 * W^2 + 2 * c120 * V * U + 2 * c021 * V * W, d010 + d110 * U + d011 * W + 2 * d020 * V + d111 * U * W + 3 * d030 * V^2 + d210 * U^2 + d012 * W^2 + 2 * d120 * V * U + 2 * d021 * V * ];
    c_bracket_W = [c001 + c011 * V + c101 * U + 2 * c002 * W + c111 * U * V + 2 * c012 * V * W + 2 * c102 * U * W + c021 * V^2 + c201 * U^2 + 3 * c003 * W^2, d001 + d011 * V + d101 * U + 2 * d002 * W + d111 * U * V + 2 * d012 * V * W + 2 * d102 * U * W + d021 * V^2 + d201 * U^2 + 3 * d003 * W^2];
end

A11 = r_bracket_U(1) / B - (A / B^2) * r_bracket_U(2);
A12 = r_bracket_V(1) / B - (A / B^2) * r_bracket_V(2);
A13 = r_bracket_W(1) / B - (A / B^2) * r_bracket_W(2);

A21 = c_bracket_U(1) / D - (C / D^2) * c_bracket_U(2);
A22 = c_bracket_V(1) / D - (C / D^2) * c_bracket_V(2);
A23 = c_bracket_W(1) / D - (C / D^2) * c_bracket_W(2);

A = [A11 A12 A13;
     A21 A22 A23];
    