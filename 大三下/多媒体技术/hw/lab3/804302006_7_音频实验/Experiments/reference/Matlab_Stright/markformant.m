function formant = markformant(n3sgram)
%MARKFORMANT Summary of this function goes here
%   Detailed explanation goes here
% formant = markformant(n3sgram)
% this function traverses n3sgram and finds the formant and mark them on the matrix
% Input parameters
%   n3sgram : Smoothed time frequency representation (spectrogram)
% Output parameters
% formant   : matrix of formant (maybe i should use a vector instead of a matrix?)
lenx = length(n3sgram(1,:));
leny = length(n3sgram(:,1));

% create a new matrix with all zeros;
formant = zeros(leny,lenx);

[formant_value,formant_index]=max(n3sgram);

temp = 0;
temp_value = 0;
for i =1:length(formant_value)
    temp = temp+ formant_index(i)*formant_value(i);
    temp_value = temp_value + formant_value(i);
end

avg_formant = temp / temp_value;

for i = 1:length(formant_value)
    if formant_index(i)/avg_formant > 2.5
        formant_value(i) = 0;
    end
end

for i=1:lenx
   formant(formant_index(i),i)=formant_value(i); 
end


return;