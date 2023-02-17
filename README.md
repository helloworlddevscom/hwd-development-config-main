## Purpose
Development Repo for setup configurations and local scripts

For New Project Setup:  Reference Confluence doc for steps:


https://helloworlddevs.atlassian.net/wiki/spaces/HWD/pages/2755231745/Wordpress+setup+via+terminus+build+tools

This REPO is to serve as the template source for all new WP Composer installations on pantheon.   Installation should be accomplished by shell script (or something better!)

This REPO should be updated to contain the latest .github, lando, webpack builds as updates are available

## BUILD scripts

---
**lando-setup:sh**

Lando setup:   This is assumed to be a WordPress site from pantheon.   
This setup should enable lando start/lando pull.  

1) Create `.env.lando` file locally.   See `.env.lando.example` for reference.
2) Update:
   1) WRITE_PATH ==>  THIS IS THE ABSOLUTE PATH TO THE DESTINATION REPO YOU WANT TO ADD LANDO TO
   2) SITE       ==>  NAME OF THE SITE ON PANTHEON
   3) ID         ==>  ID OF THE SITE ON PANTHEON
   4) DOMAIN     ==>  LOCAL HOST NAME.   USUALLY <SITE>.lando
3) Run script `./lando-setup.sh`
4) In the DESTINATION REPO:
   1) Run `lando start`

---

**lando-pull-alternative.sh**

`lando pull` (sometimes) does not work correctly.   This is a terminus, CLI script when does the same thing.

1) Copy script to your repo root directory (NOTE:  Don't check this in)
   1) If needed, add `lando-` to your gitignore to avoid this for the project.   No standard lando configs use `lando-`.
2) change permissions if needed `chmod +x lando-pull-alternative.sh`;
3) run with `-h` to see usage:  `lando-pull-alternative.sh -h`
4) Update site (`-n`) and launch script to use defaults!

---

**plugin-setup.sh**

NOTE:  You must have a skeleton plugin created first for this to successfully work.   See Confluence for more info.
--> this is step 3 ...where you use the wp boiler plate code to generate a base plugin
 
1) Add a new variable name `PLUGIN_NAME` to your `.env.lando` file with the slug name
2) Run script `./plugin-setup.sh`
3) In the DESTINATION REPO:
    1) Run `nvm i; npm i; npm run start:webprod`
NOTE:  THis is a shortcut to use the correct version of .nvm ...as set here in the `.nvmrc` file
   