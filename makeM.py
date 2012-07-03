#!/usr/bin/python

import sys, os, re
from copy import deepcopy

if len(sys.argv) <= 1:
	print >> sys.stderr, 'Usage: %s <filename>' % sys.argv[0]
	sys.exit(0)

# open file
filename = sys.argv[1]
try:
	f = open(filename, 'r')
except IOError:
	print >> sys.stderr, 'Cannot open '+filename
	sys.exit(0)

M = [[0, 0],[0, 0]]

startPatt = re.compile('Session start: s(\d)')
endPatt = re.compile('Session end: s(\d)')
line = f.readline()
while line != '':
	m = startPatt.search(line)
	if m is not None:
		startState = int(m.group(1))
	else:
		m = endPatt.search(line)
		if m is not None:
			endState = int(m.group(1))
			M[startState][endState] = M[startState][endState] + 1
	line = f.readline()

denom = sum(M[0])
M[0][0] = float(M[0][0])/denom
M[0][1] = float(M[0][1])/denom
denom = sum(M[1])
M[1][0] = float(M[1][0])/denom
M[1][1] = float(M[1][1])/denom
print M

"""
a_10, d_1:
[[0.20000000000000001, 0.80000000000000004], [0.13636363636363635, 0.86363636363636365]]
a_10, d_2 (theoretically more effective defense):
[[0.33333333333333331, 0.66666666666666663], [0.14285714285714285, 0.8571428571428571]]
a_20, d_1 (theoretically more effective defense):
[[0.5, 0.5], [0.043478260869565216, 0.95652173913043481]]
a_20, d_2:
[[0.5714285714285714, 0.42857142857142855], [0.10000000000000001, 0.90000000000000002]]
"""
