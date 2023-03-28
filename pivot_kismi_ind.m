% clear all;clc;
% A=[1 20 1 3 5;9 5 100 4 4;5 100 3 4 8;6 3 3 2 4;4 2 3 2.2 4];w=[20;5;14;16;16];
% A=[5 6 7;10 12 3;20 17 19];w=[18;25;56];
% A=[2 15 10;-30 -2.249 7;5 1 3];w=[45;1.751;9];+

%% Kýsmi pivotlama ile Gauss indirgemesi

function dx_pivot_kismi_ind = pivot_kismi_ind(A , w)

A = [A w]; A(: , : , 1) = A;
n = length(A(: , 1 , 1));

    [nn ii] = max(abs(A(: , 1 , 1)));
     b(: , : , 1) = A(: , : , 1);
     b(1 , : , 1) = A(ii , : , 1);
     b(ii , : , 1) = A(1 , : , 1);  
     A = b;
     
for k = 1 : n - 1

    for i = k + 1 : n
        for j = k : n + 1
            b(i , j , k) = A(i , j , k) - A(i , k , k) / A( k , k , k) * A(k , j , k);
        end
    end
        b(: , : , k + 1) = b(: , : , k);
        c = b(k + 1 : n , : , k);
        c = [zeros(k , n + 1) ; c];     
        [nn ii] = max(abs(c(: , k + 1)));
        A(: , : , k + 1) = c(: , :);
        A(k + 1 , : , k + 1) = c(ii , :);
        A(ii , : , k + 1) = c(k + 1 , :);
end
    
for k = n : - 1 : 1
    if k == n
        dx_pivot_kismi_ind(k , 1) = b(k , n + 1  , n - 1) / b(k , k , n - 1);
    elseif k < n
        dx_pivot_kismi_ind(k , 1) = (b(k , n+1  , n-1) - (b(k , (k + 1) : n, n-1) * dx_pivot_kismi_ind((k + 1) : n , 1))) / b(k , k , n - 1);
    end
end