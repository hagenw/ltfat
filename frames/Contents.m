% LTFAT - Frames
%
%  Peter L. Søndergaard, 2012 - 2013.
%
%  Creation of a frame object
%    FRAME             - Construct a new frame
%    FRAMEPAIR         - Construct a pair of frames
%    FRAMEDUAL         - The canonical dual frame
%    FRAMETIGHT        - The canonical tight frame
%    FRAMEACCEL        - Precompute arrays for faster application
%
%  Linear operators
%    FRANA             - Frame analysis
%    FRSYN             - Frame synthesis
%    FRAMEMATRIX       - Frame analysis operator matrix
%    FRAMEDIAG         - Diagonal of frame operator
%
%  Visualization
%    PLOTFRAME         - Plot frame coefficients
%    FRAMEGRAM         - Plot energy of signal in frame space
%
%  Information about a frame
%    FRAMEBOUNDS       - Frame bounds
%    FRAMERED          - Redundancy of frame
%    FRAMELENGTH       - Length of frame to expand signal
%    FRAMELENGTHCOEF   - Length of frame given a set of coefficients
%
%  Coefficients conversions
%    FRAMECOEF2NATIVE  - Convert to native transform format
%    FRAMENATIVE2COEF  - Convert native to column format
%    FRAMECOEF2TF      - Convert to time-frequency plane layout
%    FRAMETF2COEF      - Convert TF-plane layout to native
%
%  Non-linear analysis and synthesis
%    FRSYNABS          - Frame synthesis from magnitude of coefficients
%    FRANAITER         - Iterative perfect reconstruction analysis
%    FRSYNITER         - Iterative perfect reconstruction synthesis
%    FRAMELASSO        - LASSO threshholding using Landweber iterations.
%    FRAMEGROUPLASSO   - Group LASSO threshholding.
%
%  Frame multipliers
%    FRAMEMUL          - Apply frame multiplier
%    IFRAMEMUL         - Apply the inverse of a frame multipllier
%    FRAMEMULADJ       - Apply the adjoint of a frame multiplier
%    FRAMEMULAPPR      - Best approx. by frame multiplier
%    FRAMEMULEIGS      - Eigenpairs of a frame multiplier
%
%  For help, bug reports, suggestions etc. please send email to
%  ltfat-help@lists.sourceforge.net
