function strain0 =  eq_strain(strain)
strain0 = sqrt((strain(1)^2+strain(2)^2+(strain(1)-strain(2))^2+6*strain(3)^2)/2);