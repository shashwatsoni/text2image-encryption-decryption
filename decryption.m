clc;
clear;
close all;
L6=imread('cipher.tiff');
msg = '3803fe009563a93781f74b31b926a36536317da1b7d657d9421434413a9dc3a8';
xx=0.275648900231572;
pp=0.347823654894159;
X4=xx-((sum(msg(43:53))/10^15)-ceil(sum(msg(43:53))/10^15))/10^2;
P4=pp-((sum(msg(54:64))/10^15)-ceil(sum(msg(54:64))/10^15))/10^2;
L6 = double(L6);
[s4,d4] = size(L6');
map4=piecewiselinearchaoticmap(P4,(7*s4),X4)
[psort4,index4]=sort(map4,'descend');
th4 = 0.6;
for i = 1:(7*s4)
    if map4(1,i)>th4
        map4(1,i) = 1;
    else if map4(1,i)<th4
            map4(1,i) = 0;
        end
    end
end
ress4 = zeros(1,s4);
count4=0;
for i = 1:7:((7*s4)-7)
    count4 = count4+1;
    flag4 = map4(i : i+6);
     res4 = 0;
     for j=1:7
         res4 = res4 + flag4(j)*(2^(7-j));
     end
    %res = bi2de(flag1);
    ress4(count4) = res4;
end
L7(1, :) = bitxor(ress4,L6(1,:)); 
for i = 2:d4
    L7(i,:) = bitxor(L6(i-1,:),L6(i,:)); 
end
[s5,d5] = size(L6');
X5=xx-((sum(msg(21:31))/10^15)-ceil(sum(msg(21:31))/10^15))/10^2;
P5=pp-((sum(msg(32:42))/10^15)-ceil(sum(msg(32:42))/10^15))/10^2;
map5=piecewiselinearchaoticmap(P5,(7*d5),X5)
[psort5,index5]=sort(map5,'descend');
th5 = 0.6;
for i = 1:(7*d5)
    if map5(1,i)>th5
        map5(1,i) = 1;
    else if map5(1,i)<th5
            map5(1,i) = 0;
        end
    end
end
%7bit binary to decimal conversion
ress5 = zeros(1, d5);
count5=0;
for i = 1:7:((7*d5)-7)
    count5 = count5+1;
    flag5 = map5(i : i+6);
     res5 = 0;
     for j=1:7
         res5 = res5 + flag5(j)*(2^(7-j));
     end
    %res = bi2de(flag1);
    ress5(count5) = res5;
end
L7 = double(L7);
  L8(:,1)= bitxor(ress5',L7(:,1));

for i = 2:s5
    L8(:,i) = bitxor(L7(:,i-1),L7(:,i)); 
end
L9 = reshape(L8,1,(s4*d4));
[s6,d6] = size(L9);
X6=xx-((sum(msg(1:10))/10^15)-ceil(sum(msg(1:10))/10^15))/10^2;
P6=pp-((sum(msg(11:20))/10^15)-ceil(sum(msg(11:20))/10^15))/10^2;
map6=piecewiselinearchaoticmap(P6,d6,X6);
[psort6,index6]=sort(map6,'descend');
for i=1:s6
    for j=1:d6
    O(i,index6(j))=L9(i,j);
    end
end
%Decryption
G= char(O);
%decrypted text with matrix
G = G';
G = reshape(G,1,s4*d4);
O = G(:,1:22261);    
%decrypted text with matrix without padding