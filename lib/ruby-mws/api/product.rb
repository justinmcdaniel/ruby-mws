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
              if (lowest_offers.respond_to?("product")) # I have noticed amazon does not always respond with an error when there is an error, so this is the best check I can do.
                if lowest_offers.product.lowest_offer_listings.respond_to?("lowest_offer_listing")
                  lowest_offers.product.lowest_offer_listings = [lowest_offers.product.lowest_offer_listings.lowest_offer_listing].flatten
                else
                  lowest_offers.product.lowest_offer_listings = []
                end
              else
                lowest_offers.product = {lowest_offer_listings:[]}
                # Set a generic error message if Amazon incorrectly responded as "success".
                lowest_offers.error.message = "An error occurred." unless lowest_offers.respond_to?("error")
              end
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
        :standard_response => true ,
        :mods => [
          lambda { |r|
            r.each do |product|
              if (product.respond_to?("products")) # I have noticed amazon does not always respond with an error when there is an error, so this is the best check I can do.
                # OMG shoot me this code sucks!!! 俺はAMAZON大きらい!!!
                if product.products.respond_to?("product")
                  product.products = [product.products.product].flatten 
                else
                  product.products = []
                end

                product.products.each do |real_product| # This has got to be an insane slowdown... will look into that later.
                  if real_product.sales_rankings.respond_to?("sales_rank")
                    real_product.sales_rankings = [real_product.sales_rankings.sales_rank].flatten
                  else
                    real_product.sales_rankings = []
                  end
                end
              else
                product.products = []
                # Set a generic error message if Amazon incorrectly responded as "success".
                product.error.message = "An error occurred." unless product.respond_to?("error")
              end
            end
            }
        ]
    end

  end
end