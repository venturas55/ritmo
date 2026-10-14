#!/usr/bin/env python3
"""Fail early when GitHub variables do not match Expo iOS configuration."""
import json
import os
import sys

with open(sys.argv[1], encoding='utf-8') as source:
    cfg = json.load(source)
app = cfg.get('exp', cfg)
actual = app.get('ios', {}).get('bundleIdentifier')
expected = os.getenv('APPLE_BUNDLE_ID', '')
team = os.getenv('APPLE_TEAM_ID', '')
if not expected or not team:
    sys.exit('Set GitHub variables APPLE_BUNDLE_ID and APPLE_TEAM_ID first.')
if actual != expected:
    sys.exit(f'Bundle ID mismatch: app config={actual!r}, GitHub variable={expected!r}')
if not app.get('ios'):
    sys.exit('Expo app config must include ios settings')
print('Expo iOS config and GitHub variables agree.')
