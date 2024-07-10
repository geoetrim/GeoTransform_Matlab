GeoTransform

Point file except sensor dependent RFM

 1 nn <= input values (Point ID)
 2 r  <= input values (row)
 3 c  <= input values (column)
 4 E  <= input values (East  / longitude)
 5 N  <= input values (North / latitude)
 6 H  <= input values
 7 r  <= normalized (assigned normalized or non-normalized coordinates)
 8 c  <= normalized (assigned normalized or non-normalized coordinates)
 9 E  <= normalized (assigned normalized or non-normalized coordinates)
10 N  <= normalized (assigned normalized or non-normalized coordinates)
11 H  <= normalized (assigned normalized or non-normalized coordinates)
12 r  <= adjusted
13 c  <= adjusted
14 r  <= adjusted and renormalized
15 c  <= adjusted and renormalized

===========================================================================

Point file for sensor dependent RFM

 1 nn <= input values
 2 r  <= input values (line)
 3 c  <= input values (column)
 4 b  <= input values (latitude)
 5 l  <= input values (longitude)
 6 H  <= input values (elipsoidal height)
 7 r  <= line    (normalized)
 8 c  <= column  (normalized)
 9 U  <= latitude(normalized)
10 V  <= long.   (normalized)
11 W  <= height  (normalized)
12 r  <= line    (estimated by RPCs)
13 c  <= column  (estimated by RPCs)
14 r  <= line    (bias compensated)
15 c  <= column  (bias compensated)
16 r  <= line    (adjusted)
17 c  <= column  (adjusted)
18 r  <= line    (compensated and renormalized)
19 c  <= column  (compensated and renormalized)
20 U  <= latitude(estimated from stereo images)
21 V  <= long.   (estimated from stereo images)
22 W  <= height  (estimated from stereo images)

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
    
7X: Xth except sensor dependent RFM
8X: Xth sensor dependent RFM

