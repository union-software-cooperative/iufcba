ENV.each do |k,v|
	if k.downcase.starts_with?('secpubsub')
		key = k.downcase.gsub('secpubsub_', '').to_sym
		Secpubsub.config[key] = ENV[k]
	end
end

Rails.application.config.middleware.use Secpubsub::Adapter, Secpubsub.adapter_options
Rails.application.config.allow_concurrency=true # needed this for my development box, prevent mutex locks - should i run puma with more than one thread?
