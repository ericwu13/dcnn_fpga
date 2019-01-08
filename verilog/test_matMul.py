import numpy as np
from pprint import pprint
num_vector = 8
num_dim = 8
x = []
w = []

for i in range(num_vector):
    tmp_x = []
    for j in range(num_dim):
        tmp_x.append((-8))#-i*j))
    x.append(tmp_x)
    w.append((-8))#-i*i))
x = np.array(x) / 16.0
w = np.array(w) / 128.0
pprint(x)
pprint(w)
print(np.dot(w,x))

