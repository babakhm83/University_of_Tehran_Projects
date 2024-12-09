len=32;
Mapset=cell(2,len);
for i=1:len
   Mapset{1,i}=char('a'+i-1);
   Mapset{2,i}=dec2bin(i-1,ceil(log2(len)));
end
Mapset{1,27}=char(' ');
Mapset{1,28}=char('.');
Mapset{1,29}=char(',');
Mapset{1,30}=char('!');
Mapset{1,31}=char('"');
Mapset{1,32}=char(';');
save Mapset Mapset;