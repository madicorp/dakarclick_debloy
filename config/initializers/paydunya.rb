Paydunya::Setup.master_key = ENV["PAYDUNYA_MASTER_KEY"]
Paydunya::Setup.public_key = ENV["PAYDUNYA_PUBLIC_KEY"]
Paydunya::Setup.private_key = ENV["PAYDUNYA_PRIVATE_KEY"]
Paydunya::Setup.token = ENV["PAYDUNYA_TOKEN"]

# Configuration des informations DakarClick
Paydunya::Checkout::Store.name = ENV["PAYDUNYA_STORE_NAME"]
Paydunya::Checkout::Store.tagline = ENV["PAYDUNYA_TAGLINE"]
Paydunya::Checkout::Store.postal_address = ENV["PAYDUNYA_ADDRESS"]
Paydunya::Checkout::Store.phone_number = ENV["PAYDUNYA_NUMBER"]
Paydunya::Checkout::Store.website_url = ENV["PAYDUNYA_WEBRITE_URL"]
Paydunya::Checkout::Store.logo_url = ENV["PAYDUNYA_LOGO_URL"]
Paydunya::Checkout::Store.return_url = ENV["PAYDUNYA_RETRUN_URL"]
