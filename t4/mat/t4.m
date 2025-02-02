pkg load control

% ---- GAIN STAGE ----

% values

VT=25e-3
BFN=178.7     %parametro beta do modelo BC5474
VAFN=69.7     %parametro Va do modelo BC5474 
RE1=80        %resistencia do emissor
RC1=1000      %resitencia do coletor
RB1=80000     %resistencia bias 1
RB2=20000     %resistencia bias 2
VBEON=0.7     %tensao a partir da qual o transistor deixa passar
VCC=12        %DC value da fonte
RS=100        %Resistencia interna 


%%%%%%%%%%%%%%%%%%%%GAIN STAGE: INCREMENTAL CIRCUIT%%%%%%%%%%%%%%%%%%%%%%%
			       
RB=1/(1/RB1+1/RB2)                 %resistencia equivalente bias

			           %pode haver erro de sinal no VEQ
			       
VEQ=RB2/(RB1+RB2)*VCC              %tensao equivalente thevnian
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)   %corrente malha B
IC1=BFN*IB1                        %corrente malha C


gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1
			           
IE1=(1+BFN)*IB1                   %corrente emissor
VE1=RE1*IE1                       %tensao emissor
VO1=VCC-RC1*IC1                   %tensao coletor -> tensao de saida do Gain Stage
VCE=VO1-VE1                       %diferenca entre tensao do coletor e emissor
                                
				  %ver se VCE e maior que VBEON
							       


%gain without CE - bypass capacitor							       
AV1w = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AV1simplew = gm1*RC1/(1+gm1*RE1)




							       
%gain with CE - bypass capacitor				       
RE1=0

							       
AV1= RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AV1simple = gm1*RC1/(1+gm1*RE1)
							       
AV1simple2 = gm1*RC1/(1+gm1*RE1) * rpi1/ (RS + rpi1)
							       


							       
RE1=100
%Impedance Calculations
ZI1 = ((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)
ZX = ro1*((RB+rpi1)*RE1/(RB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RB)+1/RE1+gm1*rpi1/(rpi1+RB)))
ZO1 = 1/(1/ZX+1/RC1)

%in the slides it is ZI1 = 1/(1/RB1+1/RB2+1/rpi1) and ZO1 = 1/(1/RC1+1/ro1)
%RE1 = 0
 
 
% 8 decades and 10 points per decade => 80 points


k1 = 80

freq1=logspace(1,8, k1);



%t1=1
%w1=2*pi*freq1
VS1=0.01							       
	   
gain1 = - gm1 * (RC1*ro1)/(RC1+ro1) * ((RB1*RB2+rpi1*RB2+rpi1*RB1)/(rpi1*RB1*RB2)) / (RS+(RB1*RB2+rpi1*RB2+rpi1*RB1)/(rpi1*RB1*RB2)) % * VS1


%%%%%%%%%%%%%%%   MAG TO DB   %%%%%%%%%%%%%%%%%%%%%%%%
AV1wdb = mag2db(abs(AV1w))
AV1simplewdb = mag2db(abs(AV1simplew))
  
AV1db = mag2db(abs(AV1))
gain1db = mag2db(abs(gain1))
AV1simpledb= mag2db(abs(AV1simple))
AV1simple2db= mag2db(abs(AV1simple2))
  

vmag_plot1 = figure ();
semilogx (freq1, abs(AV1simple2db), "r");

xlabel ("f[Hz]");
ylabel ("Vo(f)/Vi(f)[dB]"); 
legenda= legend("Frequency response"); 
print (vmag_plot1, "vmag_plot1.eps", "-depsc");





% ---- OUTPUT STAGE ----

% values
BFP = 227.3
VAFP = 37.2
RE2 = 300
VEBON = 0.7

VI2 = VO1 % shouldn't it be VI2 = VO-VEBON ?
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2


gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2


AV2 = gm2/(gm2+gpi2+go2+ge2)





ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)

AV22= mag2db(abs(AV2))

vmag_plot2 = figure ();
semilogx (freq1, AV2, "b");

xlabel ("f[Hz]");
ylabel ("Vo(f)/Vi(f)[dB]"); 
legenda= legend("Frequency response"); 
print (vmag_plot2, "vmag_plot2.eps", "-depsc");


final_gain= AV1simple2*AV2
final_gaindb= mag2db(abs(final_gain))

%final_impedance = ZO1*ZO2  
	      
		     
vmag_plot3 = figure ();
semilogx (freq1, final_gaindb, "r");

xlabel ("f[Hz]");
ylabel ("Vo(f)/Vi(f)[dB]"); 
%legenda= legend("Frequency response"); 
print (vmag_plot3, "vmag_plot3.eps", "-depsc");




%%%%%%%%%%%%%% TABLE WITH VALUES (FOR LATEX) %%%%%%%%%%%%%%%%%%%%
resistance_tab = fopen("resistance_tab.tex", "w");

