cambridge-signup
================

Cloudflare Worker that collects email signups from the CamBridge marketing
site's signup form and stores them in a D1 database.

Deployed URL: https://cambridge-signup.mohsin-sapra.workers.dev

D1 database: cambridge_signups
Database ID: edd36ef9-c9bd-4599-b3ba-5ccd798cfb0d

Export the signup list
-----------------------

Run this from the worker/ directory:

wrangler d1 execute cambridge_signups --remote --command "SELECT email, channel, platform, use_case, created_at FROM signups ORDER BY created_at DESC"
