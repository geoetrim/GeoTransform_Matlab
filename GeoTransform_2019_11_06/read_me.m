GeoTransform
Last update: 07.11.2019

Point (GCP/ICP) file except sensor dependent RFM

 1 nn <= input values (Point ID)
 2 r  <= input values (row)
 3 c  <= input values (column)
 4 E  <= input values (East  / longitude) (This order is not important since the model is not sensor dependent.)
 5 N  <= input values (North / latitude)  (This order is not important since the model is not sensor dependent.)
 6 H  <= input values
 7 r  <= normalized (If the normalization was not chosen, it equals as the original.)
 8 c  <= normalized (If the normalization was not chosen, it equals as the original.)
 9 E  <= normalized (If the normalization was not chosen, it equals as the original.)
10 N  <= normalized (If the normalization was not chosen, it equals as the original.)
11 H  <= normalized (If the normalization was not chosen, it equals as the original.)
12 r  <= adjusted
13 c  <= adjusted
14 r  <= adjusted and renormalized
15 c  <= adjusted and renormalized

===========================================================================

Point (GCP/ICP) file for sensor dependent RFM

 1 nn <= input values (Point ID)
 2 r  <= input values (row)
 3 c  <= input values (column)
 4 b  <= input values (latitude in WGS84)
 5 l  <= input values (longitude in WGS84)
 6 H  <= input values (height in WGS84)
 7 r  <= line    (normalized)(If the normalization was not chosen, it equals as the original.)
 8 c  <= column  (normalized)(If the normalization was not chosen, it equals as the original.)
 9 U  <= latitude(normalized)(If the normalization was not chosen, it equals as the original.)
10 V  <= long.   (normalized)(If the normalization was not chosen, it equals as the original.)
11 W  <= height  (normalized)(If the normalization was not chosen, it equals as the original.)
12 r  <= line    (estimated by RPCs)
13 c  <= column  (estimated by RPCs)
14 r  <= line    (bias compensated) (If the bias compensation was not chosen, it equals as the original.)
15 c  <= column  (bias compensated) (If the bias compensation was not chosen, it equals as the original.)
16 r  <= line    (adjusted)
17 c  <= column  (adjusted)
18 r  <= line    (adjusted and renormalized)
19 c  <= column  (adjusted and renormalized)

Only for ICPs
20 b  <= ~latitude  (estimated by row RPCs in stereo mode)
21 l  <= ~longitude (estimated by row RPCs in stereo mode)
23 h  <= ~height    (estimated by row RPCs in stereo mode)

===========================================================================

DEM file (sequence must be same with GCP)

 1 E <= input values (East  / longitude)
 2 N <= input values (North / latitude)
 3 H <= input values (Height)
 4 E <= normalized 
 5 N <= normalized
 6 H <= normalized
 7 r <= normalized   (estimated)
 8 c <= normalized   (estimated)
 9 r <= renormalized (estimated)
10 c <= renormalized (estimated)
11 ms<= total accuracy in pixel unit
12 ms<= total accuracy in meter

===========================================================================

DEM Quality

1 RMSE (East)
2 RMSE (North)
3 RMSE (Height)
4 RMSE <= normalized
5 RMSE <= normalized
6 RMSE <= normalized

Model selection (s)

3X: Xth degree polinomial

41: Generic affine projection
42: AP for OrbView-3
43: AP for IKONOS & QuickBird
    
7X: Xth except sensor dependent RFM of degree
8X: Xth sensor dependent RFM of degree

