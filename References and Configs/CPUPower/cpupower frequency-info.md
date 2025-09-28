cpupower frequency-info                                    
analyzing CPU 2:
  driver: intel_cpufreq
  CPUs which run at the same hardware frequency: 2
  CPUs which need to have their frequency coordinated by software: 2
  maximum transition latency: 20.0 us
  hardware limits: 800 MHz - 2.10 GHz
  available cpufreq governors: conservative ondemand userspace powersave performance schedutil
  current policy: frequency should be within 800 MHz and 2.10 GHz.
                  The governor "schedutil" may decide which speed to use
                  within this range.
  current CPU frequency: 1.38 GHz (asserted by call to kernel)
  boost state support:
    Supported: no
    Active: no
    25500 MHz max turbo 4 active cores
    25500 MHz max turbo 3 active cores
    25500 MHz max turbo 2 active cores
    25500 MHz max turbo 1 active cores

cpupower frequency-info | grep driver                           ? ? 
  driver: intel_cpufreq


cpupower -c 0 frequency-info                                    ? ? 
analyzing CPU 0:
  driver: intel_cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 20.0 us
  hardware limits: 800 MHz - 2.10 GHz
  available cpufreq governors: conservative ondemand userspace powersave performance schedutil
  current policy: frequency should be within 800 MHz and 2.10 GHz.
                  The governor "schedutil" may decide which speed to use
                  within this range.
  current CPU frequency: 1.38 GHz (asserted by call to kernel)
  boost state support:
    Supported: no
    Active: no
    25500 MHz max turbo 4 active cores
    25500 MHz max turbo 3 active cores
    25500 MHz max turbo 2 active cores
    25500 MHz max turbo 1 active cores

cpupower -c 1 frequency-info                                    ? ? 
analyzing CPU 1:
  driver: intel_cpufreq
  CPUs which run at the same hardware frequency: 1
  CPUs which need to have their frequency coordinated by software: 1
  maximum transition latency: 20.0 us
  hardware limits: 800 MHz - 2.10 GHz
  available cpufreq governors: conservative ondemand userspace powersave performance schedutil
  current policy: frequency should be within 800 MHz and 2.10 GHz.
                  The governor "schedutil" may decide which speed to use
                  within this range.
  current CPU frequency: 897 MHz (asserted by call to kernel)
  boost state support:
    Supported: no
    Active: no
    25500 MHz max turbo 4 active cores
    25500 MHz max turbo 3 active cores
    25500 MHz max turbo 2 active cores
    25500 MHz max turbo 1 active cores
  

sudo cpupower frequency-set -g performance                      ? ? 
Setting cpu: 0
Setting cpu: 1
Setting cpu: 2
Setting cpu: 3

cpupower -c 0 frequency-info                                    ? ? 
analyzing CPU 0:
  driver: intel_cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 20.0 us
  hardware limits: 800 MHz - 2.10 GHz
  available cpufreq governors: conservative ondemand userspace powersave performance schedutil
  current policy: frequency should be within 800 MHz and 2.10 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency: 2.10 GHz (asserted by call to kernel)
  boost state support:
    Supported: no
    Active: no
    25500 MHz max turbo 4 active cores
    25500 MHz max turbo 3 active cores
    25500 MHz max turbo 2 active cores
    25500 MHz max turbo 1 active cores

 cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor       ? ? 
performance
performance
performance
performance