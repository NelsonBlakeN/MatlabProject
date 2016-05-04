function [file, statFile] = Project_loadFile(inputFileName)

%I have no idea why I had to add this. One day it started saying the output
%arguments weren't being defined, when before they had been despite being
%defined inside if statements and try/catch's. It even says ''file' is not
%being used' but doesn't say it for statFile, when they're essentially 
%defined the same way. Idk if you're going to read all this but I feel like 
%venting about it.
file = 0;
statFile = 0;

%Error check the file name. If no such file exists (due to missing
%extension, misspell) the user is prompted again until the name matches.
while(exist(inputFileName, 'file') ~= 2)
    inputFileName = input('Your file could not be found, or does not exist in this file directory. Please try again.\n', 's');
end

%TODO: Put the error check below in a loop. That will fulfill the else
%statement at the end of the strfind if.

try
    file = load(inputFileName);
catch
    file = xlsread(inputFileName);
end

%BUG: If the .mat file is 2 one column variables, as opposed to 1 two
%column variable, statFile will not be created, and the two variables
%will be vertically stacked.
if strfind(inputFileName, '.mat') > 0
    %.mat files are loaded as structs, so it needs to be converted into
    %something that can be used universally.
    file = cell2mat(struct2cell(file));
else
    
end

s = size(file);
if(s(1) ~= 1 && s(2) ~= 1)
    %if the matrix is not a single column/single row
    %turn the matrix into a single column/row (don't have to worry
    %about statistics being done by column)
    statFile = reshape(file, s(1)*s(2), 1);
end

end