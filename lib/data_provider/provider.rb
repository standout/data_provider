module DataProvider
  class Provider
    def initialize(name, source, cache = DataProvider.config.cache_store)
      @cache = cache
      @name = name
      @source = source
    end

    def fetch
      cached_data = @cache.fetch(cache_key)
      return cached_data if cached_data

      resp = @source.fetch
      resp.data.tap do |data|
        @cache.write(cache_key, data, expires_in(resp.expires_at))
      end
    end

    def options
      @source.options
    end

    private

    def cache_key
      "#{@name}/data"
    end

    def expires_in(timestamp)
      return {} unless timestamp
      { expires_in: timestamp.utc.to_i - Time.now.utc.to_i }
    end
  end
end
