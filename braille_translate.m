% test input: result = braille_translate(["010111", "100000", "011100", "011100", "010111", "000111"],"german");

function [result] = braille_translate(input, language)
% alphabet = containers.Map({1, 5, 8}, {'A', 'B', 'C'});

% language
% switch language
%     case 'german'
%

% Probleme mit IJSTW
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
    "000010" '.'; "000010" '.'; "001000" ','; "001010" ';';...
    "001100" ':'; "001001" '?'; "001110" '!'...
    ];



special_keys = [...
    "000011" "-"; "000001" "_"; "000100" "|"
    ];

double_char = containers.Map(...
    {000001},...
    {'.'});

letters = create_map(letter_pairs);
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
numbers = 0;

% Number Code 010111
% Percentage 010111 -> 000111
% Permille 010111 -> 000111 -> 000111

temp = size(input(:));
input_size = temp(1);
skip_steps = 0; % increase to skip loop and therefore symbols in the array

for i=1:input_size
    if skip_steps > 0
        skip_steps = skip_steps - 1;
        continue;
    end
    if isKey(letters, string(input(i)))  % Check if the key is a regular value
        temp_char = letters(string(input(i)));
    elseif string(input(i)) == "000001" % Check for capital code 000001 or _ code
        if i+1<=input_size & string(input(i+1)) == "000011"
            temp_char = "_";
            result = result + temp_char;
        elseif upper_case
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
        numbers = mod(numbers + 1, 2);
        continue;
    else
        temp_char = "ERROR";
    end
    if upper_case || all_caps
        temp_char = upper(temp_char);
        upper_case = 0;
    elseif numbers
        temp_char = mod(double(char(temp_char))-96, 10);
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