%Cholesky yöntemi ile matris indirgeme.
%Dengeleme Hesabý 1, Ergün Öztürk, syf: 66
% clear all; clc;

%A matrisi simetrik matris olmalýdýr.
 
function dx_cholesky_ind = cholesky_ind(A , w)

a = [A -w];

n = length(A(1 , :));

for i = 1 : n
    
    if i == 1
        
        c(i , i) = sqrt(a(i , i));
            
        c(i , 2 : n + 1)=a(i , 2 : n + 1) / c(i , i);
        
    elseif i > 1
        
        c(i , i) = sqrt(a(i , i) - sum(c(1 : i - 1 , i).* c(1 : i - 1 , i)));
                 
        for j = i + 1 : n + 1
                    
            c(i , j) = (a(i , j) - sum(c(1 : i - 1 , i).* c(1 : i - 1 , j))) / c(i , i);
                   
        end
        
    end
    
end

for k = n : - 1 : 1
    
    if k == n
        
        dx_cholesky_ind(k , 1) = - c(k , n + 1) / c(k , k);
  
    elseif k < n
        
        dx_cholesky_ind(k) = - 1 / sqrt(c(k , k)) * (c(k , k + 1 : n) * dx_cholesky_ind(k + 1 : n) / sqrt(c(k , k)) + c(k , n + 1) / sqrt(c(k , k)));
   
    end
    
end