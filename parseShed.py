#!/usr/bin/python

import sys, os, re

injectList = []
shedList = []
f = None

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

# read line by line
injectPattern = re.compile('Injecting ([-]*\d+.\d+)')
shedPattern = re.compile('Shed (\d+.\d+)')
line = f.readline()
while line != '':
	m = injectPattern.search(line)
	if m is not None:
		#print m.group(0)+'-->'+m.group(1)
		injectList.append(m.group(1))
		shedList.append(0)
	else:
		m = shedPattern.search(line)
		if m is not None:
			#print m.group(0)+'-->'+m.group(1)
			shedList[-1] = m.group(1)
	line = f.readline()

# clean-up
f.close()

# check result
injectList.pop()	# remove potentially incomplete data due to termination of simulation
shedList.pop()
for inject, shed in zip(injectList, shedList):
	print '%s\t\t%s' % (inject, shed)
