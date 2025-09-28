#!/bin/bash
#
# Copyright (c) 2011 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Let the wrapped binary know that it has been run through the wrapper.
export CHROME_WRAPPER="$(readlink -f "$0")"
export HERE="$(dirname "$CHROME_WRAPPER")"

# Allow users to override command-line options
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
FREETUBE_USER_FLAGS=""
if [[ -f "$XDG_CONFIG_HOME/freetube-flags.conf" ]]; then
   FREETUBE_USER_FLAGS="$(cat "$XDG_CONFIG_HOME/freetube-flags.conf" | sed -e '/^\s*#/d')"
fi

# Note: exec -a below is a bashism.
exec -a "$0" "$HERE/freetube" $FREETUBE_USER_FLAGS "$@"