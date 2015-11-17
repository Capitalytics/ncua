module NCUA
  class Client
    include HTTParty

    base_uri 'http://mapping.ncua.gov'
    format :json
    #debug_output $stderr

    def find_credit_union_by_address(address, radius)
      self.class.get(query_endpoint, query: {
        address: address,
        type: 'address',
        radius: radius.to_s })
    end

    def find_credit_union_by_name(name)
      self.class.get(query_endpoint, query: {
        address: name,
        type: 'cuname' })
    end

    def find_credit_union_by_charter_number(charter_number)
      self.class.get(query_endpoint, query: {
        address: charter_number,
        type: 'cunumber' })
    end

    # return bool if all is well
    def schema_valid?
      base_fields_valid? && list_fields_valid?
    end

    private

    def base_fields_valid?
      types = ['cuname', 'cunumber', 'address']
      expected_keys = ['list', 'latitude', 'longitude'].sort
      valid = true

      types.each do |type|
        found_keys = self.class.get(query_endpoint, query: {
          address: "somethingfake",
          type: type }).keys.sort
          valid = valid && (found_keys == expected_keys)
      end
    end

    def list_fields_valid?
      expected_keys = ['CU_NAME', 'AddressLongitude', 'AddressLatitude',
                         'CU_SITENAME', 'CU_NUMBER', 'City', 'Country',
                         'IsMainOffice', 'Phone', 'SiteFunctions', 'SiteId',
                         'State', 'URL', 'Zipcode', 'distance', 'Street'].sort
      found_keys = self.find_credit_union_by_charter_number(42)["list"].first.keys.sort
      # return expected_fields is a subset of found_keys
      return expected_keys & found_keys == expected_keys
    end

    def query_endpoint
      '/findCUByRadius.aspx'
    end
  end
end
