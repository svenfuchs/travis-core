#!/bin/bash
RAILS_ENV=test bundle exec rake parallel:spec\[2\]
export tresult=$?
find . -name hs_err_pid*.log -exec cat {} \;
exit $tresult
