function [y] = simulate(r1,l1,l2,r2,N,tol) 
    V = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1;
    dV = @(t) 4 * t - (cos(4 * t) * exp(-t/4))/4 - 4 * sin(4 * t) * exp(-t/4) + 3; 
     
    sph = (4 / 3) * pi * r1.^3; 
    cone = (1 / 3) * pi * r2.^2 * l1; 
    cyl = pi * r2.^2 * l2; 
    hem = (2 / 3) * pi * r2.^3; 
    
    V1 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - sph;
    V2 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - sph - cone;
    V3 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - sph - cone - cyl;
    V4 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - sph - cone - cyl - hem;

    Ta = solver(V1,dV,0,tol);
    Tb = solver(V2,dV,0,tol);
    Tc = solver(V3,dV,0,tol);
    Td = solver(V4,dV,0,tol);
    fprintf("Ta = %d \n",Ta);
    fprintf("Tb = %d \n",Tb);
    fprintf("Tc = %d \n",Tc);
    fprintf("Td = %d \n",Td);
    
    H = 2 * r1 + l1 + l2 + r2;
    
    h_sph = @(h) (pi / 3) * (3 * r1 * h.^2 - h.^3);
    h_cone = @(h) (pi / 3) * (h * r2 / l1).^2 * l1;
    h_cyl = @(h) pi * r2.^2 * h;
    h_hem = @(h) (pi / 3) * (3 * r2.^2 * h - h.^3);

    x(1) = 0;
    y(1) = 0;
    vol = 0;
    for i = 1:N - 1
        x(i + 1) = i * (H / N);
        if x(i + 1) <= 2 * r1
            vol = h_sph(x(i + 1));
            V5 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - vol;
            y(i + 1) = solver(V5,dV,0,tol);
        elseif x(i + 1) <= 2 * r1 +l1
            vol = sph + h_cone(x(i + 1) - 2 * r1);
            V6 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - vol;
            y(i + 1) = solver(V6,dV,0,tol);
        elseif x(i + 1) <= 2 * r1 + l1 + l2
            vol = sph + cone + h_cyl(x(i + 1) - 2 * r1 - l1);
            V7 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - vol;
            y(i + 1) = solver(V7,dV,0,tol);
        else 
            vol = sph + cone + cyl + h_hem(x(i + 1) - 2 * r1 - l1 - l2);
            V8 = @(t) 3 * t + 2 * t.^2 + cos(4 * t) * exp(-t/4) - 1 - vol;
            y(i + 1) = solver(V8,dV,0,tol);
        end
    end
    plot(x,y)
    xlabel("height of water");
    ylabel("time");
end
