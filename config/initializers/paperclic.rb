#Paperclip.options[:command_path] = 'C:\Users\A621217\Documents\Perso\Dakarclic\GnuWin32\bin'
Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-1.amazonaws.com'
Paperclip.options[:content_type_mappings] = {
    :jpg => "image/jpeg",
    :png => "image/png",
    :gif => "image/gif"
}
