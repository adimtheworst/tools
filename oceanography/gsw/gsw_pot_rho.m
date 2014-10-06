function pot_rho = gsw_pot_rho(SA,t,p,pr)

% gsw_pot_rho                                             potential density
%==========================================================================
%
% USAGE:
%  pot_rho = gsw_pot_rho(SA,t,p,pr)
%
% DESCRIPTION:
%  Calculates potential density of seawater.  Note. This function outputs
%  potential density, not potential density anomaly; that is, 1000 kg/m^3
%  is not subtracted.  
%
% INPUT:
%  SA  =  Absolute Salinity                                        [ g/kg ]
%  t   =  in-situ temperature (ITS-90)                            [ deg C ]
%  p   =  sea pressure                                             [ dbar ]
%         ( ie. absolute pressure - 10.1325 dbar )
%  pr  =  reference pressure                                       [ dbar ]
%         ( ie. reference absolute pressure - 10.1325 dbar )
%
%  SA & t need to have the same dimensions.
%  p & pr may have dimensions 1x1 or Mx1 or 1xN or MxN, where SA & t 
%  are MxN
%
% OUTPUT:
%  pot_rho  =  potential density (not potential density anomaly)
%                                                                [ kg/m^3 ]
%
% AUTHOR: 
%  David Jackett, Trevor McDougall and Paul Barker [ help_gsw@csiro.au ]
%
% VERSION NUMBER: 2.0 (23rd July, 2010)
%
% REFERENCES:
%  IOC, SCOR and IAPSO, 2010: The international thermodynamic equation of 
%   seawater - 2010: Calculation and use of thermodynamic properties.  
%   Intergovernmental Oceanographic Commission, Manuals and Guides No. 56,
%   UNESCO (English), 196 pp.  Available from http://www.TEOS-10.org
%    See section 3.4 of this TEOS-10 Manual. 
%
%  The software is available from http://www.TEOS-10.org
%
%==========================================================================

%--------------------------------------------------------------------------
% Check variables and resize if necessary
%--------------------------------------------------------------------------

if ~(nargin == 4 )
   error('gsw_pot_rho:  Requires four inputs')
end %if

[ms,ns] = size(SA);
[mt,nt] = size(t);
[mp,np] = size(p);

if (mt ~= ms | nt ~= ns)
    error('gsw_pot_rho: SA and t must have same dimensions')
end

if ~isscalar(unique(pr))
    error('gsw_pot_rho: The reference pressures differ, they should be unique')
end

if (mp == 1) & (np == 1)              % p scalar - fill to size of SA
    p = p*ones(size(SA));
elseif (ns == np) & (mp == 1)         % p is row vector,
    p = p(ones(1,ms), :);              % copy down each column.
elseif (ms == mp) & (np == 1)         % p is column vector,
    p = p(:,ones(1,ns));               % copy across each row.
elseif (ms == mp) & (ns == np)
    % ok
else
    error('gsw_pot_rho: Inputs array dimensions arguments do not agree')
end %if

[mpr,npr] = size(pr);

if mpr == 1 & npr == 1               % pr scalar - fill to size of SA
    pr = pr*ones(size(SA));
elseif (ns == np) & (mp == 1)         % pr is row vector,
    pr = pr(ones(1,ms), :);              % copy down each column.
elseif (ms == mp) & (np == 1)         % pr is column vector,
    pr = pr(:,ones(1,ns));               % copy across each row.
elseif (ms == mp) & (ns == np)
    % ok
else
    error('gsw_pot_rho: Inputs array dimensions arguments do not agree')
end %if

if ms == 1
    SA = SA';
    t = t';
    p = p';
    pr = pr';
    transposed = 1;
else
    transposed = 0;
end

%--------------------------------------------------------------------------
% Start of the calculation
%--------------------------------------------------------------------------

pt = gsw_pt_from_t(SA,t,p,pr);

pot_rho = gsw_rho(SA,pt,pr);

if transposed
    pot_rho = pot_rho';
end

end