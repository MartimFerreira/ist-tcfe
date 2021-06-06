

%Componentes

R1=10e3;
R2=5e2;
R3=100e3;
R4=1e3;
R5=100e3; 
C1=220e-9;
C2=220e-9;
C3=220e-9; 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exercicio 1 

f=1000;

w=2*pi*f;

%Impedancias condensadores
ZC1=1/(j*w*C1);
ZC2=1/(j*w*C2);
ZC3=1/(j*w*C3);
Zpar=(1/(1/R5+1/ZC3));


%Impedancia in & out 
Zin=abs(ZC1+R1)
  Zout=abs(1/(1/R2+1/(ZC2+Zpar)));

  
%high  pass filter

Vi=1; 
Vl=R1/(R1+ZC1)*Vi;
wl=1/(R1*C1);       %low cut off frequency



%Amplification
Va=(1+R3/R4)*Vl;



%low pass filter
Vh= Va;
wh=1/(R2*(C2/2));      %high cut off frequency


gain=abs(Vh);
gain_db=20*log10(gain)

gain_dev=gain_db-40


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exercicio 2

t=1:0.1:8;

w=2*pi*power(10,t);

ZC1=1./(j*w*C1);
ZC2=1./(j*w*(C2+C3)); 
ZC3=1./(j*w*C3);

Vl=R1./(R1+ZC1);
A=(1+R3/R4).*Vl;
fgain=abs(ZC2./(ZC2+R2).*A);


fgain_db=20*log10(fgain);

max_gain=max(fgain_db)


  
freq_graph = figure();
plot (t, fgain_db, "m");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB");
print (freq_graph, "graph.eps", "-depsc");















	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%modelo nao ideal

%modelo nao ideal ampop
%Zi=966.3157e3 + j*2.850914e-2
%Zo=5.000960e1 - j*5.09420e-3
%Av=(Zo+1)*(-1.12308e-2 -j*1.95016e-1)


%freq=logspace(1,8,7000);

%for i=freq


  
%w=2*pi*i;


%ZC1=1./(j*w*C1);
%ZC2=1./(j*w*C2);
%ZC3=1./(j*w*C3);

%Vl=R1./(R1+ZC1);
%A=(1+R3/R4).*Vl;
%Vh= A;
%fgain=abs(Vh);
%fgain_db=20*log10(fgain);

%max_gain=max(fgain_db);

%Zeq= ZC2+(ZC3*R5/(ZC3+R5));

%B=[1/Zo + 1/(Zeq) + 1/R3 , -Av/Zo + 1/R3;
%      1/R3 , 1/Zi + 1/R3 + 1/R4;];

%C = [Vl/R3 , Vl/R3 + Vl/R4];

%D= C/B;

%Vout=D(1)

%endfor

%fgain=abs(Vout/Vi);
%fgain_db=20*log10(fgain);

