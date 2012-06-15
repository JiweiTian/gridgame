#!/usr/bin/python2.7

import sys, os, re
from pylab import *

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
		injectList.append(float(m.group(1)))
		shedList.append(0)
	else:
		m = shedPattern.search(line)
		if m is not None:
			#print m.group(0)+'-->'+m.group(1)
			shedList[-1] = float(m.group(1))
	line = f.readline()

# clean-up
f.close()

# check result
injectList.pop()	# remove potentially incomplete data due to termination of simulation
shedList.pop()
injectShedList = zip(injectList, shedList)
injectShedList.sort()
#for inject, shed in injectShedList:
#	print '%s,\t%s' % (inject, shed)

# statistical processing
it = iter(injectShedList)
freqBins = arange(-3, 0, 0.05)
totalCnt = 0
shedCnt = 0
probList = []
for freq in freqBins:
	try:
		(inject, shed) = it.next()
		while freq <= inject and inject < freq + 0.05:
			totalCnt += 1
			if shed > 0:
				shedCnt += 1
			(inject, shed) = it.next()
		probList.append(float(shedCnt)/totalCnt)
		totalCnt = 0
		shedCnt = 0
	except Exception as exc:
		probList.append(float(shedCnt)/totalCnt)
		break
plot(freqBins+([0.025]*len(freqBins)), probList) # take the middle of each freqBin
show()
