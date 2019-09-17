R= [0  1  0  0  1   0  0   0   0   0  1  0  0  0  0  0  0
    1  0  1  0  1   0  0   0   0   0  0  0  0  0  0  0  0
    0  1  0  1  0   1  0   0   0   0  0  0  0  0  0  0  0
    0  0  1  0  1   1  0   0   0   0  0  0  0  0  0  0  0
    1  1  0  1  0   0  10  0   0   0  1  0  0  0  0  0  0
    0  0  1  1  0   0  1   0   1   0  0  1  0  0  0  0  0
    0  0  0  0  10  1  0   10  0   0  0  0  0  0  0  0  0
    0  0  0  0  0   0  10  0   10  0  1  0  1  0  0  0  0
    0  0  0  0  0   1  0   10  0   1  0  0  0  0  0  0  0
    0  0  0  0  0   0  0   0   1   0  0  1  0  0  1  0  0
    1  0  0  0  1   0  0   1   0   0  0  0  0  1  0  0  0
    0  0  0  0  0   1  0   0   0   1  0  0  0  0  0  1  0
    0  0  0  0  0   0  0   1   0   0  0  0  0  1  1  0  0
    0  0  0  0  0   0  0   0   0   0  1  0  1  0  0  0  0
    0  0  0  0  0   0  0   0   0   1  0  0  1  0  0  0  1
    0  0  0  0  0   0  0   0   0   0  0  1  0  0  0  0  1
    0  0  0  0  0   0  0   0   0   0  0  0  0  0  1  1  0];

C= [0  1  0  0  1  0  0  0  0  0  2  0  0  0  0  0  0
    1  0  1  0  1  0  0  0  0  0  0  0  0  0  0  0  0
    0  1  0  1  0  1  0  0  0  0  0  0  0  0  0  0  0
    0  0  1  0  1  1  0  0  0  0  0  0  0  0  0  0  0
    1  1  0  1  0  0  4  0  0  0  2  0  0  0  0  0  0
    0  0  1  1  0  0  1  0  1  0  0  2  0  0  0  0  0
    0  0  0  0  4  1  0  4  0  0  0  0  0  0  0  0  0
    0  0  0  0  0  0  4  0  4  0  1  0  1  0  0  0  0
    0  0  0  0  0  1  0  4  0  1  0  0  0  0  0  0  0
    0  0  0  0  0  0  0  0  1  0  0  1  0  0  1  0  0
    2  0  0  0  2  0  0  1  0  0  0  0  0  1  0  0  0
    0  0  0  0  0  2  0  0  0  1  0  0  0  0  0  1  0
    0  0  0  0  0  0  0  1  0  0  0  0  0  1  1  0  0
    0  0  0  0  0  0  0  0  0  0  1  0  1  0  0  0  0
    0  0  0  0  0  0  0  0  0  1  0  0  1  0  0  0  1
    0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  1
    0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  1  0];
%length of each link (from 1 to 2 is 119 andd from2  to 1 is 119)
%inf if the link doesn't exist
L= [inf 119 inf inf 147 inf inf inf inf inf 292 inf inf inf inf inf inf
    119 inf 61  inf 105 inf inf inf inf inf inf inf inf inf inf inf inf
    inf 61  inf 40  inf 136 inf inf inf inf inf inf inf inf inf inf inf
    inf inf 40  inf 83  116 inf inf inf inf inf inf inf inf inf inf inf
    147 105 inf 83  inf inf 65  inf inf inf 181 inf inf inf inf inf inf
    inf inf 136 116 inf inf 120 inf 136 inf inf 157 inf inf inf inf inf
    inf inf inf inf 65  120 inf 95  inf inf inf inf inf inf inf inf inf
    inf inf inf inf inf inf 95  inf 71  inf 80  inf 67  inf inf inf inf
    inf inf inf inf inf 136 inf 71  inf 51  inf inf inf inf inf inf inf
    inf inf inf inf inf inf inf inf 51  inf inf 32  inf inf 87  inf inf
    292 inf inf inf 181 inf inf 80  inf inf inf inf inf 73  inf inf inf
    inf inf inf inf inf 157 inf inf inf 32  inf inf inf inf inf 61  inf
    inf inf inf inf inf inf inf 67  inf inf inf inf inf 68  40  inf inf
    inf inf inf inf inf inf inf inf inf inf 73  inf 68  inf inf inf inf
    inf inf inf inf inf inf inf inf inf 87  inf inf 40  inf inf inf 45
    inf inf inf inf inf inf inf inf inf inf inf 61  inf inf inf inf 81
    inf inf inf inf inf inf inf inf inf inf inf inf inf inf 45  81  inf];

T=  [0  30	48	23	0	40	0	0	0	13	14	15	25	45	17	14	12
    30	0	80	38	0	240	0	0	0	51	78	70	51	220	42	64	54
    52	84	0	11	0	210	0	0	0	19	15	48	17	84	18	19	15
    18	51	21	0	0	41	0	0	0	26	41	16	12	42	15	14	19
    0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
    52	310	225	73	0	0	0	0	0	54	71	59	56	310	54	94	83
    0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
    0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
    0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
    17	70	14	13	0	61	0	0	0	0	12	13	15	56	14	15	12
    12	48	13	41	0	54	0	0	0	19	0	13	14	63	12	15	14
    14	81	47	13	0	79	0	0	0	14	16	0	13	44	13	37	13
    14	43	12	16	0	47	0	0	0	19	13	18	0	50	15	23	12
    34	210	65	76	0	350	0	0	0	42	42	44	61	0	54	76	53
    16	49	14	13	0	49	0	0	0	14	13	16	15	63	0	15	14
    14	63	13	15	0	59	0	0	0	18	24	17	12	75	19	0	15
    21	45	16	22	0	73	0	0	0	12	14	17	14	59	14	16	0];

