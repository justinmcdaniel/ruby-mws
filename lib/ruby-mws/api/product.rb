module MWS
  module API

    class Product < Base

      def_request :get_lowest_offer_listings_for_asin,
        :verb => :get,
        :uri => '/Products/2011-10-01',
        :version => '2011-10-01',
        :lists => {
          :asin_list => "ASINList.ASIN"
        },
        :standard_response => true,
        :mods => [
          lambda { |r|
            r.each do |lowest_offers|
              lowest_offers.product.lowest_offer_listings = [lowest_offers.product.lowest_offer_listings.lowest_offer_listing].flatten
            end
            }
        ]

      def_request :get_matching_product_for_id,
        :verb => :get,
        :uri => '/Products/2011-10-01',
        :version => '2011-10-01',
        :lists => {
          :id_list => "IdList.Id"
        },
        :standard_response => true #,
        # :mods => [
          
        # ]
    end

  end
end