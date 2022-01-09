function I_out = imagecomplement(I_in)
   if isa(I_in, 'logical')
        % special case for logical arrays, otherwise return type will be
        % wrong (double instead of logical)
        I_out = ~I_in;
   else
       % get max value of array and subtract every value from it
       % makes highest values to lowest and vice-versa
        maxval = max(I_in, [], 'all');
        I_out = maxval - I_in;
   end
end