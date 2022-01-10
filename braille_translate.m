% test input: result = braille_translate(["010111", "100000", "011100", "011100", "010111", "000111"],"german");

function [result] = braille_translate(input, language)
% alphabet = containers.Map({1, 5, 8}, {'A', 'B', 'C'});

% language
% switch language
%     case 'german'
%

letter_pairs = [...
    "100000" 'a'; "101000" 'b'; "110000" 'c'; "110100" 'd';...
    "100100" 'e'; "111000" 'f'; "111100" 'g'; "101100" 'h';...
    "011000" 'i'; "011100" 'j'; "100010" 'k'; "101010" 'l';...
    "110010" 'm'; "110110" 'n'; "100110" 'o'; "111010" 'p';...
    "111110" 'q'; "101110" 'r'; "011010" 's'; "011110" 't';...
    "100011" 'u'; "101011" 'v'; "011101" 'w'; "110011" 'x';...
    "110111" 'y'; "100111" 'z'; "010110" 'ä'; "011001" 'ö';...
    "101101" 'ü'; "011011" 'ß'; "010011" 'ie'; "110001" 'ei';...
    "101001" 'eu'; "010010" 'äu'; "100001" 'au'; "110101" 'ch';...
    "100101" 'sch'; "011111" 'st'; "111111" '#'; "000000" ' ';...
    "000010" '.'; "001000" ','; "001010" ';'; "001100" ':';...
    "001001" '?'; "001110" '!'; "000111" '«'; "001011" '»';...
    "001101" '/'; "001110" '+'; "000110" '*'; "111001" '`';...
    "111101" '^'; "000011" "-"];

number_pairs = [...
    "100000" '1'; "101000" '2'; "110000" '3'; "110100" '4';...
    "100100" '5'; "111000" '6'; "111100" '7'; "101100" '8';...
    "011000" '9'; "011100" '0';...
    "001000" '1.'; "001010" '2.'; "001100" '3.'; "001101" '4.';...
    "001001" '5.'; "001110" '6.'; "001111" '7.'; "001011" '8.';...
    "000110" '9.'; "000111" '0.'];

special_keys = [...
    "000011" "-"; "000100" "|"
    ];

double_char = containers.Map(...
    {000001},...
    {'.'});

letters = create_map(letter_pairs);
numbers = create_map(number_pairs);
punctuation = create_map(special_keys);

%     case "english"
%         letters = containers.Map({},{});
%     otherwise
%         "test"
% end


result = "";
swap = 1;
upper_case = 0;
all_caps = 0;
print_numbers = 0;
open_bracket = 0;


% Number Code 010111
% Percentage 010111 -> 000111
% Permille 010111 -> 000111 -> 000111

temp = size(input(:));
input_size = temp(1);
skip_steps = 0; % increase to skip loop and therefore symbols in the array

for i=1:input_size
    % Skip eventual steps
    if skip_steps > 0
        skip_steps = skip_steps - 1;
        continue;
    end
    
    if string(input(i)) == "000001" % Check for capital code 000001 or _, *
        if i+1<=input_size
            temp_char = "";
            switch(string(input(i+1)))
                case '000110'
                    temp_char = "*";
                case "000011"
                    temp_char = "_";
                case "000001"
                    all_caps = 1;
                    continue;
            end
            if isempty(temp_char)
                result = result + temp_char;
                skip_steps = skip_steps + 1;
                continue;
            end
        end
        if upper_case % check if it is already set as upper case, if yes, everything is supposed to be caps
            all_caps = 1;
        else
            upper_case = 1;
        end
        continue;
    elseif string(input(i)) == "010111"
        if i+1<=input_size(1) & string(input(i+1)) == "000111"
            skip_steps = skip_steps + 1;
            temp_char = "%";
            if i+2<=input_size & string(input(i+2)) == "000111"
                temp_char = "‰";
                skip_steps = skip_steps + 1;
            end
            result = result + temp_char;
            continue;
        end
        print_numbers = mod(print_numbers + 1, 2);
        continue;
    end
    
    if print_numbers % check if number is supposed to be printed
        if isKey(numbers, string(input(i)))
            temp_char = numbers(string(input(i))); % mod(double(char(temp_char))-96, 10);
        else
            temp_char = "*EN*"; % Error with the numbers
        end
    elseif isKey(letters, string(input(i)))  % Check if the key is a regular value
        temp_char = letters(string(input(i)));
    elseif string(input(i)) == "001111" % check for open or closed bracked
        temp_char = "(";
        if open_bracket
            temp_char = ")";
        end
        open_bracket = mod(open_bracket + 1, 2);
    else
        temp_char = "⚠";
    end
    if upper_case || all_caps
        temp_char = upper(temp_char);
        upper_case = 0;
    end
    result = result + temp_char;
end

end

function value_map = create_map(key_value_pairs)
value_map = containers.Map();
for i=1:size(key_value_pairs)
    key = "";
    for k=1:1:6-strlength(string(key_value_pairs(i, 1)))
        key = key+"0";
    end
    key = key+string(key_value_pairs(i, 1));
    value = key_value_pairs(i, 2);
    value_map(key) = value;
end
end


% letters = containers.Map(...
%     {100000, 101000, 110000, 110100,...
%     100100, 111000, 111100, 101100, 011000,...
%     011100, 100010, 101010, 110010, 110110,...
%     100110, 111010, 111110, 101110, 011010,...
%     011110, 100011, 101011, 011101, 110011,...
%     110111, 100111, 010110, 011001, 101101,...
%     011011, 010011, 110001, 101001, 010010,...
%     100001, 110101, 100101, 011111, 010111,...
%     000000,...
%     000010, 000010, 001000, 001010, 001100,...
%     001001, 001110},...
%     {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',...
%     'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',...
%     's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'ä',...
%     'ö', 'ü', 'ß', 'ie', 'ei', 'eu', 'äu', 'au',...
%     'ch', 'sch', 'st', '#', ' ',...
%     "'", '.', ',', ';', ':', '?', '!'});
%
%
% keySet = [100000, 101000, 110000, 110100,...
%     100100, 111000, 111100, 101100, 011000,...
%     011100, 100010, 101010, 110010, 110110,...
%     100110, 111010, 111110, 101110, 011010,...
%     011110, 100011, 101011, 011101, 110011,...
%     110111, 100111, 010110, 011001, 101101,...
%     011011, 010011, 110001, 101001, 010010,...
%     100001, 110101, 100101, 011111, 010111,...
%     000000,...
%     000010, 000010, 001000, 001010, 001100,...
%     001001, 001110];
% % valueSet = values(letters);
% temp = "";
% for i=1:size(keySet(:))
%     temp = temp+'"';
%     for k=1:1:6-strlength(string(keySet(i)))
%         temp = temp+"0";
%     end
%     temp = temp + string(keySet(i)) + '" "' + letters(keySet(i)) + '"; ';
% end
% temp