ENV.each do |k,v|
	if k.downcase.starts_with?('secpubsub')
		key = k.downcase.gsub('secpubsub_', '').to_sym
		Secpubsub.config[key] = ENV[k]
	end
end

Rails.application.config.middleware.use Secpubsub::Adapter, Secpubsub.adapter_options
 