function [compare_matrix] = call_compare(call_org, call_speak)

   for n = 1:500
 
      compare_matrix(n) = (- call_speak(n + 194999) + call_org(n + 194999))/call_org(n + 194999);
       
   end
compare_matrix = compare_matrix';   
compare_matrix(1:500);