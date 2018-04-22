function Y = linear_map(X,original_range,map_range)
%% Linearly Maps a set of numbers to another scale
%% Inputs :
% X : The number to be mapped
% original_range : The original range of the variable e.g. ([0 10]), the
% minimum and maximum possible value that X can take
% map_range : The new min and maximum range that the number should be
% assigned to that range

%% Output : 
% Y : Mapped number

%% Part of : Algorithm is based on the following paper :

% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull

a1 = original_range(1);
a2 = original_range(2);

b1 = map_range(1);
b2 = map_range(2);

if original_range(1) ~= original_range(2)
 Y = b1 + ((X - a1).*(b2 - b1))./(a2 - a1);
else
 Y = X./original_range(1);
end

Y = round(Y);                       % map to nearest integer

end