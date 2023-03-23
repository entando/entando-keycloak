#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ -f "./entando-project" ] && . ./entando-project
[ -f "../entando-project" ] && . ../entando-project


if ! type -t "_log_i"; then
  _log_i() {
    echo "> $@"
  }
fi