
clear all; clc; close all;

% Define parameters
center = [0, 0];     % Center Fault
L = 1000;           % Length
W = 100;            % Width
strike = 200;    % Rotation angle (clockwise from North)
dip = 60;

% Get rotated corners
W = cosd(dip) * W
rotated_corners = RotatedRectangle(center, L, W, strike)

llh=local2llh(rotated_corners',[140,40]);
Lon_Lat = llh'



% Plot the rectangle
figure;
subplot(1,2,1)
plot(rotated_corners(:,1), rotated_corners(:,2), 'b-', 'LineWidth', 2);
hold on;
plot(center(1), center(2), 'ro', 'MarkerFaceColor', 'r');
axis equal;
grid on;
title(sprintf('Rectangle (L=%.0f, W=%.0f) rotated %.0f° from North', L, W, strike));
xlabel('X');
ylabel('Y');

% Plot the rectangle
subplot(1,2,2)
plot(Lon_Lat(:,1), Lon_Lat(:,2), 'b-', 'LineWidth', 2);
hold on;
plot(140,40, 'ro', 'MarkerFaceColor', 'r');
axis equal;
grid on;
title('Lat Lon');
xlabel('X');
ylabel('Y');



%%
function rotated_corners = RotatedRectangle(center, L, W, strike)
% GETROTATEDRECTANGLECORNERS Calculate coordinates of a rotated rectangle
%   rotated_corners = getRotatedRectangleCorners(center, L, W, angle_deg)
%   returns the corner coordinates of a rectangle centered at [x,y], with
%   length L, width W, rotated by angle_deg degrees clockwise from North.
%
%   Inputs:
%       center    - [x,y] coordinates of rectangle center
%       L         - Length of rectangle (major axis)
%       W         - Width of rectangle (minor axis)
%       angle_deg - Rotation angle in degrees clockwise from North
%
%   Output:
%       rotated_corners - 5x2 matrix of [x,y] coordinates (first point repeated to close polygon)

    % Convert angle to mathematical convention (CCW from +x axis)
    math_angle_deg = 90 - strike;  % Convert to CCW from East
    
    % Calculate corner offsets (unrotated, centered at origin)
    corners = [L/2  W/2;   % Top-right
              -L/2  W/2;   % Top-left
              -L/2 -W/2;   % Bottom-left
               L/2 -W/2];  % Bottom-right
    
    % Rotation matrix
    theta = deg2rad(math_angle_deg);
    R = [cos(theta) -sin(theta);
         sin(theta)  cos(theta)];
    
    % Rotate and shift corners
    rotated_corners = (R * corners')' + center;
    
    % Close the polygon by repeating first point
    rotated_corners = [rotated_corners; rotated_corners(1,:)];
end
%%
%%======================================================================================================
function llh=local2llh(xy,origin)
%local2llh     llh=local2llh(xy,origin)
%
%Converts from local coorindates to longitude and latitude 
%given the [lon, lat] of an origin. 'origin' should be in 
%decimal degrees. Note that heights are ignored and that 
%xy is in km.  Output is [lon, lat, height] in decimal 
%degrees. This is an iterative solution for the inverse of 
%a polyconic projection.

%-------------------------------------------------------------
%   Record of revisions:
%
%   Date          Programmer            Description of Change
%   ====          ==========            =====================
%
%   Aug 23, 2001  Jessica Murray        Clarification to help.
%
%   Apr 4, 2001   Peter Cervelli        Added failsafe to avoid
%                                       infinite loop because of
%                                       covergence failure.
%   Sep 7, 2000   Peter Cervelli		Original Code
%
%-------------------------------------------------------------

%Set ellipsoid constants (WGS84)

   a=6378137.0;
   e=0.08209443794970;

%Convert to radians / meters

   xy=xy*1000;
   origin=origin*pi/180;

%Iterate to perform inverse projection

   M0=a*((1-e^2/4-3*e^4/64-5*e^6/256)*origin(2) - ...
        (3*e^2/8+3*e^4/32+45*e^6/1024)*sin(2*origin(2)) + ...
        (15*e^4/256 +45*e^6/1024)*sin(4*origin(2)) - ...
        (35*e^6/3072)*sin(6*origin(2)));

   z=xy(2,:)~=-M0;

   A=(M0+xy(2,z))/a;
   B=xy(1,z).^2./a^2+A.^2;

   llh(2,z)=A;

   delta=Inf;

   c=0;
   
   while max(abs(delta))>1e-8

      C=sqrt((1-e^2*sin(llh(2,z)).^2)).*tan(llh(2,z));

      M=a*((1-e^2/4-3*e^4/64-5*e^6/256)*llh(2,z) - ...
           (3*e^2/8+3*e^4/32+45*e^6/1024)*sin(2*llh(2,z)) + ...
           (15*e^4/256 +45*e^6/1024)*sin(4*llh(2,z)) - ...
           (35*e^6/3072)*sin(6*llh(2,z)));

      Mn=1-e^2/4-3*e^4/64-5*e^6/256 - ...
         -2*(3*e^2/8+3*e^4/32+45*e^6/1024)*cos(2*llh(2,z)) + ...
         4*(15*e^4/256 +45*e^6/1024)*cos(4*llh(2,z)) + ...
         -6*(35*e^6/3072)*cos(6*llh(2,z));

      Ma=M/a;
   
      delta=-(A.*(C.*Ma+1)-Ma-0.5*(Ma.^2+B).*C)./ ...
           (e^2*sin(2*llh(2,z)).*(Ma.^2+B-2*A.*Ma)./(4*C)+(A-Ma).*(C.*Mn-2./sin(2*llh(2,z)))-Mn);

      llh(2,z)=llh(2,z)+delta;

      c=c+1;
      if c>100
          error('Convergence failure.')
      end
   end

   llh(1,z)=(asin(xy(1,z).*C/a))./sin(llh(2,z))+origin(1);

%Handle special case of latitude = 0

   llh(1,~z)=xy(1,~z)/a+origin(1);
   llh(2,~z)=0;

%Convert back to decimal degrees

   llh=llh*180/pi;
end
