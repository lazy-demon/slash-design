# This is the main configuration file. You can deploy your Serverpod by only
# doing changes to this file. Serverpod uses a minimal setup by default, but
# you can edit the main.tf file to choose higher tiers for database and your
# managed instances or enable additional services like Redis.
#
# You can find complete setup instructions at:
# https://docs.serverpod.dev/

# The Project ID from the Google Cloud Console.
project = "slash-design-231099"

# The service account email address authorized by your Google Cloud Console.
service_account_email = "jefdayt@gmail.com"

# The name of your DNS zone.
dns_managed_zone = "slashdesign.nl."

# The top domain of your DNS zone. e.g. "examplepod.com"
top_domain = "slashdesign.nl"

# The region and zone to use for the deployment. Default values work.
region = "eu-west4"
zone   = "eu-west4-a"
