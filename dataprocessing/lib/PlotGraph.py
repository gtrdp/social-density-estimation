# this program read the condensed log file and plot it in a graph
# (c) Guntur DP 2016 - guntur.dharma@gmail.com

import pprint
<<<<<<< HEAD
import matplotlib
=======
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt
from scipy.stats.stats import pearsonr
from itertools import islice

class PlotGraph:
	pp = pprint.PrettyPrinter(indent=4)
	access_point = dict()
	probe_request = dict()
	audio_record = dict()
	rms = dict()
	pklv = dict()
	ground_truth = dict()
	rssi = dict()
	snr = dict()

	audio = 0
	scan_date = ""
	threshold = 0

	def __init__(self, access_point, probe_request, audio_record, ground_truth, pklv, rms, rssi, snr, audio, scan_date, threshold):
		self.access_point = access_point
		self.probe_request = probe_request
		self.audio_record = audio_record
		self.ground_truth = ground_truth
		self.pklv = pklv
		self.rms = rms
		self.rssi = rssi
		self.snr = snr

		self.audio = audio
		self.scan_date = scan_date
		self.threshold = threshold

	def plot(self):
		for location in self.access_point:
			# prepare the figure
			plt.figure(1)
			plt.plot(self.access_point[location]['timely'], label='Access Point count')
			plt.plot(self.probe_request[location]['timely'], label='Device count')
<<<<<<< HEAD
			# if self.audio:
			# 	plt.plot(self.audio_record[location]['timely'], label='Speaker count')
			# plt.plot(self.ground_truth[location], label='Head count')
=======
			if self.audio:
				plt.plot(self.audio_record[location]['timely'], label='Speaker count')
			plt.plot(self.ground_truth[location], label='Ground truth')
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237

			max_x = len(self.access_point[location]['timely']) + 0.2
			max_y = max(self.probe_request[location]['timely'] + self.access_point[location]['timely'] + self.ground_truth[location])
			print max_y
<<<<<<< HEAD
			# plt.axis([0, max_x, 0, max_y + int(round(0.25*max_y))])
			plt.axis([0, max_x, 0, 300])
=======
			plt.axis([0, max_x, 0, max_y + int(round(0.25*max_y))])
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
			plt.xlabel('# Measurement')
			plt.ylabel('Count')
			plt.title(location)

			# annotate the points
<<<<<<< HEAD
			matplotlib.rcParams.update({'font.size': 10})
			# for idx, value in enumerate(self.access_point[location]['timely']):
			# 	plt.annotate(str(value), xy=(idx, value))
			# for idx, value in enumerate(self.probe_request[location]['timely']):
			# 	plt.annotate(str(value), xy=(idx, value))
			# if self.audio:
			# 	for idx, value in enumerate(self.audio_record[location]['timely']):
			# 		plt.annotate(str(value), xy=(idx, value))
			# for idx, value in enumerate(self.ground_truth[location]):
			# 	plt.annotate(str(value), xy=(idx, value))
=======
			for idx, value in enumerate(self.access_point[location]['timely']):
				plt.annotate(str(value), xy=(idx, value))
			for idx, value in enumerate(self.probe_request[location]['timely']):
				plt.annotate(str(value), xy=(idx, value))
			if self.audio:
				for idx, value in enumerate(self.audio_record[location]['timely']):
					plt.annotate(str(value), xy=(idx, value))
			for idx, value in enumerate(self.ground_truth[location]):
				plt.annotate(str(value), xy=(idx, value))
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237

			lgd = plt.legend(bbox_to_anchor=(1, 1), loc='upper right', ncol=1)

			# plt.xticks(1)
			pdfgraph = PdfPages(location + '-' + self.scan_date +'.pdf')
			pdfgraph.savefig(plt.gcf())
			pdfgraph.close()
			# plt.show()

			print "The graph is saved..."

	# plot scatter and count the correlation
	def plotScatter(self, ap, pr, au, gt, location, scan_date = None):
		# prepare the variable for loops
<<<<<<< HEAD
		xlabel = ['device count', 'head count', 'head count']
