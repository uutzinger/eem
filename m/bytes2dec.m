function [result] = bytes2dec(bytes)
[m,n]=size(bytes);
result=sum(bytes.*[[256.^[m-1:-1:0]']*[ones(1,n)]],1);