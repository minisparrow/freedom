#!/bin/csh -f
#
# This is a generic drive script used for large suites of regression
# tests that each use "self specifying" tool envronments. This script
# assumes that all of the leaves of a regression test file hierarchy
# are tests that each contain a file called 'Env.script' which is a
# csh script that specifies ONLY the required tool environments for
# that specific test.
#
# The script itself should be run only from VANILLA SHELLS and not
# pre-set tool environments. For example it could be driven from
# regression cron jobs or LSF queue jobs.
#
# This script can be driven from recursive Makefiles that traverse
# heirarchy leading to leaf tests.
#
# The contents of those Makefile's would look something like this:
#
# Recursive Makefile sample:
#     DIRS = test1 test2 more_tests_sub_dir ...
#
#     all clean: 
#         for i in $(DIRS); do \
#             test_drive.csh $$i $(MAKE) $@; \
#         done
#
# This recursive Makefile combined with this simple script
# will run all regression tests whether passed or failed.
#
# Once such regressions are run then, if they've been re-directed to
# a global log file, a nice report can be generated by simply grep'ping
# for the pattern "=+= Test" as follows:
#
# % grep "=+= Test" make.log
# =+= Test PASSED /regressions/testcases/test1
# =+= Test FAILED /regressions/testcases/test2
#
# This setup is fractal in nature. That is, it works the same way
# whether it is from the root of the regression tree or at any
# intermediate point in the hierarhcy exluding leaf tests. Each intermediate
# level of the tree merely needs to contain an appropriate recursive
# Makefile script like that shown above.
#
# Any leaf test, can easily be run manually by going to that directory
# and manually sourcing Env.script FROM A VANILLA SHELL.
#
# -- johnS 9-24-04

cd $1;
grep -q DIRS Ma*
if ( $status == "0" ) then
    echo "=+= ----------- `pwd`"
    shift
    $*
else
    if( -e Env.script ) source Env.script
    shift
    echo "Test Started: `date`"
    $*
    if ( $status == "0" ) then
        echo "=+= Test PASSED `pwd`"
    else 
        echo "=+= Test FAILED `pwd`"
    endif
    echo "Test Ended: `date`"
endif
