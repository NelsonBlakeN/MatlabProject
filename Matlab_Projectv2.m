%Begin by welcoming the user ("Welcome to Statistics2k16!!!!") and ask the
%user for the name of the file they would like to read from ("Please
%include the extnesion as well (.txt, .xlsx, etc)",save this name
%as string, "load(file_name_as_string)"
%//fscanf OR xlsread?? Dependign on extension, possible menu opportunity
%^^^COMPLETED 4/10/2016^^^

%Create menu ("choice = menu(...)") with each choice being one of the
%statistical analysis.

%"Switch(choice)", each case runs different function (just the old
%functions from past assignments?). Make sure the variables/arrays that
%contain final output are easily traceable and can be called.

%"Congratulations, your analysis is completed. What would you like to name
%the output file? (Please include extension as well)(be careful to not
%choose the name of a file that already exits!!"
%//menu for type (.xlsx, .txt, .mat)??

%IF TEXT FILE
%fileID = fopen('user_choice_output_name', 'wt')
%fprintf(fileID, '%f...', final_stats_outout_variables/arrays)
%//alignment of decimals/zeros in this print
%//0- or something like that
%save('user_choice_output_name', relevant_cariables)
%//errorcheck: if this name (or any names/inputs) are null
%fclose(fileID)

%IF XLSX
%xlswrite(user_name_choice, variale_to_put_in_cell, sheet_number, 'cell
%number/range'

%% Take in user's file
%Start
username = input('Welcome to StatisticsLab 2k16!!!\nStart with your name.\n', 's');
userFileName = input('Input the name of your file into the terminal window \n(Please include extensions such as ''.txt'', ''.mat'', ''.xlsx''...)\n', 's');

[file, statFile] = Project_loadFile(userFileName);
% %Error check the file name. If no such file exists (due to missing
% %extension, misspell) the user is prompted again until the name matches.
% while(exist(userFileName, 'file') ~= 2)
%     userFileName = input('Your file could not be found, or does not exist in this file directory. Please try again.\n', 's');
% end
% 
% %TODO: Put the error check below in a loop. That will fulfill the else
% %statement at the end of the strfind if.
% 
% try
%     file = load(userFileName);
% catch
%     file = xlsread(userFileName);
% end
% 
% %BUG: If the .mat file is 2 one column variables, as opposed to 1 two
% %column variable, statFile will not be created, and the two variables
% %will be vertically stacked. I can't remember if the try/catch fails or
% %not... (finishing writing this after the fact)
% if strfind(userFileName, '.mat') > 0
%     %.mat files are loaded as structs, so it needs to be converted into
%     %something that can be used universally.
%     file = cell2mat(struct2cell(file));
% else
%     
% end
% 
% s = size(file);
% disp(s)
% if(s(1) ~= 1 && s(2) ~= 1)
%     disp('statFile enter')
%     %if the matrix is not a single column/single row
%     %turn the matrix into a single column/row (don't have to worry
%     %about statistics being done by column)
%     statFile = reshape(file, s(1)*s(2), 1);
% end

%% Save Output File
%Statistics must be done after outputFileName has been assigned from user
%input (saving done after everythin) in order for fopen to work with
%correct parameters (see top)

validRenameChoice = false;
%TODO: Prompt the user to change file type if necessary
outputFileName = input('Statistical analysis is being performed. \nWhat would you like to call the output file? Note: if no extension \nis specified, the file will become .mat by default.\n', 's');


%Revision: while(exists(outputFileName) == 2){ choice: 'file already
%exists...' //test if 'choice' is invalid, if they want to overwrite file
%will while loop exit? 'break'?
if(~exist(outputFileName, 'file'))
    %BUG: Actully appending to a file that is already made creates an
    %encrypted mess.
    fileID = fopen(outputFileName, 'a+');
    if exist('statFile', 'var')
        [avg, med, mod, va, stdev, minimum, maximum, count, msg] = mystat(statFile);
    else
        [avg, med, mod, va, stdev, minimum, maximum, count, msg] = mystat(file);
    end
    d = date;
    prompt = sprintf('%s\n%s\n%s', outputFileName, d, username);
    fprintf(fileID, '%s\nMean\t= %8.2f\nMedian\t= %8.2f\nMode\t= %8.2f\nVar\t\t= %8.2f\nStdev\t= %8.2f\t%s\nMin\t\t= %8.2f\nMax\t\t= %8.2f\nCount\t= %8.2f', prompt, avg, med, mod, va, stdev, msg, minimum, maximum, count);
    
    done = false;
    
    while(~done)
        mtitle = sprintf('Is there anything else you want to do with the data, %s?', username);
        choice = menu(mtitle, 'Reset username', 'Reset input file', 'Reset output file', 'Plot histogram', 'Plot histogram fit', 'Plot probability plots', 'Regression of y on x', 'Find probability given x or z', 'Find x or z given probability', 'Exit');
        switch(choice)
            case 1
                %Reset username
                username = input('Type your new name: ', 's');
            case 2
                %Reset input file name and write to statistics output to output
                %file
                
            case 3
                %Reset output file/file name and writes all info and new
                %statistics to new file
                
            case 4
                %Histogram
                histogram(statFile)
            case 5
                %Histogram fit
                histfit(statFile)
            case 6
                %Plot probability plots
            case 7
                %Plot n-order regression
                Project_Regression(file);
            case 8
                %Part A: find probability based on user input for z
                %Part B: find probability based on user input for x
                %normcdf
            case 9
                %Part A: find z based on user input for prob
                %Part B: find x based on user input for prob
                %norminv
            case 10
                %Exit
                fclose(fileID);
                done = ~done;
            otherwise
                fprintf('Not a valid input\n');
                fclose(fileID);
                done = ~done;
        end
    end
else
    while(~validRenameChoice)
        choice = input('The file name you chose already exists. Would you like to overwrite \nthe file? (Y/N)', 's');
        choice = upper(choice);
        switch(choice)
            case 'N'
                outputFileName = input('Please type the new name you would like to use.\n', 's');
                %BUG: If outputFileName is a string w/o .mat, but .mat file
                %with same name exists, 'exist' won't see them as the same,
                %but the file will be overwritten by 'save'
                if(~exist(outputFileName, 'file'))
                    save(outputFileName)
                    validRenameChoice = true;
                end
            case 'Y'
                %Using 'save' with a name that already exists WILL
                %overwrite that file, will also save with proper extension
                %if it's part of the name string
                save(outputFileName);
                validRenameChoice = true;
            otherwise
                choice = input('Your input was not valid. Please enter a valid string for your file name \n(as well as desired file extension) or Ctrl+C to quit\n');
        end
    end
end