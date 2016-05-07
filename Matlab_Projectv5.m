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
inputFileName = input('Input the name of your file into the terminal window \n(Please include extensions such as ''.txt'', ''.mat'', ''.xlsx''...)\n', 's');

[file, statFile] = Project_loadFile(inputFileName);

%% Save Output File
%Statistics must be done after outputFileName has been assigned from user
%input (saving done after everything) in order for fopen to work with
%correct parameters (see top)

validRenameChoice = false;
%TODO: Prompt the user to change file type if necessary
outputFileName = input('Statistical analysis is being performed. \nWhat would you like to call the output file? Note: if no extension \nis specified, the file will become .mat by default.\n', 's');
while exist(outputFileName, 'file') == 2 || validRenameChoice
    choice = input('The file name you chose already exists. Would you like to overwrite \nthe file? (Y/N)', 's');
    choice = upper(choice);
    switch(choice)
        case 'N'
            outputFileName = input('Please type the name you would like to use instead.\n', 's');
        case 'Y'
            validRenameChoice = true;
        otherwise
            choice = input('Your input was not valid. Please enter a valid string for your file name \n(as well as desired file extension) or Ctrl+C to quit\n');
    end
end

fileID = Project_outputFile(outputFileName, file, statFile, username, inputFileName);
fprintf('fileID = %i\n', fileID);

done = false;
while(~done)
    mtitle = sprintf('Is there anything else you want to do with the data, %s?', username);
    choice = menu(mtitle, 'Reset username', 'Reset input file', 'Reset output file', 'Plot histogram', 'Plot histogram fit', 'Plot probability plots', 'Regression of y on x', 'Find probability given x or z', 'Find x or z given probability', 'Exit');
    switch(choice)
        case 1
            %Reset username
            username = input('Type your new name: ', 's');
        case 2
            %Reset input file name and write to statistics output to output file
            newInputFileName = input('Type the new input name: ', 's');
            [file, statFile] = Project_loadFile(newInputFileName);
            newChoice = input('Would you lblkaike to (1) append this data to the existing file or\n(2) create a new output file?');
            switch newChoice
                case 1
                    
                case 2
                    oldOutputFileName = outputFileName;
                    outputFileName = input('Type your new output file name: ', 's');
                    Project_outputFile(outputFileName, file, statFile, username, newInputFileName);
                otherwise
            end
        case 3
            %Reset output file/file name and writes all info and new
            %statistics to new file
            oldOutputFileName = outputFileName;
            outputFileName = input('Type your new output file name: ', 's');
            Project_outputFile(outputFileName, file, statFile, username, inputFileName, fileID, oldOutputFileName)
        case 4
            %Histogram
            histogram(statFile)
        case 5
            %Histogram fit
            histfit(statFile)
        case 6
            %Plot probability plots
            probplot(file)
        case 7
            %Plot n-order regression
            Project_Regression(file);
        case 8
            %Standard deviation = sigma; average = mu
            %Part A: find probability based on user input for z
            %Part B: find probability based on user input for x
            
            %TODO: Ask Ishan if this is the correct way to "check for
            %normality." Also ask if the z value calculation is
            %correect/how to find x with z/what the rubric means with the
            %formula (wouldn't it be easier to find x given z with that
            %equation? Or use norminv?)
            
            a = input('Are you entering a (1) z value or (2) x value?\n', 's');
            while a ~= '1' && a ~= '2'
                disp('Input invalid.')
                a = input('Are you entering a (1) z value or (2) x value?\n', 's');
            end
            
            normDist = input('To your best judgement, is this data \nnormally distributed? (0: No, 1: Yes)\n', 's');
            if normDist
                
                xzCont = false;
                while ~xzCont
                    try
                        a = input('Are you entering a (1) z value or (2) x value?\n', 's');
                        xzCont = true;
                    catch
                        disp('Your input could not be understood. Try again.');
                    end
                end
                
                while a ~= '1' && a ~= '2'
                    %Check all inputs for isScalar/isVector, isColumn/isRow,
                    %isNumeric, isLogical, isChar, isEmpty
                    switch a
                        case '1'
                            
                        case '2'
                            x = input('Enter your desired x value: ');
                            %On this line: error checking if statement described
                            %above switch
                            z = normcdf(x, 0, 1);
                            fprintf('The z value at x = %.2f = %.2f', x, z)
                            fprintf(fileID, 'The z value at x = %.2f = %.2f', x, z);
                        otherwise
                            disp('Cut it out with these shenanigans.')
                            a = input('Are you entering a (1) z value or (2) x value?\n');
                    end
                end
            else
                disp('You answered no, or the answer was invalid. Returning to the menu.');
            end
        case 9
            %Standard deviation = sigma; average = mu
            %Part A: find z based on user input for prob
            %Part B: find x based on user input for prob
            
            normDist = input('In your best judgement, is this data \nnormally distributed? (0: No, 1: Yes)\n');
            if normDist
                a = input('Are you looking for a (1) x value or (2) z value?');
                while a ~= 1 && a ~= 2
                    switch a
                        case 1
                            %Possible revision: check below probability: if
                            %greater then 1, divide by 100 (means its not
                            %in decimal format)
                            p = input('Enter desired probability (in decimal form): ');
                            %Error check the above number. See case 8.
                            x = norminv(p, 0, 1);
                            fprintf('The x value that represents the given probability (%.2f%) is %.2f', p, x);
                            %TODO: Make sure these are printing on the file
                            %on different lines....
                            fprintf(fileID, 'The x value that represents the given probability (%.2f%) is %.2f', p, x);
                        case 2
                            %This case might make sense to use the formula
                            %on the rubric.
                        otherwise
                            disp('Cut it out with these shenanigans.')
                            a = input('Are you looking for a (1) x value or (2) z value?');
                    end
                end
            else
                disp('You answered no, or the answer was invalid. Returning to the menu.');
            end
            %norminv
        case 10
            %Exit
            %BUG: Files aren't being closed? Tf
            fprintf('file being closed: %i\n', fileID);
            fclose(fileID);
            done = ~done;
        otherwise
            %BUG: Yeah...same as above.
            fclose(fileID);
            done = ~done;
    end
end