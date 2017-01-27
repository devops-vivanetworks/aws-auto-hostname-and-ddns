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

## To enable dynamic DNS part, please refer to 
The [Lambda script](https://github.com/awslabs/aws-lambda-ddns-function/blob/master/union.py) from [Building a Dynamic DNS for Route 53 using CloudWatch Events and Lambda](https://github.com/awslabs/aws-lambda-ddns-function)

We tweaked the script, so instead of using `instance_state=='running'`, we use `event_detail_type=='EC2 Instance Launch Successful'` which means the script will be trigger each type an instance is spawned. We use EC2 tags to filter the instances this script applies to.
```python
    # Set variables
    # Get lifecycle transition from Event stream
    detail_type = event['detail-type']
    # ...
    if detail_type == 'EC2 Instance Launch Successful':
```
