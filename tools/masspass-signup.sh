#!/bin/bash
# Signup handler for MASSAGE-PASS landing page
EMAIL=$1
DATE=$(date '+%Y-%m-%d')
echo "$EMAIL,$DATE,welcome,pending" >> /data/workspace/PROJECTS/MASSAGE-PASS/waitlist.csv
echo "✓ Signed up: $EMAIL"