C1=220e-9;
C2=220e-9;
R1=1e3;
R2=1e3;
R3=100e3;
R4=1e3;

f=1000;

w=2*pi*f;

Zc1=1/(j*w*C1);
Zc2=1/(j*w*C2);

Zin=abs(Zc1+R1)
Zout=abs(1/(1/R2+1/Zc2))

vp=R1/(R1+Zc1);
amp=(1+R3/R4)*vp;
gain=abs(Zc2/(Zc2+R2)*amp)
gain_db=20*log10(gain)





t=1:0.1:8;



w=2*pi*power(10,t);

Zc1=1./(j*w*C1);
Zc2=1./(j*w*C2);

vp=R1./(R1+Zc1);
amp=(1+R3/R4).*vp;
fgain=abs(Zc2./(Zc2+R2).*amp);
fgain_db=20*log10(fgain);

[max_gain,index_freq_central]=max(fgain_db)






freq_graph = figure();
plot (t, fgain_db, "m");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB");
print (freq_graph, "graph.eps", "-depsc");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
% para o circuito que o professor pôs inicialmente no ngspice
%Gain = -R2/R1;
%Zi = R1;
%Zo = 0;
% queremos ter um Gain e Zi elevados e uma Zo baixa


% para o circuito que eu tinha visto
% Gain = 1 + R3/R4
% Zi = Vi/Ii quando Zl = inf
% Zo = Vo/Io quando Vi = 0

% sites que acho que podem dar jeito
%https://www.electronics-tutorials.ws/filter/filter_7.html
%http://www.learningaboutelectronics.com/Articles/Active-op-amp-bandpass-filter-circuit.php


