%calculates the error in the orientation between the reference and current
%rotation.
function e_or = get_error_orientation(Rref, Rcurrent)
    n_ref = Rref(:,1);
    o_ref = Rref(:,2);
    a_ref = Rref(:,3);
    
    n_current = Rcurrent(:,1);
    o_current = Rcurrent(:,2);
    a_current = Rcurrent(:,3);
    
    e_or = 0.5*(cross(n_current,n_ref)+cross(o_current,o_ref)+cross(a_current,a_ref));
end