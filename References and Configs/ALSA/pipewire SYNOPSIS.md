pipewire SYNOPSIS

https://docs.pipewire.org/page_man_pipewire_1.html

Table of Contents
 RUNTIME SETTINGS
 ENVIRONMENT VARIABLES
The PipeWire media server

SYNOPSIS
pipewire [options]

DESCRIPTION
PipeWire is a service that facilitates sharing of multimedia content between devices and applications.

The pipewire daemon reads a config file that is further documented in pipewire.conf(5) manual page.

OPTIONS
-h | --help
Show help.
-v | --verbose
Increase the verbosity by one level. This option may be specified multiple times.
--version
Show version information.
-c | --config=FILE
Load the given config file (Default: pipewire.conf).
-P | --properties=PROPS
Add the given properties as a SPA JSON object to the context.
RUNTIME SETTINGS
A PipeWire daemon will also expose a settings metadata object that can be used to change some settings at runtime.

Normally these settings can bypass any of the restrictions listed in the config options above, such as quantum and samplerate values.

The settings can be modified using pw-metadata(1):

pw-metadata -n settings                  # list settings
pw-metadata -n settings 0                # list server settings
pw-metadata -n settings 0 log.level 2    # modify a server setting

log.level = INTEGER
Change the log level of the PipeWire daemon.

clock.rate = INTEGER
The default samplerate.

clock.allowed-rates = [ RATE1 RATE2... ]
The allowed samplerates.

clock.force-rate = INTEGER
Temporarily forces the graph to operate in a fixed sample rate. Both DSP processing and devices will switch to the new rate immediately. Running streams (PulseAudio, native and ALSA applications) will automatically resample to match the new rate.

Set the value to 0 to allow the sample rate to vary again.


clock.quantum = INTEGER
The default quantum (buffer size).

clock.min-quantum = INTEGER
Smallest quantum to be used.

clock.max-quantum = INTEGER
Largest quantum to be used.

clock.force-quantum = INTEGER
Temporarily force the graph to operate in a fixed quantum.

Set the value to 0 to allow the quantum to vary again.

ENVIRONMENT VARIABLES
Socket directories

PIPEWIRE_RUNTIME_DIR

XDG_RUNTIME_DIR

USERPROFILE
Used to find the PipeWire socket on the server (and native clients).

PIPEWIRE_CORE
Name of the socket to make.

PIPEWIRE_REMOTE
Name of the socket to connect to.

PIPEWIRE_DAEMON
If set to true then the process becomes a new PipeWire server.
Config directories, config file name and prefix

PIPEWIRE_CONFIG_DIR

XDG_CONFIG_HOME

HOME
Used to find the config file directories.

PIPEWIRE_CONFIG_PREFIX

PIPEWIRE_CONFIG_NAME
Used to override the application provided config prefix and config name.

PIPEWIRE_NO_CONFIG
Enables (false) or disables (true) overriding on the default configuration.
Context information
As part of a client context, the following information is collected from environment variables and placed in the context properties:


LANG
The current language in application.language.

XDG_SESSION_ID
Set as the application.process.session-id property.

DISPLAY
Is set as the window.x11.display property.
Modules

PIPEWIRE_MODULE_DIR
Sets the directory where to find PipeWire modules.

SPA_SUPPORT_LIB
The name of the SPA support lib to load. This can be used to switch to an alternative support library, for example, to run on the EVL realtime kernel.
Logging options

JOURNAL_STREAM
Is used to parse the stream used for the journal. This is usually configured by systemd.

PIPEWIRE_LOG_LINE
Enables the logging of line numbers. Default true.

PIPEWIRE_LOG_TIMESTAMP
Logging timestamp type: "local", "monotonic", "realtime", "none". Default "local".

PIPEWIRE_LOG
Specifies a log file to use instead of the default logger.

PIPEWIRE_LOG_SYSTEMD
Enables the use of systemd for the logger, default true.
Other settings

PIPEWIRE_CPU
Selects the CPU and flags. This is a bitmask of any of the CPU flags

PIPEWIRE_VM
Selects the Virtual Machine PipeWire is running on. This can be any of the VM types.

DISABLE_RTKIT
Disables the use of RTKit or the Realtime Portal for realtime scheduling.

NO_COLOR
Disables the use of colors in the console output.
Debugging options

PIPEWIRE_DLCLOSE
Enables (true) or disables (false) the use of dlclose when a shared library is no longer in use. When debugging, it might make sense to disable dlclose to be able to get debugging symbols from the object.
Stream options

PIPEWIRE_NODE
Makes a stream connect to a specific object.serial or node.name.

PIPEWIRE_PROPS
Adds extra properties to a stream or filter.

PIPEWIRE_QUANTUM
Forces a specific rate and buffer-size for the stream or filter.

PIPEWIRE_LATENCY
Sets a specific latency for a stream or filter. This is only a suggestion but the configured latency will not be larger.

PIPEWIRE_RATE
Sets a rate for a stream or filter. This is only a suggestion. The rate will be switched when the graph is idle.

PIPEWIRE_AUTOCONNECT
Overrides the default stream autoconnect settings.
Plugin options

SPA_PLUGIN_DIR
Is used to locate SPA plugins.

SPA_DATA_DIR
Is used to locate plugin specific config files. This is used by the bluetooth plugin currently to locate the quirks database.

SPA_DEBUG
Set the log level for SPA plugins. This is usually controlled by the PIPEWIRE_DEBUG variable when the plugins are managed by PipeWire but some standalone tools (like spa-inspect) uses this variable.

ACP_BUILDDIR
If set, the ACP profiles are loaded from the builddir.

ACP_PATHS_DIR

ACP_PROFILES_DIR
Used to locate the ACP paths and profile directories respectively.

LADSPA_PATH
Comma separated list of directories where the ladspa plugins can be found.

LIBJACK_PATH
Directory where the jack1 or jack2 libjack.so can be found.
AUTHORS
The PipeWire Developers <https://gitlab.freedesktop.org/pipewire/pipewire/issues>; PipeWire is available from <https://pipewire.org>