=======
		xlabel = ['device count', 'ground truth', 'ground truth']
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
		ylabel = ['access point count', 'device count', 'access point count']
		x = [pr, gt, gt]
		y = [ap, pr, ap]
		filename = ['-pr-vs-ap.pdf', '-gt-vs-pr.pdf', '-gt-vs-ap.pdf']

		for i in range(0, 3):
			# calculate the correlation first
			rho, pvalue = pearsonr(x[i], y[i])
			# plotting scatter table and calculating correlation
			plt.figure()
			plt.xlabel(xlabel[i])
			plt.ylabel(ylabel[i])
			plt.scatter(x[i], y[i])
			plt.grid(True)

			if scan_date is None:
				pdfgraph = PdfPages(location + filename[i])
				plt.title(r'$\mathrm{%s:}\ \rho=%.3f,\ p-value=%.3f$' % (location, rho, pvalue))
			else:
				pdfgraph = PdfPages(location + '-' + scan_date + filename[i])
				plt.title(r'$\mathrm{%s-%s:}\ \rho=%.3f,\ p-value=%.3f$' % (location, scan_date, rho, pvalue))

			pdfgraph.savefig(plt.gcf())
			pdfgraph.close()

	def plotScatterGlobal(self):
		ap = dict()
		pr = dict()
		gt = dict()

		# read all data from log file
		# separate the data into locations
		with open('dump/global-dump.txt') as f:
			for line in islice(f, 3, None):  # skip the headers
				foo = line.split("	")
				loc = foo[8].strip()

				if loc not in ap:
					ap[loc] = [int(foo[0].strip())]
					pr[loc] = [int(foo[1].strip())]
					gt[loc] = [int(foo[3].strip())]
				else:
					ap[loc].append(int(foo[0].strip()))
					pr[loc].append(int(foo[1].strip()))
					gt[loc].append(int(foo[3].strip()))

		# plot the graph
<<<<<<< HEAD
		xlabel = ['device count', 'head count', 'head count']
=======
		xlabel = ['device count', 'ground truth', 'ground truth']
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
		ylabel = ['access point count', 'device count', 'access point count']
		x = [pr, gt, gt]
		y = [ap, pr, ap]
		filename = ['-pr-vs-ap.pdf', '-gt-vs-pr.pdf', '-gt-vs-ap.pdf']
		location_name = {"g": "grotemarkt", "h": "home", "p": "paddepoel", "r": "remote"}
		colors = {"g": "c", "h": "m", "p": "y", "r": "g"}

		for i in range(0, 3):
			# combine all data
			x_all, y_all = list(), list()
			for key in x[i]:
				x_all += x[i][key]
				y_all += y[i][key]

			# calculate the correlation first
			rho, pvalue = pearsonr(x_all, y_all)

			# plotting scatter table and calculating correlation
			plt.figure()

			# plotting in all location
			for key in x[i]:
				plt.scatter(x[i][key], y[i][key], c=colors[key], label=location_name[key])

			plt.xlabel(xlabel[i])
			plt.ylabel(ylabel[i])
			plt.grid(True)
			plt.legend(loc='upper left')

			# save to pdf
			pdfgraph = PdfPages("global" + filename[i])
			plt.title(r'$\mathrm{global:}\ \rho=%.3f,\ p-value=%.3f$' % (rho, pvalue))

			pdfgraph.savefig(plt.gcf())
			pdfgraph.close()

	def plotScatterLocal(self):
		for location in self.access_point:
			self.plotScatter(self.access_point[location]['timely'],
							 self.probe_request[location]['timely'],
							 self.audio_record[location]['timely'],
							 self.ground_truth[location],
							 location,
							 self.scan_date)

	def plotScatterCumulative(self):
		for location in self.access_point:
			ap = list()
			pr = list()
			au = list()
			gt = list()

			print location

			# read all data from log file
			with open('dump/'+location+'-dump.txt') as f:
				for line in islice(f, 3, None):  # skip the headers
					foo = line.split("	")

					ap.append(int(foo[0].strip()))
					pr.append(int(foo[1].strip()))
					au.append(int(foo[2].strip()))
					gt.append(int(foo[3].strip()))

			self.plotScatter(ap, pr, au, gt, location)
