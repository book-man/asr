# Automatic Speech Recognition

## Sources
* Juang and Rabiner 1991 ([link](http://users.ece.gatech.edu/~clements/6273.fa14/HMM_rabiner-juang.pdf))
* ETSI standard 201 108 ([link](http://www.etsi.org/deliver/etsi_es/201100_201199/201108/01.01.03_60/es_201108v010103p.pdf))

## Algorithm
### Extraction of MFCCs (mfcc.m)
#### Offset Compensation
The mean of the signal from all samples (todo: will highpass filtering with a higher cutoff frequency improve performance?)
#### Short-Time Fourier Transform
A hamming window with a size given by the ETSI standard was used before the FFT (todo: different window type?)

## Framework Details

### Evaluation
To easily compare different approaches or parameters, evalasr.m tests the system and outputs a structure with results.