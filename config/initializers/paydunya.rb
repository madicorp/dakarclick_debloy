=begin
Paydunya::Setup.master_key = ENV.fetch("PAYDUNYA_MASTER_KEY")
Paydunya::Setup.public_key = ENV.fetch("PAYDUNYA_PUBLIC_KEY")
Paydunya::Setup.private_key = ENV.fetch("PAYDUNYA_PRIVATE_KEY")
Paydunya::Setup.token = ENV.fetch("PAYDUNYA_TOKEN")
Paydunya::Setup.mode = "live"
=end
Paydunya::Setup.master_key = "3OyMcM74-4NXR-Dqjv-Dzfr-mzgZQcKC2fMs"
Paydunya::Setup.public_key = "test_public_JQ5yEn9yswKhn8QIu5CQbZTradO"
Paydunya::Setup.private_key = "test_private_2BFarw7iXUn9NM7QGLi0pCLgeUC"
Paydunya::Setup.mode = "test" # Optionnel. Utilisez cette option pour les paiements tests.
Paydunya::Setup.token = "XXwhVKiLvwL6nNbvg6QW"

# Configuration des informations DakarClick
Paydunya::Checkout::Store.name = ENV.fetch("PAYDUNYA_STORE_NAME")
Paydunya::Checkout::Store.tagline = ENV.fetch("PAYDUNYA_TAGLINE")
Paydunya::Checkout::Store.postal_address = ENV.fetch("PAYDUNYA_ADDRESS")
Paydunya::Checkout::Store.phone_number = ENV.fetch("PAYDUNYA_NUMBER")
Paydunya::Checkout::Store.website_url = ENV.fetch("PAYDUNYA_WEBRITE_URL")
Paydunya::Checkout::Store.logo_url = ENV.fetch("PAYDUNYA_LOGO_URL")
Paydunya::Checkout::Store.return_url = ENV.fetch("PAYDUNYA_RETRUN_URL")
Paydunya::Checkout::Store.cancel_url = ENV.fetch("PAYDUNYA_RETRUN_URL")