fprintf(resistance_tab, "$V_{CC}\\;(V)$ & %.1e\\\\ \\hline\n", VCC);
fprintf(resistance_tab, "$R_{S}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RS);
fprintf(resistance_tab, "$R_{E1}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RE1);
fprintf(resistance_tab, "$R_{C1}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RC1);
fprintf(resistance_tab, "$R_{B1}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RB1);
fprintf(resistance_tab, "$R_{B2}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RB2);
fprintf(resistance_tab, "$R_{E2}\\;(\\Omega)$ & %.1e\\\\ \\hline\n", RE2);
fprintf(resistance_tab, "$C_{i}\\;(mF)$ & %.1e\\\\ \\hline\n", 1);
fprintf(resistance_tab, "$C_{e}\\;(mF)$ & %.1e\\\\ \\hline\n", 0.5);
fprintf(resistance_tab, "$C_{o}\\;(mF)$ & %.1e\\\\ \\hline\n", 0.5);

fclose(resistance_tab);

resistance1_tab = fopen("resistance1_tab.tex", "w");

fprintf(resistance1_tab, "$V_T\\;(V)$ & %.3e\\\\ \\hline\n", VT);
fprintf(resistance1_tab, "$\\beta_{FN}$ & %.3e\\\\ \\hline\n", BFN);
fprintf(resistance1_tab, "$V_{AFN}\\;(V)$ & %.3e\\\\ \\hline\n", VAFN);
fprintf(resistance1_tab, "$V_{EBON}\\;(V)$ & %.3e\\\\ \\hline\n", VEBON);
fprintf(resistance1_tab, "$\\beta_{FP}$ & %.3e\\\\ \\hline\n", BFP);
fprintf(resistance1_tab, "$V_{AFP}\\;(V)$ & %.3e\\\\ \\hline\n", VAFP);

fclose(resistance1_tab);




resultsDC1_tab = fopen("resultsDC1_tab.tex", "w");

fprintf(resultsDC1_tab, "$R_B\\;(\\Omega)$ & %.6e\\\\ \\hline\n", RB);
fprintf(resultsDC1_tab, "$V_{eq}\\;(V)$ & %.6e\\\\ \\hline\n", VEQ);
fprintf(resultsDC1_tab, "$I_{B1}\\;(A)$ & %.6e\\\\ \\hline\n", IB1);
fprintf(resultsDC1_tab, "$I_{C1}\\;(A)$ & %.6e\\\\ \\hline\n", IC1);
fprintf(resultsDC1_tab, "$I_{E1}\\;(A)$ & %.6e\\\\ \\hline\n", IE1);
fprintf(resultsDC1_tab, "$V_{E1}\\;(V)$ & %.6e\\\\ \\hline\n", VE1);
fprintf(resultsDC1_tab, "$V_{O1}\\;(V)$ & %.6e\\\\ \\hline\n", VO1);
fprintf(resultsDC1_tab, "$V_{CE}\\;(V)$ & %.6e\\\\ \\hline\n", VCE);

fclose(resultsDC1_tab);




resultsDC2_tab = fopen("resultsDC2_tab.tex", "w");

fprintf(resultsDC2_tab, "$V_{I2}\\;(V)$ & %.6e\\\\ \\hline\n", VI2);
fprintf(resultsDC2_tab, "$I_{E2}\\;(A)$ & %.6e\\\\ \\hline\n", IE2);
fprintf(resultsDC2_tab, "$I_{C2}\\;(A)$ & %.6e\\\\ \\hline\n", IC2);
fprintf(resultsDC2_tab, "$V_{O2}\\;(V)$ & %.6e\\\\ \\hline\n", VO2);

fclose(resultsDC2_tab);




resultsAC1_tab = fopen("resultsAC1_tab.tex", "w");

%fprintf(resultsAC1_tab, "$Gain_1\\;(without \ C_E)$ & %.6e\\\\ \\hline\n", AV1simplew);
%fprintf(resultsAC1_tab, "$Gain_1\\;(with \ C_E)$ & %.6e\\\\ \\hline\n", AV1simple2);
fprintf(resultsAC1_tab, "$Gain_1$ & %.6e\\\\ \\hline\n", AV1simple2);
fprintf(resultsAC1_tab, "$Z_{I1}\\;(\\Omega)$ & %.6e\\\\ \\hline\n", ZI1);
fprintf(resultsAC1_tab, "$Z_{O1}\\;(\\Omega)$ & %.6e\\\\ \\hline\n", ZO1);

fclose(resultsAC1_tab);




resultsAC2_tab = fopen("resultsAC2_tab.tex", "w");

fprintf(resultsAC2_tab, "$Gain_2$ & %.6e\\\\ \\hline\n", AV2);
fprintf(resultsAC2_tab, "$Z_{I2}\\;(\\Omega)$ & %.6e\\\\ \\hline\n", ZI2);
fprintf(resultsAC2_tab, "$Z_{O2}\\;(\\Omega)$ & %.6e\\\\ \\hline\n", ZO2);

fclose(resultsAC2_tab);




final_tab = fopen("final_tab.tex", "w");

fprintf(final_tab, "$Gain$ & %.6e\\\\ \\hline\n", AV1simple2*AV2);
fprintf(final_tab, "$Z_I\\;(\\Omega)$ & %.6e\\\\ \\hline\n", ZI1);
fprintf(final_tab, "$Z_O\\;(\\Omega)$ & %.6e\\\\ \\hline\n", ZO2);

fclose(final_tab);



% Point 2 explanation (why both stages can be connected without significant signal loss)

% thanks to a coupling capacitor and a bias circuit

% https://www.audioholics.com/audio-amplifier/amplifier-classes
% Note: there are different types of audio amplifiers

% https://www.youtube.com/watch?v=-fIpj2eHL0k
% In the gain stage we have a NPN transistor (positive part of the signal).
% In the output stage we have a PNP transistor (negative part of the signal).

% https://www.electronics-tutorials.ws/amplifier/amp_1.html
% In the Common Emitter Transistor, for the transistor to operate within its “Active Region” some form of “Base Biasing” was required. This small Base Bias voltage added to the input signal allowed the transistor to reproduce the full input waveform at its output with no loss of signal.

% https://www.allaboutcircuits.com/worksheets/bjt-amplifier-troubleshooting/
% https://www.electronics-tutorials.ws/amplifier/class-ab-amplifier.html
% https://www.pearsonhighered.com/assets/samplechapter/0/1/3/4/0134420101.pdf
% https://wiki.analog.com/university/courses/electronics/text/chapter-10
% https://www.sciencedirect.com/topics/computer-science/amplifier-stage
