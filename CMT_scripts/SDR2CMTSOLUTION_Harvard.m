% 2001 Hollywood Earthquake — Harvard CMT calculation
clc;

% Input (in degrees)
strike = 252;
dip = 78;
rake = -162;
Mw = 4.19;


M0 = 10^((1.5 * Mw) + 9.1);  % N.m
M0_sub = M0 * 1e7; % N.m --> dyn.cm


D = deg2rad(dip);
S = deg2rad(strike);
R = deg2rad(rake);

Mxx = -1.0 * ( sin(D) * cos(R) * sin (2*S) + sin(2*D) * sin(R) * sin(S)*sin(S) );
Myy =        ( sin(D) * cos(R) * sin (2*S) - sin(2*D) * sin(R) * cos(S)*cos(S) ); 
Mzz = -1.0 * ( Mxx + Myy);               
Mxy =        ( sin(D) * cos(R) * cos (2*S) + 0.5 * sin(2*D) * sin(R) * sin(2*S) );  
Mxz = -1.0 * ( cos(D) * cos(R) * cos (S)   + cos(2*D) * sin(R) * sin(S) );  
Myz = -1.0 * ( cos(D) * cos(R) * sin (S)   - cos(2*D) * sin(R) * cos(S) );    


% convert to Harvard CMTSOLUTION format
Mtt = Mxx ;
Mpp = Myy ;
Mrr = Mzz ;
Mtp = Mxy * -1 ;
Mrt = Mxz ;
Mrp = Myz * -1 ;



fprintf("\nOutput Harvard CMTSOLUTION:  Mrr Mtt Mpp Mrt Mrp Mtp\n");
    fprintf('Mrr:      %13.5fe+23\n', Mrr*M0_sub / 1e23);
    fprintf('Mtt:      %13.5fe+23\n', Mtt*M0_sub / 1e23);
    fprintf('Mpp:      %13.5fe+23\n', Mpp*M0_sub / 1e23);
    fprintf('Mrt:      %13.5fe+23\n', Mrt*M0_sub / 1e23);
    fprintf('Mrp:      %13.5fe+23\n', Mrp*M0_sub / 1e23);
    fprintf('Mtp:      %13.5fe+23\n', Mtp*M0_sub / 1e23);
    