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
        :mods => [
          lambda { |r|
            # if r.respond_to?('has_key?') #hack so "r.each" below can work regardless of result.
            #   r = [r]
            # end
            r.each do |lowest_offers|
              lowest_offers.product.lowest_offer_listings = [lowest_offers.product.lowest_offer_listings.lowest_offer_listing].flatten
            end
            }
        ],
        :standard_response => true

    end

  end
end