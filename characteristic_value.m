function [ characteristic_val ] = characteristic_value( data,f )
%the script calculates the characteristic values

    for i=1:size(data)
        if f(i)>=1000
            characteristic_val(i)=f(i)/1000;
        else
            switch data(i,1)
                case 1 %normal distribution
                    characteristic_val(i)=data(i,2)+norminv(f(i))*data(i,3);
                case 2 %lognormal distribution
                    m=data(i,2);s=data(i,3);
                    sln=sqrt(log(1+s^2/m^2));
                    mln=log(m)-0.5*sln^2;
                    characteristic_val(i)=exp(norminv(f(i))*sln+mln);
                case 15 %Gumbel distribution
                    m=data(i,2);s=data(i,3);
                    b=s*sqrt(6)/pi;
                    a=m-b*0.577216;
                    characteristic_val(i)=a-b*log(-log(f(i)));

                otherwise
                    error('distribution type not recognized in characteristic_value');
            end
        end
    end
end

