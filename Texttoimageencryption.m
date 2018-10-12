clc;
clear;
close all;
filename = fullfile(matlabroot,'1.txt');
fid  = fopen('1.txt','r') ;
C = fscanf(fid,'%c');
L = strlength(C);
%original length of text
N = floor(L/128);
H = C;
H(end+1:N*ceil(numel(H)/N)) = 0;     
%padding
A = strlength(H);
B = reshape(H,(A/N),N); 
B = B';
D2 = double(B);
D = double(H);
[s1,d1] = size(D);
opt.method='SHA-256';
opt.format='HEX';
msg= DataHash(D2,opt);
xx=0.275648900231572;
pp=0.347823654894159;
l = strlength(msg);
X1=xx-((sum(msg(1:10))/10^15)-ceil(sum(msg(1:10))/10^15))/10^2;
P1=pp-((sum(msg(11:20))/10^15)-ceil(sum(msg(11:20))/10^15))/10^2;
map1=piecewiselinearchaoticmap(P1,d1,X1);
[psort1,index1]=sort(map1,'descend');
L1=zeros(s1,d1);
    for j=1:d1
    L1(1,j)=D(1,index1(j));
    end
Ll = reshape(L1,(A/N),N);
[s2,d2] = size(D2);
X2=xx-((sum(msg(21:31))/10^15)-ceil(sum(msg(21:31))/10^15))/10^2;
P2=pp-((sum(msg(32:42))/10^15)-ceil(sum(msg(32:42))/10^15))/10^2;
map2=piecewiselinearchaoticmap(P2,(7*d2),X2)
[psort2,index2]=sort(map2,'descend');
th2 = 0.6;
for i = 1:(7*d2)
    if map2(1,i)>th2
        map2(1,i) = 1;
    else if map2(1,i)<th2
            map2(1,i) = 0;
        end
    end
end
%7bit binary to decimal conversion
ress2 = zeros(1, d2);
count=0;
for i = 1:7:((7*d2)-7)
    count = count+1;
    flag1 = map2(i : i+6);
     res = 0;
     for j=1:7
         res = res + flag1(j)*(2^(7-j));
     end
    %res = bi2de(flag1);
    ress2(count) = res;
end
% reverse conversion correct below
% map3 = de2bi(ress2);  
% map3 = map3';
% map3 = reshape (map3,1,7*d2);
L3(:,1) = bitxor(ress2',Ll(:,1));

for i = 2:s2
    L3(:,i) = bitxor(L3(:,i-1),Ll(:,i));
end
[s3,d3] = size(D2);
X3=xx-((sum(msg(43:53))/10^15)-ceil(sum(msg(43:53))/10^15))/10^2;
P3=pp-((sum(msg(54:64))/10^15)-ceil(sum(msg(54:64))/10^15))/10^2;
map3=piecewiselinearchaoticmap(P3,(7*s3),X3)
[psort3,index3]=sort(map3,'descend');
th3 = 0.6;
for i = 1:(7*s3)
    if map3(1,i)>th3
        map3(1,i) = 1;
    else if map3(1,i)<th3
            map3(1,i) = 0;
        end
    end
end
ress3 = zeros(1,s3);
count3=0;
for i = 1:7:((7*s3)-7)
    count3 = count3+1;
    flag3 = map3(i : i+6);
     res3 = 0;
     for j=1:7
         res3 = res3 + flag3(j)*(2^(7-j));
     end
    %res = bi2de(flag1);
    ress3(count3) = res3;
end
L4(1,:) = bitxor(ress3',L3(1, :)');
for i = 2:d3
    L4(i,:) = bitxor(L4(i-1,:),L3(i,:));
end
L5 = uint8(L4);
imwrite(L5,'cipher.tiff');
%encryption
imshow(L5);