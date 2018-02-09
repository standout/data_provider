require 'test_helper'

class DataProviderTest < Minitest::Test
  DATA = [{ data: 2, type: 'number', title: 'Antal' }].freeze
  EXPIRES_IN = 60

  def test_register
    register_mock_provider
    assert_instance_of DataProvider::Provider, DataProvider.providers[:mock]
  end

  def test_register_with_options
    register_mock_provider username: 'standout'
    assert_equal 'standout', DataProvider.providers[:mock].options[:username]
  end

  def test_get_provider_by_string
    register_mock_provider
    assert_instance_of DataProvider::Provider, DataProvider.providers['mock']
  end

  def test_fetch_empty_cache
    cache_store = Minitest::Mock.new
    configure_cache_store(cache_store)
    register_mock_provider
    cache_store.expect :fetch, nil, ['mock/data']
    cache_store.expect :write, true, ['mock/data', DATA, expires_in: EXPIRES_IN]

    Timecop.freeze(Time.now) do
      DataProvider.providers[:mock].fetch

      assert_mock cache_store
    end
  end

  def test_fetch_with_data_in_cache
    cache_store = Minitest::Mock.new
    configure_cache_store(cache_store)
    register_mock_provider
    cache_store.expect :fetch, DATA, ['mock/data']

    Timecop.freeze(Time.now) do
      data = DataProvider.providers[:mock].fetch

      assert_mock cache_store
      assert_equal DATA, data
    end
  end

  def test_fetch_without_expires_at
    cache_store = Minitest::Mock.new
    configure_cache_store(cache_store)
    register_mock_provider(data: DATA, expires_in: nil)
    cache_store.expect :fetch, nil, ['mock/data']
    cache_store.expect :write, true, ['mock/data', DATA, {}]

    data = DataProvider.providers[:mock].fetch

    assert_mock cache_store
    assert_equal DATA, data
  end

  private

  def configure_cache_store(cache_store)
    DataProvider.configure do |c|
      c.cache_store = cache_store
    end
  end

  def register_mock_provider(options = { data: DATA, expires_in: EXPIRES_IN })
    DataProvider.register :mock, MockProvider, options
  end
end
