f1 = open('../TH/code.bin', 'rb')
f2 = open('../TH/code1.bin', 'rb')
r = open('../TH/res.bin', 'wb')
for i in f1:
    r.write(i)
for j in f2:
    r.write(j)
f1.close()
f2.close()
r.close()