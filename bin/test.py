#!/usr/bin/env python3
import os
import subprocess
import shlex

exclude = set(['.idea', '.git', 'scripts'])

for root, dirs, files in os.walk('.', topdown=True):
    dirs[:] = [d for d in dirs if d not in exclude]
    for dir in dirs:
        path = os.path.join(root, dir)
        if any([f for f in os.listdir(path) if f.endswith('.tf')]):
            print('checking Terraform module @ {0} -- '.format(path), end='', flush=True)
            res = subprocess.call(shlex.split('terraform validate {0}'.format(path)))
            print('OK' if res == 0 else 'FAIL')