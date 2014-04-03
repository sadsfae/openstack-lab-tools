Provisioning Tools
===================

This is a series of tools which help deploy Foreman-driven OpenStack deployments
in a rapidly provisioned environment (R&D, CI, scale testing).

These tools will allow you to use the Foreman CLI, IPMI, and Foreman
hostgroup-driven puppet modules to automatically deploy a configurable set of
OpenStack nodes into a working cluster with 1 x controller, 1 x neutron networker
and however many nova compute nodes you like.

   * demo-cluster-hosts  (list of target deployment hosts)
   * wipe-node.sh
        custom script, which does the following:
          - Unregister host from RHN or Satellite
          - Use IPMI interface to powerdown host
          - Delete host parameters from Foreman using hammer CLI
   * one-cluster.sh
        custom script, which does the following:
          - call "cold-kick.sh" with 6 parameters:
                  controller, controller IPMI, 
                  neutron, neutron IPMI, 
                  and one nova compute node, nova compute IPMI
          - call "cold-move-nova-compute.sh" with each of the rest of nova compute nodes
   * cold-kick.sh
          - Builds cluster with minimum requirements, i.e.:
               .  One controller
               .  One neutron node
               .  One nova compute
          - Assumes hosts are powered down, and uses hammer CLI to point nodes at the controller.
            (Also marks for rebuild)
          - Uses IPMI interface to powerup the hosts
   * cold-move-nova-compute.sh
          - Takes three arguments.  Controller IP, nova compute node, and compute node IPMI interface.
          - Uses hammer CLI to allocate compute node to cluster.  Mark host for rebuild.
          - Uses IPMI interface to power up the host (assumes already down).
