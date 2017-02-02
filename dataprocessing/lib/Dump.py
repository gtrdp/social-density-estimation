# this program dump the resulted data extraction to file
# (c) Guntur DP 2016 - guntur.dharma@gmail.com

from itertools import islice
import sys

class Dump:
	# features variable
	access_point = dict()
	probe_request = dict()
	audio_record = dict()
	rms = dict()
	pklv = dict()
	ground_truth = dict()
	rssi = dict()
	snr = dict()

	all_data = list()
	scan_date = ""

	def __init__(self, access_point, probe_request, audio_record, ground_truth, pklv, rms, rssi, snr, scan_date):
		self.access_point = access_point
		self.probe_request = probe_request
		self.audio_record = audio_record
		self.ground_truth = ground_truth
		self.pklv = pklv
		self.rms = rms
		self.rssi = rssi
		self.snr = snr
		self.scan_date = scan_date

	def readDump(self, filename):
		# read all data from log file
		try:
			f = open(filename, 'r+')
		except Exception, e:
			print str(e)
			print "Empty data dump: "+filename+"..."
		else:
			for line in islice(f, 3, None):  # skip the headers
				foo = line.split("	")
				# convert to int
				for i, val in enumerate(foo):
					try:
						foo[i] = int(foo[i].strip())
					except Exception, e:
						foo[i] = foo[i].strip()


				self.all_data.append(tuple(foo))

			f.close()

	# Write global dump
	def writeDump(self):
		# read previous data
		self.readDump('dump/global-dump.txt')

		# we assume that the length of all ap pr and audio are the same
		for location in self.access_point:
			# only proceed if the variable length is the same
			if len(self.access_point[location]['timely']) == len(self.probe_request[location]['timely']) == len(self.audio_record[location]['timely']):
				for i in range(0, len(self.access_point[location]['timely'])):
					ap = self.access_point[location]['timely'][i]
					pr = self.probe_request[location]['timely'][i]
					au = self.audio_record[location]['timely'][i]
					gt = self.ground_truth[location][i]
					pklv=self.pklv[location][i]
					rms= self.rms[location][i]
					rssi=self.rssi[location][i]
					snr= self.snr[location][i]

					self.all_data.append((ap, pr, au, gt, pklv, rms, rssi, snr, location[:1]))
			else:
				print 'ERROR: the length of the input variables are not the same'
				sys.exit()

		# remove duplicates using set
		self.all_data = list(set(self.all_data))

		# write data to the file, overwrite
		target = open('dump/global-dump.txt', 'w')
		# header comes first
		header = "[WiFi and Probe request correlation data]\n\nAP	PR	Au	GT	RMS	PKLV	RSSI	SNR	LOC\n"
		target.write(header)

		for value in self.all_data:
			target.write(str(value[0]) + "\t" + str(value[1]) + "\t" + str(value[2]) + "\t" + str(value[3]) + "\t"\
						 + str(value[4]) + "\t" + str(value[5]) + "\t" + str(value[6]) + "\t" + str(value[7]) + "\t"\
						 + str(value[8]) +"\n")

		target.close()

	# Write local dump for each location and each scanning time
	# also write to cumulative local dump
	def writeLocalDump(self):
		# This function writes: correlation dump, raw data, manufacturer
		local_dump = list()

		# we assume that the length of all ap pr and audio are the same
		for location in self.access_point:
			# =======================================
			# 1. a) write the dump for correlation graph
			# only proceed if the variable length is the same
			if len(self.access_point[location]['timely']) == len(self.probe_request[location]['timely']) == len(self.audio_record[location]['timely']):
				for i in range(0, len(self.access_point[location]['timely'])):
					ap = self.access_point[location]['timely'][i]
					pr = self.probe_request[location]['timely'][i]
					au = self.audio_record[location]['timely'][i]
					gt = self.ground_truth[location][i]
					pklv = self.pklv[location][i]
					rms = self.rms[location][i]
					rssi = self.rssi[location][i]
					snr = self.snr[location][i]

					local_dump.append((ap, pr, au, gt, pklv, rms, rssi, snr, location[:1]))
			else:
				print 'ERROR: the length of the input variables are not the same (write local dump)'
				sys.exit()

			# remove duplicates using set
			local_dump = list(set(local_dump))

			# write data to the file, overwrite
			target = open('dump/' + location + '-' + self.scan_date + '-dump.txt', 'w')
			# header comes first
			header = "[WiFi and Probe request correlation data for " + location +"-"+self.scan_date+"]\n\nAP	PR	Au	GT	RMS	PKLV	RSSI	SNR	LOC\n"
			target.write(header)

			for value in local_dump:
				target.write(str(value[0]) + "\t" + str(value[1]) + "\t" + str(value[2]) + "\t" + str(value[3]) + "\t" \
							 + str(value[4]) + "\t" + str(value[5]) + "\t" + str(value[6]) + "\t" + str(value[7]) + "\t" \
							 + str(value[8]) + "\n")

			target.close()

			# ==========================
			# 1. b) cumulative local dump
			# firstly read out the previous data
			self.all_data = list()
			self.readDump('dump/' + location + '-dump.txt')

			# append the data and remove duplicates
			self.all_data = self.all_data + local_dump
			self.all_data = list(set(self.all_data))

			# write to file
			target = open('dump/' + location + '-dump.txt', 'w')
			# header comes first
			header = "[WiFi and Probe request correlation data for " + location + "]\n\nAP	PR	Au	GT	RMS	PKLV	RSSI	SNR	LOC\n"
			target.write(header)

			for value in self.all_data:
				target.write(str(value[0]) + "\t" + str(value[1]) + "\t" + str(value[2]) + "\t" + str(value[3]) + "\t" \
							 + str(value[4]) + "\t" + str(value[5]) + "\t" + str(value[6]) + "\t" + str(value[7]) + "\t" \
							 + str(value[8]) + "\n")

			# empty the list
			local_dump = list()
			target.close()

			# ==========================
			# 2. the processed data dump
			target = open('dump/' + location + '-' + self.scan_date + '-raw.txt', 'w')
			# header comes first
			header = "[Raw data for " + location + "-" + self.scan_date + "]\n\n"
			target.write(header)

			target.write("access point\n" + repr(self.access_point[location]) + "\n\n\n")
			target.write("probe request\n" + repr(self.probe_request[location]) + "\n\n\n")
			target.write("audio record\n" + repr(self.audio_record[location]) + "\n\n\n")
			target.write("ground truth\n" + repr(self.ground_truth[location]) + "\n\n\n")
			target.write("peak level\n" + repr(self.pklv[location]) + "\n\n\n")
			target.write("root mean square\n" + repr(self.rms[location]) + "\n\n\n")
			target.write("rssi\n" + repr(self.rssi[location]) + "\n\n\n")
			target.write("signal to noise ratio\n" + repr(self.snr[location]) + "\n\n\n")

			# close the handle and empty the list
			target.close()

			# ====================
			# 3. manufacturer dump
			# firstly read OUI list and store that in memory
			# for MAC address removal
			oui_list = dict()
			with open('nmap-mac-prefixes.txt') as f:
				for line in f:
					(macaddr, company) = line.split("	")
					oui_list[macaddr] = company

			# the file handler
			target = open('dump/' + location + '-' + self.scan_date + '-manufacturer.txt', 'w')
			header = "[Manufacturer dump for " + location + "-" + self.scan_date + "]\n\n"
			target.write(header)

			# for access point
			ap_mac = dict()
			for idx, value in self.access_point[location]['total'].iteritems():
				foo = idx.upper().replace(':', '') # get the formatted mac address

				oui = foo[0:6]

				# check if the MAC address complies with IEEE OUI standards
				try:
					vendor = oui_list[oui].strip()
				except Exception, e:
					vendor = ""

				if vendor and vendor not in ap_mac:
					ap_mac[vendor] = 1
				elif vendor and vendor in ap_mac:
					ap_mac[vendor] = ap_mac[vendor] + 1

			# write to file
			target.write("access point\n")
			for idx, value in ap_mac.iteritems():
				target.write(idx + "\t" + str(value) + "\n")
			target.write("\n\n\n")

			# for probe request
			pr_mac = dict()
			for idx, value in self.probe_request[location]['total'].iteritems():
				oui = idx[0:6]

				# check if the MAC address complies with IEEE OUI standards
				try:
					vendor = oui_list[oui].strip()
				except Exception, e:
					vendor = "randomMAC"

				if vendor and vendor not in pr_mac:
					pr_mac[vendor] = 1
				elif vendor and vendor in pr_mac:
					pr_mac[vendor] = pr_mac[vendor] + 1

			# write to file
			target.write("probe request\n")
			for idx, value in pr_mac.iteritems():
				target.write(idx + "\t" + str(value) + "\n")

			target.close()
