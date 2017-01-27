# aws-auto-hostname-and-ddns

A script to dynamically set hostname and DNS entry for ec2 instances belong to a security group based on each instance's IPv4 address.

The `init-hostname.sh` script is to be added as instances startup script. You may also use cloud-config `bootcmd`:

### Dynamic hostname alternative using cloud-config:
```yaml
#cloud-config
bootcmd:
    - "HOSTNAME_PREFIX=my-app"
    - "INSTANCE_IP=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-hostname | cut -d . -f 1 | cut -c4-)"
    - "echo ${HOSTNAME_PREFIX}-${INSTANCE_IP} > /etc/hostname; hostname -F /etc/hostname"
```
