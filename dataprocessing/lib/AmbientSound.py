# This program read the log file and extract the ambien noise in decibels
# (c) Guntur DP 2016 - guntur.dharma@gmail.com

import os, re
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import subprocess

class AmbientSound:
	peak = dict()
	rms = dict()

	def readAmbientSound(self):
		# the access point file
		# split the columns using regex
		for filename in os.listdir("data/"):
			if len(filename.split("-")) == 4:
				# get the parameters from filename
				(location, scan_type, scan_date, scan_time) = filename.split("-")

				if scan_type == "au":
					regex_peak = r'Pk lev dB\s+\S+'
					regex_rms = r'RMS lev dB\s+\S+'
					foo = subprocess.Popen(['sox', 'data/' + filename, '-n', 'stats'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE).communicate()[1]
					foo = foo.strip()

					peak = re.findall(regex_peak, foo)
					rms = re.findall(regex_rms, foo)

					# get the peak level
					if peak:
						peak = float(peak[0].replace('Pk lev dB', '').strip())

						if location not in self.peak:
							# new record
							self.peak[location] = [peak]
						else:
							self.peak[location].append(peak)
					else:
						print "peak not found"

					# get the rms level
					if rms:
						rms = float(rms[0].replace('RMS lev dB', '').strip())

						if location not in self.rms:
							# new record
							self.rms[location] = [rms]
						else:
							self.rms[location].append(rms)
					else:
						print "rms not found"

		peak_sorted = sorted(self.peak)
		rms_sorted = sorted(self.rms)

		# draw the figure for peak
		plt.figure()

		max_y, min_y, max_x = 0,0,0

		for location in peak_sorted:
			plt.plot(self.peak[location], label=location)
			if min_y > min(self.peak[location]):
				min_y = min(self.peak[location])
			if max_y < max(self.peak[location]):
				max_y = max(self.peak[location])

			max_x = len(self.peak[location])

			# annotation
			# for idx, value in enumerate(self.peak[location]):
			# 	plt.annotate(str(value), xy=(idx, value))

			# print out the average
			print "%s - Peak Level average: %f" %(location, (sum(self.peak[location])/float(len(self.peak[location]))))

		plt.axis([0, max_x, min_y - 10, max_y + 20])
		plt.xlabel('# Measurement')
		plt.ylabel('Peak Level (dB)')
		plt.title('Peak Level Comparison in dB ('+scan_date+')')
		plt.legend(bbox_to_anchor=(1, 1), loc='upper right', ncol=1)

		# plt.xticks(1)
		pdfgraph = PdfPages('peak-level-comparison-'+scan_date+'.pdf')
		pdfgraph.savefig(plt.gcf())
		pdfgraph.close()

		# draw figure for rms
		plt.figure()

		max_y, min_y, max_x = 0, 0, 0

		for location in rms_sorted:
			plt.plot(self.rms[location], label=location)
			if min_y > min(self.rms[location]):
				min_y = min(self.rms[location])
			if max_y < max(self.rms[location]):
				max_y = max(self.rms[location])

			max_x = len(self.rms[location])

			# annotation
			# for idx, value in enumerate(self.rms[location]):
			# 	plt.annotate(str(value), xy=(idx, value))

			# print out the average
			print "%s - RMS average: %f" %(location, sum(self.rms[location]) / float(len(self.rms[location])))

		plt.axis([0, max_x, min_y - 10, max_y + 20])
		plt.xlabel('# Measurement')
		plt.ylabel('rms Level (dB)')
		plt.title('RMS Level Comparison in dB ('+scan_date+')')

		plt.legend(bbox_to_anchor=(1, 1), loc='upper right', ncol=1)

		# plt.xticks(1)
		pdfgraph = PdfPages('rms-level-comparison'+scan_date+'.pdf')
		pdfgraph.savefig(plt.gcf())
		pdfgraph.close()
