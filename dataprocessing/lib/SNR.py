# This program read the log file and extract the SNR
# (c) Guntur DP 2016 - guntur.dharma@gmail.com

# todo
# [ ] median
# [ ] mode
# [ ] mean

import os, re
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import numpy as np

class SNR:
	decibels = range(-25,75)
	count = [0] * len(decibels)
	rssi = range(-120, 1)
	count_rssi = [0] * len(rssi)

	def readProbeSNR(self):
		# the access point file
		# split the columns using regex
		for filename in os.listdir("data/"):
			if len(filename.split("-")) == 4:
				# get the parameters from filename
				(location, scan_type, scan_date, scan_time) = filename.split("-")

				if scan_type == "pr":
					foo = dict()
					scan_time = scan_time[:-4]

					with open("data/" + filename) as f:
						for line in f:
							# the pattern:
							# -79[dB signal] -96[dB noise]
							# regex = r'SA:[a-z|0-9]{2}:[a-z|0-9]{2}:[a-z|0-9]{2}:[a-z|0-9]{2}:[a-z|0-9]{2}:[a-z|0-9]{2}'
							regex = r'\-[0-9]+'
							matches = re.findall(regex, line)

							# get the snr
							if matches and len(matches) > 1:
								snr = int(matches[0]) - int(matches[1])
							else:
								continue

							# find the index of the snr
							try:
								index = self.decibels.index(snr)
							except ValueError:
								print "Index out of bounds... (%d)" %snr
								exit(1)

							self.count[index] += 1

		# get the statistic value
		mode = self.decibels[self.count.index(max(self.count))]

		plt.figure()
		plt.title(r'$\mathrm{%s-%s PR:}\  Mo=%ddB$' % (location, scan_date, mode))
		plt.plot(self.decibels, self.count)
		plt.xlabel("SNR (dB)")
		plt.ylabel("Frequency")
		plt.grid(True)

		# save to pdf
		pdfgraph = PdfPages(location + "-" + scan_date + "-pr-SNR.pdf")
		pdfgraph.savefig(plt.gcf())
		pdfgraph.close()

	def readAPSignal(self):
		# the access point file
		# split the columns using regex
		for filename in os.listdir("data/"):
			if len(filename.split("-")) == 4:
				# get the parameters from filename
				(location, scan_type, scan_date, scan_time) = filename.split("-")

				if scan_type == "ap":
					foo = dict()
					scan_time = scan_time[:-4]

					with open("data/" + filename) as f:
						for line in f:
							# the pattern:
							# [:e8 ]-85[  136]
							regex = r':[a-z|0-9]{2}\s\-[0-9]+\s'
							matches = re.findall(regex, line)

							# get the snr
							if matches:
								# print matches[0][4:]
								current_rssi = int(matches[0][4:])

								# find the index of the snr
								try:
									index = self.rssi.index(current_rssi)
								except ValueError:
									print "Index out of bounds... (%d)" % current_rssi
									exit(1)

								self.count_rssi[index] += 1
							else:
								continue

		# get the statistic value
		mode = self.rssi[self.count_rssi.index(max(self.count_rssi))]

		plt.figure()
		plt.title(r'$\mathrm{%s-%s AP:}\  Mo=%ddB$' % (location, scan_date, mode))
		plt.plot(self.rssi, self.count_rssi)
		plt.xlabel("RSSI (dB)")
		plt.ylabel("Frequency")
		plt.grid(True)

		# save to pdf
		pdfgraph = PdfPages(location + "-" + scan_date + "-ap-RSSI.pdf")
		pdfgraph.savefig(plt.gcf())
		pdfgraph.close()
