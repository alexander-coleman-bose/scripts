# Updating Zone Records in Route53

## Requirements

* `python` and `pip` installed and on the `$PATH` for new users
* AWS account with permission to create new IAM users

## Setup

### Create an AWS IAM

Create an AWS IAM user with the following permissions:

* AmazonRoute53AutoNamingRegistrantAccess

### Create a user to run the cron job

The following code creates a new "route53" user, installs `awscli` for that user, and configures `aws` with the appropriate token. Use the AWS Token from the new IAM user that you created to manage this service.

```bash
sudo useradd route53
pip install awscli --upgrade --user
aws configure
```

Then, copy [update_route53.sh](networking/update_route53.sh) from this repository to `/opt/update_route53.sh` and update the hostname, zone id, and nameserver variables in the script to match the AWS Route53 records that you want to update.

Finally, create the following file in `/etc/cron.d/route53-dynamic-dns`:

```bash
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user command
47 * * * * route53 /opt/update_route53.sh
```
