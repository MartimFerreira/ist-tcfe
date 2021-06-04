pkg load control

%Componentes
R1=1000
R2=10000

% para o circuito que o professor pôs inicialmente no ngspice
Gain = -R2/R1;
Zi = R1;
Zo = 0;
% queremos ter um Gain e Zi elevados e uma Zo baixa


% para o circuito que eu tinha visto
% Gain = 1 + R3/R4
% Zi = Vi/Ii quando Zl = inf
% Zo = Vo/Io quando Vi = 0




% sites que acho que podem dar jeito
%https://www.electronics-tutorials.ws/filter/filter_7.html
%http://www.learningaboutelectronics.com/Articles/Active-op-amp-bandpass-filter-circuit.php










 
% 8 decades and 10 points per decade => 80 points


%k1 = 80

%freq1=logspace(1,8, k1);



%t1=1
%w1=2*pi*freq1
VS1=0.01							       
	   
%gain1 = - gm1 * (RC1*ro1)/(RC1+ro1) * ((RB1*RB2+rpi1*RB2+rpi1*RB1)/(rpi1*RB1*RB2)) / (RS+(RB1*RB2+rpi1*RB2+rpi1*RB1)/(rpi1*RB1*RB2)) % * VS1


%%%%%%%%%%%%%%%   MAG TO DB   %%%%%%%%%%%%%%%%%%%%%%%%
%AV1wdb = mag2db(abs(AV1w))
%AV1simplewdb = mag2db(abs(AV1simplew))
  
%AV1db = mag2db(abs(AV1))
%gain1db = mag2db(abs(gain1))
%AV1simpledb= mag2db(abs(AV1simple))
%AV1simple2db= mag2db(abs(AV1simple2))
  

%vmag_plot1 = figure ();
%semilogx (freq1, abs(AV1simple2db), "r");

%xlabel ("f[Hz]");
%ylabel ("Vo(f)/Vi(f)[dB]"); 
%legenda= legend("Frequency response"); 
%print (vmag_plot1, "vmag_plot1.eps", "-depsc");





%AV22= mag2db(abs(AV2))

%vmag_plot2 = figure ();
%semilogx (freq1, AV2, "b");

%xlabel ("f[Hz]");
%ylabel ("Vo(f)/Vi(f)[dB]"); 
%legenda= legend("Frequency response"); 
%print (vmag_plot2, "vmag_plot2.eps", "-depsc");


%final_gain= AV1simple2*AV2
%final_gaindb= mag2db(abs(final_gain))

%final_impedance = ZO1*ZO2  
	      
		     
%vmag_plot3 = figure ();
%semilogx (freq1, final_gaindb, "r");

%xlabel ("f[Hz]");
%ylabel ("Vo(f)/Vi(f)[dB]"); 
%legenda= legend("Frequency response"); 
%print (vmag_plot3, "vmag_plot3.eps", "-depsc");




%%%%%%%%%%%%%% TABLE WITH VALUES (FOR LATEX) %%%%%%%%%%%%%%%%%%%%
%resistance_tab = fopen("resistance_tab.tex", "w");

%fprintf(resistance_tab, "$V_{CC}\\;(V)$ & %.1e\\\\ \\hline\n", VCC);
%fprintf(resistance_tab, "$R_{S}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RS);
%fprintf(resistance_tab, "$R_{E1}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RE1);
%fprintf(resistance_tab, "$R_{C1}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RC1);
%fprintf(resistance_tab, "$R_{B1}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RB1);
%fprintf(resistance_tab, "$R_{B2}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RB2);
%fprintf(resistance_tab, "$R_{E2}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RE2);
%fprintf(resistance_tab, "$C_{i}\\;(mF)$ & %.1e\\\\ \\hline\n", 1);
%fprintf(resistance_tab, "$C_{e}\\;(mF)$ & %.1e\\\\ \\hline\n", 0.5);
%fprintf(resistance_tab, "$C_{o}\\;(mF)$ & %.1e\\\\ \\hline\n", 0.5);

%fclose(resistance_tab);


