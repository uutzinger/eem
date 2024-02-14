function [sen,spe,ppv,npv,ud]=stat_sum(diag,class)
% function [Sensitivity,Specificity,PPV,NPV,unique_dagnosis]=stat_sum(diagnosis,classified)
%
% input:  Diagnosis Vector, Classified Vector (result of an algorithm)
% output: Sensitivity, Specificity, Positive Predictive Value, Negaitve Predictive Value
%         are vectors of the length of unique diagnosis values
%
% Results will be calculated for all unique numbers in diagnosis eg.
% true_positive = sum(classified(diagnosis==unique_diagnosis(i))==unique_diagnosis(i))
%
ud=unique(diag);
nr_categories=length(ud);
% numbered_categories=1:nr_categories;

for i=1:nr_categories,
   t1=diag==ud(i);
   t2=diag~=ud(i);
	 true_positives = sum(class(t1) == ud(i));
	false_positives = sum(class(t2) == ud(i));
	 true_negatives = sum(class(t2) ~= ud(i));
	false_negatives = sum(class(t1) ~= ud(i));
	sen(i) = true_positives/(true_positives + false_negatives);
	spe(i) = true_negatives/(true_negatives + false_positives);
	if (true_positives + false_positives)==0  
		ppv(i) = 0; 
	else  
		ppv(i) = true_positives/(true_positives + false_positives); 
	end
	if (true_negatives + false_negatives)==0  
		npv(i) = 0; 
	else  
		npv(i) = true_negatives/(true_negatives + false_negatives);
	end
end

