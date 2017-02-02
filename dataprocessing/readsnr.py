#!/usr/bin/env python
from lib.SNR import SNR
from lib.AmbientSound import AmbientSound

# snrReader = SNR()
#
# snrReader.readProbeSNR()
# snrReader.readAPSignal()

ambient = AmbientSound()
ambient.readAmbientSound()
