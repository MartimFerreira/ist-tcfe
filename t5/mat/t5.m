

%Componentes

R1=10e3;
R2=1e3;
R3=100e3;
R4=1e3;
R5=100e3; 
C1=220e-9;
C2=220e-9;
C3=220e-9;

%modelo nao ideal

Vos=5e-3
Ios=7.975e-8


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exercicio 1 

f=1000;

w=2*pi*f;

%Impedancias condensadores
ZC1=1/(j*w*C1);
ZC2=1/(j*w*C2);
ZC3=1/(j*w*C3);


%Impedancia in & out 
Zin=abs(ZC1+R1)


Zout=abs(ZC2)

%low pass filter

Vi=1; 
Vl=R1/(R1+ZC1)*Vi;
wl=1/(R1*C1);       %low cut off frequency



%Amplification
Va=(1+R3/R4)*Vl;



%High pass filter
Vh= Va;
wh=1/(R2*C2);      %high cut off frequency


gain=abs(Vh)


gain_db=20*log10(gain)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exercicio 2

t=1:0.1:8;
w=2*pi*power(10,t);

ZC1=1./(j*w*C1);
ZC2=1./(j*w*C2);

Vl=R1./(R1+ZC1);
A=(1+R3/R4).*Vl;
Vh= A;
fgain=abs(Vh);
fgain_db=20*log10(fgain);

max_gain=max(fgain_db)


freq_graph = figure();
plot (t, fgain_db, "m");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB");
print (freq_graph, "graph.eps", "-depsc");

