/* yawtb.h:
 *
 * \mansec{Description}
 * This is an include file for the yawtb mex file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/include/yawtb.h,v 1.3 2002-01-23 09:12:26 ljacques Exp $
 *
 * Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

#ifndef yawtb_h
#define yawtb_h

/********************************************************************************
 *                             Miscellaneous macros                              *
 ********************************************************************************/
#define mxCreateCellRow(lg)    mxCreateCellMatrix(1,lg);


/********************************************************************************
 *                                  Interface                                   *
 ********************************************************************************/
void     mxSetCellNb(mxArray*, int, mxArray*);

#ifndef MATLAB6
mxArray* mxCreateScalarDouble(double);
#endif

/********************************************************************************
 *                                Implementation                                *
 ********************************************************************************/

/* This function set the index cell of a matlab list to cell
 * Example:
 *   mxArray *mylist;
 *   mxSetName(mylist, "a list");
 *   mxSetCellNb(mylist, 0, mxCreateString("smthing"));
 */

void mxSetCellNb(mxArray *cellarray, int index, mxArray *cell)
{
  mxSetCell(cellarray, mxCalcSingleSubscript(cellarray, 1, &index), cell);
}

#ifndef MATLAB6

/* The following function was created to be compatible with matlab 5.x which 
 * don't have mxCreateDoubleScalar(double) */
mxArray* mxCreateScalarDouble(double value)
{
  mxArray* mxtmp;

  mxtmp = mxCreateDoubleMatrix(1,1,mxREAL);
  *mxGetPr(mxtmp) = value;  

  return mxtmp;
}
#endif



#endif

/* This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */
