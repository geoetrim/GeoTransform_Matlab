function lo = miscloser (g, A, Px)

for i = 1 : length(g(: , 1))
%     if s < 5 || s > 30 && s < 44
        lo(i , 1) = A(2 * i - 1, :) * Px;
        lo(i , 2) = A(2 * i    , :) * Px;
    % assignin('base','lo',lo);
%     elseif s == 5
%         lo(i , 1) = (Px(1) + Px(2) * g(i , 9) + Px(3) * g(i , 10)) / (1 + Px(7) * g(i , 9) + Px(8) * g(i , 10));
%         lo(i , 2) = (Px(4) + Px(5) * g(i , 9) + Px(6) * g(i , 10)) / (1 + Px(7) * g(i , 9) + Px(8) * g(i , 10));
% 
%     elseif s == 6
%         lo(i , 1) = (Px(1) + Px(2) * g(i , 9) +  Px(3) * g(i , 10) +  Px(4) * g(i , 11)) / (1 + Px(5) * g(i , 9) + Px(6) * g(i , 10) + Px(7) * g(i , 11));
%         lo(i , 2) = (Px(8) + Px(9) * g(i , 9) + Px(10) * g(i , 10) + Px(11) * g(i , 11)) / (1 + Px(5) * g(i , 9) + Px(6) * g(i , 10) + Px(7) * g(i , 11));
% 
%     elseif s > 70  && s < 74   
%         lo(i , :) = rfm_lo(s, g(i , 9 : 11), Px);
%     end
end
assignin('base','lo',lo);