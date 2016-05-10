%% Take in user's file
%Start
username = input('Welcome to StatisticsLab 2k16!!!\nStart with your name.\n', 's');
inputFileName = input('Input the name of your file into the terminal window \n(Please include extensions such as ''.txt'', ''.mat'', ''.xlsx''...)\n', 's');

[file, statFile] = Project_loadFile(inputFileName);

%% Creating Output File Name
%Statistics must be done after outputFileName has been assigned from user
%input (saving done after everything) in order for fopen to work with
%correct parameters (see top)

validRenameChoice = false;
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

%% Creating Output File
[fileID, avg, stdev] = Project_outputFile(outputFileName, file, statFile, username, inputFileName);

%% Options Menu
done = false;
while(~done)
    mtitle = sprintf('Is there anything else you want to do with the data, %s?', username);
    choice = menu(mtitle, 'Reset username', 'Reset input file', 'Reset output file', 'Plot histogram', 'Plot histogram fit', 'Plot probability plots', 'Regression of y on x', 'Find probability given x or z', 'Find x or z given probability', 'Exit');
    switch(choice)
        case 1
            %% Username Reset
            %Reset username
            username = input('Type your new name: ', 's');
        case 2
            %% Reset input file name and write to statistics output to output file
            newInputFileName = input('Type the new input name: ', 's');
            [file, statFile] = Project_loadFile(newInputFileName);
            newChoice = input('Would you like to (1) append this data to the existing file or\n(2) create a new output file?', 's');
            while newChoice ~= '1' && newChoice ~= '2'
                disp('Input invalid.')
                newChoice = input('Would you like to (1) append this data to the existing file or\n(2) create a new output file?', 's');
            end
            switch newChoice
                case 1
                    [a, b, c, d, e, f, g, h, i] = mystat(statFile);
                    prompt = srintf('\nFrom: %s', newInputFileName);
                    fprintf(fileID, '%s\nMean\t= %8.2f\nMedian\t= %8.2f\nMode\t= %8.2f\nVar\t\t= %8.2f\nStdev\t= %8.2f\t%s\nMin\t\t= %8.2f\nMax\t\t= %8.2f\nCount\t= %8.2f', prompt, a, b, c, d, e, i, f, g, h);
                case 2
                    oldOutputFileName = outputFileName;
                    outputFileName = input('Type your new output file name: ', 's');
                    [fileID, av, stdev] = Project_outputFile(outputFileName, file, statFile, username, newInputFileName);
            end
        case 3
            %% Reset output file/file name and writes all info and new
            %statistics to new file
            oldOutputFileName = outputFileName;
            outputFileName = input('Type your new output file name: ', 's');
            Project_outputFile(outputFileName, file, statFile, username, inputFileName, fileID, oldOutputFileName)
        case 4
            %% Histogram
            histogram(statFile)
        case 5
            %% Histogram fit
            histfit(statFile)
        case 6
            %% Plot probability plots
            probplot(file)
        case 7
            %% Plot n-order regression
            Project_Regression(file);
        case 8
            %% Find probability given x/z
            %Standard deviation = sigma; average = mu
            %Part A: find probability based on user input for z
            %Part B: find probability based on user input for x
            
            %% Determine whether x/z value and error check
            a = input('Are you entering a (1) z value or (2) x value?\n', 's');
            while a ~= '1' && a ~= '2'
                disp('Input invalid.')
                a = input('Are you entering a (1) z value or (2) x value?\n', 's');
            end
            
            %% Check for normal distribustion
            normDist = input('To your best judgement, is this data \nnormally distributed? (0: No, 1: Yes)\n', 's');
            while normDist ~= '1' && normDist ~= '2'
                disp('Input invalid.')
                normDist = input('To your best judgement, is this data \nnormally distributed? (0: No, 1: Yes)\n', 's');
            end
            if normDist
                %Check all inputs for isScalar/isVector, isColumn/isRow,
                %isNumeric, isLogical, isChar, isEmpty
                switch a
                    case '1'
                        z = input('Type desired z value: ');
                        while ~isScalar(z)
                            disp('Input invalid.')
                            z = input('Type desired z value: ');
                        end
                        prob = normcdf(z, 0, 1);
                        fprintf('The probability at the given z value is %.2f', prob);
                        fprintf(fileID, 'The probability at the given z value is %.2f', prob);
                    case '2'
                        x = input('Enter your desired x value: ');
                        while ~isScalar(x)
                            disp('Input invalid.')
                            x = input('Type desired z value: ');
                        end
                        
                        prob = normcdf(x, avg, stdev);
                        fprintf('The probability at the given x value is %.2f', prob)
                        fprintf(fileID, 'The probability the given x value is %.2f', prob);
                    otherwise
                        disp('Cut it out with these shenanigans.')
                        a = input('Are you entering a (1) z value or (2) x value?\n', 's');
                end
            else
                disp('You answered no, or the answer was invalid. Returning to the menu.');
            end
        case 9
            %% Finding z/x based on given probability
            %Standard deviation = sigma; average = mu
            %Part A: find z based on user input for prob
            %Part B: find x based on user input for prob
            
            %% Determine whether x/z value and error check
            a = input('Are you looking for a (1) z value or (2) x value?\n', 's');
            while a ~= '1' && a ~= '2'
                disp('Input invalid.')
                a = input('Are you looking for a (1) z value or (2) x value?\n', 's');
            end
            
            %% Check for normal distribution
            normDist = input('In your best judgement, is this data \nnormally distributed? (0: No, 1: Yes)\n', 's');
            while normDist ~= '1' && normDist ~= '2'
                disp('Input invalid.')
                normDist = input('To your best judgement, is this data \nnormally distributed? (0: No, 1: Yes)\n', 's');
            end
            if normDist
                p = input('Enter desired probability (in decimal form): ');
                while ~isscalar(p)
                    disp('Input invalid')
                    p = input('Enter desired probability (in decimal form): ');
                end
                if p > 1 && p < 100
                    p = p/100;
                    switch a
                        case 1
                            %Error check the above number. See case 8.
                            z = norminv(p, 0, 1);
                            fprintf('The z value that represents the given probability (%.2f%) is %.2f', p, z);
                            fprintf(fileID, 'The z value that represents the given probability (%.2f%) is %.2f', p, z);
                        case 2
                            x = norminv(p, avg, stdev);
                            fprintf('The x value that represents the given probability (%.2f%) is %.2f', p, x);
                            fprintf(fileID, 'The x value that represents the given probability (%.2f%) is %.2f', p, x);
                        otherwise
                            disp('Cut it out with these shenanigans.')
                            a = input('Are you looking for a (1) x value or (2) z value?');
                    end
                elseif p > 100
                    disp('Probability cannot be greater than 100%, or 1. Returning to menu.');
                end
            else
                disp('You answered no, or the answer was invalid. Returning to the menu.');
            end
        case 10
            %Exit
            done = ~done;
        otherwise
            done = ~done;
    end
end

%Tried putting the fclose() line in the 'Exit' case, but for some reason it
%wasn't closing the files, even though it had the right file ID and
%everything. However, it works here.
fclose all;
clear