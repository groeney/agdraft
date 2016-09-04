if Rails.env.development?
  Paperclip::Attachment.default_options[:url] = '/assets/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:path] = ':rails_root/app/assets/images/:class/:attachment/:id_partition/:style/:filename'
elsif Rails.env.test?
  Paperclip::Attachment.default_options[:url] = '/assets/:class/test/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:path] = ':rails_root/app/assets/images/:class/test/:attachment/:id_partition/:style/:filename'
else
  Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
end