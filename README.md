openstack-lab-tools
===================

This is a set of Shell and Python tools which help deploy Foreman-driven OpenStack 
deployments in a rapidly provisioned environment (R&D, CI, scale testing).

These tools will allow you to use the Foreman CLI, IPMI, and Foreman
hostgroup-driven puppet modules to automatically deploy a configurable set of
OpenStack nodes into a working cluster with 1 x controller, 1 x neutron networker
and however many nova compute nodes you like.

For testing-driven setups, the lab-schedule tooling will allow you to automatically
build/rebuild sets of hosts based on assignment and produce an ical calendar file
where you can publish current status of the various clusters or any tests you are
running for development groups to plan against (or change as needed).

This is offered as-is, and not affiliated with Red Hat official deployment methodologies
or any sort of support but hopefully others can find them useful.
Original credit for this tooling goes to @kambiz-aghaiepour

Here's a video demo of reprovisioning 70 bare-metal hosts into a new OpenStack cluster: http://youtu.be/i6r7W-HtufU

**Tools Needed**

   - Foreman 1.3.2+ (or provided by openstack-foreman-installer)
      * http://openstack.redhat.com/Deploying_RDO_using_Foreman
   - quickstack/Astapor modules (or ones provided by openstack-foreman-installer)
      * https://github.com/redhat-openstack/astapor
   - Hammer CLI
      * http://blog.theforeman.org/2013/11/hammer-cli-for-foreman-part-i-setup.html
   - Some IPMI tooling (vendor provided or similiar: our examples use Dell/Racadm)
   - RHOS4 or RDO repos on RHEL or CentOS
   - a local git repo (if you want to use the lab scheduling tools)

**Contents**

   - _provision-tools_: contains Shell tools that call the Foreman CLI and IPMI tools
     to build and deploy your OpenStack cluster

   - _lab-tools_: contains Python and Shell tools which allow automatic provisioning based
     on node-to-cluster definitions, generates an iCal calendar file for hosting somewhere.

