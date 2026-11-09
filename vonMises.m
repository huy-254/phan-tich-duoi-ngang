function[v_stress] =  vonMises(stress)
v_stress = sqrt(stress(1)^2+stress(2)^2-stress(1)*stress(2)+3*stress(3)^2);