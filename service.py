import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'resources', 'site-packages'))
from lt2http import service, config

config.init()
service.run()
