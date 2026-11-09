function x_E = shear_center(q_b1,q_b2,A1,A2,A3,delta_1,delta_2,delta_3,delta_1_2,delta_2_3,d1,d2,h_1_2,h_2_3)

M = [delta_1+delta_1_2 -delta_1_2 0;...
    -delta_1_2 delta_2+delta_1_2+delta_2_3 -delta_2_3;...
    0 -delta_2_3 delta_3+delta_2_3];

Qb = [-q_b1*delta_1_2;...
    q_b1*delta_1_2-q_b2*delta_2_3;...
    q_b2*delta_2_3];

Q = M\Qb;
q1 = Q(1);
q2 = Q(2);
q3 = Q(3);
x_E = (2*(A1*q1+A2*q2+A3*q3)+q_b2*h_2_3*d2+q_b1*h_1_2*d1)/(q_b1*h_1_2+q_b2*h_2_3);

